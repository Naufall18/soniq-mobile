<div align="center">

# Soniq

**Your music, beautifully organized.**

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white)
![Material 3](https://img.shields.io/badge/Material%203-757575?style=flat-square&logo=materialdesign&logoColor=white)
![Platform](https://img.shields.io/badge/Android%20%7C%20iOS-3DDC84?style=flat-square&logo=android&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)

</div>

---

## ✨ Features

- 📝 Create, edit, and delete Song entries with a clean Material 3 UI
- 💾 **Offline-first** — data persists on-device via `shared_preferences`
- 🗂️ Organize by category and filter across dedicated tabs
- 📊 **Insights** tab with a category-breakdown pie chart (`fl_chart`)
- 👆 Swipe-to-delete, tap-to-edit, instant validation
- ⚡ Reactive state with `ChangeNotifier` + `ListenableBuilder`
- 🎨 Dynamic seeded color theme (Material 3)

## 📱 Screenshots

> _Screenshots coming soon._

## 🏗️ Architecture

A small, layered structure that stays easy to test and extend:

```
lib/
├── config.dart              # theme, labels, seed data (single source of truth)
├── models/
│   └── item.dart            # data model (JSON serializable)
├── data/
│   └── repo.dart            # repository + persistence (ChangeNotifier)
├── widgets/
│   ├── item_list.dart       # list + swipe-to-delete
│   ├── item_form.dart       # create / edit form
│   ├── category_chart.dart  # fl_chart pie breakdown
│   └── summary.dart         # insights screen
└── main.dart                # navigation shell
```

| Concern      | Choice                                   |
|--------------|------------------------------------------|
| State        | `ChangeNotifier` + `ListenableBuilder`   |
| Persistence  | `shared_preferences` (JSON)              |
| Charts       | `fl_chart`                               |
| Design       | Material 3, seeded dynamic color         |

## 🚀 Getting Started

```bash
git clone https://github.com/Naufall18/soniq-mobile.git
cd soniq-mobile
flutter pub get
flutter run
```

**Requirements:** Flutter 3.x · Dart 3.x

## 🗺️ Roadmap

- [ ] Cloud sync (Supabase)
- [ ] Search & advanced filters
- [ ] Home-screen widget
- [ ] Unit & widget tests
- [ ] CI (GitHub Actions)

## 📄 License

MIT © [Naufall18](https://github.com/Naufall18)
