# CSBPM - Smart Blood Pressure Monitor (IoT)

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase)
![MQTT](https://img.shields.io/badge/MQTT-3C3C3C?style=for-the-badge&logo=mqtt&logoColor=white)
![ESP32](https://img.shields.io/badge/ESP32-E7352C?style=for-the-badge&logo=espressif&logoColor=white)

CSBPM is a professional-grade IoT ecosystem designed for real-time cardiovascular health monitoring. The system integrates hardware (ESP32), cloud messaging (MQTT), and backend persistence (Firebase) into a unified, high-performance mobile application (Android & iOS).

---

## 🚀 Key Features

- **Real-time Monitoring**: Live ECG and vital signs visualization using high-performance charting.
- **Data Persistence**: Automated batching and synchronization with Google Firestore.
- **Smart Analysis**: Statistical aggregation of heart rate, SpO2, and blood pressure trends.
- **Hardware Integration**: Dedicated ESP32 firmware for medical sensor simulation and data transmission.
- **Thematic Consistency**: Full light-theme support with a centralized design system.

---

## 🛠 Tech Stack

- **Frontend**: Flutter (Mobile Only: Android & iOS)
- **State Management**: BLoC / Cubit (Event-driven architecture)
- **Communication**: MQTT (HiveMQ Broker) with SSL/TLS encryption.
- **Backend**: Firebase Firestore & Core services.
- **Hardware**: ESP32 (C++/Arduino) using `PubSubClient` and `WiFiClientSecure`.

---

## 🏗 Architecture

The project follows a **Feature-First modular architecture** to ensure scalability and maintainability:

```text
lib/
├── core/               # Shared services, constants, and themes
│   ├── services/       # MQTT and Firebase implementations
│   └── theme/          # Centralized AppTheme and AppColors
└── features/           # Domain-specific modules
    ├── monitor/        # Real-time data visualization
    ├── history/        # Historical data fetching and display
    ├── analysis/       # Statistical data processing
    └── about/          # Application metadata
```

---

## 📡 Getting Started

### Prerequisites

- Flutter SDK (Latest Stable)
- Android Studio / VS Code
- Firebase Project (google-services.json required)
- HiveMQ Cloud Cluster

### Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/Mohamed-ElTahan/BPMonitorIOTApp.git
   ```

2. **Install dependencies**:

   ```bash
   flutter pub get
   ```

3. **Configure Constants**:
   Update `lib/core/constants/app_constants.dart` with your specific MQTT and Firebase credentials.

4. **Run the app**:
   ```bash
   flutter run
   ```

---

## 🔌 Hardware Setup (ESP32)

A dedicated firmware is provided in `esp32_firmware/esp32_firmware.ino`.

1. Open the file in **Arduino IDE**.
2. Install the `PubSubClient` library.
3. Update specific WiFi/MQTT credentials in the code.
4. Upload to your ESP32 board.
5. Watch real-time vitals flow into the CSBPM app!

---

## 🤝 Contribution

This project is built with maintainability in mind. For senior-level contributions:

- Ensure all UI components follow the `AppTheme` patterns.
- Implement state changes via dedicated `Cubits`.
- Maintain granular, atomic commits.

---

## 📄 License

Developed by **Mohamed ElTahan**. All rights reserved.
