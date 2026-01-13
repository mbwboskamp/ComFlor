import 'package:drift/drift.dart';
import 'package:driversense_app/core/storage/database/app_database.dart';
import 'package:driversense_app/core/storage/database/tables/messages_table.dart';

part 'messages_dao.g.dart';

@DriftAccessor(tables: [Messages])
class MessagesDao extends DatabaseAccessor<AppDatabase> with _$MessagesDaoMixin {
  MessagesDao(super.db);

  /// Get messages by conversation
  Future<List<Message>> getMessagesByConversation(String conversationId) {
    return (select(messages)
          ..where((t) => t.conversationId.equals(conversationId))
          ..orderBy([(t) => OrderingTerm.desc(t.sentAt)]))
        .get();
  }

  /// Get paginated messages by conversation
  Future<List<Message>> getPaginatedMessages(
    String conversationId, {
    required int limit,
    required int offset,
  }) {
    return (select(messages)
          ..where((t) => t.conversationId.equals(conversationId))
          ..orderBy([(t) => OrderingTerm.desc(t.sentAt)])
          ..limit(limit, offset: offset))
        .get();
  }

  /// Get unsynced messages
  Future<List<Message>> getUnsyncedMessages() {
    return (select(messages)..where((t) => t.isSynced.equals(false))).get();
  }

  /// Get unread messages
  Future<List<Message>> getUnreadMessages() {
    return (select(messages)
          ..where((t) => t.isIncoming.equals(true) & t.readAt.isNull()))
        .get();
  }

  /// Get unread count by conversation
  Future<int> getUnreadCountByConversation(String conversationId) async {
    final count = messages.id.count();
    final query = selectOnly(messages)
      ..where(messages.conversationId.equals(conversationId) &
          messages.isIncoming.equals(true) &
          messages.readAt.isNull())
      ..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Insert a message
  Future<void> insertMessage(MessagesCompanion message) {
    return into(messages).insert(message);
  }

  /// Insert multiple messages
  Future<void> insertMessages(List<MessagesCompanion> messagesList) async {
    await batch((batch) {
      batch.insertAll(messages, messagesList, mode: InsertMode.insertOrReplace);
    });
  }

  /// Mark message as read
  Future<void> markAsRead(String id) {
    return (update(messages)..where((t) => t.id.equals(id))).write(
      MessagesCompanion(readAt: Value(DateTime.now())),
    );
  }

  /// Mark all conversation messages as read
  Future<void> markConversationAsRead(String conversationId) {
    return (update(messages)
          ..where((t) => t.conversationId.equals(conversationId) & t.readAt.isNull()))
        .write(MessagesCompanion(readAt: Value(DateTime.now())));
  }

  /// Mark message as synced
  Future<void> markAsSynced(String id) {
    return (update(messages)..where((t) => t.id.equals(id))).write(
      const MessagesCompanion(isSynced: Value(true)),
    );
  }

  /// Delete message
  Future<int> deleteMessage(String id) {
    return (delete(messages)..where((t) => t.id.equals(id))).go();
  }

  /// Delete messages by conversation
  Future<int> deleteMessagesByConversation(String conversationId) {
    return (delete(messages)..where((t) => t.conversationId.equals(conversationId))).go();
  }

  /// Watch messages by conversation
  Stream<List<Message>> watchMessagesByConversation(String conversationId) {
    return (select(messages)
          ..where((t) => t.conversationId.equals(conversationId))
          ..orderBy([(t) => OrderingTerm.desc(t.sentAt)]))
        .watch();
  }

  /// Watch total unread count
  Stream<int> watchTotalUnreadCount() {
    return customSelect(
      'SELECT COUNT(*) as count FROM messages WHERE is_incoming = 1 AND read_at IS NULL',
      readsFrom: {messages},
    ).map((row) => row.read<int>('count')).watchSingle();
  }

  /// Get latest message per conversation
  Future<Map<String, Message>> getLatestMessagePerConversation() async {
    final allMessages = await (select(messages)
          ..orderBy([(t) => OrderingTerm.desc(t.sentAt)]))
        .get();

    final latestMap = <String, Message>{};
    for (final message in allMessages) {
      if (!latestMap.containsKey(message.conversationId)) {
        latestMap[message.conversationId] = message;
      }
    }
    return latestMap;
  }
}
