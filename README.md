# 🦖 Interactive Portfolio - Dino Game Edition

An innovative, interactive portfolio website that combines a Chrome Dino-style side-scroller game with an interactive map visualization. Play the game to reveal resume sections while exploring a synchronized map journey!

---

## 🎮 Overview

This portfolio project showcases a unique approach to presenting professional information through gamification. As you play the classic Dino game, each successful obstacle jump reveals a section of the resume, while an interactive map tracks your progress in real-time.

---

## 🎯 How to Play

1. **Start the Game**: Tap/click anywhere to start
2. **Jump Over Obstacles**: Tap/click to make the dino jump
3. **Reveal Resume Sections**: Each successful jump reveals a new section
4. **Explore the Map**: Watch the map update as you progress
5. **Complete the Journey**: Reach the Contact section to see your score
6. **Continue Playing**: After Contact, continue to build your score!

---

## ✨ Features

### Game Features

- 🦖 **Chrome Dino-Style Gameplay** — Classic endless runner mechanics
- 🎮 **Tap/Click to Jump** — Simple and intuitive controls
- 🌵 **Dynamic Obstacles** — Auto-spawning cacti with collision detection
- 🏃 **Smooth Animations** — Scrolling terrain and character movement
- 📊 **Score System** — Track your progress after completing the journey

### Portfolio Features

- 🗺️ **Interactive Map** — Real-time map visualization synchronized with game progress
- 📄 **Resume Sections** — Six sections revealed progressively:
  - Intro/About Me
  - Education
  - Skills
  - Experience
  - Projects
  - Contact
- 💼 **Project Showcase** — Visual cards with images and descriptions
- 🔗 **Social Links** — Direct links to LinkedIn, GitHub, and Email
- 📱 **Responsive Design** — Works seamlessly on web, mobile, and desktop

### Technical Features

- 🧪 **Comprehensive Tests** — Unit tests for game logic and data validation
- 🎨 **Modern UI** — Material Design with custom overlays
- ⚡ **Performance Optimized** — Efficient rendering and state management
- 🌐 **Multi-Platform** — Web, Android, iOS, macOS, Linux, Windows support

---

## 🛠 Tech Stack

- **Framework**: Flutter 3.16.0+
- **Game Engine**: Flame 1.34.0
- **Maps**: flutter_map 8.2.2
- **State Management**: ValueNotifier
- **Testing**: flutter_test, flame_test 2.2.0
- **Linting**: flutter_lints 6.0.0

---

## 📋 Prerequisites

- Flutter SDK (>=3.16.0)
- Dart SDK (>=3.0.0 <4.0.0)
- Git

---

## 🚀 Getting Started

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/D1vyam29/Portfolio.git
   cd Portfolio
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**

   ```bash
   # For web
   flutter run -d chrome

   # For mobile (iOS/Android)
   flutter run

   # For desktop (macOS/Linux/Windows)
   flutter run -d macos  # or linux/windows
   ```

---

## 🧪 Testing

Run the test suite:

```bash
flutter test
```

The project includes:

- **Game Logic Tests** — Validates game state, jump mechanics, and game over logic
- **Portfolio Data Tests** — Ensures data integrity and structure
- **API Tests** — Verifies Flame testing utilities

---

## 📁 Project Structure

```
lib/
├── data/
│   └── portfolio_data.dart      # Resume data and segments
├── game/
│   ├── components/              # Game components (Dino, Obstacles, Ground)
│   └── dino_game.dart           # Main game logic
├── ui/
│   ├── contact_content.dart     # Contact section UI
│   ├── info_overlay.dart        # Resume section overlays
│   └── portfolio_map_view.dart  # Interactive map view
└── main.dart                    # App entry point

test/
├── game_logic_test.dart         # Game logic unit tests
├── portfolio_data_test.dart     # Data validation tests
└── ...
```

---

## 🌐 Deployment

### Web Deployment

The project is configured for GitHub Pages deployment:

```bash
flutter build web
# Deploy the build/web directory to GitHub Pages
```

### Mobile Deployment

```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release
```

---

## 🔧 Development

### Code Style

The project uses `flutter_lints` for code quality. Run:

```bash
flutter analyze
```

### Updating Dependencies

```bash
# Update to latest compatible versions
flutter pub upgrade

# Update to latest major versions
flutter pub upgrade --major-versions
```

---

## 📝 License

This project is a personal portfolio and is not licensed for commercial use.

---

## 👤 Author

**Divyam Sharma**

- 📧 Email: divyams584@gmail.com
- 💼 LinkedIn: [divyam-sharma-sde](https://www.linkedin.com/in/divyam-sharma-sde/)
- 🐙 GitHub: [@D1vyam29](https://github.com/D1vyam29)

---

## 🙏 Acknowledgments

- Inspired by the classic Chrome Dino game
- Built with [Flame](https://flame-engine.org/) game engine
- Maps powered by [flutter_map](https://pub.dev/packages/flutter_map)

---

## 📈 Version

Current version: **1.0.1** - Features Deployment Test

---

**Enjoy exploring the portfolio! 🎮✨**
