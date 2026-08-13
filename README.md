# 👗 Rosewe Online Shopping App

<p align="center">
  <strong>A Premium Fashion Shopping Experience Built with Flutter</strong>
</p>

<p align="center">
  A modern, highly interactive e-commerce application inspired by the Rosewe shopping experience, designed to deliver seamless fashion discovery, personalized shopping, and a smooth checkout journey.
</p>

<p align="center">
  <img src="assets/images/app_showcase.gif" width="280" alt="Rosewe Online Shopping App Showcase">
</p>



---

## ✨ Overview

**Rosewe Online Shopping** is a feature-rich Flutter e-commerce application focused on fashion and lifestyle shopping.

The application combines a visually rich shopping experience with a scalable and maintainable Flutter architecture. It includes everything from onboarding and authentication to product discovery, category browsing, favorites, shopping bags, personalization, localization, and account management.

### 🎯 Key Highlights

* 🛍️ Premium fashion shopping experience
* 🎨 Modern and responsive UI
* ⚡ Smooth animations and interactive components
* 🏠 Dynamic home dashboard
* 👗 Category-based product discovery
* 🔎 Advanced filtering and browsing
* ❤️ Favorites and personalized recommendations
* 🛒 Shopping bag management
* 👤 Complete profile customization
* 🌎 Country, region, and currency selection
* 🔐 Authentication and account management
* 📡 Production-ready API integration
* 🧩 Modular and scalable Flutter architecture

---

# 📱 Core Features

## ✨ 1. Onboarding & Welcome

Create a strong first impression with a clean, brand-focused onboarding experience.

### Features

* Branded splash screen
* Welcome screen with modern visuals
* Sign In entry point
* Create Account flow
* Guest browsing using **"Maybe Later"**
* Smooth navigation between onboarding screens

---

## 🔐 2. Authentication & Session Management

A complete authentication experience designed around simplicity and usability.

### Features

* Sign In
* Create Account
* Password visibility toggle
* Email validation
* Password validation
* Session persistence
* New-member promotional banner
* "$40 OFF for New Members" promotional messaging
* Form-level error handling
* Secure logout flow

### Validation Rules

| Field           | Validation                       |
| --------------- | -------------------------------- |
| Email           | Required + valid email format    |
| Password        | Minimum 6 characters             |
| Password        | Must contain at least one letter |
| Required fields | Cannot be empty                  |

---

# 🏠 3. Smart Home Dashboard

The home screen acts as the central shopping hub and provides quick access to products, categories, promotions, and recommendations.

### 🎞️ Promotional Carousel

* Auto-scrolling promotional banners
* Seasonal campaigns
* Interactive page indicators
* Smooth swipe gestures
* Promotional content such as **"Graceful Shores"**

### 👚 Fashion Categories

Quick-access category cards for:

* Swimwear
* Tops
* Dresses
* Bottoms
* Accessories
* Trending collections
* And more

### 🎁 Daily Check-In

Encourage daily engagement through:

* Daily rewards
* Gift redemption
* Check-in interactions
* Reward-focused UI

### 🔥 Product Collections

Tabbed product discovery with sections such as:

* Best Sellers
* New Arrivals
* Trending
* Dresses
* Tops
* Swimwear

---

# 👗 4. Wardrobe & Category Explorer

A structured browsing experience makes it easy to discover products across a large fashion catalog.

### 🧭 Category Organization

Products can be explored through multiple dimensions:

* **Type**
* **Style**
* **Trend**
* **Color**

### 📂 Expandable Categories

Accordion-style navigation allows users to expand and collapse large collections such as:

```text
Dresses
├── Mini Dresses
├── Midi Dresses
├── Maxi Dresses
├── Bodycon Dresses
└── Casual Dresses

Swimwear
├── Bikinis
├── One Piece
├── Cover Ups
└── Beachwear
```

This keeps the browsing experience clean while supporting a large product catalog.

---

# ❤️ 5. Favorites & Shopping Bag

## ❤️ Favorites

Users can save products they love and return to them later.

Features include:

* Add/remove favorites
* Favorites collection
* Product recommendations
* "You May Also Like" section
* Personalized shopping experience

## 🛒 Shopping Bag

A dedicated shopping bag provides a centralized place for selected products.

### Empty State

When the bag is empty, users receive a clear call-to-action:

> **Start Shopping**

This creates a direct path back into product discovery.

---

# 👤 6. Profile & Account Management

A complete profile experience allows users to personalize their shopping journey.

### Profile Information

Users can manage:

* Gender
* Birthday
* Style preferences
* Personal information

### 🎨 Style Preferences

Interactive chips allow users to select preferred styles and fashion categories.

### ⚙️ Account Management

Includes:

* Change Password
* Contact Support
* Logout
* Account Deletion
* Account deletion reason selection
* Profile completion

---

# 🌎 7. Global Localization

The application is designed for a global shopping audience.

### 🌍 Country & Region

Users can select their country or region through an alphabetically organized selection screen.

Features include:

* A–Z navigation
* Alphabetical country grouping
* Fast scrolling
* Search-friendly structure

Example:

```text
A
├── Albania
├── Algeria
├── Andorra
├── Australia
└── Austria

B
├── Bangladesh
├── Belgium
├── Bhutan
└── Brazil
```

### 💱 Currency

Users can select their preferred shopping currency from a dedicated currency-selection experience.

---

# 🏗️ Architecture

The project follows a **modular and scalable Flutter architecture** designed to keep business logic, data handling, navigation, and presentation layers organized.

```text
lib/
│
├── core/
│   ├── network/
│   ├── theme/
│   ├── utils/
│   └── constants/
│
├── features/
│   │
│   ├── auth/
│   │   ├── controller/
│   │   ├── data/
│   │   └── presentation/
│   │
│   ├── home/
│   │   ├── controller/
│   │   ├── data/
│   │   └── presentation/
│   │
│   ├── category/
│   │   ├── controller/
│   │   ├── data/
│   │   └── presentation/
│   │
│   └── profile/
│       ├── controller/
│       ├── data/
│       └── presentation/
│
├── models/
├── widgets/
├── routes/
│
└── main.dart
```

### 🧩 Feature-Based Structure

Each major application feature is isolated into its own module.

```text
Feature
│
├── controller
│   └── Business & UI State
│
├── data
│   ├── Models
│   └── Repositories
│
└── presentation
    ├── Screens
    └── Widgets
```

This makes the application easier to:

* Maintain
* Test
* Scale
* Debug
* Extend with new features

---

# 🛠️ Technology Stack

| Layer            | Technology             | Purpose                                          |
| ---------------- | ---------------------- | ------------------------------------------------ |
| Framework        | Flutter                | Cross-platform application development           |
| Language         | Dart                   | Application programming                          |
| State Management | GetX                   | Reactive state management & dependency injection |
| Navigation       | Custom `RouteNavigate` | Centralized navigation                           |
| Networking       | HTTP                   | REST API communication                           |
| API Handling     | `ApiResponse<T>`       | Strongly typed response handling                 |
| Local Storage    | SharedPreferences      | User preferences & session data                  |
| Database         | SQLite                 | Local/offline data persistence                   |
| UI               | Custom Widgets         | Consistent reusable interface                    |
| Assets           | PNG / SVG / Fonts      | Branding & visual experience                     |

---

# 🎨 Custom UI System

The project uses reusable custom components to maintain a consistent design language across the application.

### Global Components

```text
BaseScreen
CustomButton
CustomText
CustomTextField
CustomAppBar
CustomImage
```

Benefits include:

* Consistent styling
* Reduced duplicate code
* Faster feature development
* Easier global UI updates
* Better maintainability

---

# 📡 API Architecture

The application uses a centralized networking layer to communicate with backend services.

API responses are processed through:

```dart
ApiService.processResponse()
```

Responses are mapped into strongly typed models using:

```dart
ApiResponse<T>
```

### Request Flow

```text
UI
 │
 ▼
GetX Controller
 │
 ▼
Repository
 │
 ▼
ApiService
 │
 ▼
REST API
 │
 ▼
ApiResponse<T>
 │
 ▼
Model
 │
 ▼
Controller State
 │
 ▼
UI Update
```

This approach keeps API logic separated from presentation code and makes error handling more consistent.

---

# 💾 Local Storage

The application uses local persistence for information that needs to survive app restarts.

### SharedPreferences

Used for:

* Authentication/session information
* User preferences
* Local settings
* Application state

### SQLite

Used for:

* Structured local data
* Offline-ready information
* Persistent application records

---

# 🔒 Security & Validation

The application provides consistent validation across authentication and profile forms.

### Email

```text
Required
      ↓
Email format validation
      ↓
Valid / Invalid
```

### Password

```text
Required
      ↓
Minimum 6 characters
      ↓
At least 1 letter
      ↓
Valid / Invalid
```

### UI Feedback

Validation errors are presented directly through reusable `CustomTextField` components with:

* Error messages
* Border state changes
* Input feedback
* Consistent styling

---

# 📂 Project Structure

```text
rosewe_online_shopping/
│
├── android/
├── ios/
├── assets/
│   ├── images/
│   ├── fonts/
│   └── svg/
│
├── lib/
│   ├── core/
│   ├── features/
│   ├── models/
│   ├── widgets/
│   ├── routes/
│   └── main.dart
│
├── test/
│
├── pubspec.yaml
└── README.md
```

---

# 🚀 Getting Started

## Prerequisites

Make sure the following tools are installed:

* Flutter SDK — Stable channel
* Dart SDK
* Android Studio
* VS Code with Flutter extensions
* Xcode for iOS development
* CocoaPods for iOS dependencies

Check your Flutter environment:

```bash
flutter doctor
```

---

# 🤖 Run on Android

### 1. Connect a device or start an emulator

```bash
flutter devices
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Run the application

```bash
flutter run
```

---

# 🍎 Run on iOS

### 1. Install Flutter dependencies

```bash
flutter pub get
```

### 2. Install CocoaPods dependencies

```bash
cd ios
pod install
cd ..
```

### 3. Run the application

```bash
flutter run
```

For iOS development, ensure that Xcode and the required signing/provisioning configuration are properly configured.

---

# 🧪 Development & Quality

Before creating a release build, it is recommended to run:

```bash
flutter analyze
```

and:

```bash
flutter test
```

You can also verify the complete Flutter environment with:

```bash
flutter doctor
```

---

# 📱 Supported Platforms

| Platform   | Support |
| ---------- | ------- |
| 🤖 Android | ✅       |
| 🍎 iOS     | ✅       |

The Flutter architecture also allows the project to be extended to additional platforms when required.

---

# 🗺️ Feature Flow

```text
Splash
   │
   ▼
Welcome
   │
   ├──────────────► Sign In
   │                   │
   │                   ▼
   │                Home
   │
   └──────────────► Maybe Later
                       │
                       ▼
                     Home
                       │
        ┌──────────────┼──────────────┐
        ▼              ▼              ▼
     Categories     Favorites       Profile
        │              │              │
        ▼              ▼              ▼
     Products       My Bag       Preferences
        │
        ▼
   Product Details
        │
        ▼
    Shopping Bag
```

---

# 🎯 Design Philosophy

The application focuses on three core principles:

### ✨ Visual First

Fashion shopping should feel inspiring. The UI emphasizes high-quality imagery, promotional content, animations, and intuitive navigation.

### ⚡ Fast & Responsive

Interactive components, reactive state management, and reusable widgets help deliver a smooth shopping experience.

### 🧩 Scalable Architecture

Feature-based organization and centralized services make it easier to introduce new functionality without affecting unrelated parts of the application.


# 👨‍💻 Development

Built with ❤️ using **Flutter & Dart**.

The project follows reusable component patterns, modular feature organization, centralized API handling, and reactive state management to provide a maintainable foundation for a modern fashion-commerce application.

---

<p align="center">
  <strong>👗 Rosewe Online Shopping</strong>
  <br>
  <sub>Discover. Style. Shop.</sub>
</p>
