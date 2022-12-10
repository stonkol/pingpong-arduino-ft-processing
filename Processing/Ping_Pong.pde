import processing.serial.*;

/*
version
v1.0 original: https://www.instructables.com/Pong-With-Processing/
v1.1 theme setup, roundJoin, color management
*/

Ball ball; // Define the ball as a global object 
Serial port;
Paddle paddleLeft;
Paddle paddleRight;
color itemColor = color(255, 204, 0); //https://processing.org/reference/color_.html
color bgColor =  color(80, 220, 220); 
color strokeColor = color(180, 120, 180); 
// color stroke = strokeColor; // stroke(value1, value2, value3, alpha);
// char 
// char theme = 'A';
int theme = 0;

int scoreLeft = 0;
int scoreRight = 0;

void setup(){
  size(800,600);
  //port = this({}) ;
  
  ball = new Ball(width/2, height/2, 50); //create a new ball to the center of the window
  ball.speedX = 5; // Giving the ball speed in x-axis
  ball.speedY = random(-3,3); // Giving the ball speed in y-axis
  
  paddleLeft = new Paddle(15, height/2, 30,200);
  paddleRight = new Paddle(width-15, height/2, 30,200);
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
  } else {
    println("set the original");
  }
}


void draw(){
  background(bgColor);//background(0); //clear canvas
  ball.display(); // Draw the ball to the window
  ball.move(); //calculate a new location for the ball
  ball.display(); // Draw the ball on the window
  
  paddleLeft.move();
  paddleLeft.display();
  paddleRight.move();
  paddleRight.display();

  
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
    ball.speedY = -ball.speedY;
  }

  if (ball.top() < 0) {
    ball.speedY = -ball.speedY;
  }
  
  if (paddleLeft.bottom() > height) {
    paddleLeft.y = height-paddleLeft.h/2;
  }

  if (paddleLeft.top() < 0) {
    paddleLeft.y = paddleLeft.h/2;
  }
    
  if (paddleRight.bottom() > height) {
    paddleRight.y = height-paddleRight.h/2;
  }

  if (paddleRight.top() < 0) {
    paddleRight.y = paddleRight.h/2;
  }
  
  
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
  
  
  textSize(40);
  textAlign(CENTER);
  text(scoreRight, width/2+30, 30); // Right side score
  text(scoreLeft, width/2-30, 30); // Left side score
}


//////////////////////////// KEY PRESS /////////////
void keyPressed(){
  if(keyCode == UP){
    paddleRight.speedY=-3;
  }
  if(keyCode == DOWN){
    paddleRight.speedY=3;
  }
  if(key == 'a'){
    paddleLeft.speedY=-3;
  }
  if(key == 'z'){
    paddleLeft.speedY=3;
  }
}

void keyReleased(){
  if(keyCode == UP){
    paddleRight.speedY=0;
  }
  if(keyCode == DOWN){
    paddleRight.speedY=0;
  }
  if(key == 'a'){
    paddleLeft.speedY=0;
  }
  if(key == 'z'){
    paddleLeft.speedY=0;
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
    ellipse(x,y,diameter,diameter); //draw a circle
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
    strokeCap(ROUND);
    strokeJoin(ROUND);
    strokeWeight(5);  // Default = 4
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