import processing.serial.*; //import serial library

Serial myPort;
color itemColor;
color bgColor;
color strokeColor;

Paddle paddleLeft;
Paddle paddleRight;

float paddleLeftWidth;
float paddleRightWidth;

int scoreLeft = 0;
int scoreRight = 0;

Ball ball; // Define the ball as a global object 

void setup() {
  size(1000, 600); //Size of Game Window
  println(height);
  //rectMode(CENTER);
  ellipseMode(CENTER);
  println(Serial.list()); //list serial ports
  myPort = new Serial(this, Serial.list()[2], 9600); //init serial object (picks 1st port available)
  
  itemColor = color(87); //https://processing.org/reference/color_.html
  bgColor =  color(227); 
  strokeColor = color(180, 193, 180); 
  
  ball = new Ball(width/2, height/2, 43); //create a new ball to the center of the window
  ball.speedX = 5; // Giving the ball speed in x-axis
  ball.speedY = random(-3,3); ////// Giving the ball speed in y-axis
  
  float paddleLeftWidth = height *0.4;
  float paddleRightWidth = height *0.4;
  paddleLeft = new Paddle(23, height/2, 17, paddleLeftWidth); // paddle size
  paddleRight = new Paddle(width-23, height/2, 17, paddleRightWidth); //!now paddle size is a variable
}

void draw() {
  // draw new frame
  background(bgColor);//background(0); //clear canvas
  ball.move(); //calculate a new location for the ball
  ball.display(); // Draw the ball on the window
  
  paddleLeft.move();
  paddleLeft.display();
  paddleRight.move();
  paddleRight.display();
  
  // input from arduino
  String val;
  int intVal;
  if ( myPort.available() > 0) {          // If data is available,
    val = myPort.readStringUntil('\n');      // read it and store it in val

    if(val != null && val.length() > 0){   //check if thereis data
      val = trim(val);  // trim the white space off the string:
      int gyro_value = int(val);
      paddleLeft.speed += gyro_value/100;
      println(gyro_value);
    }
  }
  
  // game logic
  if (ball.right() > width) {
    scoreLeft = scoreLeft + 1;
    newBall();
  }
  if (ball.left() < 0) {
    scoreRight = scoreRight + 1;
    newBall();
  }
  

  if (ball.bottom() > height) {
    ball.speedY = -ball.speedY;}
  if (ball.top() < 0) {
    ball.speedY = -ball.speedY;}
  
  if (paddleLeft.bottom() > height) {
    paddleLeft.y = height-paddleLeft.h;}
  if (paddleLeft.top() < 0) {
    paddleLeft.y = 0;}

  if (paddleRight.bottom() > height) {
    paddleRight.y = height-paddleRight.h;}
  if (paddleRight.top() < 0) {
    paddleRight.y = 0;}
  
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
  
  
  /////////// WIN ////////////////
  if (scoreRight > 2 || scoreLeft > 2){
    //stop ball
    ball.speedX = 0; // Giving the ball speed in x-axis
    ball.speedY = 0; ////// Giving the ball speed in y-axis
         
    String lWin = "Left Win!"; 
    String rWin = "Right Win!";
    textSize(130);
    textAlign(CENTER);
    if (scoreLeft > scoreRight){
      text(lWin, width/2, height/3);
    }
    else{
      text(rWin, width/2, height/3);
    }
    delay(1000);
    lWin = " "; 
    rWin = " "; 
       
    scoreLeft = 0;
    scoreRight = 0;
    
    ball.speedX = random(3,6); // Giving the ball speed in x-axis
    ball.speedY = random(-3,3); ////// Giving the ball speed in y-axis
  }
  
  /////// SCORE TEXT
  textSize(40);
  textAlign(CENTER);
  text(scoreRight, width/2+30, height/13); // Right side score
  text(scoreLeft, width/2-30, height/13); // Left side score
  
  delay(7); //58fps
}

void newBall(){
  ball = new Ball(width/2, height/2, 43); //create a new ball to the center of the window
  ball.speedX = random(3,6); // Giving the ball speed in x-axis
  ball.speedY = random(-3,3); ////// Giving the ball speed in y-axis
}

///////////////////    CONTROLS   //////////////////////////


////// KEY PRESS /////////////
void keyPressed(){
  if(keyCode == UP){
    paddleRight.speed=-9;
  }
  if(keyCode == DOWN){
    paddleRight.speed=9;
  }
}

void keyReleased(){
  if(keyCode == UP){
    paddleRight.speed=0;
  }
  if(keyCode == DOWN){
    paddleRight.speed=0;
  }
}
