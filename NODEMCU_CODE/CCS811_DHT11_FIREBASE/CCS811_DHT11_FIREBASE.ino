#include <ArduinoJson.h>
#include <ESP8266WiFi.h>
#include <FirebaseArduino.h>
#include "DHT.h"
#include <Wire.h>
#include "SparkFunCCS811.h"

#define DHTPIN 2
#define DHTTYPE DHT11
#define CCS811_ADDR 0x5B
/*IMPORTANT, when assigning your firebase host be sure just to add the uri of the
host not the complete direction*/
#define FIREBASE_HOST ""
#define FIREBASE_AUTH ""
#define WIFI_SSID ""
#define WIFI_PASSWORD ""

CCS811 mySensor(CCS811_ADDR);
DHT dht(DHTPIN, DHTTYPE);

void setup() {
  Serial.begin(9600);
  dht.begin();
  delay(1500);
  Wire.begin();
  CCS811Core::status returnCode = mySensor.begin();
  
  if (returnCode != CCS811Core::SENSOR_SUCCESS){
    Serial.println("CCS811 Failed to begin.");
    while (1);
  }
  
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("connecting");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  
  for (uint8_t t = 4; t > 0; t--) {
    Serial.printf("[SETUP] WAIT %d...\n", t);
    Serial.flush();
    delay(1000);
  }
  
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
}


void loop() {

  DynamicJsonBuffer jsonBuffer;
  
  float h = dht.readHumidity();
  float t = dht.readTemperature();
  float hic = dht.computeHeatIndex(t, h, false);
  
  mySensor.readAlgorithmResults();
  float CO2 = mySensor.getCO2();
  float TVOC = mySensor.getTVOC();
  float MILLI = millis();
  
  if (isnan(h) || isnan(t) || isnan(CO2) || isnan(TVOC) || isnan(MILLI)) {  
    Serial.println("Failed to read from sensors!");
    return;
    }

  if (Firebase.failed()) {
      Serial.print("pushing /logs failed:");
      Serial.println(Firebase.error());
      delay(1500);
      return;
      }

   
   
   Firebase.pushInt("ID", 1);
   Firebase.pushFloat("CO2", CO2);
   Firebase.pushFloat("TVOC", TVOC);
   Firebase.pushFloat("Humidity", h);
   Firebase.pushFloat("Temperature", t);
   Firebase.pushFloat("Heat_Index", hic);
   delay(2000);
}
