# Hacker News Reader

A minimal retro-style Hacker News Reader application built using Flutter and the official Hacker News Firebase APIs.

The app replicates the classic Hacker News experience with a clean lightweight interface, real-time top stories, and nested comments support.

---

# Features

- Fetch Top Stories from Hacker News
- View Story Details
- Read Nested Comments
- Pixel-perfect retro Hacker News UI
- Clean lightweight architecture
- Android support
- Responsive scrolling
- HTML comment rendering
- API-based real-time content

---

# Screenshots

## Home Screen

![Home Screen](assets/screenshots/home.png)

---

## Detail Screen

![Detail Screen](assets/screenshots/detail.png)

---

## Splash Screen

![Splash Screen](assets/screenshots/splash.png)

---

# APK Download

## Google Drive Link

[Download APK Here](https://drive.google.com/drive/folders/13vmHsg4K9VUrG71QpSY-ATsjvI811giU?usp=sharing)

---

# APIs Used

This project uses the official Hacker News Firebase APIs.

## 1. Top Stories API

Used to fetch the list of top story IDs.

```txt
https://hacker-news.firebaseio.com/v0/topstories.json
```

### Example Response

```json
[
  44111431,
  44111420,
  44111399
]
```

---

## 2. Item Details API

Used to fetch:
- Story details
- Comments
- Nested replies

```txt
https://hacker-news.firebaseio.com/v0/item/<id>.json
```

### Example

```txt
https://hacker-news.firebaseio.com/v0/item/8863.json
```

### Example Response

```json
{
  "by": "dhouston",
  "descendants": 71,
  "id": 8863,
  "kids": [9224, 8917, 8884],
  "score": 104,
  "time": 1175714200,
  "title": "My YC app: Dropbox - Throw away your USB drive",
  "type": "story",
  "url": "http://www.getdropbox.com/u/2/screencast.html"
}
```

---

# Application Flow

## Home Screen

1. Fetch top stories IDs
2. Fetch details for each story
3. Display stories in a scrollable list
4. Open detail screen on tap

---

## Detail Screen

1. Fetch selected story details
2. Read `kids` array for comments
3. Fetch comment data recursively
4. Display nested comments

---

# Tech Stack

- Flutter
- Dart
- HTTP Package
- Flutter HTML
- Hacker News Firebase API

---

# Packages Used

```yaml
dependencies:
  http:
  flutter_html:
  timeago:
```

---

# Folder Structure

```txt
lib/
│
├── models/
├── services/
├── screens/
├── widgets/
├── utils/
└── main.dart
```

---

# Installation

## Clone Repository

```bash
git clone YOUR_GITHUB_REPOSITORY_LINK
```

---

## Install Dependencies

```bash
flutter pub get
```

---

## Run Application

```bash
flutter run
```

---

# Launcher Icon

Generated using:

```yaml
flutter_launcher_icons
```

---

# Splash Screen

Custom retro-inspired splash screen matching the Hacker News branding.

---

# Future Improvements

- Infinite scrolling
- Pull to refresh
- Bookmark stories
- WebView integration
- Dark mode
- Search functionality

---

# Author

Developed by YOUR_NAME

---

# License

This project is created for educational and assignment purposes.