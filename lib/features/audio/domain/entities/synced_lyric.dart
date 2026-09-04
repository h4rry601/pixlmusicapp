import 'package:audio_service/audio_service.dart';

class SyncedLyricLine {
  final int startMs;
  final int endMs;
  final String text;

  const SyncedLyricLine({
    required this.startMs,
    required this.endMs,
    required this.text,
  });

  bool isActive(int positionMs) {
    return positionMs >= startMs && positionMs < endMs;
  }

  bool isPast(int positionMs) {
    return positionMs >= endMs;
  }

  bool isFuture(int positionMs) {
    return positionMs < startMs;
  }
}

class SyncedLyrics {
  final String trackId;
  final String language;
  final List<SyncedLyricLine> lines;
  final String? translationLanguage;
  final List<SyncedLyricLine>? translationLines;

  const SyncedLyrics({
    required this.trackId,
    required this.language,
    required this.lines,
    this.translationLanguage,
    this.translationLines,
  });

  SyncedLyricLine? lineAt(int positionMs) {
    for (final line in lines) {
      if (line.isActive(positionMs)) return line;
    }
    return null;
  }

  int indexOf(int positionMs) {
    for (var i = 0; i < lines.length; i++) {
      if (lines[i].isActive(positionMs) || lines[i].isFuture(positionMs)) {
        return i;
      }
    }
    return lines.length - 1;
  }

  static SyncedLyrics fromMediaItem(MediaItem item) {
    final lyricsData = item.extras?['syncedLyrics'] as Map<String, dynamic>?;
    if (lyricsData == null) {
      return const SyncedLyrics(
        trackId: '',
        language: 'en',
        lines: [],
      );
    }

    final lines = <SyncedLyricLine>[];
    final rawLines = lyricsData['lines'] as List<dynamic>? ?? [];
    for (final raw in rawLines) {
      final map = raw as Map<String, dynamic>;
      lines.add(SyncedLyricLine(
        startMs: map['startMs'] as int,
        endMs: map['endMs'] as int,
        text: map['text'] as String,
      ));
    }

    final translationLines = <SyncedLyricLine>[];
    final rawTranslation = lyricsData['translationLines'] as List<dynamic>? ?? [];
    for (final raw in rawTranslation) {
      final map = raw as Map<String, dynamic>;
      translationLines.add(SyncedLyricLine(
        startMs: map['startMs'] as int,
        endMs: map['endMs'] as int,
        text: map['text'] as String,
      ));
    }

    return SyncedLyrics(
      trackId: lyricsData['trackId'] as String? ?? item.id,
      language: lyricsData['language'] as String? ?? 'en',
      lines: lines,
      translationLanguage: lyricsData['translationLanguage'] as String?,
      translationLines: translationLines.isNotEmpty ? translationLines : null,
    );
  }
}
