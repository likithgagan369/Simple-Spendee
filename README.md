<<<<<<< HEAD
# 💸 SPENDIX — Smart Expense Tracker

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white"/>
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge"/>
</p>

> A **crazy neon-themed** smart expense tracker built with Flutter — track your spending, visualize weekly trends, and manage budgets in style. 🚀

---

## ✨ Features

| Feature | Description |
|---|---|
| 💥 **Add Expenses** | Track expenses with title, amount, category, date, and notes |
| 📊 **Weekly Bar Chart** | 7-day spending visualization with today/peak/avg stats |
| 🥧 **Category Breakdown** | Pie chart + bar breakdown of spending by category |
| 💰 **Budget Tracking** | Monthly budget with animated progress indicator |
| 🔍 **Search & Filter** | Filter by category, search by name |
| 🗑️ **Swipe to Delete** | Slidable delete on expense items |
| 💾 **Persistent Storage** | All data saved locally via SharedPreferences |
| 🎨 **Crazy UI** | Neon-punk dark theme with gradient accents |

---

## 📱 Screenshots

> Dashboard · Analytics · All Expenses · Settings

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- Android Studio / VS Code
- An Android device or emulator (min SDK 21)

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/YOUR_USERNAME/smart_expense_tracker.git

# 2. Navigate into the project
cd smart_expense_tracker

# 3. Get dependencies
flutter pub get

# 4. Run on device/emulator
flutter run
```

### Build APK

```bash
# Debug APK (fast, for testing)
flutter build apk --debug

# Release APK (optimized)
flutter build apk --release

# Split APKs by ABI (smaller file sizes)
flutter build apk --split-per-abi
```

APK output location: `build/app/outputs/flutter-apk/`

---

## 📦 Tech Stack

- **State Management** — Provider
- **Charts** — fl_chart
- **Storage** — shared_preferences
- **UI** — curved_navigation_bar, flutter_slidable, flutter_staggered_animations
- **Fonts** — google_fonts (Space Grotesk + Rajdhani + Space Mono)
- **IDs** — uuid

---

## 🗂️ Project Structure

```
lib/
├── main.dart                  # App entry point + navigation
├── models/
│   ├── expense.dart           # Expense model + categories
│   └── budget.dart            # Budget model
├── providers/
│   └── expense_provider.dart  # State management
├── screens/
│   ├── home_screen.dart       # Dashboard
│   ├── add_expense_screen.dart
│   ├── analytics_screen.dart
│   ├── all_expenses_screen.dart
│   └── settings_screen.dart
├── widgets/
│   ├── weekly_bar_chart.dart
│   ├── category_pie_chart.dart
│   ├── budget_progress_card.dart
│   └── expense_list_item.dart
└── utils/
    ├── theme.dart             # Neon color palette + styles
    └── formatters.dart        # Currency + date formatters
```

---

## 🎨 Color Palette

| Color | Hex | Usage |
|---|---|---|
| Neon Pink | `#FF2D78` | Primary accent, FAB |
| Neon Cyan | `#00F5FF` | Secondary accent |
| Neon Yellow | `#FFE600` | Warnings |
| Neon Green | `#39FF14` | Success / health |
| Neon Purple | `#BF00FF` | Charts |
| Dark BG | `#0A0A0F` | Background |

---

## 📄 License

MIT License — feel free to use, modify, and distribute.

---

<p align="center">Made with 💙 and way too much neon</p>
=======
# Simple-Spendee
A simple and user-friendly Flutter-based Expense Tracker application to manage daily income and expenses efficiently. The app provides transaction management, category-wise analysis, balance tracking, and weekly financial insights with an attractive UI.
>>>>>>> 048caaa38f64211444496fe2c4b3bbcb567b08c5
