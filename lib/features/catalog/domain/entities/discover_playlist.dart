import '../../../audio/domain/entities/music_track.dart';

class BlendPlaylist {
  final String id;
  final String name;
  final String description;
  final String coverUrl;
  final List<MusicTrack> tracks;
  final String ownerName;
  final String? ownerAvatarUrl;
  final int ownerContributionPercent;
  final int friendContributionPercent;
  final DateTime createdAt;

  const BlendPlaylist({
    required this.id,
    required this.name,
    required this.description,
    required this.coverUrl,
    required this.tracks,
    required this.ownerName,
    this.ownerAvatarUrl,
    required this.ownerContributionPercent,
    required this.friendContributionPercent,
    required this.createdAt,
  });
}

class DiscoverWeeklyPlaylist {
  final String id;
  final String name;
  final String description;
  final String coverUrl;
  final List<MusicTrack> tracks;
  final DateTime expiresAt;
  final int totalMinutes;

  const DiscoverWeeklyPlaylist({
    required this.id,
    required this.name,
    required this.description,
    required this.coverUrl,
    required this.tracks,
    required this.expiresAt,
    required this.totalMinutes,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

class FriendProfile {
  final String id;
  final String displayName;
  final String avatarUrl;
  final int mutualFriends;

  const FriendProfile({
    required this.id,
    required this.displayName,
    required this.avatarUrl,
    this.mutualFriends = 0,
  });
}

class RecommendationFilters {
  final int yearRange;
  final List<String> genres;
  final int maxDurationSeconds;
  final bool excludePlayed;

  const RecommendationFilters({
    this.yearRange = 5,
    this.genres = const [],
    this.maxDurationSeconds = 600,
    this.excludePlayed = false,
  });
}
