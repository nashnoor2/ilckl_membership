# Independent Living Centre Kuala Lumpur (ILCKL) Membership System

A modern, secure, and cross-platform mobile application built with Flutter to manage and verify memberships for the **Independent Living Centre Kuala Lumpur**. The system enables members to access their digital profiles, generate unique verification QR codes, upload documents, and export membership details.

---

## 📱 Features

* **Secure Authentication**: Robust user registration, login, and password reset functionalities powered by **Supabase Auth**.
* **Digital Membership Card**: Instantly view membership details, status, and validity with a clean, modern user interface.
* **Dynamic QR Code Verification**: In-app QR code generation representing the member's unique ID for seamless entry and validity checks.
* **Profile Management**: Update user profile information, upload avatars, and manage membership details.
* **PDF Document Generation**: Export membership profile cards and official reports directly to printable PDF format.
* **Local Secure Storage**: Secure caching of credentials and preferences on-device using secure hardware-backed storage.

---

## 🛠️ Tech Stack & Architecture

This project is built using modern Flutter best practices and clean architecture principles:

* **Framework**: [Flutter](https://flutter.dev/) (v3.44.0+)
* **Database & Auth**: [Supabase Flutter SDK](https://supabase.com/)
* **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc) (BLoC Pattern)
* **Routing**: [go_router](https://pub.dev/packages/go_router) for declarative routing and deep linking
* **Validation**: [form_builder_validators](https://pub.dev/packages/form_builder_validators)
* **Storage**: [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) for secure on-device storage
* **PDF Engine**: [pdf](https://pub.dev/packages/pdf) & [printing](https://pub.dev/packages/printing) for report generation and direct printing

---

## 📂 Project Structure

```
lib/
├── core/
│   ├── constants/       # Global constants (e.g. Supabase credentials)
│   └── services/        # App-wide services (Auth, Member, Secure Storage)
├── features/
│   ├── auth/            # Authentication screens (Login, Register, Forgot Password)
│   ├── dashboard/       # Main user dashboard and navigation
│   ├── membership/      # Digital membership card and QR generation
│   └── profile/         # User profile details and uploads
├── routes/              # Navigation router configuration (GoRouter)
└── shared/
    └── models/          # Shared data models (Member data)
```

---

## 🚀 Download & Installation

To install the application on your Android device:

1. Navigate to the [Releases Page](https://github.com/nashnoor2/ilckl_membership/releases).
2. Download the latest **`ilckl_membership_v1.0.0.apk`** file.
3. Open the downloaded file on your device and install (ensure "Install from Unknown Sources" is enabled in your Android settings).

---

## 💻 Developer Setup Guide

### Prerequisites
* Flutter SDK (v3.44.0 or higher)
* Android Studio / VS Code with Flutter extensions
* A Supabase project instance

### Getting Started

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/nashnoor2/ilckl_membership.git
   cd ilckl_membership
   ```

2. **Configure Supabase Credentials**:
   Open [lib/core/constants/supabase_constants.dart](lib/core/constants/supabase_constants.dart) and configure your URL and Anon Key:
   ```dart
   class SupabaseConstants {
     static const url = 'YOUR_SUPABASE_PROJECT_URL';
     static const anonKey = 'YOUR_SUPABASE_ANON_KEY';
   }
   ```

3. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

4. **Run the Application**:
   ```bash
   flutter run
   ```

### Building for Release (Android APK)
To build a production-ready release APK:
```bash
flutter build apk --release
```
The output APK will be generated at `build/app/outputs/flutter-apk/app-release.apk`.
