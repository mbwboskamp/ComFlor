const express = require('express');
const cors = require('cors');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const { v4: uuidv4 } = require('uuid');

const app = express();
const PORT = 8000;
const JWT_SECRET = 'driversense-dev-secret-key-2024';
const JWT_REFRESH_SECRET = 'driversense-dev-refresh-secret-2024';

// Middleware
app.use(cors());
app.use(express.json());

// In-memory database
const users = new Map();
const sessions = new Map();
const vehicles = new Map();
const trips = new Map();

// Initialize with a test user
const testUserId = uuidv4();
users.set('test@driversense.nl', {
  id: testUserId,
  email: 'test@driversense.nl',
  password: bcrypt.hashSync('Test1234!', 10),
  firstName: 'Test',
  lastName: 'Gebruiker',
  role: 'driver',
  companyId: 'company-1',
  language: 'nl',
  phoneNumber: '+31612345678',
  profileImageUrl: null,
  consentAccepted: true,
  consentVersion: '1.0',
  requires2FA: false,
  createdAt: new Date().toISOString(),
});

// Initialize with some vehicles
vehicles.set('vehicle-1', {
  id: 'vehicle-1',
  licensePlate: 'AB-123-CD',
  brand: 'Volvo',
  model: 'FH16',
  type: 'truck',
  year: 2022,
  lastKm: 125000,
});

vehicles.set('vehicle-2', {
  id: 'vehicle-2',
  licensePlate: 'EF-456-GH',
  brand: 'DAF',
  model: 'XF',
  type: 'truck',
  year: 2021,
  lastKm: 89000,
});

// Helper functions
function generateTokens(userId) {
  const accessToken = jwt.sign({ userId, type: 'access' }, JWT_SECRET, { expiresIn: '1h' });
  const refreshToken = jwt.sign({ userId, type: 'refresh' }, JWT_REFRESH_SECRET, { expiresIn: '7d' });
  return { accessToken, refreshToken };
}

function verifyAccessToken(token) {
  try {
    return jwt.verify(token, JWT_SECRET);
  } catch {
    return null;
  }
}

function authMiddleware(req, res, next) {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'Unauthorized', message: 'No token provided' });
  }

  const token = authHeader.split(' ')[1];
  const decoded = verifyAccessToken(token);

  if (!decoded) {
    return res.status(401).json({ error: 'Unauthorized', message: 'Invalid token' });
  }

  req.userId = decoded.userId;
  next();
}

// Request logging
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} ${req.method} ${req.path}`);
  next();
});

// ============ AUTH ENDPOINTS ============

// POST /api/v1/auth/login
app.post('/api/v1/auth/login', async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({
      error: 'ValidationError',
      message: 'Email and password are required'
    });
  }

  const user = users.get(email.toLowerCase());

  if (!user || !bcrypt.compareSync(password, user.password)) {
    return res.status(401).json({
      error: 'AuthenticationError',
      message: 'Invalid email or password'
    });
  }

  // Check if 2FA is required
  if (user.requires2FA) {
    const sessionToken = uuidv4();
    sessions.set(sessionToken, { userId: user.id, type: '2fa', expiresAt: Date.now() + 5 * 60 * 1000 });

    return res.json({
      status: 'requires_2fa',
      sessionToken,
      message: 'Please verify with 2FA code',
    });
  }

  // Check if consent is needed
  if (!user.consentAccepted) {
    const { accessToken, refreshToken } = generateTokens(user.id);

    return res.json({
      status: 'requires_consent',
      accessToken,
      refreshToken,
      user: {
        id: user.id,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        role: user.role,
        companyId: user.companyId,
        language: user.language,
      },
    });
  }

  // Success - return tokens
  const { accessToken, refreshToken } = generateTokens(user.id);

  res.json({
    status: 'authenticated',
    accessToken,
    refreshToken,
    user: {
      id: user.id,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      role: user.role,
      companyId: user.companyId,
      language: user.language,
      phoneNumber: user.phoneNumber,
      profileImageUrl: user.profileImageUrl,
    },
  });
});

// POST /api/v1/auth/verify-2fa
app.post('/api/v1/auth/verify-2fa', (req, res) => {
  const { session_token, code } = req.body;

  const session = sessions.get(session_token);
  if (!session || session.type !== '2fa' || session.expiresAt < Date.now()) {
    return res.status(401).json({ error: 'InvalidSession', message: 'Invalid or expired session' });
  }

  // For dev, accept any 6-digit code
  if (!/^\d{6}$/.test(code)) {
    return res.status(400).json({ error: 'InvalidCode', message: 'Invalid 2FA code format' });
  }

  sessions.delete(session_token);

  const user = [...users.values()].find(u => u.id === session.userId);
  const { accessToken, refreshToken } = generateTokens(user.id);

  res.json({
    status: 'authenticated',
    accessToken,
    refreshToken,
    user: {
      id: user.id,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      role: user.role,
      companyId: user.companyId,
      language: user.language,
    },
  });
});

// POST /api/v1/auth/refresh
app.post('/api/v1/auth/refresh', (req, res) => {
  const { refresh_token } = req.body;

  try {
    const decoded = jwt.verify(refresh_token, JWT_REFRESH_SECRET);
    const { accessToken, refreshToken } = generateTokens(decoded.userId);

    res.json({ accessToken, refreshToken });
  } catch {
    res.status(401).json({ error: 'InvalidToken', message: 'Invalid refresh token' });
  }
});

// POST /api/v1/auth/logout
app.post('/api/v1/auth/logout', authMiddleware, (req, res) => {
  res.status(204).send();
});

// GET /api/v1/auth/profile
app.get('/api/v1/auth/profile', authMiddleware, (req, res) => {
  const user = [...users.values()].find(u => u.id === req.userId);

  if (!user) {
    return res.status(404).json({ error: 'NotFound', message: 'User not found' });
  }

  res.json({
    id: user.id,
    email: user.email,
    firstName: user.firstName,
    lastName: user.lastName,
    role: user.role,
    companyId: user.companyId,
    language: user.language,
    phoneNumber: user.phoneNumber,
    profileImageUrl: user.profileImageUrl,
  });
});

// PATCH /api/v1/auth/profile
app.patch('/api/v1/auth/profile', authMiddleware, (req, res) => {
  const user = [...users.values()].find(u => u.id === req.userId);

  if (!user) {
    return res.status(404).json({ error: 'NotFound', message: 'User not found' });
  }

  const { first_name, last_name, language, phone_number } = req.body;

  if (first_name) user.firstName = first_name;
  if (last_name) user.lastName = last_name;
  if (language) user.language = language;
  if (phone_number) user.phoneNumber = phone_number;

  res.json({
    id: user.id,
    email: user.email,
    firstName: user.firstName,
    lastName: user.lastName,
    role: user.role,
    companyId: user.companyId,
    language: user.language,
    phoneNumber: user.phoneNumber,
    profileImageUrl: user.profileImageUrl,
  });
});

// POST /api/v1/auth/consent
app.post('/api/v1/auth/consent', authMiddleware, (req, res) => {
  const user = [...users.values()].find(u => u.id === req.userId);

  if (!user) {
    return res.status(404).json({ error: 'NotFound', message: 'User not found' });
  }

  user.consentAccepted = true;
  user.consentVersion = req.body.consent_version || '1.0';

  res.status(204).send();
});

// POST /api/v1/auth/forgot-password
app.post('/api/v1/auth/forgot-password', (req, res) => {
  // Always return success for security
  res.json({ message: 'If the email exists, a password reset link has been sent.' });
});

// ============ VEHICLE ENDPOINTS ============

// GET /api/v1/vehicles/assigned
app.get('/api/v1/vehicles/assigned', authMiddleware, (req, res) => {
  res.json({
    vehicles: [...vehicles.values()],
  });
});

// GET /api/v1/vehicles/:id
app.get('/api/v1/vehicles/:id', authMiddleware, (req, res) => {
  const vehicle = vehicles.get(req.params.id);

  if (!vehicle) {
    return res.status(404).json({ error: 'NotFound', message: 'Vehicle not found' });
  }

  res.json(vehicle);
});

// ============ CHECK ENDPOINTS ============

// GET /api/v1/checks/questions
app.get('/api/v1/checks/questions', authMiddleware, (req, res) => {
  const type = req.query.type || 'start';

  const questions = type === 'start' ? [
    { id: 'q1', text: 'Heb je goed geslapen?', type: 'boolean', required: true },
    { id: 'q2', text: 'Heb je alcohol of drugs gebruikt in de laatste 24 uur?', type: 'boolean', required: true },
    { id: 'q3', text: 'Zijn er beschadigingen aan het voertuig?', type: 'boolean', required: true },
    { id: 'q4', text: 'Opmerkingen', type: 'text', required: false },
  ] : [
    { id: 'q5', text: 'Waren er incidenten tijdens de rit?', type: 'boolean', required: true },
    { id: 'q6', text: 'Is het voertuig schoon achtergelaten?', type: 'boolean', required: true },
    { id: 'q7', text: 'Opmerkingen', type: 'text', required: false },
  ];

  res.json({ questions });
});

// POST /api/v1/checks/start
app.post('/api/v1/checks/start', authMiddleware, (req, res) => {
  const checkId = uuidv4();

  res.json({
    id: checkId,
    status: 'completed',
    createdAt: new Date().toISOString(),
  });
});

// POST /api/v1/checks/end
app.post('/api/v1/checks/end', authMiddleware, (req, res) => {
  const checkId = uuidv4();

  res.json({
    id: checkId,
    status: 'completed',
    createdAt: new Date().toISOString(),
  });
});

// ============ TRIP ENDPOINTS ============

// GET /api/v1/trips/active
app.get('/api/v1/trips/active', authMiddleware, (req, res) => {
  const activeTrip = [...trips.values()].find(t => t.userId === req.userId && t.status === 'active');

  if (!activeTrip) {
    return res.status(404).json({ error: 'NotFound', message: 'No active trip' });
  }

  res.json(activeTrip);
});

// POST /api/v1/trips
app.post('/api/v1/trips', authMiddleware, (req, res) => {
  const tripId = uuidv4();
  const trip = {
    id: tripId,
    userId: req.userId,
    vehicleId: req.body.vehicle_id,
    status: 'active',
    startedAt: new Date().toISOString(),
    startLocation: req.body.start_location,
    points: [],
  };

  trips.set(tripId, trip);

  res.status(201).json(trip);
});

// POST /api/v1/trips/:id/stop
app.post('/api/v1/trips/:id/stop', authMiddleware, (req, res) => {
  const trip = trips.get(req.params.id);

  if (!trip) {
    return res.status(404).json({ error: 'NotFound', message: 'Trip not found' });
  }

  trip.status = 'completed';
  trip.endedAt = new Date().toISOString();
  trip.endLocation = req.body.end_location;
  trip.endKm = req.body.end_km;

  res.json(trip);
});

// GET /api/v1/trips
app.get('/api/v1/trips', authMiddleware, (req, res) => {
  const userTrips = [...trips.values()]
    .filter(t => t.userId === req.userId)
    .sort((a, b) => new Date(b.startedAt) - new Date(a.startedAt));

  res.json({ trips: userTrips });
});

// GET /api/v1/trips/statistics
app.get('/api/v1/trips/statistics', authMiddleware, (req, res) => {
  res.json({
    totalTrips: 42,
    totalKm: 15234,
    totalHours: 312,
    averageSpeed: 65,
    safetyScore: 92,
    streakDays: 7,
  });
});

// ============ INCIDENT ENDPOINTS ============

// GET /api/v1/incidents/types
app.get('/api/v1/incidents/types', authMiddleware, (req, res) => {
  res.json({
    types: [
      { id: 'accident', label: 'Ongeval', icon: 'car_crash' },
      { id: 'breakdown', label: 'Pech', icon: 'build' },
      { id: 'traffic', label: 'File/Vertraging', icon: 'traffic' },
      { id: 'weather', label: 'Weer', icon: 'cloud' },
      { id: 'road_condition', label: 'Wegconditie', icon: 'road' },
      { id: 'other', label: 'Overig', icon: 'more_horiz' },
    ],
  });
});

// POST /api/v1/incidents
app.post('/api/v1/incidents', authMiddleware, (req, res) => {
  const incidentId = uuidv4();

  res.status(201).json({
    id: incidentId,
    type: req.body.type,
    description: req.body.description,
    location: req.body.location,
    createdAt: new Date().toISOString(),
    status: 'reported',
  });
});

// ============ PRIVACY ZONE ENDPOINTS ============

// GET /api/v1/trips/privacy-zones
app.get('/api/v1/trips/privacy-zones', authMiddleware, (req, res) => {
  res.json({
    zones: [
      {
        id: 'zone-1',
        name: 'Thuis',
        latitude: 52.3676,
        longitude: 4.9041,
        radiusMeters: 200,
      },
    ],
  });
});

// POST /api/v1/trips/privacy-zones
app.post('/api/v1/trips/privacy-zones', authMiddleware, (req, res) => {
  const zoneId = uuidv4();

  res.status(201).json({
    id: zoneId,
    name: req.body.name,
    latitude: req.body.latitude,
    longitude: req.body.longitude,
    radiusMeters: req.body.radius_meters || 200,
  });
});

// ============ CHAT ENDPOINTS ============

// GET /api/v1/chat/conversations
app.get('/api/v1/chat/conversations', authMiddleware, (req, res) => {
  res.json({
    conversations: [
      {
        id: 'conv-1',
        title: 'Planning',
        lastMessage: 'Je route voor morgen is klaar',
        lastMessageAt: new Date().toISOString(),
        unreadCount: 1,
      },
    ],
  });
});

// GET /api/v1/chat/conversations/:id/messages
app.get('/api/v1/chat/conversations/:id/messages', authMiddleware, (req, res) => {
  res.json({
    messages: [
      {
        id: 'msg-1',
        conversationId: req.params.id,
        content: 'Je route voor morgen is klaar',
        senderId: 'planner-1',
        senderName: 'Planning',
        createdAt: new Date().toISOString(),
        isRead: false,
      },
    ],
  });
});

// POST /api/v1/chat/conversations/:id/messages
app.post('/api/v1/chat/conversations/:id/messages', authMiddleware, (req, res) => {
  const messageId = uuidv4();

  res.status(201).json({
    id: messageId,
    conversationId: req.params.id,
    content: req.body.content,
    senderId: req.userId,
    createdAt: new Date().toISOString(),
    isRead: true,
  });
});

// ============ ACHIEVEMENT ENDPOINTS ============

// GET /api/v1/achievements
app.get('/api/v1/achievements', authMiddleware, (req, res) => {
  res.json({
    achievements: [
      { id: 'ach-1', name: 'Eerste Rit', description: 'Voltooi je eerste rit', unlocked: true, unlockedAt: '2024-01-15T10:00:00Z' },
      { id: 'ach-2', name: 'Week Streak', description: 'Rij 7 dagen achter elkaar', unlocked: true, unlockedAt: '2024-01-22T18:00:00Z' },
      { id: 'ach-3', name: 'Veilige Chauffeur', description: 'Geen incidenten in 30 dagen', unlocked: false, progress: 0.7 },
    ],
  });
});

// GET /api/v1/achievements/streaks
app.get('/api/v1/achievements/streaks', authMiddleware, (req, res) => {
  res.json({
    currentStreak: 7,
    longestStreak: 14,
    totalDaysWorked: 42,
  });
});

// ============ EMERGENCY ENDPOINTS ============

// POST /api/v1/emergency/panic
app.post('/api/v1/emergency/panic', authMiddleware, (req, res) => {
  console.log('PANIC ALERT from user:', req.userId, 'at location:', req.body.location);

  res.json({
    status: 'received',
    message: 'Je locatie is gedeeld met de planner',
    timestamp: new Date().toISOString(),
  });
});

// ============ NOTIFICATION ENDPOINTS ============

// GET /api/v1/notifications/settings
app.get('/api/v1/notifications/settings', authMiddleware, (req, res) => {
  res.json({
    pushEnabled: true,
    chatNotifications: true,
    tripReminders: true,
    achievementNotifications: true,
  });
});

// POST /api/v1/notifications/register-token
app.post('/api/v1/notifications/register-token', authMiddleware, (req, res) => {
  res.status(204).send();
});

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Start server
app.listen(PORT, '0.0.0.0', () => {
  console.log(`\n=================================`);
  console.log(`DriverSense API Server`);
  console.log(`=================================`);
  console.log(`Server running on http://0.0.0.0:${PORT}`);
  console.log(`API Base: http://localhost:${PORT}/api/v1`);
  console.log(`\nTest credentials:`);
  console.log(`  Email: test@driversense.nl`);
  console.log(`  Password: Test1234!`);
  console.log(`=================================\n`);
});
