// ─── Data models ───────────────────────────────────────────────

class KanjiItem {
  final String kanji;
  final String reading;
  final String meaning;
  final String on;
  final String kun;

  const KanjiItem({
    required this.kanji,
    required this.reading,
    required this.meaning,
    required this.on,
    required this.kun,
  });

  String get strokes => on.isNotEmpty ? 'On: $on | Kun: $kun' : '';
}

class VocabItem {
  final String word;
  final String reading;
  final String meaning;

  const VocabItem({
    required this.word,
    required this.reading,
    required this.meaning,
  });
}

class GrammarItem {
  final String pattern;
  final String explanation;
  final String example;

  const GrammarItem({
    required this.pattern,
    required this.explanation,
    required this.example,
  });
}

enum ContentType { vocab, grammar, kanji }
