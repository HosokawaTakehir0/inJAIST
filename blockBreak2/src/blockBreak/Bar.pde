float initBarX = width;
float initBarY = height;
float initBarVX = 15.0f;
float initBarVY = 0.0f;
float initBarWidth = 200.0f;
float initBarHeight = 50.0f;

final float barRadius = 100.0f;
final float twoBarRadius = barRadius*2;

float barLife;
final float maxBarLife = 1000;

final float upRatio = 0.8;
float upBarRadius = barRadius * upRatio;

Bar bar = new Bar(initBarX,initBarY, initBarVX, initBarVY, initBarWidth, initBarHeight);

Bar specialBar = new Bar(initBarX,initBarY, initBarVX, initBarVY, initBarWidth, initBarHeight);
Boolean isExistSpBar = false;

class Bar{
  float x, y, vX, vY,
      _width, _height;
  Boolean isUp = false;
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
    if(isUp)return;
    
    x = width/2 - devicePos[1]*100;
    
    if(x < barRadius)x = barRadius;
    if(x > width - barRadius)x = width - barRadius;
  }
  
  void display(){
    if(isUp){
      fill(0,0,0);
      arc(x, y - upBarRadius * 0.3, twoBarRadius * upRatio , twoBarRadius * upRatio , PI, TWO_PI);
      line(x -  upBarRadius
      , y - upBarRadius * 0.3, x + upBarRadius, y - upBarRadius*0.3);
    }else{
    fill(255,255,255);
    arc(x, y, twoBarRadius, twoBarRadius, PI, TWO_PI);
    line(x - barRadius , y, x + barRadius, y);
    }
  }
}
