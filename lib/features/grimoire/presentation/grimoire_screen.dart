import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nava_demon_lords_diary/features/grimoire/data/journal_repository.dart';
import 'package:nava_demon_lords_diary/features/grimoire/domain/journal_entry.dart';
import 'package:go_router/go_router.dart';

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
      appBar: AppBar(
        title: const Text('Grimoire'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await _openCreateSheet(context);
            },
            tooltip: 'New Entry',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _openCreateSheet(context);
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

  Future<void> _openCreateSheet(BuildContext context) async {
    final created = await showModalBottomSheet<JournalEntry?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _CreateEntrySheet(),
    );
    if (created != null && mounted) {
      await ref.read(journalRepositoryProvider).insert(created);
      ref.invalidate(journalEntriesProvider);
    }
  }
}

class _CreateEntrySheet extends StatefulWidget {
  const _CreateEntrySheet();

  @override
  State<_CreateEntryDialog> createState() => _CreateEntryDialogState();
}

class _CreateEntrySheetState extends State<_CreateEntrySheet> {
  final titleCtrl = TextEditingController();
  final bodyCtrl = TextEditingController();
  final tagsCtrl = TextEditingController();

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
              const Text('New Grimoire Entry', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
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
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel'))),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
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
