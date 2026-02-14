# 📝 Notes App

> ⚠️ **STILL UNDER DEVELOPMENT** ⚠️

A **Flutter-based Notes App** designed to help users create, manage, and organize their notes efficiently. The project is currently a work in progress, with key features and Firebase integration being implemented gradually.

---

## 🔹 Features (Planned & Partial)

- **User Authentication (Firebase Auth)**
  - Login with email & password
  - Registration (Sign up)
- Create, edit, and delete notes
- Notes categorization (categories/tags)
- Local storage with **Hive** (for offline persistence)
- Notes listing with basic UI
- Smooth navigation between screens
- Form validation for user inputs
- 🔜 **Future:** Cloud synchronization with Firebase Firestore

---

## 📱 Screens

| Screen | Description |
|---|---|
| Login Screen | Secure authentication |
| Register Screen | Create a new account |
| Notes List Screen | View all notes |
| Note Editor Screen | Add or edit notes |
| Notes Home Screen | Main navigation hub |

> **Note:** Screens are under active development, and UI/UX may change.

---

## 🛠 Tech Stack

| Technology | Purpose |
|---|---|
| Flutter | Frontend framework |
| Dart | Programming language |
| Hive | Local NoSQL storage |
| Firebase Authentication | User login/registration |
| Material Design | UI components |

---

## ⚡ Getting Started

### 1. Clone the repository

```bash
git clone <your-repo-url>
cd notes_app
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Initialize Hive (if not done automatically)

```dart
await Hive.initFlutter();
```

### 4. Run the app

```bash
flutter run
```

> Make sure you have a device/emulator running.

---

## 📁 Project Structure

```
lib/
├── models/          # Note & Category models
├── services/        # Auth & Notes manager services
├── screens/         # All app screens
└── main.dart        # App entry point
```

---

## 🚧 Contributing

This project is actively under development. Contributions are welcome, but please check issues and ongoing features before making major changes.

---

## 📌 Notes

- Some features are **partially implemented**.
- **Firebase integration** is ongoing.
- UI is still evolving and may change.
- Error handling and testing are in progress.

---

## 👤 Author

**French Abdo** – Beginner Flutter developer exploring multi-screen app development and Firebase integration.

---

## 📄 License

This project is for **learning purposes** and is not intended for production use.
