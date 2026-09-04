# PIXL Music - Complete UI Implementation Plan

## Context
The PIXL music app currently has a functional but incomplete UI. Core services (audio engine, synced lyrics, recommendations, credits) are implemented. This plan completes all remaining screens to Apple Music/Spotify polish quality while preserving the retro 8-bit NES UI theme.

## Decisions
1. **Theme**: Keep retro pixel/8-bit NES aesthetic. Polish layouts, spacing, typography, animations, and micro-interactions. Do NOT migrate to modern Material 3.
2. **State Management**: Add `flutter_bloc` for screen-level state (Home, Search, Library, Player, Auth). Keep `GetIt` for dependency injection.
3. **Routing**: Keep named routes in `MaterialApp`. Wrap screens with `BlocProvider` where needed.
4. **Navigation**: Keep existing bottom nav (Home, Search, Library). Add Profile tab (4th tab). Settings accessible from Profile.
5. **Data**: Continue using `demo_tracks.dart` as mock data source. `RecommendationService` already generates playlists.

## Dependencies
- Existing: `flutter_bloc`, `get_it`, `nes_ui`, `google_fonts`, `just_audio`, `audio_service`, `rxdart`
- No new dependencies required

## Bloc Structure
| Bloc | Events | States | Purpose |
|------|--------|--------|---------|
| `AuthBloc` | LoginRequested, SignUpRequested, ForgotPasswordRequested, LogoutRequested | AuthInitial, AuthLoading, AuthAuthenticated, AuthUnauthenticated, AuthFailure | Auth flow |
| `HomeBloc` | LoadFeed, RefreshFeed, PlayTrack, ToggleLike | HomeInitial, HomeLoading, HomeLoaded, HomeFailure | Home feed data |
| `SearchBloc` | UpdateQuery, ClearQuery, SelectCategory, SearchTracks | SearchInitial, SearchLoading, SearchResults, SearchCategories | Search + browse |
| `LibraryBloc` | LoadLibrary, FilterByType, SelectItem | LibraryInitial, LibraryLoading, LibraryLoaded, LibraryFailure | Library tabs |
| `PlayerBloc` | Play, Pause, Seek, ToggleShuffle, ToggleRepeat, ToggleLyrics, ToggleCredits, SetQuality | PlayerInitial, PlayerLoading, PlayerPlaying, PlayerPaused, PlayerBuffering, PlayerError | Player state |
| `PlaylistBloc` | LoadPlaylist, PlayAll, ShufflePlay, ToggleTrackLike | PlaylistInitial, PlaylistLoading, PlaylistLoaded, PlaylistFailure | Playlist detail |

## File Structure (New Files)
```
lib/
  features/
    auth/
      application/
        auth_bloc.dart
        auth_event.dart
        auth_state.dart
      presentation/
        pages/
          signup_page.dart
          forgot_password_page.dart
    home/
      application/
        home_bloc.dart
        home_event.dart
        home_state.dart
      presentation/
        pages/
          home_feed_page.dart (rewrite)
          widgets/
            featured_card.dart
            horizontal_track_list.dart
            browse_category_card.dart
    library/
      application/
        library_bloc.dart
        library_event.dart
        library_state.dart
      presentation/
        pages/
          library_page.dart (rewrite)
          widgets/
            library_section_header.dart
            album_grid_item.dart
            artist_grid_item.dart
    player/
      application/
        player_bloc.dart
        player_event.dart
      presentation/
        pages/
          player_page.dart (rewrite)
        widgets/
          player_artwork.dart
          player_controls.dart
          player_progress.dart
          quality_selector.dart
          queue_sheet.dart
    search/
      application/
        search_bloc.dart
        search_event.dart
        search_state.dart
      presentation/
        pages/
          search_page.dart (rewrite)
          widgets/
            search_category_grid.dart
            recent_search_chip.dart
    playlist/
      application/
        playlist_bloc.dart
        playlist_event.dart
        playlist_state.dart
      presentation/
        pages/
          playlist_page.dart (rewrite)
        widgets/
          playlist_header.dart
          track_list_item.dart
          track_swipe_action.dart
    profile/
      application/
        profile_bloc.dart
        profile_event.dart
        profile_state.dart
      presentation/
        pages/
          profile_page.dart
        widgets/
          listening_stats_card.dart
          settings_list_item.dart
    settings/
      presentation/
        pages/
          settings_page.dart
```

## File Structure (Modified Files)
```
lib/
  core/
    constants/
      app_strings.dart (add new strings)
      app_colors.dart (add new colors)
    di/
      injection_container.dart (register Blocs)
  main.dart (add BlocObserver, wrap with BlocProvider)
  presentation/
    pages/
      shell/
        mini_player.dart (rewrite with progress)
    widgets/
      common/
        shimmer_loading.dart
        error_state.dart
        empty_state.dart
        pull_to_refresh.dart
        nes_neumorphic_container.dart
        track_list_tile.dart
```

## Implementation Order
1. **Core Foundation** - Add Blocs to DI, create common widgets (shimmer, error, empty states, track list tile, neumorphic containers)
2. **Auth Screens** - Sign Up page, Forgot Password page, update Login page to use AuthBloc
3. **Home Feed** - Rewrite with BlocProvider, featured hero cards, horizontal track lists, browse categories
4. **Search** - Rewrite with BlocProvider, browse categories grid, recent searches, search results with track tiles
5. **Library** - Rewrite with BlocProvider, playlists/albums/artists grid views, recently played section
6. **Player** - Full rewrite with BlocProvider, immersive full-screen, lyrics toggle, credits button, quality selector, queue sheet
7. **Playlist** - Rewrite with BlocProvider, better header, swipeable track list, credits integration
8. **Mini Player** - Rewrite with progress bar, swipe to expand into full player
9. **Profile** - New page with listening stats, settings navigation
10. **Settings** - New page with audio quality, lyrics toggle, downloads, account settings
11. **Validation** - Run `flutter analyze`, verify all screens navigate correctly, test state transitions

## Screen Specifications

### Home Feed (`home_feed_page.dart`)
- **Top section**: Large featured playlist/album card with gradient overlay (NES-styled pixel borders)
- **Horizontal sections**: "Made For You", "Discover Weekly", "Friend Blend", "Recently Played" - each with horizontal scrolling `ListView`
- **Track tiles**: Square album art (placeholder pixel icon), title, artist, duration, play button overlay on hover
- **Pull to refresh**: Wrap `ListView` in refresh indicator
- **Loading**: Shimmer skeleton while loading
- **Animations**: Staggered fade-in on scroll using `AnimatedList` or `SliverAnimatedList`

### Search (`search_page.dart`)
- **Search bar**: NES-styled `TextField` with pixel borders, blinking cursor effect
- **Browse categories**: Grid of 6-8 category cards (Synthwave, Lo-Fi, Chiptune, etc.) with pixel art icons
- **Recent searches**: Horizontal scrolling chips
- **Results**: Track list with album art, title, artist, duration
- **Empty state**: Pixel art ghost with "No results found" message

### Library (`library_page.dart`)
- **Tabs**: Playlists, Albums, Artists, Songs (NES tab bar with pixel underlines)
- **Grid view**: Square album/artist cards with pixel placeholders
- **List view**: Track list with numbers, album art, duration
- **Sections**: "Recently Played", "Downloaded", "Your Playlists"

### Player (`player_page.dart`)
- **Full screen**: Immersive dark background with blurred album art backdrop
- **Artwork**: Large centered square (or circular for Apple Music style) with pixel frame
- **Controls**: Large NES play/pause button, skip prev/next, shuffle, repeat
- **Progress**: Pixel-styled slider with orange fill, time labels
- **Actions row**: Lyrics button, Credits button, Quality button, Queue button, Share, More
- **Bottom sheet triggers**: Lyrics (synced lyrics widget), Credits (track credits bottom sheet), Quality (audio quality selector), Queue (up next list)
- **Animations**: Smooth artwork rotation when playing, button press scale effects

### Playlist (`playlist_page.dart`)
- **Header**: Large cover art with gradient overlay, title, description, owner info
- **Controls**: Play All, Shuffle buttons (NES style)
- **Track list**: Numbered, album art thumbnail, title, artist, duration, more options button
- **Swipe actions**: Swipe left to reveal Like, Add to Playlist, Share, Credits
- **Footer**: Total duration, track count

### Mini Player (`mini_player.dart`)
- **Layout**: Horizontal row with album art, title/artist, play/pause, skip next
- **Progress**: Thin orange progress bar at top
- **Interaction**: Tap expands to full player, swipe up/down dismisses

### Auth Screens
- **Sign Up**: Form with name, email, password, confirm password, terms checkbox, pixel-styled button
- **Forgot Password**: Email input, "Send Reset Link" button, back to login link
- **Consistent**: Same NES container style as login, blinking "INSERT COIN" text replaced with themed taglines

### Profile (`profile_page.dart`)
- **Header**: Pixel avatar, username, stats (playlists, followers, following)
- **Sections**: Listening Stats (top artists, top genres, listening time), Settings, Logout
- **Settings navigation**: Taps open Settings page

### Settings (`settings_page.dart`)
- **Sections**: Audio (quality selector, normalize volume), Playback (crossfade, gapless), Downloads (quality, location), Account (change password, delete account)
- **Toggles**: NES-styled switches with pixel animations
- **List items**: Icon, label, chevron right or toggle

## Common Widgets
- `NesNeumorphicContainer`: Elevated surface with NES-style pixel shadow borders
- `TrackListTile`: Reusable track row with artwork, metadata, actions
- `ShimmerLoading`: Pixel-grid shimmer animation for loading states
- `EmptyState`: Centered pixel art icon + message + optional action button
- `ErrorState`: Pixel art error icon + message + retry button

## Validation & Quality Gates
1. `flutter analyze` passes with zero errors
2. All screens render without runtime exceptions on iOS/Android simulators
3. Navigation flow: Splash -> Login -> Home -> (Search, Library, Profile, Player) works
4. Auth flow: Login, Sign Up, Forgot Password all navigate correctly
5. Player controls: Play, pause, seek, next, previous, shuffle, repeat all wired to `AudioController`
6. Lyrics sync: Auto-scroll updates when `snapshotStream` emits new position
7. Credits: Bottom sheet opens, displays mock data, dismisses correctly
8. No memory leaks: `StreamSubscription`s disposed in `dispose()`
9. No hardcoded strings: All text in `AppStrings`

## Open Questions (Resolved)
- Theme direction: Keep retro NES, polish UI
- State management: Add flutter_bloc
- Priority: Auth screens first

## Risks
- **Bloc migration complexity**: Existing pages use `getIt` directly. Migrating to BlocProvider requires wrapping `MaterialApp` or individual routes. Mitigation: Use `BlocProvider.value` or `MultiBlocProvider` at route level.
- **NES UI + premium polish tension**: NES components (NesContainer, NesButton) have limited customization. Mitigation: Wrap NES widgets with custom `Container`/`DecoratedBox` for advanced styling (gradients, shadows).
- **Audio state sync**: PlayerBloc must mirror AudioController/PlaybackSnapshot without race conditions. Mitigation: Single source of truth - AudioController. PlayerBloc subscribes to `snapshotStream` and emits states.
