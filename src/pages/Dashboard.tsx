import { Header, StatCard, StatusBadge, ProgressBar } from '../components';
import {
  FolderKanban,
  ShoppingCart,
  Euro,
  FileText,
  Clock,
  ThumbsUp,
  Package,
  CheckCircle2,
  ArrowRight,
} from 'lucide-react';
import {
  AreaChart,
  Area,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  BarChart,
  Bar,
  PieChart,
  Pie,
  Cell,
} from 'recharts';
import {
  dashboardKPIs,
  omzetPerMaand,
  projectenPerStatus,
  comflorVerkoop,
  recenteActiviteiten,
  projects,
} from '../data/sampleData';
import { Link } from 'react-router-dom';
import { format } from 'date-fns';
import { nl } from 'date-fns/locale';

const COLORS = ['#8b5cf6', '#3b82f6', '#f59e0b', '#22c55e', '#6b7280'];

function formatCurrency(value: number): string {
  return new Intl.NumberFormat('nl-NL', {
    style: 'currency',
    currency: 'EUR',
    maximumFractionDigits: 0,
  }).format(value);
}

function formatNumber(value: number): string {
  return new Intl.NumberFormat('nl-NL').format(value);
}

export function Dashboard() {
  const omzetGroei = Math.round(
    ((dashboardKPIs.omzetDezeMaand - dashboardKPIs.omzetVorigeMaand) /
      dashboardKPIs.omzetVorigeMaand) *
      100
  );

  const actieveProjecten = projects.filter(
    (p) => p.status === 'in_uitvoering' || p.status === 'gepland'
  );

  return (
    <div className="min-h-screen">
      <Header
        title="Dashboard"
        subtitle={`Welkom terug! Hier is een overzicht van vandaag, ${format(new Date(), 'd MMMM yyyy', { locale: nl })}`}
      />

      <div className="p-6 space-y-6">
        {/* KPI Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
          <StatCard
            title="Actieve Projecten"
            value={dashboardKPIs.actieveProjecten}
            icon={FolderKanban}
            color="blue"
          />
          <StatCard
            title="Open Orders"
            value={dashboardKPIs.openOrders}
            icon={ShoppingCart}
            color="orange"
          />
          <StatCard
            title="Omzet deze maand"
            value={formatCurrency(dashboardKPIs.omzetDezeMaand)}
            icon={Euro}
            trend={omzetGroei}
            trendLabel="vs vorige maand"
            color="green"
          />
          <StatCard
            title="Openstaande facturen"
            value={formatCurrency(dashboardKPIs.openstaandeFacturen)}
            icon={FileText}
            color="red"
          />
        </div>

        {/* Secondary KPI Cards */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
          <StatCard
            title="Gem. levertijd"
            value={`${dashboardKPIs.gemiddeldeLevertijd} dagen`}
            icon={Clock}
            color="purple"
          />
          <StatCard
            title="Klanttevredenheid"
            value={`${dashboardKPIs.klanttevredenheid}%`}
            icon={ThumbsUp}
            color="green"
          />
          <StatCard
            title="Voorraadwaarde"
            value={formatCurrency(dashboardKPIs.voorraadWaarde)}
            icon={Package}
            color="blue"
          />
          <StatCard
            title="Projecten op schema"
            value={`${dashboardKPIs.projectenOpSchema}%`}
            icon={CheckCircle2}
            color="green"
          />
        </div>

        {/* Charts Row */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Revenue Chart */}
          <div className="bg-white rounded-xl p-6 shadow-sm border border-gray-100">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">
              Omzet & Winst Overzicht
            </h3>
            <div className="h-72">
              <ResponsiveContainer width="100%" height="100%">
                <AreaChart data={omzetPerMaand}>
                  <defs>
                    <linearGradient id="colorOmzet" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="5%" stopColor="#3b82f6" stopOpacity={0.3} />
                      <stop offset="95%" stopColor="#3b82f6" stopOpacity={0} />
                    </linearGradient>
                    <linearGradient id="colorWinst" x1="0" y1="0" x2="0" y2="1">
                      <stop offset="5%" stopColor="#22c55e" stopOpacity={0.3} />
                      <stop offset="95%" stopColor="#22c55e" stopOpacity={0} />
                    </linearGradient>
                  </defs>
                  <CartesianGrid strokeDasharray="3 3" stroke="#f1f5f9" />
                  <XAxis dataKey="maand" tick={{ fontSize: 12 }} stroke="#94a3b8" />
                  <YAxis
                    tick={{ fontSize: 12 }}
                    stroke="#94a3b8"
                    tickFormatter={(v) => `€${v / 1000}k`}
                  />
                  <Tooltip
                    formatter={(value) => formatCurrency(value as number)}
                    contentStyle={{
                      backgroundColor: 'white',
                      border: '1px solid #e2e8f0',
                      borderRadius: '8px',
                    }}
                  />
                  <Area
                    type="monotone"
                    dataKey="omzet"
                    stroke="#3b82f6"
                    strokeWidth={2}
                    fill="url(#colorOmzet)"
                    name="Omzet"
                  />
                  <Area
                    type="monotone"
                    dataKey="winst"
                    stroke="#22c55e"
                    strokeWidth={2}
                    fill="url(#colorWinst)"
                    name="Winst"
                  />
                </AreaChart>
              </ResponsiveContainer>
            </div>
          </div>

          {/* Projects by Status */}
          <div className="bg-white rounded-xl p-6 shadow-sm border border-gray-100">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">
              Projecten per Status
            </h3>
            <div className="h-72 flex items-center">
              <div className="w-1/2">
                <ResponsiveContainer width="100%" height={250}>
                  <PieChart>
                    <Pie
                      data={projectenPerStatus}
                      cx="50%"
                      cy="50%"
                      innerRadius={60}
                      outerRadius={90}
                      paddingAngle={3}
                      dataKey="aantal"
                    >
                      {projectenPerStatus.map((_, index) => (
                        <Cell
                          key={`cell-${index}`}
                          fill={COLORS[index % COLORS.length]}
                        />
                      ))}
                    </Pie>
                    <Tooltip />
                  </PieChart>
                </ResponsiveContainer>
              </div>
              <div className="w-1/2 space-y-2">
                {projectenPerStatus.map((item, index) => (
                  <div key={item.status} className="flex items-center gap-2">
                    <div
                      className="w-3 h-3 rounded-full"
                      style={{ backgroundColor: COLORS[index % COLORS.length] }}
                    />
                    <span className="text-sm text-gray-600 flex-1">
                      {item.status}
                    </span>
                    <span className="text-sm font-medium text-gray-900">
                      {item.aantal}
                    </span>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>

        {/* ComFlor Sales & Active Projects */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* ComFlor Type Sales */}
          <div className="bg-white rounded-xl p-6 shadow-sm border border-gray-100">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">
              Verkoop per ComFlor Type
            </h3>
            <div className="h-72">
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={comflorVerkoop} layout="vertical">
                  <CartesianGrid strokeDasharray="3 3" stroke="#f1f5f9" />
                  <XAxis
                    type="number"
                    tick={{ fontSize: 12 }}
                    stroke="#94a3b8"
                    tickFormatter={(v) => `${v / 1000}k m²`}
                  />
                  <YAxis
                    type="category"
                    dataKey="type"
                    tick={{ fontSize: 12 }}
                    stroke="#94a3b8"
                    width={60}
                  />
                  <Tooltip
                    formatter={(value) => `${formatNumber(value as number)} m²`}
                    contentStyle={{
                      backgroundColor: 'white',
                      border: '1px solid #e2e8f0',
                      borderRadius: '8px',
                    }}
                  />
                  <Bar dataKey="oppervlakte" fill="#3b82f6" radius={[0, 4, 4, 0]} />
                </BarChart>
              </ResponsiveContainer>
            </div>
          </div>

          {/* Active Projects List */}
          <div className="bg-white rounded-xl p-6 shadow-sm border border-gray-100">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-lg font-semibold text-gray-900">
                Actieve Projecten
              </h3>
              <Link
                to="/projecten"
                className="text-sm text-blue-600 hover:text-blue-700 flex items-center gap-1"
              >
                Bekijk alle
                <ArrowRight className="w-4 h-4" />
              </Link>
            </div>
            <div className="space-y-4">
              {actieveProjecten.slice(0, 4).map((project) => (
                <div
                  key={project.id}
                  className="p-4 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors"
                >
                  <div className="flex items-start justify-between mb-2">
                    <div>
                      <p className="font-medium text-gray-900">{project.naam}</p>
                      <p className="text-sm text-gray-500">{project.clientNaam}</p>
                    </div>
                    <StatusBadge status={project.status} size="sm" />
                  </div>
                  <div className="mt-3">
                    <div className="flex items-center justify-between text-sm mb-1">
                      <span className="text-gray-500">Voortgang</span>
                      <span className="font-medium">{project.voortgang}%</span>
                    </div>
                    <ProgressBar value={project.voortgang} size="sm" />
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Recent Activities */}
        <div className="bg-white rounded-xl p-6 shadow-sm border border-gray-100">
          <h3 className="text-lg font-semibold text-gray-900 mb-4">
            Recente Activiteiten
          </h3>
          <div className="space-y-4">
            {recenteActiviteiten.map((activiteit) => (
              <div
                key={activiteit.id}
                className="flex items-start gap-4 p-3 hover:bg-gray-50 rounded-lg transition-colors"
              >
                <div
                  className={`w-10 h-10 rounded-full flex items-center justify-center flex-shrink-0 ${
                    activiteit.type === 'project'
                      ? 'bg-blue-100 text-blue-600'
                      : activiteit.type === 'order'
                      ? 'bg-orange-100 text-orange-600'
                      : activiteit.type === 'factuur'
                      ? 'bg-green-100 text-green-600'
                      : 'bg-purple-100 text-purple-600'
                  }`}
                >
                  {activiteit.type === 'project' && (
                    <FolderKanban className="w-5 h-5" />
                  )}
                  {activiteit.type === 'order' && (
                    <ShoppingCart className="w-5 h-5" />
                  )}
                  {activiteit.type === 'factuur' && <FileText className="w-5 h-5" />}
                  {activiteit.type === 'client' && (
                    <span className="text-lg">👤</span>
                  )}
                </div>
                <div className="flex-1 min-w-0">
                  <p className="text-sm font-medium text-gray-900">
                    {activiteit.beschrijving}
                  </p>
                  <p className="text-sm text-gray-500">
                    {activiteit.gebruiker} •{' '}
                    {format(new Date(activiteit.tijdstip), "d MMM 'om' HH:mm", {
                      locale: nl,
                    })}
                  </p>
                </div>
                <span
                  className={`px-2 py-1 rounded text-xs font-medium ${
                    activiteit.actie === 'Nieuw' || activiteit.actie === 'Aangemaakt'
                      ? 'bg-blue-100 text-blue-700'
                      : activiteit.actie === 'Update'
                      ? 'bg-yellow-100 text-yellow-700'
                      : activiteit.actie === 'Betaald'
                      ? 'bg-green-100 text-green-700'
                      : activiteit.actie === 'Verzonden'
                      ? 'bg-orange-100 text-orange-700'
                      : 'bg-gray-100 text-gray-700'
                  }`}
                >
                  {activiteit.actie}
                </span>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}
