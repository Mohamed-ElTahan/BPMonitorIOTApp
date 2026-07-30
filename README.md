# CSBPM - Smart Blood Pressure Monitor (IoT)

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase)
![MQTT](https://img.shields.io/badge/MQTT-3C3C3C?style=for-the-badge&logo=mqtt&logoColor=white)
![ESP32](https://img.shields.io/badge/ESP32-E7352C?style=for-the-badge&logo=espressif&logoColor=white)

CSBPM is a complete IoT health monitoring platform that connects an ESP32-based sensor device to a Flutter mobile app, Firebase backend, and MQTT messaging pipeline. It enables secure, real-time blood pressure and vital sign tracking for Android and iOS.

---

## 🚀 What this project delivers

- **Live vital tracking** with real-time ECG-style graphs, blood pressure, heart rate, and SpO2 monitoring.
- **Cloud persistence** using Firebase Firestore for secure storage and historical analysis.
- **MQTT-powered telemetry** for low-latency device-to-app communication.
- **Modular Flutter architecture** with feature-based separation and Cubit state management.
- **ESP32 firmware** for wireless sensor simulation and MQTT publishing.

---

## 📸 App Screenshots

| Monitor                                             | History                                             |
| --------------------------------------------------- | --------------------------------------------------- |
| ![Monitor Screen](assets/images/monitor_screen.jpg) | ![History Screen](assets/images/history_screen.jpg) |

| Patient Info                                    | About Screen                                    |
| ----------------------------------------------- | ----------------------------------------------- |
| ![Patient Info](assets/images/patient_info.jpg) | ![About Screen](assets/images/about_screen.jpg) |

---

## 🛠 Tech Stack

- **Frontend:** Flutter + Dart
- **State management:** Cubit / BLoC
- **Realtime messaging:** MQTT (HiveMQ)
- **Backend:** Firebase Firestore
- **Device firmware:** ESP32 (Arduino/C++)
- **Platforms:** Android and iOS

---

## 🏗 Architecture

The project follows a **Feature-First modular architecture** to ensure scalability and maintainability:

```text
lib/
├── core/               # Shared services, helpers, theme, and constants
└── features/           # Domain-specific feature modules
    ├── monitor/        # Real-time monitoring UI and data handling
    ├── history/        # Historical readings and charts
    ├── analysis/       # Trend analysis and statistics
    └── about/          # App metadata and credits
```

---

## 🤝 Contribution

This project is built with maintainability in mind. For senior-level contributions:

- Ensure all UI components follow the `AppTheme` patterns.
- Implement state changes via dedicated `Cubits`.
- Maintain granular, atomic commits.

---

## 📄 License

Developed by **Mohamed ElTahan**. All rights reserved.
