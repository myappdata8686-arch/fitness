# Athletic OS (Flutter MVP)

Version 1 architecture scaffold for a deterministic wellness operating system.

## What you have now
This repository is a **starter architecture** for your app, not a fully wired production app yet.

It already includes:
- Flutter project structure in `lib/`
- Riverpod state management setup
- Firebase package dependencies (`firebase_core`, `firebase_auth`, `cloud_firestore`)
- Dark theme with emerald accent
- Bottom navigation with the 5 required modules
- Physical module tabs (Today, Week, Metrics, Journey)
- Deterministic domain logic (`PhysicalEngine`) for:
  - day-color assignment (Red / Yellow / Green)
  - checklist protocol selection by phase + color
  - phase transition rules
  - weekly integrity scoring
- Firestore collection constants and a repository contract/implementation for daily logs

---

## 1) Install required tools
You need these on your machine:
- Flutter SDK (stable)
- Dart SDK (bundled with Flutter)
- Android Studio and/or Xcode (for emulator/device)
- Firebase CLI
- FlutterFire CLI

Quick checks:

```bash
flutter --version
flutter doctor
dart --version
firebase --version
flutterfire --version
```

---

## 2) Get packages
From repo root:

```bash
flutter pub get
```

---

## 3) Create Firebase project and attach app

1. Create a Firebase project (console.firebase.google.com).
2. Enable:
   - Authentication
   - Cloud Firestore
3. Register your Flutter apps (Android/iOS).
4. From repo root, configure FlutterFire:

```bash
flutterfire configure
```

This generates `firebase_options.dart`.

Then update `lib/main.dart` to initialize Firebase before running app:

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

(You’ll also import `firebase_core` and generated `firebase_options.dart`.)

---

## 4) Run the app

```bash
flutter run
```

Choose an emulator/simulator/device.

---

## 5) How to use the current code structure

### App shell
- `lib/main.dart`: app entry point + Riverpod `ProviderScope`
- `lib/src/app/athletic_os_app.dart`: `MaterialApp` + theme + root screen
- `lib/src/features/home/presentation/root_scaffold.dart`: bottom navigation

### Theme
- `lib/src/core/theme/app_theme.dart`

### Features
Each feature is split by concern:
- `domain/` → pure deterministic rules/models
- `application/` → providers/controllers/use-cases
- `data/` → repository + Firestore mapping
- `presentation/` → widgets/screens

### Physical deterministic engine
- `lib/src/features/physical/domain/physical_engine.dart`

Use this pattern for future logic so behavior remains predictable and testable.

---

## 6) What to implement next (incremental plan)

### Step A: Wire real auth user
- Add sign-in flow (email/password or anonymous)
- Replace `demo-user` with `FirebaseAuth.instance.currentUser!.uid`

### Step B: Persist/read real data
- Expand repositories for:
  - weekly summaries
  - metrics
  - spiritual logs
  - self-care logs
- Bind UI to Firestore streams/providers

### Step C: Compute weekly engine outputs
- Use `PhysicalEngine` with weekly logs to calculate integrity + success
- Store result in `weekly_summary`

### Step D: Implement phase/credit updates
- Apply phase rules from domain to current user state
- Persist phase progression and credits in Firestore

### Step E: Add tests for deterministic rules
- Unit test `evaluateColor`
- Unit test `resolveNextPhase`
- Unit test `calculateWeeklyIntegrity`

---

## 7) Firestore collections expected
Defined in `lib/src/features/shared/data/firestore_collections.dart`:
- `users`
- `daily_logs`
- `weekly_summary`
- `physical_metrics`
- `spiritual_logs`
- `selfcare_logs`
- `credits`

---

## 8) MVP scope guardrails
Keep V1 strict:
- No cinematic animation
- No avatar system
- No AI mentor
- No immersive mode
- Focus on deterministic functional architecture only

