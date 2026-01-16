import 'package:drift/drift.dart';

/// Table for storing chat messages
class Messages extends Table {
  /// Unique identifier (UUID)
  TextColumn get id => text()();

  /// Conversation/thread ID
  TextColumn get conversationId => text()();

  /// Sender user ID
  TextColumn get senderId => text()();

  /// Sender name for display
  TextColumn get senderName => text()();

  /// Message content
  TextColumn get content => text()();

  /// Message type: 'text', 'image', 'file', 'system'
  TextColumn get type => text().withDefault(const Constant('text'))();

  /// URL for attached media
  TextColumn get mediaUrl => text().nullable()();

  /// Local path for attached media
  TextColumn get mediaLocalPath => text().nullable()();

  /// When the message was sent
  DateTimeColumn get sentAt => dateTime()();

  /// When the message was delivered
  DateTimeColumn get deliveredAt => dateTime().nullable()();

  /// When the message was read
  DateTimeColumn get readAt => dateTime().nullable()();

  /// Whether this is an incoming message
  BoolColumn get isIncoming => boolean()();

  /// Whether the message has been synced
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
