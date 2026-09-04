import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../features/audio/application/audio_controller.dart';
import '../../../features/audio/domain/entities/synced_lyric.dart';

class SyncedLyricsWidget extends StatefulWidget {
  const SyncedLyricsWidget({
    super.key,
    required this.lyrics,
    required this.controller,
    this.showTranslation = false,
    this.maxVisibleLines = 7,
  });

  final SyncedLyrics lyrics;
  final AudioController controller;
  final bool showTranslation;
  final int maxVisibleLines;

  @override
  State<SyncedLyricsWidget> createState() => _SyncedLyricsWidgetState();
}

class _SyncedLyricsWidgetState extends State<SyncedLyricsWidget> {
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;
  bool _isUserScrolling = false;
  StreamSubscription<int>? _positionSubscription;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.lyrics.indexOf(0);
    _positionSubscription = widget.controller.snapshotStream
        .map((snapshot) => snapshot.position.inMilliseconds)
        .distinct()
        .listen(_onPositionChanged);
  }

  @override
  void didUpdateWidget(covariant SyncedLyricsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lyrics != widget.lyrics) {
      _positionSubscription?.cancel();
      _currentIndex = widget.lyrics.indexOf(0);
      _scrollToIndex(_currentIndex, animate: false);
      _positionSubscription = widget.controller.snapshotStream
          .map((snapshot) => snapshot.position.inMilliseconds)
          .distinct()
          .listen(_onPositionChanged);
    }
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _onPositionChanged(int positionMs) {
    if (_isUserScrolling) return;

    final newIndex = widget.lyrics.indexOf(positionMs);
    if (newIndex != _currentIndex && newIndex >= 0 && newIndex < widget.lyrics.lines.length) {
      setState(() => _currentIndex = newIndex);
      _scrollToIndex(newIndex);
    }
  }

  void _scrollToIndex(int index, {bool animate = true}) {
    if (!_scrollController.hasClients) return;

    final itemHeight = _scrollController.position.viewportDimension / widget.maxVisibleLines;
    final targetOffset = (index * itemHeight) - (itemHeight * 2);
    final maxScroll = _scrollController.position.maxScrollExtent;
    final clampedOffset = targetOffset.clamp(0.0, maxScroll);

    if (animate) {
      _scrollController.animateTo(
        clampedOffset,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _scrollController.jumpTo(clampedOffset);
    }
  }

  Future<void> _handleLineTap(int index) async {
    final line = widget.lyrics.lines[index];
    HapticFeedback.lightImpact();
    await widget.controller.seek(Duration(milliseconds: line.startMs));
  }

  @override
  Widget build(BuildContext context) {
    final lines = widget.lyrics.lines;
    final translationLines = widget.lyrics.translationLines;

    if (lines.isEmpty) {
      return Center(
        child: Text(
          AppStrings.loading,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontFamily: 'Monospace',
          ),
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is UserScrollNotification) {
          setState(() => _isUserScrolling = true);
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted) {
              setState(() => _isUserScrolling = false);
            }
          });
        }
        return false;
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.25,
          horizontal: 24,
        ),
        itemCount: lines.length,
        itemExtent: 56,
        itemBuilder: (context, index) {
          final line = lines[index];
          final translation = widget.showTranslation &&
                  translationLines != null &&
                  index < translationLines.length
              ? translationLines[index]
              : null;

          final isActive = index == _currentIndex;
          final isPast = index < _currentIndex;

          return GestureDetector(
            onTap: () => _handleLineTap(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(vertical: 3),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary.withOpacity(0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isActive)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, right: 10),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: TextStyle(
                            fontSize: isActive ? 19 : 15,
                            fontWeight: isActive
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: isActive
                                ? AppColors.textPrimary
                                : isPast
                                    ? AppColors.textSecondary.withOpacity(0.5)
                                    : AppColors.textSecondary,
                            height: 1.45,
                            fontFamily: 'Monospace',
                          ),
                          child: Text(line.text),
                        ),
                        if (translation != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            translation.text,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary.withOpacity(0.65),
                              height: 1.35,
                              fontFamily: 'Monospace',
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
