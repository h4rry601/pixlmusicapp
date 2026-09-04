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
  MusicTrack(
    id: 'demo-4',
    title: 'Chiptune Highway',
    artist: '8-Bit Riders',
    album: 'Retro Drive',
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
    duration: Duration(minutes: 4, seconds: 30),
  ),
  MusicTrack(
    id: 'demo-5',
    title: 'Synthwave Drift',
    artist: 'Neon Pulse',
    album: 'Night Vibes',
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
    duration: Duration(minutes: 3, seconds: 58),
  ),
  MusicTrack(
    id: 'demo-6',
    title: 'Lo-Fi Dojo',
    artist: 'Calm Waves',
    album: 'Study Session',
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
    duration: Duration(minutes: 4, seconds: 15),
  ),
  MusicTrack(
    id: 'demo-7',
    title: 'Game Over',
    artist: 'PIXL Radio',
    album: 'Daily Mix',
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
    duration: Duration(minutes: 5, seconds: 33),
  ),
  MusicTrack(
    id: 'demo-8',
    title: 'Electric Castle',
    artist: 'Thunder Grid',
    album: 'Fortress',
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
    duration: Duration(minutes: 6, seconds: 47),
  ),
  MusicTrack(
    id: 'demo-9',
    title: 'Disco Reactor',
    artist: 'Groove Machines',
    album: 'Floor Fever',
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-9.mp3',
    duration: Duration(minutes: 4, seconds: 22),
  ),
  MusicTrack(
    id: 'demo-10',
    title: 'Moonbase Alpha',
    artist: 'Cosmic Keys',
    album: 'Space Station',
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-10.mp3',
    duration: Duration(minutes: 5, seconds: 10),
  ),
];

/// Các bài hát nổi bật cho trang Home
const featuredTracks = [
  MusicTrack(
    id: 'demo-1',
    title: 'Pixel Sunrise',
    artist: 'PIXL Radio',
    album: 'Daily Mix',
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    duration: Duration(minutes: 6, seconds: 12),
  ),
  MusicTrack(
    id: 'demo-5',
    title: 'Synthwave Drift',
    artist: 'Neon Pulse',
    album: 'Night Vibes',
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
    duration: Duration(minutes: 3, seconds: 58),
  ),
  MusicTrack(
    id: 'demo-10',
    title: 'Moonbase Alpha',
    artist: 'Cosmic Keys',
    album: 'Space Station',
    url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-10.mp3',
    duration: Duration(minutes: 5, seconds: 10),
  ),
];

/// Demo playlists data
const demoPlaylists = [
  {'id': 'pl-1', 'name': 'Daily Mix', 'count': 4, 'color': 0xFFFF8800},
  {'id': 'pl-2', 'name': 'Night Vibes', 'count': 3, 'color': 0xFF8800FF},
  {'id': 'pl-3', 'name': 'Retro Drive', 'count': 2, 'color': 0xFF00AAFF},
  {'id': 'pl-4', 'name': 'Chill Zone', 'count': 3, 'color': 0xFF00FF88},
];
