# 📝 Memoa – Notes App

<div align="center">

⚠️ **STILL UNDER DEVELOPMENT** ⚠️

A Flutter-based Notes App designed to help users create, manage, and organize their notes efficiently.  
The project is currently a work in progress, with key features and Firebase integration being implemented gradually.

</div>

---

## 🎨 Design & Prototype

Explore the interactive Figma prototype with full navigation and button interactions:

[![Figma Prototype](https://img.shields.io/badge/Figma-Prototype-F24E1E?style=for-the-badge&logo=figma&logoColor=white)](YOUR_FIGMA_LINK_HERE)

> Click the button above to open the interactive prototype in Figma.

---

## 🎬 App Demo

<div align="center">

![App Demo](screenshots/GIF_APP_UI.gif)

</div>

---

## 📱 Screens

### 🔐 Onboarding & Authentication

| Splash Screen | Welcome Screen | Confirm Guest |
|:---:|:---:|:---:|
| ![Splash](screenshots/1_splash_screen.png) | ![Welcome](screenshots/2_welcome_screen.png) | ![Confirm Guest](screenshots/3_confirm_guest.png) |

| Sign In | Registration | Forget Password |
|:---:|:---:|:---:|
| ![Sign In](screenshots/4_sign_in.png) | ![Registration](screenshots/5_registration.png) | ![Forget Password](screenshots/6_forget_password.png) |

<div align="center">

| Create New Password |
|:---:|
| ![Create New Password](screenshots/7_create_new_password.png) |

</div>

---

### 🏠 Main App

| Home Screen | Sorting Options | Delete Note |
|:---:|:---:|:---:|
| ![Home](screenshots/8_home_screen.png) | ![Sorting](screenshots/9_sorting_option.png) | ![Delete](screenshots/10_delete_note.png) |

| Main Text Screen | Choose Category | New Category |
|:---:|:---:|:---:|
| ![Text Screen](screenshots/11_main_text_screen.png) | ![Category](screenshots/12_choose_category.png) | ![New Category](screenshots/13_new_category.png) |

---

## 🔹 Features (Planned & Partial)

| Status | Feature |
|:---:|---|
| ✅ | User Authentication (Firebase Auth) |
| ✅ | Login with email & password |
| ✅ | Registration (Sign up) |
| ✅ | Guest access option |
| ✅ | Forgot password / Reset password flow |
| ✅ | Create, edit, and delete notes |
| ✅ | Notes categorization (categories/tags) |
| ✅ | Local storage with Hive (for offline persistence) |
| ✅ | Notes listing with basic UI |
| ✅ | Smooth navigation between screens |
| ✅ | Form validation for user inputs |
| 🔜 | Cloud synchronization with Firebase Firestore |

---

## 🛠 Tech Stack

| Technology | Purpose |
|---|---|
| ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white) | Frontend framework |
| ![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white) | Programming language |
| ![Hive](https://img.shields.io/badge/Hive-FF7D00?style=flat&logo=hive&logoColor=white) | Local NoSQL storage |
| ![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat&logo=firebase&logoColor=black) | User authentication |
| ![Material Design](https://img.shields.io/badge/Material_Design-757575?style=flat&logo=material-design&logoColor=white) | UI components |

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

screenshots/
├── GIF_APP_UI.gif
├── 1_splash_screen.png
├── 2_welcome_screen.png
├── 3_confirm_guest.png
├── 4_sign_in.png
├── 5_registration.png
├── 6_forget_password.png
├── 7_create_new_password.png
├── 8_home_screen.png
├── 9_sorting_option.png
├── 10_delete_note.png
├── 11_main_text_screen.png
├── 12_choose_category.png
└── 13_new_category.png
```

---

## 🚧 Contributing

This project is actively under development. Contributions are welcome, but please check issues and ongoing features before making major changes.

---

## 📌 Notes

- Some features are partially implemented.
- Firebase integration is ongoing.
- UI is still evolving and may change.
- Error handling and testing are in progress.

---

## 👤 Author

**Abdelilah Aharcha** – Flutter Developer

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

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
