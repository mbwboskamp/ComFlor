import { useState } from 'react';
import { Header, StatusBadge, ProgressBar } from '../components';
import { projects } from '../data/sampleData';
import type { Project, ProjectStatus } from '../types';
import {
  Plus,
  Search,
  Filter,
  MapPin,
  Calendar,
  User,
  Euro,
  Layers,
  ChevronDown,
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

const statusFilters: { value: ProjectStatus | 'alle'; label: string }[] = [
  { value: 'alle', label: 'Alle projecten' },
  { value: 'offerte', label: 'Offerte' },
  { value: 'gepland', label: 'Gepland' },
  { value: 'in_uitvoering', label: 'In uitvoering' },
  { value: 'afgerond', label: 'Afgerond' },
  { value: 'gefactureerd', label: 'Gefactureerd' },
];

export function Projects() {
  const [searchQuery, setSearchQuery] = useState('');
  const [statusFilter, setStatusFilter] = useState<ProjectStatus | 'alle'>('alle');
  const [selectedProject, setSelectedProject] = useState<Project | null>(null);

  const filteredProjects = projects.filter((project) => {
    const matchesSearch =
      project.naam.toLowerCase().includes(searchQuery.toLowerCase()) ||
      project.projectnummer.toLowerCase().includes(searchQuery.toLowerCase()) ||
      project.clientNaam.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesStatus =
      statusFilter === 'alle' || project.status === statusFilter;
    return matchesSearch && matchesStatus;
  });

  const totalWaarde = filteredProjects.reduce((sum, p) => sum + p.geschatteWaarde, 0);
  const totaalOppervlakte = filteredProjects.reduce(
    (sum, p) => sum + p.totaalOppervlakte,
    0
  );

  return (
    <div className="min-h-screen">
      <Header
        title="Projecten"
        subtitle={`${projects.length} projecten in totaal`}
      />

      <div className="p-6">
        {/* Filters & Actions */}
        <div className="bg-white rounded-xl p-4 shadow-sm border border-gray-100 mb-6">
          <div className="flex flex-wrap items-center gap-4">
            <div className="relative flex-1 min-w-[250px]">
              <Search className="w-5 h-5 absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
              <input
                type="text"
                placeholder="Zoek op projectnaam, nummer of klant..."
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
                  setStatusFilter(e.target.value as ProjectStatus | 'alle')
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
              Nieuw Project
            </button>
          </div>

          {/* Summary Stats */}
          <div className="flex items-center gap-6 mt-4 pt-4 border-t border-gray-100 text-sm">
            <div>
              <span className="text-gray-500">Getoond:</span>{' '}
              <span className="font-semibold">{filteredProjects.length} projecten</span>
            </div>
            <div>
              <span className="text-gray-500">Totale waarde:</span>{' '}
              <span className="font-semibold">{formatCurrency(totalWaarde)}</span>
            </div>
            <div>
              <span className="text-gray-500">Totaal oppervlakte:</span>{' '}
              <span className="font-semibold">
                {totaalOppervlakte.toLocaleString('nl-NL')} m²
              </span>
            </div>
          </div>
        </div>

        {/* Projects Grid */}
        <div className="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-4">
          {filteredProjects.map((project) => (
            <div
              key={project.id}
              onClick={() => setSelectedProject(project)}
              className="bg-white rounded-xl p-5 shadow-sm border border-gray-100 hover:shadow-md hover:border-blue-200 transition-all cursor-pointer"
            >
              <div className="flex items-start justify-between mb-3">
                <div>
                  <p className="text-xs text-gray-500 mb-1">
                    {project.projectnummer}
                  </p>
                  <h3 className="font-semibold text-gray-900 line-clamp-1">
                    {project.naam}
                  </h3>
                </div>
                <StatusBadge status={project.status} size="sm" />
              </div>

              <p className="text-sm text-gray-600 mb-4">{project.clientNaam}</p>

              <div className="space-y-2 text-sm mb-4">
                <div className="flex items-center gap-2 text-gray-500">
                  <MapPin className="w-4 h-4" />
                  <span>{project.locatie}</span>
                </div>
                <div className="flex items-center gap-2 text-gray-500">
                  <Calendar className="w-4 h-4" />
                  <span>
                    {format(new Date(project.startdatum), 'd MMM yyyy', {
                      locale: nl,
                    })}{' '}
                    -{' '}
                    {format(new Date(project.einddatum), 'd MMM yyyy', {
                      locale: nl,
                    })}
                  </span>
                </div>
                <div className="flex items-center gap-2 text-gray-500">
                  <Layers className="w-4 h-4" />
                  <span>
                    {project.comflorType} • {project.totaalOppervlakte.toLocaleString('nl-NL')} m²
                  </span>
                </div>
              </div>

              <div className="mb-4">
                <div className="flex items-center justify-between text-sm mb-1">
                  <span className="text-gray-500">Voortgang</span>
                  <span className="font-medium">{project.voortgang}%</span>
                </div>
                <ProgressBar value={project.voortgang} size="sm" />
              </div>

              <div className="flex items-center justify-between pt-3 border-t border-gray-100">
                <div className="flex items-center gap-2 text-sm text-gray-500">
                  <User className="w-4 h-4" />
                  <span>{project.projectleider}</span>
                </div>
                <div className="flex items-center gap-1 text-sm font-semibold text-gray-900">
                  <Euro className="w-4 h-4" />
                  {formatCurrency(project.geschatteWaarde)}
                </div>
              </div>
            </div>
          ))}
        </div>

        {filteredProjects.length === 0 && (
          <div className="text-center py-12">
            <p className="text-gray-500">
              Geen projecten gevonden die aan de criteria voldoen.
            </p>
          </div>
        )}
      </div>

      {/* Project Detail Modal */}
      {selectedProject && (
        <div
          className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4"
          onClick={() => setSelectedProject(null)}
        >
          <div
            className="bg-white rounded-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="p-6 border-b border-gray-100">
              <div className="flex items-start justify-between">
                <div>
                  <p className="text-sm text-gray-500 mb-1">
                    {selectedProject.projectnummer}
                  </p>
                  <h2 className="text-xl font-bold text-gray-900">
                    {selectedProject.naam}
                  </h2>
                </div>
                <button
                  onClick={() => setSelectedProject(null)}
                  className="p-2 hover:bg-gray-100 rounded-lg"
                >
                  <X className="w-5 h-5 text-gray-500" />
                </button>
              </div>
            </div>

            <div className="p-6 space-y-6">
              <div className="flex items-center gap-3">
                <StatusBadge status={selectedProject.status} />
                <StatusBadge status={selectedProject.prioriteit} />
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <p className="text-sm text-gray-500 mb-1">Klant</p>
                  <p className="font-medium">{selectedProject.clientNaam}</p>
                </div>
                <div>
                  <p className="text-sm text-gray-500 mb-1">Projectleider</p>
                  <p className="font-medium">{selectedProject.projectleider}</p>
                </div>
                <div>
                  <p className="text-sm text-gray-500 mb-1">Locatie</p>
                  <p className="font-medium">{selectedProject.locatie}</p>
                </div>
                <div>
                  <p className="text-sm text-gray-500 mb-1">Looptijd</p>
                  <p className="font-medium">
                    {format(new Date(selectedProject.startdatum), 'd MMM yyyy', {
                      locale: nl,
                    })}{' '}
                    t/m{' '}
                    {format(new Date(selectedProject.einddatum), 'd MMM yyyy', {
                      locale: nl,
                    })}
                  </p>
                </div>
              </div>

              <div className="bg-gray-50 rounded-xl p-4">
                <h4 className="font-medium text-gray-900 mb-3">
                  Technische specificaties
                </h4>
                <div className="grid grid-cols-3 gap-4 text-sm">
                  <div>
                    <p className="text-gray-500">ComFlor type</p>
                    <p className="font-semibold text-lg">
                      {selectedProject.comflorType}
                    </p>
                  </div>
                  <div>
                    <p className="text-gray-500">Oppervlakte</p>
                    <p className="font-semibold text-lg">
                      {selectedProject.totaalOppervlakte.toLocaleString('nl-NL')} m²
                    </p>
                  </div>
                  <div>
                    <p className="text-gray-500">Betondikte</p>
                    <p className="font-semibold text-lg">
                      {selectedProject.betondikte} mm
                    </p>
                  </div>
                </div>
              </div>

              <div>
                <div className="flex items-center justify-between mb-2">
                  <span className="text-sm text-gray-500">Voortgang</span>
                  <span className="text-sm font-medium">
                    {selectedProject.voortgang}%
                  </span>
                </div>
                <ProgressBar value={selectedProject.voortgang} size="lg" showLabel />
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div className="bg-blue-50 rounded-xl p-4">
                  <p className="text-sm text-blue-600 mb-1">Geschatte waarde</p>
                  <p className="text-2xl font-bold text-blue-900">
                    {formatCurrency(selectedProject.geschatteWaarde)}
                  </p>
                </div>
                <div className="bg-green-50 rounded-xl p-4">
                  <p className="text-sm text-green-600 mb-1">Gefactureerd</p>
                  <p className="text-2xl font-bold text-green-900">
                    {formatCurrency(selectedProject.gefactureerd)}
                  </p>
                </div>
              </div>

              {selectedProject.opmerkingen && (
                <div>
                  <p className="text-sm text-gray-500 mb-1">Opmerkingen</p>
                  <p className="text-gray-700">{selectedProject.opmerkingen}</p>
                </div>
              )}
            </div>

            <div className="p-6 border-t border-gray-100 flex justify-end gap-3">
              <button
                onClick={() => setSelectedProject(null)}
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
