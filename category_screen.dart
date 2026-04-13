import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/models.dart';
import '../data/app_database.dart';
import '../theme/app_theme.dart';

class CategoryScreen extends StatelessWidget {
  final ContentType type;
  const CategoryScreen({super.key, required this.type});

  String get _label    => switch (type) { ContentType.vocab => 'Vocabulary', ContentType.grammar => 'Grammar', ContentType.kanji => 'Kanji' };
  String get _sub      => switch (type) { ContentType.vocab => 'words & phrases', ContentType.grammar => 'patterns & rules', ContentType.kanji => 'characters & readings' };
  IconData get _icon   => switch (type) { ContentType.vocab => Icons.menu_book_rounded, ContentType.grammar => Icons.rule_rounded, ContentType.kanji => Icons.edit_rounded };
  Color get _color     => switch (type) { ContentType.vocab => const Color(0xFF2A9D8F), ContentType.grammar => const Color(0xFF7C3AED), ContentType.kanji => const Color(0xFFE76F51) };
  Color get _colorBg   => _color.withOpacity(0.10);

  Map<int, dynamic> get _dataMap => switch (type) {
    ContentType.vocab   => vocabData,
    ContentType.grammar => grammarData,
    ContentType.kanji   => kanjiData,
  };

  @override
  Widget build(BuildContext context) {
    final lessons = _dataMap.keys.toList()..sort();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: lessons.length + 1,
      itemBuilder: (ctx, i) {
        if (i == 0) return _Header(label: _label, sub: '${lessons.length} lessons · $_sub', icon: _icon, color: _color, colorBg: _colorBg);
        final lesson = lessons[i - 1];
        final items  = _dataMap[lesson] as List;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _LessonChip(
            lesson: lesson,
            count: items.length,
            color: _color,
            colorBg: _colorBg,
            onTap: () => context.go(
              '/${type.name}/lesson/$lesson',
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final String label, sub;
  final IconData icon;
  final Color color, colorBg;
  const _Header({required this.label, required this.sub, required this.icon, required this.color, required this.colorBg});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: context.cardDecoration,
      padding: const EdgeInsets.all(16),
      child: Row(children: [
        Container(
          width: 46, height: 46,
          decoration: BoxDecoration(color: colorBg, borderRadius: BorderRadius.circular(14)),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: context.textMain)),
          const SizedBox(height: 2),
          Text(sub, style: TextStyle(fontSize: 12, color: context.textSub)),
        ]),
      ]),
    );
  }
}

class _LessonChip extends StatelessWidget {
  final int lesson, count;
  final Color color, colorBg;
  final VoidCallback onTap;
  const _LessonChip({required this.lesson, required this.count, required this.color, required this.colorBg, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: context.cardDecoration.copyWith(
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: colorBg, borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text('$lesson',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color),
            )),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(lesson == 0 ? 'Lesson 0 – Dates & Months' : 'Lesson $lesson',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.textMain),
            ),
            const SizedBox(height: 2),
            Text('$count item${count != 1 ? "s" : ""}',
              style: TextStyle(fontSize: 12, color: context.textSub),
            ),
          ])),
          Icon(Icons.chevron_right_rounded, color: context.textMain.withOpacity(0.3), size: 20),
        ]),
      ),
    );
  }
}
