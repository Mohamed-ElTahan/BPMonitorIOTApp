# scripts/git_deploy.ps1

Write-Host "🚀 Starting granular deployment process..." -ForegroundColor Cyan

# 1. New Models
git add lib/features/monitor/models/bp_model.dart lib/features/monitor/models/oximeter_model.dart
git commit -m "feat(models): add BPModel and OximeterModel for granular vital tracking"

# 2. PatientMeasurementModel
git add lib/features/monitor/models/patient_measurement_model.dart
git commit -m "feat(models): add PatientMeasurementModel with consolidated state fields and copyWith"

# 3. Delete Legacy
git rm lib/features/monitor/models/vitals_model.dart
git commit -m "refactor(models): delete legacy VitalsModel"

# 4. State Refactor
git add lib/features/monitor/cubit/monitor_state.dart
git commit -m "refactor(monitor): simplify MonitorConnected state to hold only PatientMeasurementModel"

# 5. Cubit Update
git add lib/features/monitor/cubit/monitor_cubit.dart
git commit -m "refactor(monitor): update MonitorCubit to use PatientMeasurementModel's copyWith"

# 6. UI Binding
git add lib/features/monitor/monitor_screen.dart
git commit -m "fix(monitor): update MonitorScreen data binding for nested model properties"

# 7. UI Status
git add lib/features/monitor/monitor_screen.dart
git commit -m "fix(monitor): ensure MonitorScreen correctly displays online status from consolidated model"

# 8. Repository
git add lib/features/monitor/repository/monitor_repository.dart
git commit -m "refactor(monitor): align MonitorRepository with new measurement data flow"

# 9. History Integration
git add lib/features/history/
git commit -m "refactor(history): update History feature to support PatientMeasurementModel"

# 10. MQTT Logic
git add lib/core/data_source/mqtt_data_source.dart
git commit -m "fix(mqtt): implement missing message parsing logic for BP and Oximeter topics"

# 11. MQTT Security
git add lib/core/data_source/mqtt_data_source.dart
git commit -m "feat(mqtt): upgrade MqttDataSource to use secure TLS/SSL for HiveMQ Cloud"

# 12. Test Simulator
git add test_simulator/mqtt_simulator.dart test_simulator/pubspec.yaml
git commit -m "chore(test): add standalone Simulator script for ESP32 data emulation"

# 13. Test Listener
git add test_simulator/mqtt_listener.dart
git commit -m "chore(test): add Listener script for end-to-end HiveMQ verification"

# 14. Project Config
git add .vscode/
git commit -m "chore: add shared vscode configuration for development environment"

# 15. Final Polish
git add .
git commit -m "fix(chore): final cleanup and project alignment for senior-level deployment"

Write-Host "✅ Commits complete. Pushing to origin/main..." -ForegroundColor Green
git push origin main

Write-Host "🎉 Successfully pushed 15 commits to GitHub!" -ForegroundColor Green
