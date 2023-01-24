/////////////////////  PADDLES  //////////////////
class Paddle{
  float x;
  float y;
  float w;
  float h;
  float speed;
  color c;
  
  Paddle(float tempX, float tempY, float tempW, float tempH){
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    speed = 0;
    c = itemColor;
   
    /// STROKE
    stroke(strokeColor); // stroke(value1, value2, value3, alpha);
    strokeJoin(ROUND);
    strokeWeight(3);  // Default = 4
  }

  void move(){
    y += speed;
  }

  void display(){
    fill(itemColor); //c
    rect(x,y,w,h);
  } 
  
  //helper functions
  float left(){
    return x;
  }
  float right(){
    return x+w;
  }
  float top(){
    return y;
  }
  float bottom(){
    return y+h;
  }
};
