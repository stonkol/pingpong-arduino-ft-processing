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
  // int decX, decY, decZ;
  // int minusX, minusY, minusZ;
  // int allPacked;

  if (IMU.gyroscopeAvailable()) {
    IMU.readGyroscope(x, y, z);
    int intX = map(((int)x), -2000, 2000, -99, 99); 
    int intY = map(((int)y), -2000, 2000, -99, 99); 
    // int intX = ((int)x) / 8; //(-255 ~ 255)
    // int intY = ((int)y) / 8;
    // int intZ = (int)z;
    
    // if (intX == 0){
    //   decX = 1;
    // }else if(intX > 0 ){
    //   decX = 2;
    // }else if(intX > 0){
    //   decX = 3;
    // }    


    // v2 Serial print
    // Serial.print(allPacked); // decX decY minusX minusY intX   intY
    // Serial.print('\n');     //   1    2     3      4     5 6    78

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