import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:driversense_app/core/router/routes.dart';
import 'package:driversense_app/core/theme/app_spacing.dart';
import 'package:driversense_app/core/theme/app_colors.dart';
import 'package:driversense_app/core/utils/extensions/context_extensions.dart';

/// Chat list page showing list of conversations
class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  // Mock conversation data
  List<Map<String, dynamic>> get _conversations => [
    {
      'id': '1',
      'name': 'Planner Support',
      'avatar': null,
      'lastMessage': 'Bedankt voor de update!',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
      'unreadCount': 2,
      'isOnline': true,
    },
    {
      'id': '2',
      'name': 'Jan (Dispatcher)',
      'avatar': null,
      'lastMessage': 'Route aangepast naar je nieuwe bestemming',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'unreadCount': 0,
      'isOnline': true,
    },
    {
      'id': '3',
      'name': 'HR Afdeling',
      'avatar': null,
      'lastMessage': 'Je vakantieaanvraag is goedgekeurd',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'unreadCount': 0,
      'isOnline': false,
    },
    {
      'id': '4',
      'name': 'Fleet Manager',
      'avatar': null,
      'lastMessage': 'Onderhoud gepland voor volgende week',
      'timestamp': DateTime.now().subtract(const Duration(days: 3)),
      'unreadCount': 0,
      'isOnline': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Berichten'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Search conversations
            },
          ),
        ],
      ),
      body: _conversations.isEmpty ? _buildEmptyState(context) : _buildConversationList(context),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: context.colorScheme.outline,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Geen gesprekken',
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Start een gesprek met de planner',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationList(BuildContext context) {
    return ListView.builder(
      itemCount: _conversations.length,
      itemBuilder: (context, index) {
        final conversation = _conversations[index];
        return _ConversationTile(
          conversation: conversation,
          onTap: () => context.push(
            Routes.conversationPath(conversation['id'] as String),
          ),
        );
      },
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final Map<String, dynamic> conversation;
  final VoidCallback onTap;

  const _ConversationTile({
    required this.conversation,
    required this.onTap,
  });

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (messageDate == today) {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'Gisteren';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = conversation['unreadCount'] as int;
    final isOnline = conversation['isOnline'] as bool;
    final timestamp = conversation['timestamp'] as DateTime;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: context.colorScheme.primaryContainer,
            child: Text(
              (conversation['name'] as String).substring(0, 1).toUpperCase(),
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorScheme.primary,
              ),
            ),
          ),
          if (isOnline)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: context.colorScheme.surface,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              conversation['name'] as String,
              style: context.textTheme.titleSmall?.copyWith(
                fontWeight: unreadCount > 0 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            _formatTimestamp(timestamp),
            style: context.textTheme.bodySmall?.copyWith(
              color: unreadCount > 0
                  ? context.colorScheme.primary
                  : context.colorScheme.outline,
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              conversation['lastMessage'] as String,
              style: context.textTheme.bodyMedium?.copyWith(
                color: unreadCount > 0
                    ? context.colorScheme.onSurface
                    : context.colorScheme.outline,
                fontWeight: unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (unreadCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xxs,
              ),
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                borderRadius: AppSpacing.borderRadiusFull,
              ),
              child: Text(
                unreadCount.toString(),
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colorScheme.onPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
