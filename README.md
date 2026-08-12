# 👗 Rosewe Online Shopping App

Rosewe Online Shopping is a high-performance, feature-rich Flutter application modeled after the premium Rosewe mobile experience. It serves as a one-stop destination for global fashion, offering a balance of comfort and stylish design. The application features a highly interactive UI built with custom widgets and follows a scalable modular architecture.

![App Showcase](assets/images/app_showcase.gif)

## 📱 Features & Core Screens

### 1. ✨ Onboarding & Welcome
*   **Visual Splash Screen**: Clean brand identity presentation upon app launch.
*   **Interactive Welcome**: Seamless entry point for new users with options to Sign In or browse as a guest ("Maybe Later").

### 2. 🔐 Authentication & Session Management
*   **Credentials Flow**: Streamlined Sign In and Create Account pages with custom input styling and visibility toggles.
*   **New Member Perks**: Integrated visual banners highlighting user benefits like "$40 OFF for New Members."
*   **Secure Validation**: Strict field validation for emails and passwords (minimum 6 characters and at least 1 letter).

### 3. 🏠 Smart Home Dashboard
*   **Dynamic Carousels**: Automated swiping banners for seasonal promotions (e.g., "Graceful Shores").
*   **Interactive Grids**: Visual category navigation with high-quality imagery for Swimwear, Tops, Dresses, and more.
*   **Daily Check-in**: A dedicated reward section to encourage daily user engagement and gift redemption.
*   **Tabbed Content**: Quick access to "Best Sellers," "New Arrivals," and specific apparel types using a responsive TabBar.

### 4. 👚 Wardrobe & Category Organizer
*   **Comprehensive Filtering**: Detailed sub-category navigation organized by Type, Style, Trend, and Color.
*   **Expandable Sections**: Clean, accordion-style menus for deep browsing within large categories like Dresses or Swimwear.

### 5. 🛒 My Bag & Favorites
*   **Shopping Bag**: A centralized view for pending purchases with "Start Shopping" calls-to-action for empty states.
*   **Favorites List**: Personalized collection of desired items with integrated "You May Also Like" recommendations.

### 6. 👤 User Profile & Account Settings
*   **Profile Management**: Detailed "Complete Profile" flow capturing gender, birthday, and style preferences via interactive chips.
*   **Global Localizations**: Dedicated selection screens for **Country/Region** (with alphabetical swipe navigation) and **Currency**.
*   **Account Controls**: Integrated flows for password management, contact support, and account deletion reasons.

## 🛠️ Architecture & Tech Stack

The application leverages absolute best practices for Flutter development:

| Component | Library / Framework | Description |
| :--- | :--- | :--- |
| **State Management** | [GetX](https://pub.dev/packages/get) | Reactive state management for high performance and clean dependency injection. |
| **Navigation** | Custom `RouteNavigate` | A centralized utility for controlled screen transitions and context-aware navigation. |
| **Networking** | [Http](https://pub.dev/packages/http) | Standardized API client with a generic `ApiResponse<T>` wrapper for consistent data handling. |
| **UI Kit** | Custom Widgets | A library of reusable GLobal widgets: `BaseScreen`, `CustomButton`, `CustomText`, and `CustomTextField`. |
| **Local Storage** | SharedPreferences & SQLite | Persistence layer for user sessions, local settings, and offline-ready data. |

## 🚀 How to Run the Application

### Prerequisites
*   [Flutter SDK](https://docs.flutter.dev/get-started/install) (Stable Channel)
*   [Android Studio](https://developer.android.com/studio) / VS Code with Flutter extensions
*   Xcode (Required for iOS builds)

### 🤖 Running the Android App
1.  Connect an Android device or start an emulator.
2.  Run the following command from the root directory:
    ```bash
    flutter run
    ```

### 🍎 Running the iOS App
1.  Open the iOS simulator or connect an iPhone.
2.  Install CocoaPods dependencies:
    ```bash
    cd ios && pod install && cd ..
    ```
3.  Launch the app:
    ```bash
    flutter run
    ```

## 📂 Project Structure

```text
.
├── lib/
│   ├── core/           # App-wide logic (Networking, Theme, Utils)
│   ├── features/       # Modular Feature Folders (Home, Profile, Auth)
│   │   └── [feature]/
│   │       ├── controller/   # GetX Business Logic
│   │       ├── data/         # Models & Repositories
│   │       └── presentation/ # UI Screens & Widgets
│   ├── widgets/        # Reusable UI Components
│   ├── models/         # Global Data Classes
│   ├── routes/         # Navigation Management
│   └── main.dart       # App Entry Point
└── assets/             # Images, Fonts (Humanist521), and SVGs
```

## 🔒 Form Validation Logic
All authentication and profile fields implement strict validations:
*   **Email**: Asserts non-empty state and standard email regex matching.
*   **Password**: Enforces a minimum of 6 characters including at least one letter.
*   **Visual Feedback**: Uses `CustomTextField` to show consistent border highlighting and error messaging.

## 📡 API Layer Integration
The project is built with a production-ready networking layer. Repositories use `ApiService.processResponse` to map backend JSON directly into strongly-typed `ApiResponse` objects, ensuring the UI remains robust even during network failures.
