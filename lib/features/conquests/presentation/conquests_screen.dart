import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nava_demon_lords_diary/features/conquests/data/conquest_repository.dart';
import 'package:nava_demon_lords_diary/features/conquests/domain/conquest.dart';
import 'package:nava_demon_lords_diary/theme/app_theme.dart';
import 'package:nava_demon_lords_diary/common/notifications/notification_service.dart';
import 'package:nava_demon_lords_diary/common/widgets/mana_toast.dart';
import 'package:go_router/go_router.dart';

class ConquestsScreen extends ConsumerStatefulWidget {
  const ConquestsScreen({super.key});

  @override
  ConsumerState<ConquestsScreen> createState() => _ConquestsScreenState();
}

class _ConquestsScreenState extends ConsumerState<ConquestsScreen> {
  @override
  Widget build(BuildContext context) {
    final conquestsAsync = ref.watch(conquestsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conquests'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openCreateSheet(context),
            tooltip: 'New Conquest',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: conquestsAsync.when(
        data: (items) => ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final c = items[index];
            return Card(
              child: ListTile(
                title: Text(c.title),
                subtitle: Text(
                  [
                    '#${c.difficulty}',
                    c.status.name,
                    if (c.dueAt != null) 'due ${c.dueAt}'
                  ].join(' • '),
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) async {
                    final repo = ref.read(conquestRepositoryProvider);
                    switch (value) {
                      case 'start':
                        await repo.update(c.copyWith(status: ConquestStatus.inProgress));
                        break;
                      case 'done':
                        await repo.update(c.copyWith(status: ConquestStatus.completed));
                        break;
                      case 'delete':
                        await repo.delete(c.id!);
                        break;
                    }
                    ref.invalidate(conquestsProvider);
                  },
                  itemBuilder: (context) => [
                    if (c.status == ConquestStatus.pending)
                      const PopupMenuItem(value: 'start', child: Text('Begin')), 
                    if (c.status != ConquestStatus.completed)
                      const PopupMenuItem(value: 'done', child: Text('Complete')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCreateSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _openCreateSheet(BuildContext context) async {
    final created = await showModalBottomSheet<Conquest?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _CreateConquestSheet(),
    );
    if (created != null && mounted) {
      final repo = ref.read(conquestRepositoryProvider);
      await repo.insert(created);
      if (created.dueAt != null) {
        await NotificationService().scheduleAt(
          title: 'Conquest Approaches',
          body: created.title,
          when: created.dueAt!,
        );
      }
      ref.invalidate(conquestsProvider);
      await ManaToast.show(context, message: 'Conquest forged');
    }
  }
}

class _CreateConquestSheet extends StatefulWidget {
  const _CreateConquestSheet();

  @override
  State<_CreateConquestSheet> createState() => _CreateConquestSheetState();
}

class _CreateConquestSheetState extends State<_CreateConquestSheet> {
  final titleCtrl = TextEditingController();
  final detailsCtrl = TextEditingController();
  int difficulty = 3;
  DateTime? dueAt;

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.only(bottom: viewInsets),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.96),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              const Text('Forge a Conquest', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
              const SizedBox(height: 12),
              TextField(
                controller: detailsCtrl,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Details'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Difficulty'),
                  Expanded(
                    child: Slider(
                      value: difficulty.toDouble(),
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: difficulty.toString(),
                      onChanged: (v) => setState(() => difficulty = v.round()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.event),
                      label: Text(dueAt == null ? 'Pick due date' : '${dueAt!.toLocal()}'),
                      onPressed: () async {
                        final now = DateTime.now();
                        final date = await showDatePicker(
                          context: context,
                          firstDate: now,
                          lastDate: DateTime(now.year + 3),
                          initialDate: now,
                        );
                        if (date == null) return;
                        final time = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 9, minute: 0));
                        if (time == null) return;
                        setState(() => dueAt = DateTime(date.year, date.month, date.day, time.hour, time.minute));
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel'))),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        if (titleCtrl.text.trim().isEmpty) return;
                        Navigator.pop(
                          context,
                          Conquest(
                            title: titleCtrl.text.trim(),
                            details: detailsCtrl.text.trim().isEmpty ? null : detailsCtrl.text.trim(),
                            difficulty: difficulty,
                            status: ConquestStatus.pending,
                            dueAt: dueAt,
                          ),
                        );
                      },
                      child: const Text('Create'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
