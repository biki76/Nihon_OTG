import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  final String title;

  const AppShell({super.key, required this.child, required this.title});

  static const _tabs = [
    _Tab(icon: Icons.home_rounded,      label: 'HOME',    route: '/'),
    _Tab(icon: Icons.menu_book_rounded, label: 'VOCAB',   route: '/vocab'),
    _Tab(icon: Icons.rule_rounded,      label: 'GRAMMAR', route: '/grammar'),
    _Tab(icon: Icons.edit_rounded,      label: 'KANJI',   route: '/kanji'),
    _Tab(icon: Icons.science_rounded,   label: 'EXAM',    route: '/exam'),
  ];

  int _tabIndex(BuildContext context) {
    final loc = GoRouterState.of(context).uri.toString();
    if (loc.startsWith('/vocab'))   return 1;
    if (loc.startsWith('/grammar')) return 2;
    if (loc.startsWith('/kanji'))   return 3;
    if (loc.startsWith('/flash'))   return 3;
    if (loc.startsWith('/exam'))    return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme    = Provider.of<ThemeProvider>(context);
    final canBack  = context.canPop();
    final tabIndex = _tabIndex(context);

    return Scaffold(
      backgroundColor: context.bg,
      appBar: AppBar(
        backgroundColor: context.cardColor,
        surfaceTintColor: Colors.transparent,
        leading: canBack
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.textMain),
                onPressed: context.pop,
                tooltip: 'Back',
              )
            : const SizedBox.shrink(),
        leadingWidth: canBack ? 56 : 0,
        title: Row(
          children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2A9D8F), Color(0xFF238276)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2A9D8F).withOpacity(0.35),
                    blurRadius: 8, offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(Icons.school_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('ビキ先生',
                  style: TextStyle(
                    fontFamily: 'NotoSerifJP',
                    fontSize: 15, fontWeight: FontWeight.w700,
                    color: context.textMain,
                  ),
                ),
                Text(title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 9, fontWeight: FontWeight.w700,
                    color: context.accent, letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              theme.isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
              color: context.textMain,
            ),
            onPressed: theme.toggle,
            tooltip: 'Toggle theme',
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: context.border),
        ),
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabIndex,
        backgroundColor: context.navBg,
        selectedItemColor: context.accent,
        unselectedItemColor: context.textSub.withOpacity(0.55),
        selectedLabelStyle: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, letterSpacing: 0.8),
        unselectedLabelStyle: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        onTap: (i) => context.go(_tabs[i].route),
        items: _tabs.map((t) => BottomNavigationBarItem(
          icon: Icon(t.icon, size: 22),
          label: t.label,
        )).toList(),
      ),
    );
  }
}

class _Tab {
  final IconData icon;
  final String label;
  final String route;
  const _Tab({required this.icon, required this.label, required this.route});
}
