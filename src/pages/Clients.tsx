import { useState } from 'react';
import { Header, DataTable } from '../components';
import { clients, projects } from '../data/sampleData';
import type { Client } from '../types';
import {
  Plus,
  Search,
  Building2,
  Mail,
  Phone,
  MapPin,
  Euro,
  FolderKanban,
  X,
  ExternalLink,
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

export function Clients() {
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedClient, setSelectedClient] = useState<Client | null>(null);

  const filteredClients = clients.filter(
    (client) =>
      client.bedrijfsnaam.toLowerCase().includes(searchQuery.toLowerCase()) ||
      client.contactpersoon.toLowerCase().includes(searchQuery.toLowerCase()) ||
      client.plaats.toLowerCase().includes(searchQuery.toLowerCase())
  );

  const columns = [
    {
      key: 'bedrijfsnaam',
      header: 'Bedrijf',
      render: (client: Client) => (
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 bg-blue-100 rounded-lg flex items-center justify-center">
            <Building2 className="w-5 h-5 text-blue-600" />
          </div>
          <div>
            <p className="font-medium text-gray-900">{client.bedrijfsnaam}</p>
            <p className="text-sm text-gray-500">{client.contactpersoon}</p>
          </div>
        </div>
      ),
    },
    {
      key: 'contact',
      header: 'Contact',
      render: (client: Client) => (
        <div className="space-y-1">
          <div className="flex items-center gap-2 text-sm text-gray-600">
            <Mail className="w-4 h-4" />
            <a href={`mailto:${client.email}`} className="hover:text-blue-600">
              {client.email}
            </a>
          </div>
          <div className="flex items-center gap-2 text-sm text-gray-600">
            <Phone className="w-4 h-4" />
            <span>{client.telefoon}</span>
          </div>
        </div>
      ),
    },
    {
      key: 'locatie',
      header: 'Locatie',
      render: (client: Client) => (
        <div className="flex items-center gap-2 text-gray-600">
          <MapPin className="w-4 h-4" />
          <span>{client.plaats}</span>
        </div>
      ),
    },
    {
      key: 'projecten',
      header: 'Projecten',
      render: (client: Client) => (
        <div className="flex items-center gap-2">
          <FolderKanban className="w-4 h-4 text-blue-500" />
          <span className="font-medium">{client.aantalProjecten}</span>
        </div>
      ),
    },
    {
      key: 'openstaand',
      header: 'Openstaand',
      render: (client: Client) => (
        <span
          className={`font-semibold ${
            client.openstaandBedrag > 0 ? 'text-orange-600' : 'text-green-600'
          }`}
        >
          {formatCurrency(client.openstaandBedrag)}
        </span>
      ),
      className: 'text-right',
    },
    {
      key: 'laatsteActiviteit',
      header: 'Laatste activiteit',
      render: (client: Client) => (
        <span className="text-gray-600">
          {format(new Date(client.laatsteActiviteit), 'd MMM yyyy', { locale: nl })}
        </span>
      ),
    },
  ];

  const clientProjects = selectedClient
    ? projects.filter((p) => p.clientId === selectedClient.id)
    : [];

  const totaalOpenstaand = clients.reduce((sum, c) => sum + c.openstaandBedrag, 0);
  const totaalKrediet = clients.reduce((sum, c) => sum + c.kredietlimiet, 0);

  return (
    <div className="min-h-screen">
      <Header title="Klanten" subtitle={`${clients.length} klanten in totaal`} />

      <div className="p-6">
        {/* Summary Stats */}
        <div className="grid grid-cols-3 gap-4 mb-6">
          <div className="bg-white rounded-xl p-5 shadow-sm border border-gray-100">
            <div className="flex items-center gap-4">
              <div className="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center">
                <Building2 className="w-6 h-6 text-blue-600" />
              </div>
              <div>
                <p className="text-sm text-gray-500">Totaal klanten</p>
                <p className="text-2xl font-bold text-gray-900">{clients.length}</p>
              </div>
            </div>
          </div>
          <div className="bg-white rounded-xl p-5 shadow-sm border border-gray-100">
            <div className="flex items-center gap-4">
              <div className="w-12 h-12 bg-orange-100 rounded-xl flex items-center justify-center">
                <Euro className="w-6 h-6 text-orange-600" />
              </div>
              <div>
                <p className="text-sm text-gray-500">Totaal openstaand</p>
                <p className="text-2xl font-bold text-orange-600">
                  {formatCurrency(totaalOpenstaand)}
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
                <p className="text-sm text-gray-500">Totaal kredietruimte</p>
                <p className="text-2xl font-bold text-green-600">
                  {formatCurrency(totaalKrediet)}
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
                placeholder="Zoek op bedrijfsnaam, contactpersoon of plaats..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
              />
            </div>

            <button className="flex items-center gap-2 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors">
              <Plus className="w-5 h-5" />
              Nieuwe Klant
            </button>
          </div>
        </div>

        {/* Clients Table */}
        <div className="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
          <DataTable
            data={filteredClients}
            columns={columns}
            keyField="id"
            onRowClick={(client) => setSelectedClient(client)}
          />
        </div>

        {filteredClients.length === 0 && (
          <div className="text-center py-12">
            <p className="text-gray-500">
              Geen klanten gevonden die aan de criteria voldoen.
            </p>
          </div>
        )}
      </div>

      {/* Client Detail Modal */}
      {selectedClient && (
        <div
          className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4"
          onClick={() => setSelectedClient(null)}
        >
          <div
            className="bg-white rounded-2xl max-w-3xl w-full max-h-[90vh] overflow-y-auto"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="p-6 border-b border-gray-100">
              <div className="flex items-start justify-between">
                <div className="flex items-center gap-4">
                  <div className="w-14 h-14 bg-blue-100 rounded-xl flex items-center justify-center">
                    <Building2 className="w-7 h-7 text-blue-600" />
                  </div>
                  <div>
                    <h2 className="text-xl font-bold text-gray-900">
                      {selectedClient.bedrijfsnaam}
                    </h2>
                    <p className="text-gray-500">{selectedClient.contactpersoon}</p>
                  </div>
                </div>
                <button
                  onClick={() => setSelectedClient(null)}
                  className="p-2 hover:bg-gray-100 rounded-lg"
                >
                  <X className="w-5 h-5 text-gray-500" />
                </button>
              </div>
            </div>

            <div className="p-6 space-y-6">
              {/* Contact Info */}
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-3">
                  <div className="flex items-center gap-2 text-gray-600">
                    <Mail className="w-4 h-4" />
                    <a
                      href={`mailto:${selectedClient.email}`}
                      className="hover:text-blue-600"
                    >
                      {selectedClient.email}
                    </a>
                  </div>
                  <div className="flex items-center gap-2 text-gray-600">
                    <Phone className="w-4 h-4" />
                    <span>{selectedClient.telefoon}</span>
                  </div>
                  <div className="flex items-start gap-2 text-gray-600">
                    <MapPin className="w-4 h-4 mt-0.5" />
                    <div>
                      <p>{selectedClient.adres}</p>
                      <p>
                        {selectedClient.postcode} {selectedClient.plaats}
                      </p>
                    </div>
                  </div>
                </div>
                <div className="space-y-2 text-sm">
                  <div className="flex justify-between">
                    <span className="text-gray-500">KVK-nummer</span>
                    <span className="font-medium">{selectedClient.kvkNummer}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-gray-500">BTW-nummer</span>
                    <span className="font-medium">{selectedClient.btwNummer}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-gray-500">Klant sinds</span>
                    <span className="font-medium">
                      {format(new Date(selectedClient.aangemaaktOp), 'd MMMM yyyy', {
                        locale: nl,
                      })}
                    </span>
                  </div>
                </div>
              </div>

              {/* Financial Info */}
              <div className="grid grid-cols-2 gap-4">
                <div className="bg-green-50 rounded-xl p-4">
                  <p className="text-sm text-green-600 mb-1">Kredietlimiet</p>
                  <p className="text-2xl font-bold text-green-900">
                    {formatCurrency(selectedClient.kredietlimiet)}
                  </p>
                </div>
                <div
                  className={`rounded-xl p-4 ${
                    selectedClient.openstaandBedrag > 0
                      ? 'bg-orange-50'
                      : 'bg-gray-50'
                  }`}
                >
                  <p
                    className={`text-sm mb-1 ${
                      selectedClient.openstaandBedrag > 0
                        ? 'text-orange-600'
                        : 'text-gray-600'
                    }`}
                  >
                    Openstaand bedrag
                  </p>
                  <p
                    className={`text-2xl font-bold ${
                      selectedClient.openstaandBedrag > 0
                        ? 'text-orange-900'
                        : 'text-gray-900'
                    }`}
                  >
                    {formatCurrency(selectedClient.openstaandBedrag)}
                  </p>
                </div>
              </div>

              {/* Projects */}
              <div>
                <h4 className="font-semibold text-gray-900 mb-3">
                  Projecten ({clientProjects.length})
                </h4>
                {clientProjects.length > 0 ? (
                  <div className="space-y-2">
                    {clientProjects.map((project) => (
                      <div
                        key={project.id}
                        className="flex items-center justify-between p-3 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors"
                      >
                        <div>
                          <p className="font-medium text-gray-900">{project.naam}</p>
                          <p className="text-sm text-gray-500">
                            {project.projectnummer} • {project.locatie}
                          </p>
                        </div>
                        <div className="flex items-center gap-3">
                          <span
                            className={`px-2 py-1 rounded text-xs font-medium ${
                              project.status === 'in_uitvoering'
                                ? 'bg-yellow-100 text-yellow-700'
                                : project.status === 'afgerond' ||
                                  project.status === 'gefactureerd'
                                ? 'bg-green-100 text-green-700'
                                : 'bg-blue-100 text-blue-700'
                            }`}
                          >
                            {project.status.replace('_', ' ')}
                          </span>
                          <ExternalLink className="w-4 h-4 text-gray-400" />
                        </div>
                      </div>
                    ))}
                  </div>
                ) : (
                  <p className="text-gray-500 text-sm">
                    Geen projecten gevonden voor deze klant.
                  </p>
                )}
              </div>
            </div>

            <div className="p-6 border-t border-gray-100 flex justify-end gap-3">
              <button
                onClick={() => setSelectedClient(null)}
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
