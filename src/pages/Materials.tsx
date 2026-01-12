import { useState } from 'react';
import { Header, ProgressBar, DataTable } from '../components';
import { materials } from '../data/sampleData';
import type { Material, ComFlorType } from '../types';
import {
  Plus,
  Search,
  Filter,
  ChevronDown,
  Package,
  AlertTriangle,
  TrendingDown,
  Euro,
  Truck,
  X,
} from 'lucide-react';
import { format } from 'date-fns';
import { nl } from 'date-fns/locale';

function formatCurrency(value: number): string {
  return new Intl.NumberFormat('nl-NL', {
    style: 'currency',
    currency: 'EUR',
    maximumFractionDigits: 0,
  }).format(value);
}

const typeFilters: { value: ComFlorType | 'alle'; label: string }[] = [
  { value: 'alle', label: 'Alle types' },
  { value: 'CF46', label: 'CF46' },
  { value: 'CF51', label: 'CF51' },
  { value: 'CF60', label: 'CF60' },
  { value: 'CF80', label: 'CF80' },
  { value: 'CF210', label: 'CF210' },
  { value: 'CF225', label: 'CF225' },
];

export function Materials() {
  const [searchQuery, setSearchQuery] = useState('');
  const [typeFilter, setTypeFilter] = useState<ComFlorType | 'alle'>('alle');
  const [showLowStock, setShowLowStock] = useState(false);
  const [selectedMaterial, setSelectedMaterial] = useState<Material | null>(null);

  const filteredMaterials = materials.filter((material) => {
    const matchesSearch =
      material.naam.toLowerCase().includes(searchQuery.toLowerCase()) ||
      material.artikelcode.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesType = typeFilter === 'alle' || material.type === typeFilter;
    const matchesStock = !showLowStock || material.voorraad < material.minimumVoorraad;
    return matchesSearch && matchesType && matchesStock;
  });

  const lowStockItems = materials.filter((m) => m.voorraad < m.minimumVoorraad);
  const totalVoorraad = materials.reduce((sum, m) => sum + m.voorraad, 0);
  const totalWaarde = materials.reduce((sum, m) => sum + m.voorraad * m.prijsPerM2, 0);

  const columns = [
    {
      key: 'artikel',
      header: 'Artikel',
      render: (material: Material) => (
        <div className="flex items-center gap-3">
          <div
            className={`w-10 h-10 rounded-lg flex items-center justify-center ${
              material.voorraad < material.minimumVoorraad
                ? 'bg-red-100'
                : 'bg-blue-100'
            }`}
          >
            <Package
              className={`w-5 h-5 ${
                material.voorraad < material.minimumVoorraad
                  ? 'text-red-600'
                  : 'text-blue-600'
              }`}
            />
          </div>
          <div>
            <p className="font-medium text-gray-900">{material.naam}</p>
            <p className="text-sm text-gray-500">{material.artikelcode}</p>
          </div>
        </div>
      ),
    },
    {
      key: 'type',
      header: 'Type',
      render: (material: Material) => (
        <span className="px-2 py-1 bg-blue-100 text-blue-700 rounded text-sm font-medium">
          {material.type}
        </span>
      ),
    },
    {
      key: 'specs',
      header: 'Specificaties',
      render: (material: Material) => (
        <div className="text-sm text-gray-600">
          <p>
            {material.dikte}mm x {material.breedte}mm x {material.lengte}mm
          </p>
        </div>
      ),
    },
    {
      key: 'voorraad',
      header: 'Voorraad',
      render: (material: Material) => {
        const percentage = (material.voorraad / material.minimumVoorraad) * 100;
        const isLow = material.voorraad < material.minimumVoorraad;
        return (
          <div className="min-w-[120px]">
            <div className="flex items-center justify-between mb-1">
              <span
                className={`font-medium ${isLow ? 'text-red-600' : 'text-gray-900'}`}
              >
                {material.voorraad.toLocaleString('nl-NL')} m²
              </span>
              {isLow && <AlertTriangle className="w-4 h-4 text-red-500" />}
            </div>
            <ProgressBar
              value={material.voorraad}
              max={material.minimumVoorraad * 2}
              size="sm"
              color={isLow ? 'red' : percentage < 150 ? 'orange' : 'green'}
            />
            <p className="text-xs text-gray-500 mt-1">
              Min: {material.minimumVoorraad.toLocaleString('nl-NL')} m²
            </p>
          </div>
        );
      },
    },
    {
      key: 'prijs',
      header: 'Prijs/m²',
      render: (material: Material) => (
        <span className="font-medium text-gray-900">
          {formatCurrency(material.prijsPerM2)}
        </span>
      ),
      className: 'text-right',
    },
    {
      key: 'waarde',
      header: 'Totale waarde',
      render: (material: Material) => (
        <span className="font-semibold text-gray-900">
          {formatCurrency(material.voorraad * material.prijsPerM2)}
        </span>
      ),
      className: 'text-right',
    },
    {
      key: 'levertijd',
      header: 'Levertijd',
      render: (material: Material) => (
        <div className="text-sm">
          <p className="text-gray-900">{material.levertijd} dagen</p>
          <p className="text-gray-500">{material.leverancier}</p>
        </div>
      ),
    },
  ];

  return (
    <div className="min-h-screen">
      <Header
        title="Materialen & Voorraad"
        subtitle={`${materials.length} artikelen in voorraad`}
      />

      <div className="p-6">
        {/* Summary Stats */}
        <div className="grid grid-cols-4 gap-4 mb-6">
          <div className="bg-white rounded-xl p-5 shadow-sm border border-gray-100">
            <div className="flex items-center gap-4">
              <div className="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center">
                <Package className="w-6 h-6 text-blue-600" />
              </div>
              <div>
                <p className="text-sm text-gray-500">Totaal voorraad</p>
                <p className="text-2xl font-bold text-gray-900">
                  {totalVoorraad.toLocaleString('nl-NL')} m²
                </p>
              </div>
            </div>
          </div>
          <div className="bg-white rounded-xl p-5 shadow-sm border border-gray-100">
            <div className="flex items-center gap-4">
              <div className="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center">
                <Euro className="w-6 h-6 text-green-600" />
              </div>
              <div>
                <p className="text-sm text-gray-500">Voorraadwaarde</p>
                <p className="text-2xl font-bold text-green-600">
                  {formatCurrency(totalWaarde)}
                </p>
              </div>
            </div>
          </div>
          <div className="bg-white rounded-xl p-5 shadow-sm border border-gray-100">
            <div className="flex items-center gap-4">
              <div className="w-12 h-12 bg-purple-100 rounded-xl flex items-center justify-center">
                <Truck className="w-6 h-6 text-purple-600" />
              </div>
              <div>
                <p className="text-sm text-gray-500">Artikelen</p>
                <p className="text-2xl font-bold text-purple-600">{materials.length}</p>
              </div>
            </div>
          </div>
          <div
            className={`rounded-xl p-5 shadow-sm border ${
              lowStockItems.length > 0
                ? 'bg-red-50 border-red-200'
                : 'bg-white border-gray-100'
            }`}
          >
            <div className="flex items-center gap-4">
              <div
                className={`w-12 h-12 rounded-xl flex items-center justify-center ${
                  lowStockItems.length > 0 ? 'bg-red-100' : 'bg-gray-100'
                }`}
              >
                <TrendingDown
                  className={`w-6 h-6 ${
                    lowStockItems.length > 0 ? 'text-red-600' : 'text-gray-600'
                  }`}
                />
              </div>
              <div>
                <p
                  className={`text-sm ${
                    lowStockItems.length > 0 ? 'text-red-600' : 'text-gray-500'
                  }`}
                >
                  Lage voorraad
                </p>
                <p
                  className={`text-2xl font-bold ${
                    lowStockItems.length > 0 ? 'text-red-700' : 'text-gray-900'
                  }`}
                >
                  {lowStockItems.length} items
                </p>
              </div>
            </div>
          </div>
        </div>

        {/* Low Stock Alert */}
        {lowStockItems.length > 0 && (
          <div className="bg-red-50 border border-red-200 rounded-xl p-4 mb-6">
            <div className="flex items-start gap-3">
              <AlertTriangle className="w-5 h-5 text-red-600 flex-shrink-0 mt-0.5" />
              <div className="flex-1">
                <h4 className="font-medium text-red-800">
                  Let op: {lowStockItems.length} artikel(en) onder minimum voorraad
                </h4>
                <div className="flex flex-wrap gap-2 mt-2">
                  {lowStockItems.map((item) => (
                    <span
                      key={item.id}
                      className="px-2 py-1 bg-red-100 text-red-700 rounded text-sm"
                    >
                      {item.type} - {item.artikelcode}
                    </span>
                  ))}
                </div>
              </div>
              <button
                onClick={() => setShowLowStock(true)}
                className="px-3 py-1.5 bg-red-600 text-white rounded-lg text-sm hover:bg-red-700"
              >
                Bekijk items
              </button>
            </div>
          </div>
        )}

        {/* Filters & Actions */}
        <div className="bg-white rounded-xl p-4 shadow-sm border border-gray-100 mb-6">
          <div className="flex flex-wrap items-center gap-4">
            <div className="relative flex-1 min-w-[250px]">
              <Search className="w-5 h-5 absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
              <input
                type="text"
                placeholder="Zoek op naam of artikelcode..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>

            <div className="relative">
              <Filter className="w-4 h-4 absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
              <select
                value={typeFilter}
                onChange={(e) => setTypeFilter(e.target.value as ComFlorType | 'alle')}
                className="pl-9 pr-8 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 appearance-none bg-white"
              >
                {typeFilters.map((filter) => (
                  <option key={filter.value} value={filter.value}>
                    {filter.label}
                  </option>
                ))}
              </select>
              <ChevronDown className="w-4 h-4 absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none" />
            </div>

            <label className="flex items-center gap-2 cursor-pointer">
              <input
                type="checkbox"
                checked={showLowStock}
                onChange={(e) => setShowLowStock(e.target.checked)}
                className="w-4 h-4 text-blue-600 rounded border-gray-300 focus:ring-blue-500"
              />
              <span className="text-sm text-gray-600">Alleen lage voorraad</span>
            </label>

            <button className="flex items-center gap-2 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
              <Plus className="w-5 h-5" />
              Nieuw Artikel
            </button>
          </div>
        </div>

        {/* Materials Table */}
        <div className="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
          <DataTable
            data={filteredMaterials}
            columns={columns}
            keyField="id"
            onRowClick={(material) => setSelectedMaterial(material)}
          />
        </div>

        {filteredMaterials.length === 0 && (
          <div className="text-center py-12">
            <p className="text-gray-500">
              Geen materialen gevonden die aan de criteria voldoen.
            </p>
          </div>
        )}
      </div>

      {/* Material Detail Modal */}
      {selectedMaterial && (
        <div
          className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4"
          onClick={() => setSelectedMaterial(null)}
        >
          <div
            className="bg-white rounded-2xl max-w-lg w-full max-h-[90vh] overflow-y-auto"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="p-6 border-b border-gray-100">
              <div className="flex items-start justify-between">
                <div>
                  <p className="text-sm text-gray-500 mb-1">
                    {selectedMaterial.artikelcode}
                  </p>
                  <h2 className="text-xl font-bold text-gray-900">
                    {selectedMaterial.naam}
                  </h2>
                </div>
                <button
                  onClick={() => setSelectedMaterial(null)}
                  className="p-2 hover:bg-gray-100 rounded-lg"
                >
                  <X className="w-5 h-5 text-gray-500" />
                </button>
              </div>
            </div>

            <div className="p-6 space-y-6">
              <div className="flex items-center gap-2">
                <span className="px-3 py-1 bg-blue-100 text-blue-700 rounded-lg font-medium">
                  {selectedMaterial.type}
                </span>
                {selectedMaterial.voorraad < selectedMaterial.minimumVoorraad && (
                  <span className="px-3 py-1 bg-red-100 text-red-700 rounded-lg font-medium flex items-center gap-1">
                    <AlertTriangle className="w-4 h-4" />
                    Lage voorraad
                  </span>
                )}
              </div>

              <div className="bg-gray-50 rounded-xl p-4">
                <h4 className="font-medium text-gray-900 mb-3">Specificaties</h4>
                <div className="grid grid-cols-3 gap-4 text-sm">
                  <div>
                    <p className="text-gray-500">Dikte</p>
                    <p className="font-semibold">{selectedMaterial.dikte} mm</p>
                  </div>
                  <div>
                    <p className="text-gray-500">Breedte</p>
                    <p className="font-semibold">{selectedMaterial.breedte} mm</p>
                  </div>
                  <div>
                    <p className="text-gray-500">Lengte</p>
                    <p className="font-semibold">{selectedMaterial.lengte} mm</p>
                  </div>
                </div>
              </div>

              <div>
                <div className="flex items-center justify-between mb-2">
                  <span className="text-sm text-gray-500">Voorraad niveau</span>
                  <span className="text-sm font-medium">
                    {selectedMaterial.voorraad.toLocaleString('nl-NL')} m² /{' '}
                    {(selectedMaterial.minimumVoorraad * 2).toLocaleString('nl-NL')} m²
                  </span>
                </div>
                <ProgressBar
                  value={selectedMaterial.voorraad}
                  max={selectedMaterial.minimumVoorraad * 2}
                  size="lg"
                />
                <p className="text-xs text-gray-500 mt-1">
                  Minimum voorraad:{' '}
                  {selectedMaterial.minimumVoorraad.toLocaleString('nl-NL')} m²
                </p>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div className="bg-blue-50 rounded-xl p-4">
                  <p className="text-sm text-blue-600 mb-1">Prijs per m²</p>
                  <p className="text-2xl font-bold text-blue-900">
                    {formatCurrency(selectedMaterial.prijsPerM2)}
                  </p>
                </div>
                <div className="bg-green-50 rounded-xl p-4">
                  <p className="text-sm text-green-600 mb-1">Totale waarde</p>
                  <p className="text-2xl font-bold text-green-900">
                    {formatCurrency(
                      selectedMaterial.voorraad * selectedMaterial.prijsPerM2
                    )}
                  </p>
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4 text-sm">
                <div>
                  <p className="text-gray-500">Leverancier</p>
                  <p className="font-medium">{selectedMaterial.leverancier}</p>
                </div>
                <div>
                  <p className="text-gray-500">Levertijd</p>
                  <p className="font-medium">{selectedMaterial.levertijd} dagen</p>
                </div>
                <div className="col-span-2">
                  <p className="text-gray-500">Laatste inkoop</p>
                  <p className="font-medium">
                    {format(new Date(selectedMaterial.laatsteInkoop), 'd MMMM yyyy', {
                      locale: nl,
                    })}
                  </p>
                </div>
              </div>
            </div>

            <div className="p-6 border-t border-gray-100 flex justify-end gap-3">
              <button
                onClick={() => setSelectedMaterial(null)}
                className="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50"
              >
                Sluiten
              </button>
              <button className="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700">
                Bijbestellen
              </button>
              <button className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                Bewerken
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
