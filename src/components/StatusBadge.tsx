import type { ProjectStatus, OrderStatus, Priority } from '../types';

type BadgeType = ProjectStatus | OrderStatus | Priority;

interface StatusBadgeProps {
  status: BadgeType;
  size?: 'sm' | 'md';
}

const statusConfig: Record<BadgeType, { label: string; className: string }> = {
  // Project statuses
  offerte: { label: 'Offerte', className: 'bg-purple-100 text-purple-700' },
  gepland: { label: 'Gepland', className: 'bg-blue-100 text-blue-700' },
  in_uitvoering: { label: 'In uitvoering', className: 'bg-yellow-100 text-yellow-700' },
  afgerond: { label: 'Afgerond', className: 'bg-green-100 text-green-700' },
  gefactureerd: { label: 'Gefactureerd', className: 'bg-gray-100 text-gray-700' },

  // Order statuses
  aangevraagd: { label: 'Aangevraagd', className: 'bg-purple-100 text-purple-700' },
  bevestigd: { label: 'Bevestigd', className: 'bg-blue-100 text-blue-700' },
  in_productie: { label: 'In productie', className: 'bg-yellow-100 text-yellow-700' },
  verzonden: { label: 'Verzonden', className: 'bg-orange-100 text-orange-700' },
  geleverd: { label: 'Geleverd', className: 'bg-green-100 text-green-700' },

  // Priorities
  laag: { label: 'Laag', className: 'bg-gray-100 text-gray-700' },
  normaal: { label: 'Normaal', className: 'bg-blue-100 text-blue-700' },
  hoog: { label: 'Hoog', className: 'bg-orange-100 text-orange-700' },
  urgent: { label: 'Urgent', className: 'bg-red-100 text-red-700' },
};

export function StatusBadge({ status, size = 'md' }: StatusBadgeProps) {
  const config = statusConfig[status];
  const sizeClasses = size === 'sm' ? 'px-2 py-0.5 text-xs' : 'px-2.5 py-1 text-sm';

  return (
    <span
      className={`inline-flex items-center font-medium rounded-full ${config.className} ${sizeClasses}`}
    >
      {config.label}
    </span>
  );
}
