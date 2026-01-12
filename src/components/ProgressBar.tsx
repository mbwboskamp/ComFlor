interface ProgressBarProps {
  value: number;
  max?: number;
  size?: 'sm' | 'md' | 'lg';
  showLabel?: boolean;
  color?: 'blue' | 'green' | 'orange' | 'red';
}

const sizeClasses = {
  sm: 'h-1.5',
  md: 'h-2.5',
  lg: 'h-4',
};

const colorClasses = {
  blue: 'bg-blue-600',
  green: 'bg-green-600',
  orange: 'bg-orange-500',
  red: 'bg-red-600',
};

function getAutoColor(value: number): 'blue' | 'green' | 'orange' | 'red' {
  if (value >= 75) return 'green';
  if (value >= 50) return 'blue';
  if (value >= 25) return 'orange';
  return 'red';
}

export function ProgressBar({
  value,
  max = 100,
  size = 'md',
  showLabel = false,
  color,
}: ProgressBarProps) {
  const percentage = Math.min((value / max) * 100, 100);
  const barColor = color || getAutoColor(percentage);

  return (
    <div className="flex items-center gap-2">
      <div className={`flex-1 bg-gray-200 rounded-full overflow-hidden ${sizeClasses[size]}`}>
        <div
          className={`h-full rounded-full transition-all duration-300 ${colorClasses[barColor]}`}
          style={{ width: `${percentage}%` }}
        />
      </div>
      {showLabel && (
        <span className="text-sm font-medium text-gray-600 min-w-[3rem] text-right">
          {Math.round(percentage)}%
        </span>
      )}
    </div>
  );
}
