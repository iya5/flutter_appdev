# Flutter for App Development <sup>(wip)</sup>

I developed this flutter application for uni. This project will feature a modular interface with multiple activities. Currently my only progress is a functional **music player** with metadata display and playback controls.

---

## Table of Contents
- [Project Structure](#project-structure)  
- [Features](#features)  
- [Used Widgets, Classes & Functionalities](#used-widgets-classes--functionalities)  
- [Dependencies](#dependencies)  
- [Installation Guide](#installation-guide)
- [Links Used in This Project](#links-used-in-this-project)
- [Notes & Issues](#notes--issues)  

---
## Project Structure
```
flutter_appdev/
│
├─ lib/
│  ├─ main.dart                     # Entry point of the app
│  ├─ homepage.dart                 # Homepage with activity cards
│  ├─ styles/
│  │  ├─ color_palette.dart         # Centralized color definitions
│  │  └─ text_styles.dart           # Centralized text styles
│  ├─ components/
│  │  └─ activitycards.dart         # Activity card widget
│  ├─ pages/
│  │  ├─ activity1/
│  │  │  ├─ activity1.dart          # Music player page (Activity 1)
│  │  │  ├─ song_list_widget.dart   # Song list widget
│  │  │  └─ song_model.dart         # Song metadata model
│  │  ├─ activity2.dart             # Placeholder for Activity 2
│  │  ├─ activity3.dart             # Placeholder for Activity 3
│  │  └─ activity4.dart             # Placeholder for Activity 4
│
├─ assets/
│  ├─ images/                       # Images used in activity cards and UI
│  └─ music/                        # Audio files for the music player
│
├─ pubspec.yaml                     # Flutter configuration and dependencies
└─ README.md                        # Project documentation

```

---

## Features

> [!NOTE]
> This application is currently a work in progress!

### Music Player (Activity 1)
- Play, pause, skip, previous, and shuffle songs  
- Display song metadata: title, artist, album, album art  
- Interactive song list inside MusicPlayer page 
- Audio progress slider with seek functionality  

### Other Activities (Activity 2–4)
- Placeholder for future school activities

### Homepage
- Grid layout of activity cards  
- Customizable AppBar with icons and title   

---

## Used Widgets, Classes & Functionalities

| Feature             | Widget / Class           | Description    |
|---------------------|--------------------------|----------------|
| Homepage            | `ActivityCard`           | Displays each activity with title, subtitle, image, and navigation link |
| Music Player UI     | `Activity1`              | Main StatefulWidget handling audio playback and UI interactions |
| Song List           | `SongListWidget`         | Displays list of songs with hover effect and tap-to-play functionality |
| Song Metadata       | `Song` & `SongMetadata`  | Stores song title, artist, album, and album art    |
| Audio Playback      | `AudioPlayer`            | Handles play, pause, skip, previous, shuffle, and seek functionality |
| AppBar Customization| `AppBar`                 | Customized toolbar with height, opacity, and icons for navigation and settings(In progress) |
| Slider              | `Slider`                 | Audio progress bar that allows seeking     |
| Icon Controls       | `IconButton`             | Play/pause, next/previous, shuffle, toggle song list    |
| Theme / Styling     | `color_palette.dart & text_styles.dart` | Centralized UI theming for colors and typography    |

---

## Dependencies

- `audioplayers` (audio playback)  
- `audiotags` (read metadata from audio files)  
- `cupertino_icons` (iOS-style icons)  

---

## Installation Guide

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.0.0 or higher recommended)  
- IDE such as [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)  
- Android/iOS emulator or physical device  

### Steps
1. **Clone the repository**  
```bash
git clone <https://github.com/iya5/flutter_appdev.git>
cd flutter_appdev
```
2. **Install dependencies**  
```bash
flutter pub get
```
3. **Run the app**  
```bash
flutter run
```

4. **Ensure assets are declared in `pubspec.yaml`:**
```yaml
dependencies:
  ...
  audioplayers: ^6.0.0
  audiotags: ^1.4.5
  cupertino_icons: ^1.0.8

flutter:
  assets:
    - assets/images/
    - assets/music/
```
---

## Links Used in This Project

| Link                      | Purpose / Reference in Code               |
| --------------------------------------------------------------------- | ------ |
| [Flutter Official Docs](https://docs.flutter.dev/)                                                 | Main reference for all Flutter widgets and MaterialApp/Scaffold usage (`main.dart`, `homepage.dart`, `Activity1`, `ActivityCard`, etc.) |
| [Dart Programming Language Guide](https://dart.dev/guides)                                         | Used for Dart syntax and language features throughout all files (`song_model.dart`, `activity1.dart`, etc.)  |
| [audioplayers package](https://pub.dev/packages/audioplayers)                                      | Used for playing audio in `Activity1` (`AudioPlayer`, `_audioPlayer.play()`, etc.)  |
| [audiotags package](https://pub.dev/packages/audiotags)                                            | Used to read metadata from audio files in `song_model.dart` and `_getSongs()` in `Activity1` |
| [CupertinoIcons](https://api.flutter.dev/flutter/cupertino/CupertinoIcons-class.html)              | Used for icons like play, pause, backward, forward in `Activity1` and for UI elements in `Homepage`  |
| [Material Icons](https://api.flutter.dev/flutter/material/Icons-class.html)                        | Used for menu, settings, and music note icons in `Homepage` and `SongListWidget` **(to be replaced)** |
| [Slider Widget](https://api.flutter.dev/flutter/material/Slider-class.html)                        | Used in `Activity1` to show the song progress slider    |
| [GridView.extent](https://api.flutter.dev/flutter/widgets/GridView/GridView.extent.html)           | Used in `Homepage` for displaying activity cards    |
| [Navigator.push / MaterialPageRoute](https://api.flutter.dev/flutter/widgets/Navigator-class.html) | Used in `ActivityCard` to navigate to activity pages (`Activity1`, `Activity2`, etc.)    |
| [ClipRRect](https://api.flutter.dev/flutter/widgets/ClipRRect-class.html)                          | Used in `SongListWidget` and `Activity1` to display song album art with rounded corners   |
| [MouseRegion](https://api.flutter.dev/flutter/widgets/MouseRegion-class.html)                      | Used in `SongListWidget` to implement hover effects on songs    |
| [ListView.builder](https://api.flutter.dev/flutter/widgets/ListView/ListView.builder.html)         | Used in `SongListWidget` to display the list of songs dynamically   |
| [StreamSubscription](https://api.flutter.dev/flutter/dart-async/StreamSubscription-class.html)     | Used in `Activity1` to listen to audio player events (`onDurationChanged`, `onPositionChanged`, `onPlayerComplete`) |
| [static](https://medium.com/@yetesfadev/mastering-static-in-flutter-and-dart-3bd21a60fa48)     | Used in `styles` to call the text styles and colors without creating an instance of the class |

---

## Notes & Issues

* **Modular Design:**
  Each activity has its own page folder, keeping the code organized and maintainable. Components like `ActivityCard` and `SongListWidget` are reusable across pages.

* **Audio Handling:**
  All music files are stored in assets. Metadata is read asynchronously using the `audiotags` package. Playback and control is handled via `audioplayers`.

* **Responsive UI Considerations:**
  Although most UI elements have fixed dimensions for simplicity. Some components (like album art in `Activity1`) may need adjustments for smaller screens. This should be updated and fixed.

* **State Management:**
  Stateful widgets handle audio playback and UI updates (e.g., play/pause, song selection, shuffle). Stream subscriptions listen to player events.

* **Hover Effects:**
  `MouseRegion` is used to implement hover effects on songs in the song list (only useful for desktop/web apps).

* **Future Improvements:**

  * Implement responsive layouts for smaller screens (e.g. mobile, tablet).
  * Improve customization (currently static height and opacity).
  * Optimize asset loading and song metadata handling for larger libraries.
  * Use a struct for song list and circular queues to improve music player's interactivity.

