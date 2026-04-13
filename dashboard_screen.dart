import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _HeroCard(),
          const SizedBox(height: 12),
          _BentoGrid(),
          const SizedBox(height: 12),
          _UserGuide(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── Hero ────────────────────────────────────────────────────────

class _HeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2A9D8F), Color(0xFF238276), Color(0xFF1A6B62)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2A9D8F).withOpacity(0.28),
            blurRadius: 24, offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Stack(
        children: [
          Positioned(
            right: -6, top: -6,
            child: Text('日本語',
              style: TextStyle(
                fontFamily: 'NotoSerifJP', fontSize: 72,
                fontWeight: FontWeight.w900,
                color: Colors.white.withOpacity(0.08),
                height: 1,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('N5 JAPANESE',
                style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.6),
                  letterSpacing: 2.2,
                ),
              ),
              const SizedBox(height: 6),
              const Text('ようこそ!',
                style: TextStyle(
                  fontFamily: 'NotoSerifJP', fontSize: 24,
                  fontWeight: FontWeight.w700, color: Colors.white,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 4),
              Text('Welcome — let\'s learn Japanese today',
                style: TextStyle(
                  fontSize: 14, color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Bento grid ──────────────────────────────────────────────────

class _BentoGrid extends StatelessWidget {
  static const _cards = [
    _BentoItem(label: 'Vocabulary', sub: '25 Lessons',           icon: Icons.menu_book_rounded,  color: Color(0xFF2A9D8F), route: '/vocab',     half: true),
    _BentoItem(label: 'Grammar',    sub: '25 Lessons',           icon: Icons.rule_rounded,       color: Color(0xFF7C3AED), route: '/grammar',   half: true),
    _BentoItem(label: 'Kanji',      sub: '20 Days of N5 Kanji',  icon: Icons.edit_rounded,       color: Color(0xFFE76F51), route: '/kanji',     half: false),
    _BentoItem(label: 'Flashcards', sub: 'Master through recall',icon: Icons.style_rounded,      color: Color(0xFFE76F51), route: '/flashcards',half: false),
  ];

  @override
  Widget build(BuildContext context) {
    final halves = _cards.where((c) => c.half).toList();
    final fulls  = _cards.where((c) => !c.half).toList();
    return Column(
      children: [
        Row(
          children: halves.map((c) => Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: c == halves.first ? 6 : 0, left: c == halves.last ? 6 : 0),
              child: _BentoCard(item: c),
            ),
          )).toList(),
        ),
        ...fulls.map((c) => Padding(
          padding: const EdgeInsets.only(top: 12),
          child: _BentoCard(item: c),
        )),
      ],
    );
  }
}

class _BentoItem {
  final String label, sub, route;
  final IconData icon;
  final Color color;
  final bool half;
  const _BentoItem({required this.label, required this.sub, required this.icon,
    required this.color, required this.route, required this.half});
}

class _BentoCard extends StatelessWidget {
  final _BentoItem item;
  const _BentoCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final bg = item.color.withOpacity(0.10);
    return GestureDetector(
      onTap: () => context.go(item.route),
      child: Container(
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border(top: BorderSide(color: item.color, width: 3)),
          boxShadow: context.isDark
              ? [const BoxShadow(color: Color(0x40000000), blurRadius: 8, offset: Offset(0,2))]
              : [const BoxShadow(color: Color(0x0A000000), blurRadius: 8, offset: Offset(0,2))],
        ),
        padding: const EdgeInsets.all(16),
        child: item.half ? _halfContent(bg, context) : _fullContent(bg, context),
      ),
    );
  }

  Widget _halfContent(Color bg, BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 44, height: 44, decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
        child: Icon(item.icon, color: item.color, size: 24),
      ),
      const SizedBox(height: 10),
      Text(item.label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.textMain)),
      const SizedBox(height: 2),
      Text(item.sub,   style: TextStyle(fontSize: 12, color: context.textSub)),
    ],
  );

  Widget _fullContent(Color bg, BuildContext context) => Row(
    children: [
      Container(
        width: 44, height: 44, decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
        child: Icon(item.icon, color: item.color, size: 22),
      ),
      const SizedBox(width: 14),
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: context.textMain)),
          const SizedBox(height: 2),
          Text(item.sub,   style: TextStyle(fontSize: 12, color: context.textSub)),
        ],
      )),
      Icon(Icons.chevron_right_rounded, color: context.textMain.withOpacity(0.35)),
    ],
  );
}

// ── User guide ──────────────────────────────────────────────────

class _UserGuide extends StatelessWidget {
  static const _tips = [
    'লেসন শেষ করে "Done" বাটনে ক্লিক করে প্রগ্রেস সেভ করুন।',
    'সঠিক উচ্চারণ শুনতে স্পিকার আইকন ব্যবহার করুন।',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2A9D8F), Color(0xFF238276)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('APP USER GUIDE',
            style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.6),
              letterSpacing: 1.5, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          const Text('অ্যাপ ব্যবহার নির্দেশিকা',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          const SizedBox(height: 14),
          ..._tips.asMap().entries.map((e) => _TipRow(num: e.key + 1, text: e.value)),
        ],
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  final int num;
  final String text;
  const _TipRow({required this.num, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 26, height: 26,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Center(
              child: Text('$num',
                style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF2A9D8F),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text,
              style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.9), height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
