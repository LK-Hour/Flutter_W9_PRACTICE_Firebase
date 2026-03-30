# W10 - Firebase Practice - Answers & Implementation

## W10-01 – Handle the like-a-song button

### Questions & Answers

**Firebase DB: How will you update your Firebase database to handle the number of likes?**

I added two new fields to each song document in Firebase:
- `likes` (integer): tracks the total number of likes
- `isLiked` (boolean): tracks whether the current user has liked the song

The structure becomes:
```json
{
  "song_id": {
    "title": "Song Title",
    "artistId": "artist_id",
    "duration": 180000,
    "imageUrl": "https://...",
    "likes": 0,
    "isLiked": false
  }
}
```

**HTTP Request: What kind of HTTP verb will you choose to increment the likes?**

I chose **HTTP PUT** because we need to update the entire song object with the new likes count and toggle status. PUT replaces the entire resource at the specified URL, which is appropriate when we want to update a song's data including the likes value and liked state.

**Repository: Propose a method in the Song Repository to handle liking a song**

- **Method parameters:** Full `Song` object - this gives us access to all song data needed to update Firebase and allows us to toggle the like state
- **Method return:** `Future<Song>` - returns the updated song so the UI can reflect the new likes count and liked status immediately
- **Possible errors:** Network errors, Firebase write failures, invalid song ID

The method works as a **toggle**: if the song is already liked (`isLiked == true`), it decrements the likes count and sets `isLiked` to false. If not liked, it increments and sets `isLiked` to true.

**Model View: How will you update the model view AsyncValues?**

After successfully toggling the like on a song, I update the local data list by finding the song by ID and replacing it with the updated song object. Then I create a new `AsyncValue.success()` with the updated list and call `notifyListeners()`.

**View: What kind of screen needs to be updated?**

The Library screen needs to be updated to show:
- A like button (heart icon) for each song that toggles between filled and outlined
- Red filled heart when liked, grey outlined heart when not liked
- The current likes count next to the button

In case of error, I use `debugPrint` to log the error. For better UX, a SnackBar could be shown to inform the user.

### Implementation Steps

1. Added `likes` and `isLiked` fields to `Song` model with `copyWith()` method
2. Updated `SongDto` to handle likes and isLiked serialization (fromJson/toJson)
3. Added `likeSong(Song song)` method to `SongRepository` interface
4. Implemented `likeSong()` in `SongRepositoryFirebase` using HTTP PUT with toggle logic
5. Added `likeSong()` method in `LibraryViewModel` to update local state
6. Added toggle-able like button (filled/outlined heart) and likes counter in `LibraryItemTile`
7. Connected `onLike` callback in `LibraryContent`

---

## W10-02 – Handle In-Memory Caches

### Questions & Answers

**Q1 - Implement caches in the different repositories (Song, Artist)**

I implemented in-memory caching in both repositories using a nullable list:
```dart
List<Song>? _cachedSongs;

Future<List<Song>> fetchSongs({bool forceFetch = false}) async {
  // 1. Return cache if available and not forcing fetch
  if (_cachedSongs != null && !forceFetch) {
    return _cachedSongs!;
  }
  
  // 2. Fetch from API
  final response = await http.get(songsUri);
  // ... parse response ...
  
  // 3. Store in memory cache
  _cachedSongs = result;
  return result;
}
```

**Q2 – Add a RefreshIndicator widget to force the refresh (clear the cache)**

I wrapped the `ListView` in a `RefreshIndicator` widget and added a `refreshData()` method in the ViewModel that calls `fetchSong(forceFetch: true)`. The `forceFetch` parameter bypasses the cache and fetches fresh data from the API.

**Q3 – We can still see a very fast tiny "loading flash": can you explain why?**

The "loading flash" occurs because the **ViewModel is recreated every time the screen is shown**. When we navigate to the Library screen, a new `LibraryViewModel` is created in the `ChangeNotifierProvider`. The constructor calls `_init()` which calls `fetchSong()`, which sets `data = AsyncValue.loading()` and calls `notifyListeners()`.

Even though the cache returns data instantly (no network delay), there's still a synchronous build cycle where the UI shows the loading state before the async operation completes. This causes the brief flash.

**Solution:** The ViewModel could be created at a higher level in the widget tree (not recreated on each navigation), or we could skip the loading state when we know we have cached data.

### Implementation Steps

1. Added `_cachedSongs` field in `SongRepositoryFirebase`
2. Added `_cachedArtists` field in `ArtistRepositoryFirebase`
3. Added `forceFetch` parameter to `fetchSongs()` and `fetchArtists()`
4. Updated cache when liking a song
5. Added `refreshData()` method in `LibraryViewModel`
6. Wrapped `ListView` with `RefreshIndicator` in `LibraryContent`

---

## W10-03 – Artist Screen with Songs and Comments

### Implementation Steps

**Model Layer:**
- Created `Comment` model with fields: `id`, `artistId`, `content`, `createdAt`

**DTO / Repository Layer:**
- Created `CommentDto` for JSON serialization
- Added methods to `ArtistRepository`:
  - `fetchSongsByArtist(String artistId)` - filters songs by artist ID
  - `fetchCommentsByArtist(String artistId)` - fetches comments for an artist
  - `postComment(String artistId, String content)` - uses HTTP POST to add new comment

**ViewModel:**
- Created `ArtistDetailViewModel` with:
  - `AsyncValue<List<Song>> songsValue` - songs state
  - `AsyncValue<List<Comment>> commentsValue` - comments state
  - `fetchData()` - fetches both songs and comments
  - `addComment(String content)` - posts new comment and updates local state

**UI Layer:**
- Created `ArtistDetailScreen` - wrapper with ChangeNotifierProvider
- Created `ArtistDetailContent` - main UI with:
  - Artist header (image, name, genre)
  - Songs list (reuses song display pattern)
  - Comments list with `CommentTile`
  - Empty state placeholders for both lists
- Created `CommentTile` widget for displaying comments
- Comment form implemented as bottom sheet with:
  - Text field for input
  - Cancel and Submit buttons
  - Validation for empty comments
  - Clears input after successful submission
- Updated `ArtistTile` to support `onTap` navigation
- Updated `ArtistsContent` to navigate to `ArtistDetailScreen`

---

## Files Modified/Created

### W10-01
- `lib/domain/model/songs/song.dart` - Added likes field
- `lib/data/dtos/song_dto.dart` - Added likes serialization
- `lib/data/repositories/songs/song_repository.dart` - Added likeSong method
- `lib/data/repositories/songs/song_repository_firebase.dart` - Implemented likeSong
- `lib/ui/screens/library/view_model/library_view_model.dart` - Added likeSong
- `lib/ui/screens/library/widgets/library_item_tile.dart` - Added like button
- `lib/ui/screens/library/widgets/library_content.dart` - Connected onLike

### W10-02
- `lib/data/repositories/songs/song_repository_firebase.dart` - Added caching
- `lib/data/repositories/artist/artist_repository_firebase.dart` - Added caching
- `lib/ui/screens/library/view_model/library_view_model.dart` - Added refreshData
- `lib/ui/screens/library/widgets/library_content.dart` - Added RefreshIndicator

### W10-03
- `lib/domain/model/comment/comment.dart` - NEW
- `lib/data/dtos/comment_dto.dart` - NEW
- `lib/data/repositories/artist/artist_repository.dart` - Added new methods
- `lib/data/repositories/artist/artist_repository_firebase.dart` - Implemented methods
- `lib/ui/screens/artists/artist_detail_screen.dart` - NEW
- `lib/ui/screens/artists/view_model/artist_detail_view_model.dart` - NEW
- `lib/ui/screens/artists/widgets/artist_detail_content.dart` - NEW
- `lib/ui/widgets/comment/comment_tile.dart` - NEW
- `lib/ui/widgets/song/artist_tile.dart` - Added onTap

---

## Bug Fixes & Error Handling

During implementation, I encountered and fixed several critical issues:

### 1. Assertion Errors in DTOs
**Problem:** Strict type assertions in `SongDto.fromJson()` and `ArtistDto.fromJson()` caused crashes when Firebase data had missing or malformed fields.

**Solution:** Removed `assert()` statements and used null-safe default values with the `??` operator:
```dart
// Before
assert(json[titleKey] is String);
title: json[titleKey],

// After
title: json[titleKey] ?? '',
```

### 2. Null Check Operator Error
**Problem:** "Null check operator used on a null value" error in LibraryViewModel when mapping songs to LibraryItemData. Some songs had artistId values that didn't match any artist in the database.

**Solution:** Added filtering to skip songs without valid artists:
```dart
List<LibraryItemData> data = songs
    .where((song) => mapArtist.containsKey(song.artistId))
    .map((song) => LibraryItemData(song: song, artist: mapArtist[song.artistId]!))
    .toList();
```

### 3. Null Values in Firebase Entries
**Problem:** Firebase could return null values in entry.value when iterating over JSON entries.

**Solution:** Added null checks when parsing all collections (songs, artists, comments):
```dart
for (final entry in jsonData.entries) {
  if (entry.value != null) {
    result.add(DtoClass.fromJson(entry.key, entry.value));
  }
}
```

### 4. Static Method Consistency
**Problem:** `toJson()` methods were instance methods in DTOs, inconsistent with static `fromJson()`.

**Solution:** Made all `toJson()` methods static for consistency.

These fixes make the app more robust and prevent crashes when dealing with real-world Firebase data that may have missing fields or inconsistencies.
- `lib/ui/screens/artists/widgets/artists_content.dart` - Added navigation
