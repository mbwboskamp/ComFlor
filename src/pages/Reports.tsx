import { useState } from 'react';
import { Header } from '../components';
import {
  omzetPerMaand,
  projectenPerStatus,
  comflorVerkoop,
  projects,
  orders,
  clients,
  facturen,
} from '../data/sampleData';
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  Line,
  PieChart,
  Pie,
  Cell,
  Legend,
  ComposedChart,
} from 'recharts';
import {
  Download,
  TrendingUp,
  Euro,
  FolderKanban,
  ShoppingCart,
  Users,
} from 'lucide-react';

function formatCurrency(value: number): string {
  return new Intl.NumberFormat('nl-NL', {
    style: 'currency',
    currency: 'EUR',
    maximumFractionDigits: 0,
  }).format(value);
}

const COLORS = ['#3b82f6', '#22c55e', '#f59e0b', '#ef4444', '#8b5cf6', '#06b6d4'];

type ReportPeriod = 'maand' | 'kwartaal' | 'jaar';

export function Reports() {
  const [period, setPeriod] = useState<ReportPeriod>('jaar');

  // Calculate various metrics
  const totaalOmzet = omzetPerMaand.reduce((sum, m) => sum + m.omzet, 0);
  const totaalWinst = omzetPerMaand.reduce((sum, m) => sum + m.winst, 0);
  const gemOmzetPerMaand = totaalOmzet / 12;
  const winstMarge = (totaalWinst / totaalOmzet) * 100;

  const projectenData = {
    totaal: projects.length,
    actief: projects.filter((p) => p.status === 'in_uitvoering').length,
    afgerond: projects.filter(
      (p) => p.status === 'afgerond' || p.status === 'gefactureerd'
    ).length,
    totaleWaarde: projects.reduce((sum, p) => sum + p.geschatteWaarde, 0),
  };

  const ordersData = {
    totaal: orders.length,
    openstaand: orders.filter(
      (o) =>
        o.status === 'aangevraagd' ||
        o.status === 'bevestigd' ||
        o.status === 'in_productie'
    ).length,
    verzonden: orders.filter((o) => o.status === 'verzonden' || o.status === 'geleverd')
      .length,
    totaleWaarde: orders.reduce((sum, o) => sum + o.totaalPrijs, 0),
  };

  const facturenData = {
    totaal: facturen.length,
    betaald: facturen.filter((f) => f.betaald).length,
    openstaand: facturen.filter((f) => !f.betaald).length,
    totaalBedrag: facturen.reduce((sum, f) => sum + f.totaalBedrag, 0),
    openstaandBedrag: facturen
      .filter((f) => !f.betaald)
      .reduce((sum, f) => sum + f.totaalBedrag, 0),
  };

  // ComFlor type performance
  const comflorPerformance = comflorVerkoop.map((cf) => ({
    ...cf,
    margin: Math.round((cf.omzet / cf.oppervlakte) * 0.3), // simulated margin
  }));


  return (
    <div className="min-h-screen">
      <Header
        title="Rapportages & Analytics"
        subtitle="Uitgebreide analyses en prestatie-indicatoren"
      />

      <div className="p-6 space-y-6">
        {/* Period Selector & Export */}
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2 bg-white rounded-lg p-1 border border-gray-200">
            {(['maand', 'kwartaal', 'jaar'] as ReportPeriod[]).map((p) => (
              <button
                key={p}
                onClick={() => setPeriod(p)}
                className={`px-4 py-2 rounded-md text-sm font-medium transition-colors ${
                  period === p
                    ? 'bg-blue-600 text-white'
                    : 'text-gray-600 hover:bg-gray-100'
                }`}
              >
                {p.charAt(0).toUpperCase() + p.slice(1)}
              </button>
            ))}
          </div>

          <button className="flex items-center gap-2 px-4 py-2 bg-white border border-gray-200 rounded-lg hover:bg-gray-50">
            <Download className="w-4 h-4" />
            Export Rapport
          </button>
        </div>

        {/* Key Metrics */}
        <div className="grid grid-cols-4 gap-4">
          <div className="bg-gradient-to-br from-blue-500 to-blue-600 rounded-xl p-5 text-white">
            <div className="flex items-center gap-3 mb-4">
              <div className="w-10 h-10 bg-white/20 rounded-lg flex items-center justify-center">
                <Euro className="w-5 h-5" />
              </div>
              <span className="text-blue-100">Jaaromzet</span>
            </div>
            <p className="text-3xl font-bold">{formatCurrency(totaalOmzet)}</p>
            <p className="text-blue-100 text-sm mt-1">
              Gem. {formatCurrency(gemOmzetPerMaand)}/maand
            </p>
          </div>

          <div className="bg-gradient-to-br from-green-500 to-green-600 rounded-xl p-5 text-white">
            <div className="flex items-center gap-3 mb-4">
              <div className="w-10 h-10 bg-white/20 rounded-lg flex items-center justify-center">
                <TrendingUp className="w-5 h-5" />
              </div>
              <span className="text-green-100">Jaarwinst</span>
            </div>
            <p className="text-3xl font-bold">{formatCurrency(totaalWinst)}</p>
            <p className="text-green-100 text-sm mt-1">
              {winstMarge.toFixed(1)}% marge
            </p>
          </div>

          <div className="bg-gradient-to-br from-purple-500 to-purple-600 rounded-xl p-5 text-white">
            <div className="flex items-center gap-3 mb-4">
              <div className="w-10 h-10 bg-white/20 rounded-lg flex items-center justify-center">
                <FolderKanban className="w-5 h-5" />
              </div>
              <span className="text-purple-100">Projecten</span>
            </div>
            <p className="text-3xl font-bold">{projectenData.totaal}</p>
            <p className="text-purple-100 text-sm mt-1">
              {projectenData.actief} actief, {projectenData.afgerond} afgerond
            </p>
          </div>

          <div className="bg-gradient-to-br from-orange-500 to-orange-600 rounded-xl p-5 text-white">
            <div className="flex items-center gap-3 mb-4">
              <div className="w-10 h-10 bg-white/20 rounded-lg flex items-center justify-center">
                <Users className="w-5 h-5" />
              </div>
              <span className="text-orange-100">Klanten</span>
            </div>
            <p className="text-3xl font-bold">{clients.length}</p>
            <p className="text-orange-100 text-sm mt-1">
              {clients.reduce((sum, c) => sum + c.aantalProjecten, 0)} projecten
            </p>
          </div>
        </div>

        {/* Charts Row 1 */}
        <div className="grid grid-cols-2 gap-6">
          {/* Revenue & Profit Trend */}
          <div className="bg-white rounded-xl p-6 shadow-sm border border-gray-100">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">
              Omzet, Kosten & Winst Trend
            </h3>
            <div className="h-80">
              <ResponsiveContainer width="100%" height="100%">
                <ComposedChart data={omzetPerMaand}>
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
                  <Legend />
                  <Bar dataKey="kosten" fill="#f87171" name="Kosten" radius={[4, 4, 0, 0]} />
                  <Bar dataKey="winst" fill="#4ade80" name="Winst" radius={[4, 4, 0, 0]} />
                  <Line
                    type="monotone"
                    dataKey="omzet"
                    stroke="#3b82f6"
                    strokeWidth={3}
                    name="Omzet"
                    dot={{ r: 4 }}
                  />
                </ComposedChart>
              </ResponsiveContainer>
            </div>
          </div>

          {/* ComFlor Type Performance */}
          <div className="bg-white rounded-xl p-6 shadow-sm border border-gray-100">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">
              Verkoop per ComFlor Type
            </h3>
            <div className="h-80">
              <ResponsiveContainer width="100%" height="100%">
                <BarChart data={comflorPerformance}>
                  <CartesianGrid strokeDasharray="3 3" stroke="#f1f5f9" />
                  <XAxis dataKey="type" tick={{ fontSize: 12 }} stroke="#94a3b8" />
                  <YAxis
                    yAxisId="left"
                    tick={{ fontSize: 12 }}
                    stroke="#94a3b8"
                    tickFormatter={(v) => `${v / 1000}k m²`}
                  />
                  <YAxis
                    yAxisId="right"
                    orientation="right"
                    tick={{ fontSize: 12 }}
                    stroke="#94a3b8"
                    tickFormatter={(v) => `€${v / 1000}k`}
                  />
                  <Tooltip
                    formatter={(value, name) =>
                      name === 'Oppervlakte'
                        ? `${(value as number).toLocaleString()} m²`
                        : formatCurrency(value as number)
                    }
                    contentStyle={{
                      backgroundColor: 'white',
                      border: '1px solid #e2e8f0',
                      borderRadius: '8px',
                    }}
                  />
                  <Legend />
                  <Bar
                    yAxisId="left"
                    dataKey="oppervlakte"
                    fill="#3b82f6"
                    name="Oppervlakte"
                    radius={[4, 4, 0, 0]}
                  />
                  <Bar
                    yAxisId="right"
                    dataKey="omzet"
                    fill="#22c55e"
                    name="Omzet"
                    radius={[4, 4, 0, 0]}
                  />
                </BarChart>
              </ResponsiveContainer>
            </div>
          </div>
        </div>

        {/* Charts Row 2 */}
        <div className="grid grid-cols-3 gap-6">
          {/* Projects by Status */}
          <div className="bg-white rounded-xl p-6 shadow-sm border border-gray-100">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">
              Projecten per Status
            </h3>
            <div className="h-64">
              <ResponsiveContainer width="100%" height="100%">
                <PieChart>
                  <Pie
                    data={projectenPerStatus}
                    cx="50%"
                    cy="50%"
                    outerRadius={80}
                    dataKey="aantal"
                    label={({ payload }) => `${payload.status}: ${payload.aantal}`}
                    labelLine={false}
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
            <div className="mt-4 space-y-2">
              {projectenPerStatus.map((item, index) => (
                <div key={item.status} className="flex items-center justify-between text-sm">
                  <div className="flex items-center gap-2">
                    <div
                      className="w-3 h-3 rounded-full"
                      style={{ backgroundColor: COLORS[index % COLORS.length] }}
                    />
                    <span className="text-gray-600">{item.status}</span>
                  </div>
                  <span className="font-medium">{formatCurrency(item.waarde)}</span>
                </div>
              ))}
            </div>
          </div>

          {/* Orders Overview */}
          <div className="bg-white rounded-xl p-6 shadow-sm border border-gray-100">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">
              Orders Overzicht
            </h3>
            <div className="space-y-4">
              <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                <div>
                  <p className="text-sm text-gray-500">Totaal orders</p>
                  <p className="text-2xl font-bold text-gray-900">{ordersData.totaal}</p>
                </div>
                <ShoppingCart className="w-8 h-8 text-gray-400" />
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div className="p-3 bg-yellow-50 rounded-lg">
                  <p className="text-xs text-yellow-600">Openstaand</p>
                  <p className="text-xl font-bold text-yellow-700">
                    {ordersData.openstaand}
                  </p>
                </div>
                <div className="p-3 bg-green-50 rounded-lg">
                  <p className="text-xs text-green-600">Afgehandeld</p>
                  <p className="text-xl font-bold text-green-700">
                    {ordersData.verzonden}
                  </p>
                </div>
              </div>
              <div className="p-4 bg-blue-50 rounded-lg">
                <p className="text-sm text-blue-600">Totale orderwaarde</p>
                <p className="text-2xl font-bold text-blue-900">
                  {formatCurrency(ordersData.totaleWaarde)}
                </p>
              </div>
            </div>
          </div>

          {/* Invoices Overview */}
          <div className="bg-white rounded-xl p-6 shadow-sm border border-gray-100">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">
              Facturen Overzicht
            </h3>
            <div className="space-y-4">
              <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                <div>
                  <p className="text-sm text-gray-500">Totaal facturen</p>
                  <p className="text-2xl font-bold text-gray-900">
                    {facturenData.totaal}
                  </p>
                </div>
                <Euro className="w-8 h-8 text-gray-400" />
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div className="p-3 bg-green-50 rounded-lg">
                  <p className="text-xs text-green-600">Betaald</p>
                  <p className="text-xl font-bold text-green-700">
                    {facturenData.betaald}
                  </p>
                </div>
                <div className="p-3 bg-orange-50 rounded-lg">
                  <p className="text-xs text-orange-600">Openstaand</p>
                  <p className="text-xl font-bold text-orange-700">
                    {facturenData.openstaand}
                  </p>
                </div>
              </div>
              <div className="p-4 bg-orange-50 rounded-lg">
                <p className="text-sm text-orange-600">Openstaand bedrag</p>
                <p className="text-2xl font-bold text-orange-900">
                  {formatCurrency(facturenData.openstaandBedrag)}
                </p>
              </div>
            </div>
          </div>
        </div>

        {/* Top Clients Table */}
        <div className="bg-white rounded-xl p-6 shadow-sm border border-gray-100">
          <h3 className="text-lg font-semibold text-gray-900 mb-4">
            Top Klanten naar Projectwaarde
          </h3>
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="border-b border-gray-200">
                  <th className="text-left text-sm font-semibold text-gray-600 px-4 py-3">
                    Klant
                  </th>
                  <th className="text-left text-sm font-semibold text-gray-600 px-4 py-3">
                    Projecten
                  </th>
                  <th className="text-right text-sm font-semibold text-gray-600 px-4 py-3">
                    Totale waarde
                  </th>
                  <th className="text-right text-sm font-semibold text-gray-600 px-4 py-3">
                    Openstaand
                  </th>
                  <th className="text-right text-sm font-semibold text-gray-600 px-4 py-3">
                    Kredietlimiet
                  </th>
                </tr>
              </thead>
              <tbody>
                {clients
                  .sort((a, b) => {
                    const aValue = projects
                      .filter((p) => p.clientId === a.id)
                      .reduce((sum, p) => sum + p.geschatteWaarde, 0);
                    const bValue = projects
                      .filter((p) => p.clientId === b.id)
                      .reduce((sum, p) => sum + p.geschatteWaarde, 0);
                    return bValue - aValue;
                  })
                  .slice(0, 5)
                  .map((client) => {
                    const clientProjects = projects.filter(
                      (p) => p.clientId === client.id
                    );
                    const totaleWaarde = clientProjects.reduce(
                      (sum, p) => sum + p.geschatteWaarde,
                      0
                    );
                    return (
                      <tr key={client.id} className="border-b border-gray-100">
                        <td className="px-4 py-3">
                          <p className="font-medium text-gray-900">
                            {client.bedrijfsnaam}
                          </p>
                          <p className="text-sm text-gray-500">
                            {client.contactpersoon}
                          </p>
                        </td>
                        <td className="px-4 py-3 text-gray-600">
                          {clientProjects.length}
                        </td>
                        <td className="px-4 py-3 text-right font-semibold text-gray-900">
                          {formatCurrency(totaleWaarde)}
                        </td>
                        <td
                          className={`px-4 py-3 text-right font-medium ${
                            client.openstaandBedrag > 0
                              ? 'text-orange-600'
                              : 'text-green-600'
                          }`}
                        >
                          {formatCurrency(client.openstaandBedrag)}
                        </td>
                        <td className="px-4 py-3 text-right text-gray-600">
                          {formatCurrency(client.kredietlimiet)}
                        </td>
                      </tr>
                    );
                  })}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
}
