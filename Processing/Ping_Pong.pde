/* VERSIONS:
v1.0 Original: https://www.instructables.com/Pong-With-Processing/
v1.1 Theme setup, roundJoin, color management
v1.2 Retrieve data from arduino and print it in the console, improve align of the score text 
v1.31 Using giro sensor X axis to move up and down. retrieve from Arduino: 7.21 Gyroscope ping pong
v1.32 Solving an error that cannot split() the serial input string, and catch gyroY
*/



import processing.serial.*;
import cc.arduino.*; //need to import library sketch > Import Library > Manage Libararies > Arduino (firmata)
Arduino arduino;
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
String d1= "";


void setup(){
  size(913, 730);
  /////// ! put font here
  
  ball = new Ball(width/2, height/2, 43); //create a new ball to the center of the window
  ball.speedX = 5; // Giving the ball speed in x-axis
  ball.speedY = random(-3,3); // Giving the ball speed in y-axis
  
  paddleLeft = new Paddle(23, height/2, 17, paddleLeftWidth); // paddle size
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

 
  if ( myPort.available() > 0) {          // If data is available,
    val = myPort.readStringUntil('\n');      // read it and store it in val
    //println("val is: " + val); //print it out in the console
    if(val != null && val.length() > 0){   //check if thereis data

      String[] data = splitTokens(val, "\t"); //ver 3
      // String[] data = splitTokens(val, '\t'); //https://forum.processing.org/two/discussion/25600/how-to-split-incoming-data-from-arduino.html
      // String[] aa = {"l","e","d"};
      // String[] baba = splitTokens(val, ",");
      // println("test: " + baba[1]);

      gyroX= int(data[0]);
      gyroY= int(data[1]); // PROBLEM 
      // d1= data[1]; 
      println("X: " + data[0] + "\tY: " + data[1]); 
      // println("X: " + gyroX + "\tY: " + data[1]); //print it out in the console
      // gyroXControl(data[0]); // gyroXControl(gyroX);
      gyroXControl(gyroX); // gyroXControl(gyroX);
      // gyroYControl(data[1]);//gyroYControl(d1);
      gyroYControl(gyroY);//gyroYControl(d1);
    }
    else{
      println("val is " + val); //val is null
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

  if (ball.bottom() > height) {
    ball.speedY = -ball.speedY;}
  if (ball.top() < 0) {
    ball.speedY = -ball.speedY;}
  
  if (paddleLeft.bottom() > height) {
    paddleLeft.y = height-paddleLeft.h/2;}
  if (paddleLeft.top() < 0) {
    paddleLeft.y = paddleLeft.h/2;}

  if (paddleRight.bottom() > height) {
    paddleRight.y = height-paddleRight.h/2;}
  if (paddleRight.top() < 0) {
    paddleRight.y = paddleRight.h/2;}
  
  
  // If the ball gets behind the paddle 
  // AND if the ball is int he area of the paddle (between paddle top and bottom)
  // bounce the ball to other direction

  if ( ball.left() < paddleLeft.right() && ball.y > paddleLeft.top() && ball.y < paddleLeft.bottom()){
    ball.speedX = -ball.speedX;
    ball.speedY = map(ball.y - paddleLeft.y, -paddleLeft.h/2, paddleLeft.h/2, -10, 10);
  }

  if ( ball.right() > paddleRight.left() && ball.y > paddleRight.top() && ball.y < paddleRight.bottom()) {
    ball.speedX = -ball.speedX;
    ball.speedY = map(ball.y - paddleRight.y, -paddleRight.h/2, paddleRight.h/2, -10, 10);
  }  
  
  /////// SCORE TEXT
  textSize(40);
  textAlign(CENTER);
  text(scoreRight, width/2+30, height/13); // Right side score
  text(scoreLeft, width/2-30, height/13); // Left side score
}




///////////////////    CONTROLS   //////////////////////////
void gyroXControl(int gyroX){
  paddleLeft.speedY= (gyroX / 17); //-2 is error compensation of my gyro
  // println("controlling Left: " + paddleLeft.speedY); //print it out in the console
}
void gyroYControl(int gyroY){ //!String
  // gyroY = int(SgyroY);
  // gyroY = Integer.parseInt(SgyroY);
  println("gyroY: " + gyroY); //print it out in the console
  paddleLeftWidth = height*(gyroY/1); //*(gyroY/10);
  // paddleLeft.speedY= ((gyroY-2) / 17); //-2 is error compensation of my gyro
}

////// KEY PRESS /////////////
void keyPressed(){
  if(keyCode == UP){
    paddleRight.speedY=-3;
  }
  if(keyCode == DOWN){
    paddleRight.speedY=3;
  }
}

void keyReleased(){
  if(keyCode == UP){
    paddleRight.speedY=0;
  }
  if(keyCode == DOWN){
    paddleRight.speedY=0;
  }
}




/////////////////////  BALL //////////////////
class Ball {
  float x;
  float y;
  float speedX;
  float speedY;
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
