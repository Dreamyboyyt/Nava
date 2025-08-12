import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nava_demon_lords_diary/common/widgets/animated_mana_orb.dart';
import 'package:nava_demon_lords_diary/features/mood/data/mood_repository.dart';
import 'package:nava_demon_lords_diary/features/mood/domain/mood_entry.dart';

class MoodScreen extends ConsumerStatefulWidget {
  const MoodScreen({super.key});

  @override
  ConsumerState<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends ConsumerState<MoodScreen> {
  double _value = 0.7;
  final noteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final latest = await ref.read(latestMoodProvider.future);
      if (latest != null) {
        setState(() => _value = latest.value / 100);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final latestAsync = ref.watch(latestMoodProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Mana')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedManaOrb(value: _value),
                    const SizedBox(height: 16),
                    Slider(
                      value: _value,
                      onChanged: (v) => setState(() => _value = v),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: noteCtrl,
                        decoration: const InputDecoration(labelText: 'Note'),
                      ),
                    ),
                    FilledButton(
                      onPressed: () async {
                        final repo = ref.read(moodRepositoryProvider);
                        await repo.insert(MoodEntry(
                          value: (_value * 100).round(),
                          note: noteCtrl.text.trim().isEmpty ? null : noteCtrl.text.trim(),
                          createdAt: DateTime.now(),
                        ));
                        ref.invalidate(latestMoodProvider);
                      },
                      child: const Text('Channel Mana'),
                    ),
                    const SizedBox(height: 24),
                    latestAsync.when(
                      data: (m) => m == null
                          ? const SizedBox.shrink()
                          : Text('Last: ${m.value}/100'),
                      loading: () => const SizedBox.shrink(),
                      error: (e, st) => Text('Error: $e'),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
