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
git clone https://github.com/ABDOU-AHARCHA/NotesApp_Project_flutter2026
cd NotesApp_Project_flutter2026
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

**Abdelilah Aharcha** – Flutter developer.

---

## 📄 License

This project is licensed under the **MIT License**.

```
MIT License

Copyright (c) 2026 Abdelilah Aharcha

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
