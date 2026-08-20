import '../audio/domain/entities/music_track.dart';

const demoTracks = [
  MusicTrack(
    id: 'demo-1',
    title: 'Pixel Sunrise',
    artist: 'PIXL Radio',
    album: 'Daily Mix',
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    duration: Duration(minutes: 6, seconds: 12),
  ),
  MusicTrack(
    id: 'demo-2',
    title: 'Neon Save Point',
    artist: 'Arcade Hearts',
    album: 'Daily Mix',
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    duration: Duration(minutes: 5, seconds: 2),
  ),
  MusicTrack(
    id: 'demo-3',
    title: 'Bitcrush Bloom',
    artist: 'The Loopers',
    album: 'New Finds',
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
    duration: Duration(minutes: 5, seconds: 44),
  ),
];
