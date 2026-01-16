import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:driversense_app/core/theme/app_spacing.dart';
import 'package:driversense_app/core/theme/app_colors.dart';
import 'package:driversense_app/core/utils/extensions/context_extensions.dart';

/// Conversation page for chat messaging
class ConversationPage extends StatefulWidget {
  final String conversationId;

  const ConversationPage({
    super.key,
    required this.conversationId,
  });

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isTyping = false;

  // Mock conversation info
  Map<String, dynamic> get _conversationInfo => {
    'name': 'Planner Support',
    'isOnline': true,
    'lastSeen': DateTime.now().subtract(const Duration(minutes: 5)),
  };

  // Mock messages
  List<Map<String, dynamic>> get _messages => [
    {
      'id': '1',
      'text': 'Goedemorgen! Hoe kan ik je helpen?',
      'isMe': false,
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'id': '2',
      'text': 'Hoi, ik heb een vraag over mijn route van vandaag.',
      'isMe': true,
      'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 55)),
    },
    {
      'id': '3',
      'text': 'Natuurlijk, wat is je vraag?',
      'isMe': false,
      'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 50)),
    },
    {
      'id': '4',
      'text': 'Is het mogelijk om de volgorde van de stops te wijzigen? De eerste locatie is moeilijk bereikbaar in de ochtendspits.',
      'isMe': true,
      'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
    },
    {
      'id': '5',
      'text': 'Ik begrijp het. Laat me even kijken naar de mogelijkheden.',
      'isMe': false,
      'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 40)),
    },
    {
      'id': '6',
      'text': 'Ik heb de route aangepast. Je begint nu bij locatie B en eindigt bij locatie A. Is dat beter?',
      'isMe': false,
      'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
    },
    {
      'id': '7',
      'text': 'Ja perfect! Bedankt voor de snelle hulp!',
      'isMe': true,
      'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 25)),
    },
    {
      'id': '8',
      'text': 'Graag gedaan! Goede rit en rij veilig!',
      'isMe': false,
      'timestamp': DateTime.now().subtract(const Duration(minutes: 15)),
    },
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // TODO: Send message via bloc/repository
    _messageController.clear();
    setState(() => _isTyping = false);

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: context.colorScheme.primaryContainer,
                  child: Text(
                    (_conversationInfo['name'] as String).substring(0, 1).toUpperCase(),
                    style: context.textTheme.titleSmall?.copyWith(
                      color: context.colorScheme.primary,
                    ),
                  ),
                ),
                if (_conversationInfo['isOnline'] as bool)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
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
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _conversationInfo['name'] as String,
                    style: context.textTheme.titleSmall,
                  ),
                  Text(
                    (_conversationInfo['isOnline'] as bool) ? 'Online' : 'Offline',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: (_conversationInfo['isOnline'] as bool)
                          ? AppColors.success
                          : context.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_outlined),
            onPressed: () {
              // TODO: Start call
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showOptionsMenu(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: AppSpacing.screenPadding,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final showTimestamp = index == 0 ||
                    _shouldShowTimestamp(
                      _messages[index - 1]['timestamp'] as DateTime,
                      message['timestamp'] as DateTime,
                    );
                return _MessageBubble(
                  message: message,
                  showTimestamp: showTimestamp,
                );
              },
            ),
          ),

          // Input area
          _buildInputArea(),
        ],
      ),
    );
  }

  bool _shouldShowTimestamp(DateTime previous, DateTime current) {
    return current.difference(previous).inMinutes > 15;
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file),
              onPressed: () {
                // TODO: Attach file
              },
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Typ een bericht...',
                  border: OutlineInputBorder(
                    borderRadius: AppSpacing.borderRadiusFull,
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: context.colorScheme.surfaceContainerHighest,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _isTyping = value.trim().isNotEmpty;
                  });
                },
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: _isTyping
                  ? IconButton(
                      icon: Icon(
                        Icons.send,
                        color: context.colorScheme.primary,
                      ),
                      onPressed: _sendMessage,
                    )
                  : IconButton(
                      icon: const Icon(Icons.mic),
                      onPressed: () {
                        // TODO: Voice message
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Zoeken in gesprek'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('Meldingen'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: AppColors.error),
              title: Text(
                'Gesprek verwijderen',
                style: TextStyle(color: AppColors.error),
              ),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool showTimestamp;

  const _MessageBubble({
    required this.message,
    required this.showTimestamp,
  });

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (messageDate == today) {
      return 'Vandaag ${_formatTime(timestamp)}';
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return 'Gisteren ${_formatTime(timestamp)}';
    } else {
      return '${timestamp.day}/${timestamp.month} ${_formatTime(timestamp)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMe = message['isMe'] as bool;
    final text = message['text'] as String;
    final timestamp = message['timestamp'] as DateTime;

    return Column(
      children: [
        if (showTimestamp)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Text(
              _formatTimestamp(timestamp),
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.outline,
              ),
            ),
          ),
        Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: isMe
                  ? context.colorScheme.primary
                  : context.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(AppSpacing.radiusMd),
                topRight: const Radius.circular(AppSpacing.radiusMd),
                bottomLeft: isMe
                    ? const Radius.circular(AppSpacing.radiusMd)
                    : const Radius.circular(AppSpacing.radiusXs),
                bottomRight: isMe
                    ? const Radius.circular(AppSpacing.radiusXs)
                    : const Radius.circular(AppSpacing.radiusMd),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  text,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isMe
                        ? context.colorScheme.onPrimary
                        : context.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  _formatTime(timestamp),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isMe
                        ? context.colorScheme.onPrimary.withOpacity(0.7)
                        : context.colorScheme.outline,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
