/* https://docs.arduino.cc/tutorials/nano-33-ble-sense/imu-gyroscope

v1.4 functions for minus, dec and int, making the serial num always being 8 figures
*/

#include <Arduino_LSM9DS1.h>

void setup() {
  Serial.begin(9600);
  while (!Serial);
  // Serial.println("Started");

  if (!IMU.begin()) {
    Serial.println("Failed to initialize IMU!");
    while (1);
  }
  // Serial.print("Gyroscope sample rate = "); Serial.print(IMU.gyroscopeSampleRate()); Serial.println(" Hz");
  // Serial.println(); 
  // Serial.println("Gyroscope in degrees/second"); Serial.println("X\tY\tZ");

  establishContact(); //See function below
}

void loop() {
  float x, y, z;
  int intX, intY;
  int decX, decY;
  int minusX, minusY;
  int allData;

  if (IMU.gyroscopeAvailable()) {
    IMU.readGyroscope(x, y, z);
   
    
    //[34 78] /////////// mapping to -99~99 ///////////  
    int intX = map(((int)x), -2000, 2000, -99, 99); 
    int intY = map(((int)y), -2000, 2000, -99, 99); 

    /// PRINT ///////
    Serial.print(intX, DEC); 
    Serial.print(","); 
    Serial.println(intY, DEC);  


    ////////////////////////////////////////////////
    /////////////////// ENCODING ///////////////////
    ////////////////////////////////////////////////
    // //[1] 4=error  1 = minus  2 = positive
    // minusX = 4; //4 will be the error, and not let the first num be 0
    // if(intX < 0) {
    //   minusX = 1; 
    //   intX = abs(intX);
    // }else if (intX > -1){
    //   minusX = 2;}

    // //[5]///////////////////////////
    // minusY = 4; //4 will be the error, and not let the first num be 0
    // if (intY < 0) {
    //   minusY = 1; 
    //   intY = abs(intY);
    // }else if (intY > -1){
    //   minusY = 2;}

    // //[2]///////////////////////////
    // decX = 3; //(intX > 10)
    // if (intX == 0){
    //   decX = 1;
    //   intX = 44;
    // }
    // else if ((intX < 10) && (intX > 0)){
    //   decX = 2;
    //   intX = intX *10;
    // }
   
    // //[6]//////////////////////////
    // decY = 3; //(intX > 10)
    // if (intY == 0){
    //   decY = 1;
    //   intY = 44;
    // }
    // else if ((intY < 10) && (intY > 0)){
    //   decY = 2;
    //   intY = intY *10;
    // }


    ////// PRINT (encoded) ///////
    // Serial.print(minusX); 
    // Serial.print(decX); 
    // Serial.print(intX); 

    // Serial.print(minusY); 
    // Serial.print(decY); 
    // Serial.print(intY);   

    // Serial.print('\n');    

    // /// PRINT ///////
    // Serial.print(intX, DEC); 
    // Serial.print(","); 
    // // Serial.print(intY, DEC);   
    // // Serial.print('\n'); 
    // Serial.println(intY, DEC);  

    // // Serial.print(leftPaddle, DEC); //print out on Serial the value of the first sensor
    // Serial.print(",");             //print out on Serial a delimiter
    // // int rightPaddle = analogRead(A1); //save the value from analog sensor as variable leftPaddle
    // Serial.println(rightPaddle, DEC); //print out on Serial the value of the first sensor
    // //print out on Serial the value of the second sensor (but make sure you use Serial.println instead of Serial.print)
    // //If you add additional sensors/buttons make sure you add delimiters between the values and use Serial.println only for the last value
 


    ////// TEST ///////
    // Serial.print("X ->"); 
    // Serial.print(minusX); 
    // Serial.print("\tdecX "); 
    // Serial.print(decX); 
    // Serial.print(" int "); 
    // Serial.print(intX); 

    // Serial.print("\tY ->"); 
    // Serial.print(minusY); 
    // Serial.print("\tdexY "); 
    // Serial.print(decY); 
    // Serial.print(" int "); 
    // Serial.print(intY);     
    // Serial.print("5678"); 
    // Serial.print("123,45"); Serial.print("678"); 
    // Serial.print('\n');    

    ///////// v2 Serial print  ///////// //// ///////// /////////
    // Serial.print(allPacked); //  minusX  decX  intX  |   minusY   decY  intY 
    // Serial.print('\n');      //    1     2      34          5      6     78 
  }
  delay(113);
}

/*
1. Accelerometer range is set at [-4, +4]g -/+0.122 mg.
      -> output data rate is fixed at 104 Hz.
2. Gyroscope range is set at [-2000, +2000] dps +/-70 mdps.
      -> output data rate is fixed at 104 Hz. 
*/


void establishContact() {
  while (Serial.available() <= 0) { //when Arduino receives a Serial message from Processing
    Serial.println("hello");   // send a starting message
    delay(300); //Wait 300 milliseconds
  }
}