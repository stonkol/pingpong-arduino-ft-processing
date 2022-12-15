/* VERSIONS:
v1.0 Original: https://www.instructables.com/Pong-With-Processing/
v1.1 Theme setup, roundJoin, color management
v1.2 Retrieve data from arduino and print it in the console, improve align of the score text 
v1.31 Using giro sensor X axis to move up and down. retrieve from Arduino: 7.21 Gyroscope ping pong
v1.32 Solving an error that cannot split() the serial input string, and catch gyroY
v1.33 Printing multiple variables in one number 
v1.4 Fixing send multiple parameters
v1.5 Cleaning and minor improvements
*/


import processing.serial.*;
// import cc.arduino.*; //need to import library sketch > Import Library > Manage Libararies > Arduino (firmata)
// Arduino arduino;
Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port


Ball ball; // Define the ball as a global object 
Serial port;
Paddle paddleLeft;
Paddle paddleRight;
float paddleLeftWidth = height *1.7;
float paddleRightWidth = height *1.7;

int theme = 2;
color itemColor = color(87); //https://processing.org/reference/color_.html
color bgColor =  color(227); 
color strokeColor = color(180, 193, 180); 

int scoreLeft = 0;
int scoreRight = 0;
int gyroX = 404;
int gyroY = 404;
// int gyroYBalSpeed = 1;


int intX, intY;
int decX, decY, decZ;
int minusX, minusY, minusZ;
int intVal;
int selectModesY = 0;
float leftSpeedMultiplier = 1;
float leftPaddleWidthMultiplier = 1;


void setup(){
  size(913, 730);
  /////// ! put font here
  
  ball = new Ball(width/2, height/2, 43); //create a new ball to the center of the window
  ball.speedX = 5; // Giving the ball speed in x-axis
  ball.speedY = random(-3,3); ////// Giving the ball speed in y-axis
  
  // paddleLeft = new Paddle; // paddle size
  paddleLeft = new Paddle(23, height/2, 17, paddleLeftWidth *leftPaddleWidthMultiplier); // paddle size
  // paddleLeft = new Paddle(23, height/2, 17, paddleLeftWidth *leftPaddleWidthMultiplier); // paddle size
  paddleRight = new Paddle(width-23, height/2, 17, paddleRightWidth); //!now paddle size is a variable
  
  String portName = Serial.list()[2]; //change the 0 to a 1 or 2 etc. to match your port, check what usbmodem 11[x]01 or run "$ lsof | grep usbmodem" on the treminal
  myPort = new Serial(this, portName, 9600);
}


////////////////// THEME ///////////////////
void themeColor(){
  if (theme == 1) { 
    bgColor = color(22, 2, 33);
    itemColor = color(2,122 ,33);
  }
  else if (theme == 2) {  
    bgColor = color(122, 2, 133);
    itemColor = color(2, 55, 133);
  } 
  else if (theme == 3) {  
    bgColor = color(17);
    itemColor = color(220);
  } else {
    println("set the original");
  }
}


////////////////////////   DRAW   ////////////////////
void draw(){
  background(bgColor);//background(0); //clear canvas
  ball.display(); // Draw the ball to the window
  ball.move(); //calculate a new location for the ball
  ball.display(); // Draw the ball on the window

  paddleLeft.move();
  paddleLeft.display();
  paddleRight.move();
  paddleRight.display();

  // paddleLeft = new Paddle(23, height/2, 17, paddleLeftWidth *leftPaddleWidthMultiplier); // paddle size
  // paddleRight = new Paddle(width-23, height/2, 17, paddleRightWidth *rightPaddleWidthMultiplier); //!now paddle size is a variable

  // paddleLeft = new Paddle(23, height/2, 17, paddleLeftWidth); // paddle size
  // paddleRight = new Paddle(width-23, height/2, 17, paddleRightWidth); //!now paddle size is a variable
  // ball.speedX = 5 *leftSpeedMultiplier; // Giving the ball speed in x-axis
  // ball.speedX = 5; // Giving the ball speed in x-axis
 
  if ( myPort.available() > 0) {          // If data is available,
    val = myPort.readStringUntil('\n');      // read it and store it in val

    //println("val is: " + val); //print it out in the console
    if(val != null && val.length() > 0){   //check if thereis data

      val = trim(val);  // trim the white space off the string:
      intVal = int(val);
      // println("val is " + val + "\tintValue = " + intVal); 

      // String[] data = {"404", "404"};
      // int data[] = int(splitTokens(val, ",")); //ver 3
      // data = splitTokens(val, "\t"); //ver 3
      // String[] data = splitTokens(val, '\t'); //https://forum.processing.org/two/discussion/25600/how-to-split-incoming-data-from-arduino.html


      //============= SERIAL -> VALUES=======-=========//
      //==============================================//
      //  minusX  decX  intX  |   minusY   decY  intY 
      //    1     2      34          5      6     78 
      minusX =  int((intVal /10000000)%10);  // 1
      decX =    int((intVal /1000000) %10);  // 2
      intX =    int((intVal /10000)   %100); // 34
      //---------- ^ X ----- v Y ---------   
      minusY =  int((intVal /1000)    %10);  // 5 
      decY =    int((intVal /100)     %10);  // 6
      intY =    int((intVal /1)       %100); // 78


      //[2]
      // decX = int(decX);
      if (decX == 1) 
        intX = int(0);
      else if (decX == 2) 
        intX = intX /10;
      //[6] ////////////////////////
      if (decY == 1) 
        intY = int(0);
      else if (decY == 2) 
        intY = intY /10;

      /////////// NEGATIVE ////////////
      //[1]
      if (minusX == 1) 
        gyroX = intX * -1;
      else
        gyroX = intX;
      //[5]
      if (minusY == 1) 
        gyroY = intY * -1;
      else
        gyroY = intY;
   
      //////////// -> FUNCTIONS ////////
      println("X: " + gyroX + "\tY: " + gyroY); 
      gyroXControl(gyroX); 
      gyroYControl(gyroY);
    }
    else {
      println("val is " + val); //when val is null
    }
  } 
  delay(17); //58fps
  

  if (ball.right() > width) {
    scoreLeft = scoreLeft + 1;
    ball.x = width/2;
    ball.y = height/2;
  }
  if (ball.left() < 0) {
    scoreRight = scoreRight + 1;
    ball.x = width/2;
    ball.y = height/2;
  }

  // Ball bouncing -> top btm walls
  if (ball.bottom() > height) {
    ball.speedY = -ball.speedY;}
  if (ball.top() < 0) {
    ball.speedY = -ball.speedY;}

  // Paddle limits /////////////////////
  if (paddleLeft.bottom() > height) {
    paddleLeft.y = height-paddleLeft.h/2;}
  if (paddleLeft.top() < 0) {
    paddleLeft.y = paddleLeft.h/2;}

  if (paddleRight.bottom() > height) {
    paddleRight.y = height-paddleRight.h/2;}
  if (paddleRight.top() < 0) {
    paddleRight.y = paddleRight.h/2;}
  

  // If the ball gets behind the paddle AND if the ball is in the area of the paddle (between paddle top and bottom)
  // when ball hits LEFT PADDLE/////////////////////////////////
  if ( ball.left() < paddleLeft.right() && ball.y > paddleLeft.top() && ball.y < paddleLeft.bottom()){
    // ball.speedX = ball.speedX *leftSpeedMultiplier;
     ball.speedX = -ball.speedX;
    ball.speedY = map(ball.y - paddleLeft.y, -paddleLeft.h/2, paddleLeft.h/2, -10, 10);
  }
  // when ball hits RIGHT PADDLE///////////////////////////////
  if ( ball.right() > paddleRight.left() && ball.y > paddleRight.top() && ball.y < paddleRight.bottom()) {
    ball.speedX = -ball.speedX;
    ball.speedY = map(ball.y - paddleRight.y, -paddleRight.h/2, paddleRight.h/2, -10, 10);
  }  
  

  /////////////////// SCORE TEXT /////////////////////
  textSize(40);
  textAlign(CENTER);
  text(scoreRight, width/2+30, height/13); // Right side score
  text(scoreLeft, width/2-30, height/13); // Left side score
}

///////////////////    CONTROLS   //////////////////////////
void gyroXControl(int gyroX){
  paddleLeft.speedY= (gyroX / 1.4); //-2 is error compensation of my gyro
  // println("controlling Left: " + paddleLeft.speedY);
}

void gyroYControl(int gyroY){ // bigger Y-axis -> faster ball -> smaller paddle
  
  // println("gyroY: " + gyroY); //print it out in the console
  // int iSpeed = 0;
 
  // when TAP on the RIGHT side of the arduino
  // if (gyroY < -7){
  //   selectModesY++;
  //   println("ModesY: " + selectModesY); //print it out in the console

  //   if (selectModesY == 1){
  //     leftSpeedMultiplier = 0.75; 
  //     leftPaddleWidthMultiplier = 1.4;       // paddleLeftWidth = height *1.4;
  //     println("wider");
  //   }
  //   if (selectModesY == 2){
  //     leftSpeedMultiplier = 1; 
  //     leftPaddleWidthMultiplier = 1.7; // paddleLeftWidth = height *1.7;
  //     println("DEFAULT");  

  //   }
  //   if (selectModesY == 3){
  //     leftSpeedMultiplier = 1.25; 
  //     leftPaddleWidthMultiplier = 2; // paddleLeftWidth = height *2;
  //     selectModesY = 0;
  //     println("tighter");   
  //   }
    // ball.speedX = gyroY/1; //v2//gyroYBalSpeed Giving the ball speed in y-axis
    // paddleLeftWidth = height * (gyroY/3); //*(gyroY/10);
  // }
  // println("modeY: " + selectModesY);
  // int iTheme;
  // if (gyroY > 5){
  // }
  // ball.speedY = gyroY/7 * (random(-1,1)); //v2//gyroYBalSpeed Giving the ball speed in y-axis
}




//////  KEY PRESS RIGHT PLAYER  /////////////
void keyPressed(){
  if(keyCode == UP){
    paddleRight.speedY=-9;
  }
  if(keyCode == DOWN){
    paddleRight.speedY=9;
  }
}
void keyReleased(){
  if(keyCode == UP || keyCode == DOWN){
    paddleRight.speedY=0;
  }
  // if(keyCode == UP)    paddleRight.speedY=0;
  // if(keyCode == DOWN)  paddleRight.speedY=0;
}




/////////////////////  BALL //////////////////
class Ball {
  float x, y;
  float speedX, speedY;
  float diameter;
  color c;
  
  // Constructor method
  Ball(float tempX, float tempY, float tempDiameter) {
    x = tempX;
    y = tempY;
    diameter = tempDiameter;
    speedX = 0;
    speedY = 0;
    c = itemColor; 
  }
  
  void move() {
    // Add speed to location
    y = y + speedY;
    x = x + speedX;
  }
  
  void display() {
    fill(c); //set the drawing color
    ellipse(x, y,diameter,diameter); //draw a circle
  }
  
  //functions to help with collision detection
  float left(){
    return x-diameter/2;
  }
  float right(){
    return x+diameter/2;
  }
  float top(){
    return y-diameter/2;
  }
  float bottom(){
    return y+diameter/2;
  }
}



/////////////////////  PADDLES  //////////////////
class Paddle{
  float x;
  float y;
  float w;
  float h;
  float speedY;
  float speedX;
  color c;
  
  Paddle(float tempX, float tempY, float tempW, float tempH){
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    speedY = 0;
    speedX = 0;
    c=itemColor;
   
    /// STROKE
    stroke(strokeColor); // stroke(value1, value2, value3, alpha);
    strokeJoin(ROUND);
    strokeWeight(3);  // Default = 4
  }

  void move(){
    y += speedY;
    x += speedX;
  }

  void display(){
    fill(itemColor); //c
    rect(x-w/2,y-h/2,w,h);
  } 
  
  //helper functions
  float left(){
    return x-w/2;
  }
  float right(){
    return x+w/2;
  }
  float top(){
    return y-h/2;
  }
  float bottom(){
    return y+h/2;
  }
}
