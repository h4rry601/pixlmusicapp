import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../../audio/domain/entities/audio_quality.dart';

class StreamQualityMetrics {
  final AudioQuality quality;
  final int bufferHealthMs;
  final double droppedFramesPercent;
  final int latencyMs;

  const StreamQualityMetrics({
    required this.quality,
    required this.bufferHealthMs,
    required this.droppedFramesPercent,
    required this.latencyMs,
  });
}

class StreamManager {
  StreamManager({
    AudioQuality initialQuality = AudioQuality.lossless,
    this.onQualityChanged,
    this.onMetricsUpdate,
  }) : _currentQuality = initialQuality;

  final Random _random = Random();
  final StreamController<StreamQualityMetrics> _metricsController =
      StreamController<StreamQualityMetrics>.broadcast();

  AudioQuality _currentQuality;
  AudioQuality get currentQuality => _currentQuality;

  final ValueChanged<AudioQuality>? onQualityChanged;
  final ValueChanged<StreamQualityMetrics>? onMetricsUpdate;

  Stream<StreamQualityMetrics> get metricsStream =>
      _metricsController.stream;

  AudioQuality get optimalQualityForNetwork {
    final networkSpeedMbps = _mockNetworkSpeed();
    if (networkSpeedMbps >= 8.0) {
      return AudioQuality.hiResLossless;
    } else if (networkSpeedMbps >= 4.0) {
      return AudioQuality.lossless;
    } else if (networkSpeedMbps >= 1.5) {
      return AudioQuality.standard;
    }
    return AudioQuality.standard;
  }

  bool setQuality(AudioQuality quality) {
    if (_currentQuality == quality) return true;
    final canStream = _mockCanStreamQuality(quality);
    if (!canStream) return false;
    _currentQuality = quality;
    onQualityChanged?.call(quality);
    return true;
  }

  StreamQualityMetrics get currentMetrics {
    return StreamQualityMetrics(
      quality: _currentQuality,
      bufferHealthMs: _random.nextInt(2000) + 200,
      droppedFramesPercent: _random.nextDouble() * 1.5,
      latencyMs: _random.nextInt(150) + 20,
    );
  }

  void startMetricsSimulation() {
    Timer.periodic(const Duration(seconds: 2), (_) {
      final metrics = currentMetrics;
      _metricsController.add(metrics);
      onMetricsUpdate?.call(metrics);
    });
  }

  void dispose() {
    _metricsController.close();
  }

  double _mockNetworkSpeed() {
    return _random.nextDouble() * 12;
  }

  bool _mockCanStreamQuality(AudioQuality quality) {
    switch (quality) {
      case AudioQuality.standard:
        return true;
      case AudioQuality.lossless:
        return _random.nextDouble() > 0.1;
      case AudioQuality.hiResLossless:
        return _random.nextDouble() > 0.35;
      case AudioQuality.dolbyAtmos:
        return _random.nextDouble() > 0.25;
    }
  }
}
