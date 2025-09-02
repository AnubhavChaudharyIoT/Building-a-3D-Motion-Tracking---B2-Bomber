#include <Wire.h>
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>

Adafruit_MPU6050 mpu;

float accX, accY, accZ;
float gyroX, gyroY, gyroZ;

float velX = 0, velY = 0, velZ = 0;
float posX = 0, posY = 0, posZ = 0;

float roll = 0, pitch = 0, yaw = 0;

unsigned long prevTime = 0;
const float damping = 0.98f;

void setup() {
  Serial.begin(460800);  // Use 460800 baud for high throughput
  Wire.begin(D2, D1);    // SDA, SCL pins for ESP8266 (adjust if different)
  
  if (!mpu.begin()) {
    Serial.println("MPU6050 not connected!");
    while (1) delay(10);
  }

  mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
  mpu.setGyroRange(MPU6050_RANGE_500_DEG);
  mpu.setFilterBandwidth(MPU6050_BAND_21_HZ);

  prevTime = millis();
}

void loop() {
  unsigned long currentTime = millis();
  float dt = (currentTime - prevTime) / 1000.0f;
  prevTime = currentTime;

  sensors_event_t a, g, temp;
  mpu.getEvent(&a, &g, &temp);

  accX = a.acceleration.x;
  accY = a.acceleration.y;
  accZ = a.acceleration.z;

  gyroX = g.gyro.x;
  gyroY = g.gyro.y;
  gyroZ = g.gyro.z;

  // Complementary filter for pitch and roll (degrees)
  float accPitch = atan2(accY, accZ) * 180.0 / PI;
  float accRoll  = atan2(accX, accZ) * 180.0 / PI;

  pitch = 0.98f * (pitch + gyroY * dt * 180.0 / PI) + 0.02f * accPitch;
  roll  = 0.98f * (roll + gyroX * dt * 180.0 / PI) + 0.02f * accRoll;
  yaw  += gyroZ * dt * 180.0 / PI;

  // Integrate acceleration to velocity and position with damping
  velX = (velX + accX * dt) * damping;
  velY = (velY + accY * dt) * damping;
  velZ = (velZ + accZ * dt) * damping;

  posX += velX * dt;
  posY += velY * dt;
  posZ += velZ * dt;

  // Send JSON line over serial (compact)
  Serial.print("{\"posX\":"); Serial.print(posX, 3);
  Serial.print(",\"posY\":"); Serial.print(posY, 3);
  Serial.print(",\"posZ\":"); Serial.print(posZ, 3);
  Serial.print(",\"roll\":"); Serial.print(roll, 2);
  Serial.print(",\"pitch\":"); Serial.print(pitch, 2);
  Serial.print(",\"yaw\":"); Serial.print(yaw, 2);
  Serial.println("}");
  
  delay(10);  // 100 updates/sec approx
}
