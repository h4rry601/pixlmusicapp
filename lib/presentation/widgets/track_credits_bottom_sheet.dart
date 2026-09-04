import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../features/audio/domain/entities/music_track.dart';
import '../../../features/catalog/domain/entities/track_credits.dart';

class TrackCreditsBottomSheet extends StatelessWidget {
  const TrackCreditsBottomSheet({
    super.key,
    required this.track,
    this.credits,
  });

  final MusicTrack track;
  final TrackCredits? credits;

  @override
  Widget build(BuildContext context) {
    final effectiveCredits = credits ?? _mockCreditsFor(track);

    if (!effectiveCredits.hasCredits) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Text(
          'No credits available for this track.',
          style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Monospace'),
        ),
      );
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.35,
      maxChildSize: 0.85,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
              child: Column(
                children: [
                  _buildHandle(),
                  _buildHeader(context),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  children: [
                    const SizedBox(height: 12),
                    _buildInfoRow('Album', effectiveCredits.albumTitle),
                    const SizedBox(height: 8),
                    _buildInfoRow('ISRC', effectiveCredits.isrc ?? 'N/A'),
                    if (effectiveCredits.label != null) ...[
                      const SizedBox(height: 8),
                      _buildInfoRow('Label', effectiveCredits.label!),
                    ],
                    if (effectiveCredits.copyrightText != null) ...[
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'Copyright',
                        effectiveCredits.copyrightText!,
                      ),
                    ],
                    const SizedBox(height: 20),
                    ...effectiveCredits.producers.isNotEmpty
                        ? [_buildRoleSection('Producers', effectiveCredits.producers)]
                        : [],
                    ...effectiveCredits.songwriters.isNotEmpty
                        ? [_buildRoleSection('Songwriters', effectiveCredits.songwriters)]
                        : [],
                    ...effectiveCredits.engineers.isNotEmpty
                        ? [_buildRoleSection('Engineers', effectiveCredits.engineers)]
                        : [],
                    ...effectiveCredits.mixers.isNotEmpty
                        ? [_buildRoleSection('Mixers', effectiveCredits.mixers)]
                        : [],
                    ...effectiveCredits.masteringEngineers.isNotEmpty
                        ? [_buildRoleSection(
                            'Mastering Engineers',
                            effectiveCredits.masteringEngineers,
                          )]
                        : [],
                    ...effectiveCredits.musicians.isNotEmpty
                        ? [_buildRoleSection('Musicians', effectiveCredits.musicians)]
                        : [],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.textSecondary,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Track Credits',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontFamily: 'Monospace',
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  track.title,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontFamily: 'Monospace',
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontFamily: 'Monospace',
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontFamily: 'Monospace',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSection(String title, List<TrackCreditRole> roles) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'Monospace',
            ),
          ),
          const SizedBox(height: 8),
          ...roles.map(
            (role) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      role.name,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontFamily: 'Monospace',
                      ),
                    ),
                  ),
                  Text(
                    role.role,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontFamily: 'Monospace',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TrackCredits _mockCreditsFor(MusicTrack track) {
    final randomRole = <String, List<TrackCreditRole>>{
      'Producer': [
        const TrackCreditRole(name: 'Alex Synthwave', role: 'Producer'),
        const TrackCreditRole(name: 'Maya Circuit', role: 'Producer'),
      ],
      'Songwriter': [
        const TrackCreditRole(name: 'Jordan Pixel', role: 'Songwriter'),
        const TrackCreditRole(name: 'Casey 8-Bit', role: 'Songwriter'),
      ],
      'Engineer': [
        const TrackCreditRole(name: 'Sam DAC', role: 'Recording Engineer'),
      ],
      'Mixer': [
        const TrackCreditRole(name: 'Riley Compressor', role: 'Mixer'),
      ],
      'Mastering': [
        const TrackCreditRole(name: 'Drew Limiter', role: 'Mastering Engineer'),
      ],
      'Musician': [
        const TrackCreditRole(name: 'Taylor Chiptune', role: 'Synthesizer'),
        const TrackCreditRole(name: 'Avery Beat', role: 'Drum Programming'),
      ],
    };

    return TrackCredits(
      trackId: track.id,
      trackTitle: track.title,
      artistName: track.artist,
      albumTitle: track.album ?? 'Unknown Album',
      producers: randomRole['Producer'] ?? const [],
      songwriters: randomRole['Songwriter'] ?? const [],
      engineers: randomRole['Engineer'] ?? const [],
      mixers: randomRole['Mixer'] ?? const [],
      masteringEngineers: randomRole['Mastering'] ?? const [],
      musicians: randomRole['Musician'] ?? const [],
      label: 'PIXL Records',
      copyrightText: '2026 PIXL Music. All rights reserved.',
      isrc: 'PIXL${track.id.hashCode.toString().padLeft(12, '0')}',
    );
  }
}
