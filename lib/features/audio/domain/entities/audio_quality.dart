import 'package:flutter/material.dart';

enum AudioQuality {
  standard(
    label: 'Standard',
    bitrate: 160,
    codec: 'AAC',
    icon: Icons.music_note,
  ),
  lossless(
    label: 'Lossless',
    bitrate: 1411,
    codec: 'FLAC',
    icon: Icons.high_quality,
  ),
  hiResLossless(
    label: 'Hi-Res Lossless',
    bitrate: 4608,
    codec: 'ALAC/FLAC',
    icon: Icons.high_quality,
  ),
  dolbyAtmos(
    label: 'Dolby Atmos',
    bitrate: 768,
    codec: 'Dolby Digital Plus',
    icon: Icons.surround_sound,
  );

  const AudioQuality({
    required this.label,
    required this.bitrate,
    required this.codec,
    required this.icon,
  });

  final String label;
  final int bitrate;
  final String codec;
  final IconData icon;

  String get bitrateDisplay {
    if (bitrate >= 1000) {
      final mbps = bitrate / 1000;
      return '${mbps.toStringAsFixed(1)} Mbps';
    }
    return '$bitrate kbps';
  }
}
