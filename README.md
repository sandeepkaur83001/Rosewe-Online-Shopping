# Flutter Base Project

A production-ready, modular Flutter starter template equipped with essential features and industry-standard architecture.

## 🚀 Features

### 🏗️ Architecture & Core
- **Modular Structure**: Clean separation of concerns into `core`, `widgets`, `features`, `routes`, and `models`.
- **Environment Configuration**: Multi-environment support (Dev, Staging, Prod) via `EnvConfig`.
- **Theming**: Integrated Light, Dark, and System mode support with persistent storage.
- **Dependency Injection**: Pre-configured GetX dependency management.
- **Global Base Screen**: A `BaseScreen` wrapper that handles keyboard dismissal, "No Internet" indicators, and top banners.

### 🌐 Networking
- **ApiService**: Unified HTTP client with automatic header management (Bearer Tokens).
- **Connectivity Handling**: Real-time monitoring of network status with a global UI indicator.
- **Standardized Responses**: Centralized handling for success, error, and unauthorized states.

### 🎨 UI Kit & Components
- **Custom Buttons**: Glossy, Outline, and Social button variants.
- **Custom Text Fields**: Feature-rich inputs with support for password toggles and iOS "Done" toolbar for numeric keyboards.
- **Skeleton Loading**: Integrated `Skeletonizer` for modern shimmer effects.
- **Network Image View**: `CachedNetworkImage` wrapper with built-in shimmer loading.
- **Empty State Widget**: Reusable component for "No Data" or "Error" scenarios.
- **Global Loader**: Stylized, theme-aware progress indicator with custom message support.

### 🛠️ Utilities & Services
- **File Picker Helper**: Unified support for picking Images (PNG/JPG), Videos, and Documents (PDF/DOCX).
- **Permission Service**: Centralized handling for Location, Camera, Photos, and other critical permissions.
- **Validation Mixin**: Reusable logic for Email, Password, and Phone validations.
- **Device Info Util**: Access to app version, build number, and device-specific metadata.
- **String Helper**: Common text manipulations (Capitalize, Mask, Initials, etc.).
- **Debouncer**: Optimization for search-heavy inputs.
- **Local Storage**: Pre-configured `SharedManager` (SharedPreferences) and `DBHelper` (SQLite).

## 📂 Project Structure

```text
lib/
  ├── core/                 # App-wide logic and configuration
  │   ├── constants/        # App and Asset constants
  │   ├── theme/            # Colors and Theme logic
  │   ├── network/          # API, Controllers, DI
  │   ├── services/         # Permissions, Notifications, DB
  │   └── utils/            # Helpers and Mixins
  ├── widgets/              # Reusable UI components
  │   ├── buttons/
  │   ├── inputs/
  │   └── common/
  ├── features/             # Business modules (Home, Auth, etc.)
  ├── models/               # Data classes
  ├── routes/               # Navigation management
  └── main.dart             # Entry point
```

## 🛠️ Getting Started

1. **Clone the project.**
2. **Configure Environments**: Update base URLs in `lib/core/network/env_config.dart`.
3. **Change Bundle ID**: Update package names for Android and iOS.
4. **Install Dependencies**:
   ```bash
   flutter pub get
   ```
5. **Run the App**:
   ```bash
   flutter run
   ```

## 📝 Recent Updates
- Refactored project to Modular Architecture.
- Implemented Environment and Theme services.
- Added Unified File Picker and enhanced Loader UI.
- Integrated Skeletonizer and connectivity monitoring.
