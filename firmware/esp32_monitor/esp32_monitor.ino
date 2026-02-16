#include <WiFi.h>
#include <WebSocketsServer.h>
#include <ArduinoJson.h>
#include <Wire.h>
#include "MAX30105.h"
#include "heartRate.h"

// ------------------- Network Configuration -------------------
const char* ssid = "YOUR_WIFI_SSID";
const char* password = "YOUR_WIFI_PASSWORD";

WebSocketsServer webSocket = WebSocketsServer(81);

// ------------------- Sensor Pins & Objects -------------------
// AD8232 ECG
const int PIN_ECG_OUTPUT = 36; // VP / A0
const int PIN_LO_PLUS = 34;
const int PIN_LO_MINUS = 35;

// MAX30102 SpO2 & HR (I2C)
MAX30105 particleSensor;

// HX710B Blood Pressure (Pressure Sensor, e.g., MPS20N0040D)
// Using bit-banging for HX710B as standard HX711 libs might differ slightly in timing or gain
const int PIN_BP_SCK = 18;
const int PIN_BP_DOUT = 19;

// ------------------- Global Variables -------------------
unsigned long lastBroadcastTime = 0;
const int broadcastInterval = 40; // ~25Hz (adjust for 50Hz if needed, but 25Hz is often enough for UI)

// Simulated BP variables (logic to calculate Sys/Dia from raw pressure requires complex algorithms/inflation)
// We will stream RAW pressure or simulated Sys/Dia for this demo context unless raw waveform is needed.
// The app expects specific int values for Sys/Dia.
double simulatedSys = 120;
double simulatedDia = 80;

void setup() {
  Serial.begin(115200);

  // --- WiFi Setup ---
  WiFi.begin(ssid, password);
  Serial.print("Connecting to WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println();
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());

  // --- WebSocket Setup ---
  webSocket.begin();
  webSocket.onEvent(webSocketEvent);

  // --- Sensor Setup: ECG ---
  pinMode(PIN_LO_PLUS, INPUT);
  pinMode(PIN_LO_MINUS, INPUT);
  pinMode(PIN_ECG_OUTPUT, INPUT);

  // --- Sensor Setup: MAX30102 ---
  if (!particleSensor.begin(Wire, I2C_SPEED_FAST)) {
    Serial.println("MAX30105 was not found. Please check wiring/power. ");
  } else {
    particleSensor.setup(); // Configure sensor with default settings
    particleSensor.setPulseAmplitudeRed(0x0A); // Turn Red LED to low to indicate sensor is running
    particleSensor.setPulseAmplitudeGreen(0); // Turn off Green LED
  }
  
  // --- Sensor Setup: BP (HX710B) ---
  pinMode(PIN_BP_SCK, OUTPUT);
  pinMode(PIN_BP_DOUT, INPUT);
}

void loop() {
  webSocket.loop();

  unsigned long currentTime = millis();
  if (currentTime - lastBroadcastTime >= broadcastInterval) {
    lastBroadcastTime = currentTime;
    broadcastSensorData();
  }
}

void broadcastSensorData() {
  // 1. Read ECG
  float ecgValue = 0;
  if ((digitalRead(PIN_LO_PLUS) == 1) || (digitalRead(PIN_LO_MINUS) == 1)) {
    ecgValue = 0; // Leads off
  } else {
    ecgValue = analogRead(PIN_ECG_OUTPUT);
    // Normalize or map if necessary, sending raw ADC (0-4095) or voltage
    // Map to -2.0 to 2.0 roughly for the chart
    ecgValue = map(ecgValue, 0, 4095, -200, 200) / 100.0; 
  }

  // 2. Read SpO2 / HR (Simplified)
  // Note: Real SpO2 calculation requires complex buffering and signal processing.
  // For this simplified firmware, we read IR value and simulate/pass simple data.
  // Use a library like 'MAX30105' properly with buffer for real implementation.
  long irValue = particleSensor.getIR();
  double heartRate = 0;
  double spo2 = 0;
  
  if (checkForBeat(irValue) == true) {
    // We sensed a beat!
    // In a real app, calculate BPM based on delta time between beats
    heartRate = 72; // Placeholder/Last calculated
  }
  // Placeholder values for demo if sensor logic is minimal
  if (irValue > 50000) {
      heartRate = 75 + (rand() % 5);
      spo2 = 98;
  }

  // 3. Read Blood Pressure (Raw)
  // long pressureRaw = readHX710B(); 
  // Conversion to Sys/Dia requires an oscillometric algorithm during cuff deflation.
  // We will send the simulated floating values for the dashboard.
  // Random small fluctuation
  simulatedSys = 120 + (rand() % 3 - 1);
  simulatedDia = 80 + (rand() % 3 - 1);

  // 4. Create JSON
  DynamicJsonDocument doc(256);
  doc["ecg"] = ecgValue;
  doc["spo2"] = spo2;
  doc["heart_rate"] = heartRate;
  doc["systolic_bp"] = simulatedSys;
  doc["diastolic_bp"] = simulatedDia;

  String jsonString;
  serializeJson(doc, jsonString);

  // 5. Broadcast
  webSocket.broadcastTXT(jsonString);
}

void webSocketEvent(uint8_t num, WStype_t type, uint8_t * payload, size_t length) {
  switch(type) {
    case WStype_DISCONNECTED:
      Serial.printf("[%u] Disconnected!\n", num);
      break;
    case WStype_CONNECTED:
      {
        IPAddress ip = webSocket.remoteIP(num);
        Serial.printf("[%u] Connected from %d.%d.%d.%d url: %s\n", num, ip[0], ip[1], ip[2], ip[3], payload);
      }
      break;
    case WStype_TEXT:
      // Handle text messages from client if needed
      break;
  }
}

// Simple blocking read for HX710B (24-bit)
long readHX710B() {
  long count = 0;
  while(digitalRead(PIN_BP_DOUT));
  for(int i=0; i<24; i++) {
    digitalWrite(PIN_BP_SCK, HIGH);
    count = count << 1;
    digitalWrite(PIN_BP_SCK, LOW);
    if(digitalRead(PIN_BP_DOUT)) count++;
  }
  // 25th pulse
  digitalWrite(PIN_BP_SCK, HIGH);
  digitalWrite(PIN_BP_SCK, LOW);
  
  if(count & 0x800000) {
    count |= 0xFF000000;
  }
  return count;
}
