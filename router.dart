import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'data/models.dart';
import 'screens/dashboard_screen.dart';
import 'screens/category_screen.dart';
import 'screens/lesson_detail_screen.dart';
import 'screens/flashcard_screen.dart';
import 'screens/exam_screen.dart';
import 'widgets/app_shell.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        // Title from route
        final loc = state.uri.toString();
        final title = _titleFor(loc);
        return AppShell(title: title, child: child);
      },
      routes: [
        GoRoute(path: '/',         builder: (_, __) => const DashboardScreen()),
        GoRoute(path: '/vocab',    builder: (_, __) => const CategoryScreen(type: ContentType.vocab)),
        GoRoute(path: '/grammar',  builder: (_, __) => const CategoryScreen(type: ContentType.grammar)),
        GoRoute(path: '/kanji',    builder: (_, __) => const CategoryScreen(type: ContentType.kanji)),
        GoRoute(path: '/flashcards', builder: (_, __) => const FlashcardScreen()),
        GoRoute(path: '/exam',     builder: (_, __) => const ExamScreen()),

        // Lesson detail routes  /:type/lesson/:id
        GoRoute(
          path: '/vocab/lesson/:id',
          builder: (_, state) => LessonDetailScreen(
            type: ContentType.vocab,
            lesson: int.tryParse(state.pathParameters['id'] ?? '0') ?? 0,
          ),
        ),
        GoRoute(
          path: '/grammar/lesson/:id',
          builder: (_, state) => LessonDetailScreen(
            type: ContentType.grammar,
            lesson: int.tryParse(state.pathParameters['id'] ?? '1') ?? 1,
          ),
        ),
        GoRoute(
          path: '/kanji/lesson/:id',
          builder: (_, state) => LessonDetailScreen(
            type: ContentType.kanji,
            lesson: int.tryParse(state.pathParameters['id'] ?? '1') ?? 1,
          ),
        ),
      ],
    ),
  ],
);

String _titleFor(String loc) {
  if (loc.startsWith('/vocab/lesson'))   return 'Vocab Lesson';
  if (loc.startsWith('/grammar/lesson')) return 'Grammar Lesson';
  if (loc.startsWith('/kanji/lesson'))   return 'Kanji Lesson';
  if (loc.startsWith('/vocab'))     return 'Vocabulary';
  if (loc.startsWith('/grammar'))   return 'Grammar';
  if (loc.startsWith('/kanji'))     return 'Kanji';
  if (loc.startsWith('/flash'))     return 'Flashcards';
  if (loc.startsWith('/exam'))      return 'Exam Mode';
  return 'Dashboard';
}
