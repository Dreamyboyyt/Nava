import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nava_demon_lords_diary/features/conquests/data/conquest_repository.dart';
import 'package:nava_demon_lords_diary/features/conquests/domain/conquest.dart';
import 'package:nava_demon_lords_diary/theme/app_theme.dart';

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
      appBar: AppBar(title: const Text('Conquests')),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await showDialog<Conquest?>(
            context: context,
            builder: (_) => const _CreateConquestDialog(),
          );
          if (created != null) {
            final repo = ref.read(conquestRepositoryProvider);
            await repo.insert(created);
            ref.invalidate(conquestsProvider);
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('New Conquest'),
      ),
    );
  }
}

class _CreateConquestDialog extends StatefulWidget {
  const _CreateConquestDialog();

  @override
  State<_CreateConquestDialog> createState() => _CreateConquestDialogState();
}

class _CreateConquestDialogState extends State<_CreateConquestDialog> {
  final titleCtrl = TextEditingController();
  final detailsCtrl = TextEditingController();
  int difficulty = 3;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.abyss.withOpacity(0.9),
      title: const Text('Forge a Conquest'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            if (titleCtrl.text.trim().isEmpty) return;
            Navigator.pop(
              context,
              Conquest(
                title: titleCtrl.text.trim(),
                details: detailsCtrl.text.trim().isEmpty ? null : detailsCtrl.text.trim(),
                difficulty: difficulty,
                status: ConquestStatus.pending,
              ),
            );
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
