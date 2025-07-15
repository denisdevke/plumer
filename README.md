<a href="https://coff.ee/denisdevke" target="_blank">
  <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" width="300" alt="Buy Me A Coffee">
</a>

# 🪶 Plumer

**Your Flutter Artisan for GetX and Dio.**

Plumer is a **zero-config CLI for Flutter + GetX + Dio** that **automates repetitive scaffolding**, letting you focus on building features, not boilerplate.

✨ Auto-generate **controllers, bindings, screens, and widgets**  
✨ Simplify **Dio API requests with auto-injection into controllers**  
✨ Auto-register **routes in your app** and sync with **Laravel backend**  
✨ Install reusable **widgets effortlessly**  
✨ Keep your Flutter project **clean, scalable, and consistent**

---

## 🚀 Why Plumer?

Plumer brings **Laravel's `artisan` productivity** to Flutter + GetX + Dio.

✅ Generate **controllers, bindings, screens, widgets** instantly  
✅ Auto-register **routes** in your Flutter app  
✅ Sync routes with **Laravel backend**  
✅ Generate **Dio API methods with clean structure**  
✅ Quickly install **widgets and reusable UI components**  
✅ Maintain **clean, organized architecture** in your Flutter projects

---

## ✨ Features

✅ Auto-generate **controllers, bindings, screens, widgets**  
✅ Auto-register **routes in `lib/config/app_routes.dart`**  
✅ Supports **nested folder structures** (`booking/flight`)  
✅ Prevents accidental overwrites with **atomic safety checks**  
✅ Checks for **Flutter project validity before running**  
✅ Inspired by `artisan` for clear, intuitive commands:

- `make:controller`
- `make:binding`
- `make:screen`
- `make:page`

---

## 📦 Installation

1️⃣ Navigate to your **Flutter project root**:

```bash
cd your_flutter_project
```

2️⃣ Download Plumer:

```bash
wget https://raw.githubusercontent.com/denisdevke/plumer/main/plumer -O plumer
```

3️⃣ Make it executable:

```bash
chmod +x plumer
```

4️⃣ *(Optional)* Add an alias for global access:

```bash
alias plumer="dart $(pwd)/plumer"
```

---

## ⚡ Usage

### Generate a Controller

```bash
plumer make:controller Booking/Flight
```

✅ Creates:

- `lib/controllers/booking/flight_controller.dart`

---

### Generate a Binding

```bash
plumer make:binding Booking/Flight
```

✅ Creates:

- `lib/bindings/booking/flight_binding.dart`

---

### Generate a Screen

```bash
plumer make:screen Booking/Flight
```

✅ Creates:

- `lib/screens/booking/flight_screen.dart`

---

### Generate a Full Page (Controller + Binding + Screen + Auto Route)

```bash
plumer make:page Booking/Flight
```

✅ Creates:
- `lib/controllers/booking/flight_controller.dart`
- `lib/bindings/booking/flight_binding.dart`
- `lib/screens/booking/flight_screen.dart`

✅ Auto-registers the route in `lib/config/app_routes.dart`:

```dart
GetPage(
  name: '/booking/flight',
  page: () => const FlightScreen(),
  binding: FlightBinding(),
),
```

---

## 📂 Folder Structure Conventions

Plumer adheres to **clean architecture conventions**:

- **Controllers:** `lib/controllers/...`
- **Bindings:** `lib/bindings/...`
- **Screens:** `lib/screens/...`
- **Widgets:** `lib/widgets/...` (upcoming)

**Naming:**
- **snake_case** for files
- **PascalCase** for classes

**Example:**

Input:
```
booking/flight
```
Output:
- `FlightController`
- `FlightBinding`
- `FlightScreen`  
in their respective folders.

---

## 🛡️ Safety & Atomicity

✅ Plumer checks for **existing files and routes** before generation.  
✅ If any conflicts are found, Plumer **aborts gracefully** to prevent partial generation or structure corruption.  
✅ Ensures **clean, atomic operations** during scaffolding.

---

## 🛠️ Upcoming Features

🚧 `plumer make:model` – Auto-generate clean data models  
🚧 `plumer install:widget Button/Primary` – Scaffold reusable widgets instantly  
🚧 `plumer api:generate` – Generate Dio API methods with request/response structure  
🚧 `plumer route:sync` – Sync routes from Laravel backend into Flutter dynamically  
🚧 `plumer test:generate` – Scaffold unit and widget test files for controllers and screens

---

## ❤️ Contributing

Contributions are welcome!

✨ Want API generation with Dio?  
✨ Need Laravel Sanctum/JWT helpers for your Flutter app?  
✨ Want Flutter widget marketplace integration?

Open an issue or submit a PR to help make Plumer the **ultimate Flutter productivity CLI**.

---

## ☕ Support Development

If Plumer saves you hours, please consider [buying me a coffee](https://coff.ee/denisdevke) to support continued maintenance and new features.

<a href="https://coff.ee/denisdevke" target="_blank">
  <img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" width="200" alt="Buy Me A Coffee">
</a>

---

## 📜 License

**MIT License**

---

**Made with ❤️ to power your Flutter + GetX + Dio development.**

