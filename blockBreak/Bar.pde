float initBarX = width;
float initBarY = height;
float initBarVX = 15.0f;
float initBarVY = 0.0f;
float initBarWidth = 200.0f;
float initBarHeight = 50.0f;

final float barRadius = 100.0f;
final float twoBarRadius = barRadius*2;

Bar bar = new Bar(initBarX,initBarY, initBarVX, initBarVY, initBarWidth, initBarHeight);

class Bar{
  float x, y, vX, vY,
      _width, _height;
  Bar(float tmpBarX, float tmpBarY, float tmpBarVX, float tmpBarVY,
      float tmpBarWidth, float tmpBarHeight){
        this.x = tmpBarX;
        this.y = tmpBarY;
        this.vX = tmpBarVX;
        this.vY = tmpBarVY;
        this._width = tmpBarWidth;
        this._height = tmpBarHeight;
  }
  
  void move(){
    if(keyPressed){
    if(keyCode == RIGHT)x += vX;
    else if(keyCode == LEFT) x -= vX;
    }
    if(x < barRadius)x = barRadius;
    if(x > width - barRadius)x = width - barRadius;
  }
  
  void display(){
    fill(255,255,255);
    arc(x, y, twoBarRadius, twoBarRadius, PI, TWO_PI);
    line(x - barRadius , y, x + barRadius, y);
  }
}
