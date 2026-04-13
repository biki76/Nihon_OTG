import 'dart:math';
import 'package:flutter/material.dart';
import '../data/app_database.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen>
    with SingleTickerProviderStateMixin {

  late final List<KanjiItem> _cards;
  late final AnimationController _ctrl;
  late final Animation<double> _flipAnim;

  int _index  = 0;
  bool _front = true;

  @override
  void initState() {
    super.initState();
    _cards = kanjiData.entries
        .toList()
        ..sort((a, b) => a.key.compareTo(b.key));
    _cards = _cards.expand((e) => e.value).toList();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _flipAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  // unwrap: the expand trick above means _cards is already List<KanjiItem>
  List<KanjiItem> get _list {
    final list = <KanjiItem>[];
    for (final day in kanjiData.keys.toList()..sort()) {
      list.addAll(kanjiData[day]!);
    }
    return list;
  }

  KanjiItem get _item => _list[_index];
  double get _progress => (_index + 1) / _list.length;

  void _flip() {
    if (_front) {
      _ctrl.forward();
    } else {
      _ctrl.reverse();
    }
    setState(() => _front = !_front);
  }

  void _navigate(int step) {
    final next = (_index + step).clamp(0, _list.length - 1);
    // Wrap
    int wrapped = _index + step;
    if (wrapped < 0) wrapped = _list.length - 1;
    if (wrapped >= _list.length) wrapped = 0;
    setState(() {
      _index = wrapped;
      _front = true;
    });
    _ctrl.reset();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item        = _item;
    final errorColor  = context.accentErr;
    final strokes     = item.strokes;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Progress bar
          Row(children: [
            Expanded(child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: _progress,
                minHeight: 6,
                backgroundColor: context.border,
                valueColor: AlwaysStoppedAnimation(context.accent),
              ),
            )),
            const SizedBox(width: 10),
            Text('${_index + 1} / ${_list.length}',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: context.textSub),
            ),
          ]),
          const SizedBox(height: 20),

          // Flashcard
          Expanded(
            child: GestureDetector(
              onTap: _flip,
              child: AnimatedBuilder(
                animation: _flipAnim,
                builder: (_, __) {
                  final angle = _flipAnim.value * pi;
                  final isFront = angle < pi / 2;
                  return Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle),
                    alignment: Alignment.center,
                    child: isFront
                        ? _CardFace(
                            color: context.cardColor,
                            borderColor: context.border,
                            child: _FrontContent(item: item, errorColor: errorColor, textSub: context.textSub, bg: context.bg, border: context.border),
                          )
                        : Transform(
                            transform: Matrix4.identity()..rotateY(pi),
                            alignment: Alignment.center,
                            child: _CardFace(
                              color: context.cardColor,
                              borderColor: context.accent.withOpacity(0.3),
                              child: _BackContent(item: item, accent: context.accent, textMain: context.textMain, textSub: context.textSub, strokes: strokes),
                            ),
                          ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Navigation buttons
          Row(children: [
            Expanded(child: _NavBtn(
              label: '← PREV',
              onTap: () => _navigate(-1),
              primary: false,
              cardColor: context.cardColor,
              borderColor: context.border,
              textColor: context.textMain,
            )),
            const SizedBox(width: 10),
            Expanded(child: _NavBtn(
              label: 'NEXT →',
              onTap: () => _navigate(1),
              primary: true,
              cardColor: context.accent,
              borderColor: context.accent,
              textColor: Colors.white,
            )),
          ]),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _CardFace extends StatelessWidget {
  final Color color, borderColor;
  final Widget child;
  const _CardFace({required this.color, required this.borderColor, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: context.isDark
            ? [const BoxShadow(color: Color(0x4D000000), blurRadius: 12, offset: Offset(0, 4))]
            : [const BoxShadow(color: Color(0x0D000000), blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: child,
    );
  }
}

class _FrontContent extends StatelessWidget {
  final KanjiItem item;
  final Color errorColor, textSub, bg, border;
  const _FrontContent({required this.item, required this.errorColor, required this.textSub, required this.bg, required this.border});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Positioned(top: 20, child: Text('KANJI',
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSub, letterSpacing: 1),
      )),
      Text(item.kanji,
        style: TextStyle(fontFamily: 'NotoSerifJP', fontSize: 90, fontWeight: FontWeight.w900, color: errorColor, height: 1),
      ),
      Positioned(
        bottom: 20,
        child: Container(
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(99), border: Border.all(color: border)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Text('Tap to reveal ✦', style: TextStyle(fontSize: 12, color: textSub)),
        ),
      ),
    ]);
  }
}

class _BackContent extends StatelessWidget {
  final KanjiItem item;
  final Color accent, textMain, textSub;
  final String strokes;
  const _BackContent({required this.item, required this.accent, required this.textMain, required this.textSub, required this.strokes});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('MEANING & READING',
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: accent, letterSpacing: 1),
      ),
      const SizedBox(height: 12),
      Text(item.meaning, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: textMain)),
      const SizedBox(height: 6),
      Text(item.reading, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: textSub)),
      if (strokes.isNotEmpty) ...[
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: accent.withOpacity(0.10),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: accent.withOpacity(0.20)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Text(strokes, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: accent)),
        ),
      ],
    ]);
  }
}

class _NavBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool primary;
  final Color cardColor, borderColor, textColor;
  const _NavBtn({required this.label, required this.onTap, required this.primary, required this.cardColor, required this.borderColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.5),
          boxShadow: primary
              ? [BoxShadow(color: const Color(0xFF2A9D8F).withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 3))]
              : null,
        ),
        child: Center(child: Text(label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),
        )),
      ),
    );
  }
}
