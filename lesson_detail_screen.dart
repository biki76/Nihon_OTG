import 'package:flutter/material.dart';
import '../data/models.dart';
import '../data/app_database.dart';
import '../theme/app_theme.dart';

class LessonDetailScreen extends StatelessWidget {
  final ContentType type;
  final int lesson;
  const LessonDetailScreen({super.key, required this.type, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      ContentType.vocab   => _VocabList(lesson: lesson),
      ContentType.grammar => _GrammarList(lesson: lesson),
      ContentType.kanji   => _KanjiGrid(lesson: lesson),
    };
  }
}

// ── Vocab list ──────────────────────────────────────────────────

class _VocabList extends StatelessWidget {
  final int lesson;
  const _VocabList({required this.lesson});

  @override
  Widget build(BuildContext context) {
    final items = (vocabData[lesson] ?? []).where((v) => v.word.isNotEmpty).toList();
    if (items.isEmpty) return _EmptyState(lesson: lesson);
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (ctx, i) => _VocabRow(item: items[i]),
    );
  }
}

class _VocabRow extends StatelessWidget {
  final VocabItem item;
  const _VocabRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: context.cardDecoration.copyWith(borderRadius: BorderRadius.circular(14)),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.word,
              style: TextStyle(
                fontFamily: 'NotoSerifJP', fontSize: 22,
                fontWeight: FontWeight.w700, color: context.textMain, height: 1.3,
              ),
            ),
            const SizedBox(height: 3),
            Text(item.reading,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.accent, letterSpacing: 0.3),
            ),
          ])),
          const SizedBox(width: 12),
          Flexible(
            child: Text(item.meaning,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 14, color: context.textMain, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Grammar list ────────────────────────────────────────────────

class _GrammarList extends StatelessWidget {
  final int lesson;
  const _GrammarList({required this.lesson});

  @override
  Widget build(BuildContext context) {
    final items = grammarData[lesson] ?? [];
    if (items.isEmpty) return _EmptyState(lesson: lesson);
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (ctx, i) => _GrammarCard(item: items[i]),
    );
  }
}

class _GrammarCard extends StatelessWidget {
  final GrammarItem item;
  const _GrammarCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: context.cardDecoration.copyWith(
        borderRadius: BorderRadius.circular(14),
        border: Border(
          left: BorderSide(color: context.violet, width: 4),
          top:    BorderSide(color: context.border),
          right:  BorderSide(color: context.border),
          bottom: BorderSide(color: context.border),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('GRAMMAR POINT',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
              color: context.violet, letterSpacing: 1.0),
          ),
          const SizedBox(height: 6),
          Text(item.pattern,
            style: TextStyle(
              fontFamily: 'NotoSerifJP', fontSize: 16,
              fontWeight: FontWeight.w700, color: context.textMain, height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(item.explanation,
            style: TextStyle(fontSize: 14, color: context.textSub, height: 1.5),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: context.bg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: context.border),
            ),
            padding: const EdgeInsets.all(10),
            child: RichText(
              text: TextSpan(children: [
                TextSpan(text: 'উদাহরণ: ',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: context.violet),
                ),
                TextSpan(text: item.example,
                  style: TextStyle(fontSize: 13, color: context.textMain, fontStyle: FontStyle.italic),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Kanji grid ──────────────────────────────────────────────────

class _KanjiGrid extends StatelessWidget {
  final int lesson;
  const _KanjiGrid({required this.lesson});

  @override
  Widget build(BuildContext context) {
    final items = kanjiData[lesson] ?? [];
    if (items.isEmpty) return _EmptyState(lesson: lesson);
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemCount: items.length,
      itemBuilder: (ctx, i) => _KanjiCard(item: items[i]),
    );
  }
}

class _KanjiCard extends StatelessWidget {
  final KanjiItem item;
  const _KanjiCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final errorColor = context.accentErr;
    return Container(
      decoration: context.cardDecoration.copyWith(borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(item.kanji,
            style: TextStyle(
              fontFamily: 'NotoSerifJP', fontSize: 44,
              fontWeight: FontWeight.w900, color: errorColor, height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(item.reading.toUpperCase(),
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
              color: context.textSub, letterSpacing: 0.5),
          ),
          const SizedBox(height: 4),
          Text(item.meaning,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.textMain),
            textAlign: TextAlign.center,
          ),
          if (item.strokes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: errorColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              child: Text(item.strokes,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: errorColor),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Empty state ─────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final int lesson;
  const _EmptyState({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('📭', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text('Data for Lesson $lesson coming soon!',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textSub),
          ),
        ],
      ),
    );
  }
}
