#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <PubSubClient.h>

/* WiFi */
const char* ssid = "MohamedElTahan";
const char* password = "123456789";

/* MQTT */
const char* mqtt_server = "3b21c699ce40469c952aefc80b244ab2.s1.eu.hivemq.cloud";
const int mqtt_port = 8883;
const char* mqtt_user = "bloodPressure";
const char* mqtt_password = "comm-SBPM1";

WiFiClientSecure espClient;
PubSubClient client(espClient);

unsigned long lastMsg = 0;

void setup_wifi() {
  delay(10);
  Serial.println();
  Serial.print("Connecting to WiFi...");

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("\nWiFi connected");
}

void reconnect() {
  while (!client.connected()) {
    Serial.print("Connecting to MQTT...");

    if (client.connect("ESP32Client", mqtt_user, mqtt_password)) {
      Serial.println("connected");
    } else {
      Serial.print("failed, rc=");
      Serial.println(client.state());
      delay(2000);
    }
  }
}

void setup() {
  Serial.begin(115200);
  setup_wifi();

  espClient.setInsecure();   // Important for SSL connection

  client.setServer(mqtt_server, mqtt_port);
}

void loop() {

  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  unsigned long now = millis();

  if (now - lastMsg > 2000) {
    lastMsg = now;

    // Simulate medical data
    String payload = "{\"ecg\":500,\"spo2\":98,\"hr\":72,\"sys\":120,\"dia\":80}";
    client.publish("medical/data", payload.c_str());

    Serial.println("Data Sent:");
    Serial.println(payload);
  }
}
