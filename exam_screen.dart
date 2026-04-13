import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/app_database.dart';
import '../data/models.dart';
import '../theme/app_theme.dart';

// ─── Helpers ───────────────────────────────────────────────────

List<VocabItem> _getAllVocab() {
  final all = <VocabItem>[];
  for (final items in vocabData.values) {
    all.addAll(items.where((v) => v.word.isNotEmpty && v.meaning.isNotEmpty));
  }
  return all;
}

List<T> _shuffle<T>(List<T> list) {
  final copy = List<T>.from(list);
  copy.shuffle(Random());
  return copy;
}

// ─── Exam state ─────────────────────────────────────────────────

enum _Phase { landing, quiz, result }

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  _Phase _phase  = _Phase.landing;
  List<VocabItem> _quizSet = [];
  int _currentIndex = 0;
  int _score = 0;
  List<VocabItem> _options = [];

  final _allVocab = _getAllVocab();

  List<VocabItem> _buildOptions(VocabItem question) {
    final distractors = _shuffle(_allVocab.where((v) => v.meaning != question.meaning).toList()).take(3).toList();
    return _shuffle([...distractors, question]);
  }

  void _startQuiz() {
    final set = _shuffle(_allVocab).take(5).toList();
    setState(() {
      _quizSet = set;
      _currentIndex = 0;
      _score = 0;
      _options = _buildOptions(set[0]);
      _phase = _Phase.quiz;
    });
  }

  void _answer(String selected) {
    final correct = _quizSet[_currentIndex].meaning;
    final newScore = selected == correct ? _score + 1 : _score;
    final next = _currentIndex + 1;
    if (next >= _quizSet.length) {
      setState(() { _score = newScore; _phase = _Phase.result; });
    } else {
      setState(() {
        _score = newScore;
        _currentIndex = next;
        _options = _buildOptions(_quizSet[next]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return switch (_phase) {
      _Phase.landing => _Landing(onStart: _startQuiz),
      _Phase.quiz    => _Quiz(
          question: _quizSet[_currentIndex],
          options: _options,
          index: _currentIndex,
          total: _quizSet.length,
          score: _score,
          onAnswer: _answer,
        ),
      _Phase.result  => _Result(
          score: _score,
          total: _quizSet.length,
          onRetry: _startQuiz,
          onHome:  () { setState(() => _phase = _Phase.landing); context.go('/'); },
        ),
    };
  }
}

// ─── Landing ────────────────────────────────────────────────────

const _tips = [
  ('ছবিগুলো আগে দেখুন', 'লিসেনিং শুরু হওয়ার আগে ছবিগুলো ভালো করে দেখে নিন। ছবিতে কী কী আছে তার জাপানি শব্দগুলো মনে মনে আওড়ান।'),
  ('মার্কার শব্দে লক্ষ্য রাখুন', 'でも・ですから・それから শব্দগুলো শুনলে সতর্ক হোন — এগুলো উত্তরের ইঙ্গিত দেয়।'),
  ('নেতিবাচক শব্দ খেয়াল করুন', 'ません বা ませんでした বাক্যের শেষে আসে। পুরো বাক্য না শুনেই উত্তর দাগাবেন না।'),
  ('নোট নিন', 'অডিও শোনার সময় কি-ওয়ার্ড লিখে রাখুন। নিয়মিত N5 Listening Practice শুনুন।'),
];

class _Landing extends StatelessWidget {
  final VoidCallback onStart;
  const _Landing({required this.onStart});

  @override
  Widget build(BuildContext context) {
    const errorColor = Color(0xFFE76F51);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hero
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFc25a3d), errorColor],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: errorColor.withOpacity(0.25), blurRadius: 24, offset: const Offset(0, 8))],
            ),
            padding: const EdgeInsets.all(28),
            child: Stack(children: [
              Positioned(right: -10, top: -8,
                child: Text('試', style: TextStyle(fontSize: 80, color: Colors.white.withOpacity(0.07))),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                const Text('🧪', style: TextStyle(fontSize: 36)),
                const SizedBox(height: 12),
                const Text('N5 Proficiency Test',
                  style: TextStyle(fontFamily: 'NotoSerifJP', fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text('Test your knowledge across all 25 lessons.\n5 random questions per round.',
                  style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.75), height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                GestureDetector(
                  onTap: onStart,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 13),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 14, offset: const Offset(0, 4))],
                    ),
                    child: const Text('START QUIZ →',
                      style: TextStyle(color: errorColor, fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                  ),
                ),
              ]),
            ]),
          ),
          const SizedBox(height: 12),

          // Tips card
          Container(
            decoration: context.cardDecoration,
            padding: const EdgeInsets.all(18),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(color: errorColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: const Center(child: Text('🧠', style: TextStyle(fontSize: 18))),
                ),
                const SizedBox(width: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('N5 LISTENING TIPS',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: errorColor, letterSpacing: 1),
                  ),
                  Text('লিসেনিং পরীক্ষার টিপস 🎧',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: context.textMain),
                  ),
                ]),
              ]),
              const SizedBox(height: 12),
              ..._tips.asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: context.bg, borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.border),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${e.key + 1}. ${e.value.$1}',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textMain),
                    ),
                    const SizedBox(height: 3),
                    Text(e.value.$2, style: TextStyle(fontSize: 13, color: context.textSub, height: 1.5)),
                  ]),
                ),
              )),
              Center(child: Text(
                'এই টিপস মনে রাখুন, N5 পরীক্ষা হবে সহজ! がんばって ✨',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: errorColor),
                textAlign: TextAlign.center,
              )),
            ]),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Quiz question ──────────────────────────────────────────────

class _Quiz extends StatelessWidget {
  final VocabItem question;
  final List<VocabItem> options;
  final int index, total, score;
  final ValueChanged<String> onAnswer;
  const _Quiz({required this.question, required this.options, required this.index, required this.total, required this.score, required this.onAnswer});

  @override
  Widget build(BuildContext context) {
    final progress = index / total;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress bar
          Row(children: [
            Expanded(child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: progress, minHeight: 6,
                backgroundColor: context.border,
                valueColor: AlwaysStoppedAnimation(context.accent),
              ),
            )),
            const SizedBox(width: 10),
            Text('${index + 1} / $total · $score ✓',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: context.textSub),
            ),
          ]),
          const SizedBox(height: 16),

          // Question card
          Container(
            decoration: context.cardDecoration,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
            child: Column(children: [
              Text('WHAT IS THE MEANING OF:',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                  color: context.accentErr, letterSpacing: 1),
              ),
              const SizedBox(height: 12),
              Text(question.word,
                style: TextStyle(fontFamily: 'NotoSerifJP', fontSize: 40,
                  fontWeight: FontWeight.w700, color: context.textMain, height: 1.1),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(question.reading,
                style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: context.textSub),
              ),
            ]),
          ),
          const SizedBox(height: 16),

          // Options
          ...options.map((opt) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () => onAnswer(opt.meaning),
              child: Container(
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.border, width: 1.5),
                  boxShadow: context.isDark
                      ? [const BoxShadow(color: Color(0x33000000), blurRadius: 4, offset: Offset(0,1))]
                      : [const BoxShadow(color: Color(0x08000000), blurRadius: 4, offset: Offset(0,1))],
                ),
                padding: const EdgeInsets.all(16),
                constraints: const BoxConstraints(minHeight: 48),
                child: Text(opt.meaning,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: context.textMain),
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }
}

// ─── Results ────────────────────────────────────────────────────

class _Result extends StatelessWidget {
  final int score, total;
  final VoidCallback onRetry, onHome;
  const _Result({required this.score, required this.total, required this.onRetry, required this.onHome});

  @override
  Widget build(BuildContext context) {
    final pct  = (score / total * 100).round();
    final pass = pct >= 80;
    const errorColor = Color(0xFFE76F51);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: pass
                    ? const Color(0xFF2A9D8F).withOpacity(0.12)
                    : errorColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Center(child: Text(pass ? '🎉' : '📚', style: const TextStyle(fontSize: 40))),
            ),
            const SizedBox(height: 16),
            Text('Test Complete!',
              style: TextStyle(fontFamily: 'NotoSerifJP', fontSize: 24, fontWeight: FontWeight.w700, color: context.textMain),
            ),
            const SizedBox(height: 6),
            Text(pass ? 'Excellent! You are ready for N5!' : 'Keep practicing, Sensei!',
              style: TextStyle(fontSize: 14, color: context.textSub),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: context.cardDecoration,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
              child: Column(children: [
                RichText(text: TextSpan(
                  children: [
                    TextSpan(text: '$score',
                      style: TextStyle(fontSize: 52, fontWeight: FontWeight.w700,
                        color: pass ? context.accent : errorColor, height: 1),
                    ),
                    TextSpan(text: ' / $total',
                      style: TextStyle(fontSize: 28, color: context.textSub.withOpacity(0.4)),
                    ),
                  ],
                )),
                const SizedBox(height: 6),
                Text('$pct% correct',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: context.textSub),
                ),
              ]),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 280,
              child: Column(children: [
                GestureDetector(
                  onTap: onRetry,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: errorColor, borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: errorColor.withOpacity(0.3), blurRadius: 14, offset: const Offset(0,4))],
                    ),
                    child: const Center(child: Text('RETRY EXAM',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
                    )),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: onHome,
                  child: SizedBox(
                    height: 44,
                    child: Center(child: Text('← Back to Home',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textSub),
                    )),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
