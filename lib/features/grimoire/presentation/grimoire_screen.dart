import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nava_demon_lords_diary/features/grimoire/data/journal_repository.dart';
import 'package:nava_demon_lords_diary/features/grimoire/domain/journal_entry.dart';

class GrimoireScreen extends ConsumerStatefulWidget {
  const GrimoireScreen({super.key});

  @override
  ConsumerState<GrimoireScreen> createState() => _GrimoireScreenState();
}

class _GrimoireScreenState extends ConsumerState<GrimoireScreen> {
  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(journalEntriesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Grimoire')),
      body: entriesAsync.when(
        data: (items) => ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final e = items[index];
            return Card(
              child: ListTile(
                title: Text(e.title),
                subtitle: Text(e.tags ?? ''),
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(e.title),
                    content: SingleChildScrollView(child: Text(e.body)),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          await ref.read(journalRepositoryProvider).delete(e.id!);
                          if (context.mounted) Navigator.pop(context);
                          ref.invalidate(journalEntriesProvider);
                        },
                        child: const Text('Delete'),
                      ),
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                    ],
                  ),
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
          final created = await showDialog<JournalEntry?>(
            context: context,
            builder: (_) => const _CreateEntryDialog(),
          );
          if (created != null) {
            await ref.read(journalRepositoryProvider).insert(created);
            ref.invalidate(journalEntriesProvider);
          }
        },
        icon: const Icon(Icons.edit_note),
        label: const Text('New Entry'),
      ),
    );
  }
}

class _CreateEntryDialog extends StatefulWidget {
  const _CreateEntryDialog();

  @override
  State<_CreateEntryDialog> createState() => _CreateEntryDialogState();
}

class _CreateEntryDialogState extends State<_CreateEntryDialog> {
  final titleCtrl = TextEditingController();
  final bodyCtrl = TextEditingController();
  final tagsCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Grimoire Entry'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
            const SizedBox(height: 12),
            TextField(
              controller: bodyCtrl,
              minLines: 5,
              maxLines: 12,
              decoration: const InputDecoration(labelText: 'Body'),
            ),
            const SizedBox(height: 12),
            TextField(controller: tagsCtrl, decoration: const InputDecoration(labelText: 'Tags (comma separated)')),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            if (titleCtrl.text.trim().isEmpty || bodyCtrl.text.trim().isEmpty) return;
            Navigator.pop(
              context,
              JournalEntry(
                title: titleCtrl.text.trim(),
                body: bodyCtrl.text.trim(),
                tags: tagsCtrl.text.trim().isEmpty ? null : tagsCtrl.text.trim(),
                createdAt: DateTime.now(),
              ),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
