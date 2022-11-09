#include <Wire.h>
#include <ADXL345.h>

ADXL345 adxl;
int x, y, z;
double g[3];
int sensorValue = 0;

void setup() {
  Serial.begin(9600);
  adxl.powerOn();
}

void loop() {

  adxl.readXYZ(&x, &y, &z);
  adxl.getAcceleration(g);
  Serial.print(g[0]);Serial.print(" ");
  Serial.print(g[1]);Serial.print(" ");
  Serial.print(g[2]);Serial.print(" ");

  sensorValue = analogRead(A0);
  Serial.print(float(sensorValue));//Serial.print(",");
  
  Serial.println("");
  
  delay(10);
}
