class TrackCreditRole {
  final String name;
  final String role;

  const TrackCreditRole({
    required this.name,
    required this.role,
  });
}

class TrackCredits {
  final String trackId;
  final String trackTitle;
  final String artistName;
  final String albumTitle;
  final List<TrackCreditRole> producers;
  final List<TrackCreditRole> songwriters;
  final List<TrackCreditRole> engineers;
  final List<TrackCreditRole> mixers;
  final List<TrackCreditRole> masteringEngineers;
  final List<TrackCreditRole> musicians;
  final String? label;
  final String? copyrightText;
  final String? isrc;

  const TrackCredits({
    required this.trackId,
    required this.trackTitle,
    required this.artistName,
    required this.albumTitle,
    this.producers = const [],
    this.songwriters = const [],
    this.engineers = const [],
    this.mixers = const [],
    this.masteringEngineers = const [],
    this.musicians = const [],
    this.label,
    this.copyrightText,
    this.isrc,
  });

  List<TrackCreditRole> get allRoles {
    return [
      ...producers,
      ...songwriters,
      ...engineers,
      ...mixers,
      ...masteringEngineers,
      ...musicians,
    ];
  }

  bool get hasCredits =>
      allRoles.isNotEmpty ||
      label != null ||
      copyrightText != null ||
      isrc != null;
}

class CreditsSection {
  final String title;
  final List<TrackCreditRole> roles;

  const CreditsSection({
    required this.title,
    required this.roles,
  });
}
