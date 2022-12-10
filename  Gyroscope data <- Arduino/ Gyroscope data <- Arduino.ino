/* https://docs.arduino.cc/tutorials/nano-33-ble-sense/imu-gyroscope

1. Accelerometer range is set at [-4, +4]g -/+0.122 mg.
      -> output data rate is fixed at 104 Hz.
2. Gyroscope range is set at [-2000, +2000] dps +/-70 mdps.
      -> output data rate is fixed at 104 Hz. */



//// My expanded official EXAMPLE simple gyroscope ////////
#include <Arduino_LSM9DS1.h>

void setup() {
  Serial.begin(9600);
  while (!Serial);
  Serial.println("Started");

  if (!IMU.begin()) {
    Serial.println("Failed to initialize IMU!");
    while (1);
  }
  // Serial.print("Gyroscope sample rate = "); Serial.print(IMU.gyroscopeSampleRate()); Serial.println(" Hz");
  // Serial.println(); 
  // Serial.println("Gyroscope in degrees/second"); Serial.println("X\tY\tZ");
}

void loop() {
  float x, y, z;

  if (IMU.gyroscopeAvailable()) {
    IMU.readGyroscope(x, y, z);
    int intX = ((int)x)-2; 
    int intY = (int)y;
    // int intZ = (int)z;
    // int intX = ((int)x)/10; 
    // int intY = ((int)y)/10;

    // Print x, y axys in INT
    Serial.print(intX); 
    Serial.print('\t');
    Serial.print(intY); 
    // Serial.print('\t');
    // Serial.print(intZ); 
    Serial.print('\n');

    // Print x, y axys in FLOAT
    // Serial.print(x); Serial.print('\t'); Serial.print(y); Serial.print('\t'); Serial.println(z);
  }
  delay(111);
}