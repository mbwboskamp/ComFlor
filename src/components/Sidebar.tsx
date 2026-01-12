import { NavLink } from 'react-router-dom';
import {
  LayoutDashboard,
  FolderKanban,
  ShoppingCart,
  Users,
  Package,
  BarChart3,
  Settings,
  Building2,
} from 'lucide-react';

const navItems = [
  { to: '/', icon: LayoutDashboard, label: 'Dashboard' },
  { to: '/projecten', icon: FolderKanban, label: 'Projecten' },
  { to: '/orders', icon: ShoppingCart, label: 'Orders' },
  { to: '/klanten', icon: Users, label: 'Klanten' },
  { to: '/materialen', icon: Package, label: 'Materialen' },
  { to: '/rapportages', icon: BarChart3, label: 'Rapportages' },
];

export function Sidebar() {
  return (
    <aside className="w-64 bg-slate-900 text-white min-h-screen flex flex-col">
      <div className="p-4 border-b border-slate-700">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 bg-blue-600 rounded-lg flex items-center justify-center">
            <Building2 className="w-6 h-6" />
          </div>
          <div>
            <h1 className="font-bold text-lg">ComFlor</h1>
            <p className="text-xs text-slate-400">Management Dashboard</p>
          </div>
        </div>
      </div>

      <nav className="flex-1 p-4">
        <ul className="space-y-1">
          {navItems.map((item) => (
            <li key={item.to}>
              <NavLink
                to={item.to}
                className={({ isActive }) =>
                  `flex items-center gap-3 px-3 py-2.5 rounded-lg transition-colors ${
                    isActive
                      ? 'bg-blue-600 text-white'
                      : 'text-slate-300 hover:bg-slate-800 hover:text-white'
                  }`
                }
              >
                <item.icon className="w-5 h-5" />
                <span>{item.label}</span>
              </NavLink>
            </li>
          ))}
        </ul>
      </nav>

      <div className="p-4 border-t border-slate-700">
        <NavLink
          to="/instellingen"
          className={({ isActive }) =>
            `flex items-center gap-3 px-3 py-2.5 rounded-lg transition-colors ${
              isActive
                ? 'bg-blue-600 text-white'
                : 'text-slate-300 hover:bg-slate-800 hover:text-white'
            }`
          }
        >
          <Settings className="w-5 h-5" />
          <span>Instellingen</span>
        </NavLink>
      </div>
    </aside>
  );
}
