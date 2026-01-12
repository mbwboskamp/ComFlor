import { useState } from 'react';
import { Header, StatusBadge, DataTable } from '../components';
import { orders } from '../data/sampleData';
import type { Order, OrderStatus } from '../types';
import {
  Plus,
  Search,
  Filter,
  ChevronDown,
  Truck,
  Package,
  X,
  FileText,
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

const statusFilters: { value: OrderStatus | 'alle'; label: string }[] = [
  { value: 'alle', label: 'Alle orders' },
  { value: 'aangevraagd', label: 'Aangevraagd' },
  { value: 'bevestigd', label: 'Bevestigd' },
  { value: 'in_productie', label: 'In productie' },
  { value: 'verzonden', label: 'Verzonden' },
  { value: 'geleverd', label: 'Geleverd' },
];

export function Orders() {
  const [searchQuery, setSearchQuery] = useState('');
  const [statusFilter, setStatusFilter] = useState<OrderStatus | 'alle'>('alle');
  const [selectedOrder, setSelectedOrder] = useState<Order | null>(null);

  const filteredOrders = orders.filter((order) => {
    const matchesSearch =
      order.ordernummer.toLowerCase().includes(searchQuery.toLowerCase()) ||
      order.projectnaam.toLowerCase().includes(searchQuery.toLowerCase()) ||
      order.clientNaam.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesStatus = statusFilter === 'alle' || order.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  const columns = [
    {
      key: 'ordernummer',
      header: 'Ordernummer',
      render: (order: Order) => (
        <div>
          <p className="font-medium text-gray-900">{order.ordernummer}</p>
          <p className="text-xs text-gray-500">
            {format(new Date(order.aangemaaktOp), 'd MMM yyyy', { locale: nl })}
          </p>
        </div>
      ),
    },
    {
      key: 'project',
      header: 'Project',
      render: (order: Order) => (
        <div>
          <p className="font-medium text-gray-900">{order.projectnaam}</p>
          <p className="text-sm text-gray-500">{order.clientNaam}</p>
        </div>
      ),
    },
    {
      key: 'product',
      header: 'Product',
      render: (order: Order) => (
        <div>
          <p className="font-medium text-gray-900">{order.comflorType}</p>
          <p className="text-sm text-gray-500">
            {order.hoeveelheid.toLocaleString('nl-NL')} m² • {order.plaatdikte}mm
          </p>
        </div>
      ),
    },
    {
      key: 'leverdatum',
      header: 'Leverdatum',
      render: (order: Order) => (
        <div>
          <p className="text-gray-900">
            {format(new Date(order.gewensteLeverdatum), 'd MMM yyyy', {
              locale: nl,
            })}
          </p>
          {order.werkelijkeLeverdatum && (
            <p className="text-xs text-green-600">
              Geleverd:{' '}
              {format(new Date(order.werkelijkeLeverdatum), 'd MMM', { locale: nl })}
            </p>
          )}
        </div>
      ),
    },
    {
      key: 'status',
      header: 'Status',
      render: (order: Order) => <StatusBadge status={order.status} />,
    },
    {
      key: 'totaal',
      header: 'Totaal',
      render: (order: Order) => (
        <span className="font-semibold text-gray-900">
          {formatCurrency(order.totaalPrijs)}
        </span>
      ),
      className: 'text-right',
    },
  ];

  const orderStats = {
    aangevraagd: orders.filter((o) => o.status === 'aangevraagd').length,
    inBehandeling: orders.filter(
      (o) => o.status === 'bevestigd' || o.status === 'in_productie'
    ).length,
    onderweg: orders.filter((o) => o.status === 'verzonden').length,
    geleverd: orders.filter((o) => o.status === 'geleverd').length,
  };

  return (
    <div className="min-h-screen">
      <Header title="Orders" subtitle={`${orders.length} orders in totaal`} />

      <div className="p-6">
        {/* Quick Stats */}
        <div className="grid grid-cols-4 gap-4 mb-6">
          <div className="bg-purple-50 rounded-xl p-4">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-purple-100 rounded-lg flex items-center justify-center">
                <FileText className="w-5 h-5 text-purple-600" />
              </div>
              <div>
                <p className="text-sm text-purple-600">Aangevraagd</p>
                <p className="text-2xl font-bold text-purple-900">
                  {orderStats.aangevraagd}
                </p>
              </div>
            </div>
          </div>
          <div className="bg-blue-50 rounded-xl p-4">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center">
                <Package className="w-5 h-5 text-blue-600" />
              </div>
              <div>
                <p className="text-sm text-blue-600">In behandeling</p>
                <p className="text-2xl font-bold text-blue-900">
                  {orderStats.inBehandeling}
                </p>
              </div>
            </div>
          </div>
          <div className="bg-orange-50 rounded-xl p-4">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-orange-100 rounded-lg flex items-center justify-center">
                <Truck className="w-5 h-5 text-orange-600" />
              </div>
              <div>
                <p className="text-sm text-orange-600">Onderweg</p>
                <p className="text-2xl font-bold text-orange-900">
                  {orderStats.onderweg}
                </p>
              </div>
            </div>
          </div>
          <div className="bg-green-50 rounded-xl p-4">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-green-100 rounded-lg flex items-center justify-center">
                <Package className="w-5 h-5 text-green-600" />
              </div>
              <div>
                <p className="text-sm text-green-600">Geleverd</p>
                <p className="text-2xl font-bold text-green-900">
                  {orderStats.geleverd}
                </p>
              </div>
            </div>
          </div>
        </div>

        {/* Filters & Actions */}
        <div className="bg-white rounded-xl p-4 shadow-sm border border-gray-100 mb-6">
          <div className="flex flex-wrap items-center gap-4">
            <div className="relative flex-1 min-w-[250px]">
              <Search className="w-5 h-5 absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
              <input
                type="text"
                placeholder="Zoek op ordernummer, project of klant..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>

            <div className="relative">
              <Filter className="w-4 h-4 absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
              <select
                value={statusFilter}
                onChange={(e) =>
                  setStatusFilter(e.target.value as OrderStatus | 'alle')
                }
                className="pl-9 pr-8 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 appearance-none bg-white"
              >
                {statusFilters.map((filter) => (
                  <option key={filter.value} value={filter.value}>
                    {filter.label}
                  </option>
                ))}
              </select>
              <ChevronDown className="w-4 h-4 absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 pointer-events-none" />
            </div>

            <button className="flex items-center gap-2 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
              <Plus className="w-5 h-5" />
              Nieuwe Order
            </button>
          </div>
        </div>

        {/* Orders Table */}
        <div className="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
          <DataTable
            data={filteredOrders}
            columns={columns}
            keyField="id"
            onRowClick={(order) => setSelectedOrder(order)}
          />
        </div>

        {filteredOrders.length === 0 && (
          <div className="text-center py-12">
            <p className="text-gray-500">
              Geen orders gevonden die aan de criteria voldoen.
            </p>
          </div>
        )}
      </div>

      {/* Order Detail Modal */}
      {selectedOrder && (
        <div
          className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4"
          onClick={() => setSelectedOrder(null)}
        >
          <div
            className="bg-white rounded-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="p-6 border-b border-gray-100">
              <div className="flex items-start justify-between">
                <div>
                  <p className="text-sm text-gray-500 mb-1">Order</p>
                  <h2 className="text-xl font-bold text-gray-900">
                    {selectedOrder.ordernummer}
                  </h2>
                </div>
                <button
                  onClick={() => setSelectedOrder(null)}
                  className="p-2 hover:bg-gray-100 rounded-lg"
                >
                  <X className="w-5 h-5 text-gray-500" />
                </button>
              </div>
            </div>

            <div className="p-6 space-y-6">
              <StatusBadge status={selectedOrder.status} />

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <p className="text-sm text-gray-500 mb-1">Project</p>
                  <p className="font-medium">{selectedOrder.projectnaam}</p>
                </div>
                <div>
                  <p className="text-sm text-gray-500 mb-1">Klant</p>
                  <p className="font-medium">{selectedOrder.clientNaam}</p>
                </div>
                <div>
                  <p className="text-sm text-gray-500 mb-1">Gewenste leverdatum</p>
                  <p className="font-medium">
                    {format(new Date(selectedOrder.gewensteLeverdatum), 'd MMMM yyyy', {
                      locale: nl,
                    })}
                  </p>
                </div>
                <div>
                  <p className="text-sm text-gray-500 mb-1">Werkelijke leverdatum</p>
                  <p className="font-medium">
                    {selectedOrder.werkelijkeLeverdatum
                      ? format(
                          new Date(selectedOrder.werkelijkeLeverdatum),
                          'd MMMM yyyy',
                          { locale: nl }
                        )
                      : '-'}
                  </p>
                </div>
              </div>

              <div className="bg-gray-50 rounded-xl p-4">
                <h4 className="font-medium text-gray-900 mb-3">Product Details</h4>
                <div className="grid grid-cols-2 gap-4 text-sm">
                  <div>
                    <p className="text-gray-500">ComFlor type</p>
                    <p className="font-semibold text-lg">{selectedOrder.comflorType}</p>
                  </div>
                  <div>
                    <p className="text-gray-500">Hoeveelheid</p>
                    <p className="font-semibold text-lg">
                      {selectedOrder.hoeveelheid.toLocaleString('nl-NL')} m²
                    </p>
                  </div>
                  <div>
                    <p className="text-gray-500">Plaatdikte</p>
                    <p className="font-semibold">{selectedOrder.plaatdikte} mm</p>
                  </div>
                  <div>
                    <p className="text-gray-500">Staalsoort</p>
                    <p className="font-semibold">{selectedOrder.staalsoort}</p>
                  </div>
                  <div className="col-span-2">
                    <p className="text-gray-500">Coating</p>
                    <p className="font-semibold">{selectedOrder.coating}</p>
                  </div>
                </div>
              </div>

              <div>
                <p className="text-sm text-gray-500 mb-1">Leveradres</p>
                <p className="font-medium">{selectedOrder.leveradres}</p>
              </div>

              <div className="bg-blue-50 rounded-xl p-4">
                <p className="text-sm text-blue-600 mb-1">Totaalprijs</p>
                <p className="text-3xl font-bold text-blue-900">
                  {formatCurrency(selectedOrder.totaalPrijs)}
                </p>
              </div>

              {selectedOrder.opmerkingen && (
                <div>
                  <p className="text-sm text-gray-500 mb-1">Opmerkingen</p>
                  <p className="text-gray-700">{selectedOrder.opmerkingen}</p>
                </div>
              )}
            </div>

            <div className="p-6 border-t border-gray-100 flex justify-end gap-3">
              <button
                onClick={() => setSelectedOrder(null)}
                className="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50"
              >
                Sluiten
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
