float initBallX;
float initBallY;
float initBallVX = 0.0f;
float initBallVY = 10.0f;
float initBallRadius = 10.0f;

final int SetHitWallFlame = 10;
final int SetHitBarFlame = 5;
final float MaxLife = 5000;

float normalVecX, normalVecY, tmpA,normSQ,norm;

class Ball{
  float x, y,vX,vY, radius;
  int hitWallFlame,hitBarFlame;
  float life;
  
  Ball(float tmpBallX,float tmpBallY,
    float tmpBallVX,float tmpBallVY, float tmpBallRadius){
    this.x = tmpBallX;
    this.y = tmpBallY;
    this.vX = tmpBallVX;
    this.vY = tmpBallVY;
    this.radius = tmpBallRadius;
    this.hitWallFlame = SetHitWallFlame;
    this.hitBarFlame = SetHitBarFlame;
    this.life = MaxLife;
  }
  
  void move(){
    x += vX;
    y += vY;
    life -= abs(vX);
  }
  
  Boolean collisionWall(){
    Boolean isCollision = false;
    if(hitWallFlame != 0){
      hitWallFlame--;
      return false;
    }
    
    if(x > width - radius || x < radius) {
      vX = -vX;
      hitWallFlame = SetHitWallFlame;
      isCollision = true;
    }
    if(y < 0){
      vY = -vY;;
    }
    return isCollision;
  }
  
  void collisionBar(){
    if(hitBarFlame != 0){
      hitBarFlame--;
      return;
    }
    normalVecX = bar.x - x;
    normalVecY = bar.y - y;
    normSQ = sq(normalVecX) + sq(normalVecY);
    if(normSQ < cirLenSQ && y < bar.y && normSQ > barRadius){
      norm = sqrt(normSQ);
      normalVecX /= norm;
      normalVecY /= norm;
      tmpA = -(normalVecX*vX + normalVecY*vY)*2;
      vX = vX + tmpA*normalVecX;
      vY = vY + tmpA*normalVecY;
      hitBarFlame = SetHitBarFlame;
      
      x -= radius*normalVecX;
      y -= radius*normalVecY;
    }
  }
  
  int collisionBlock(){
    int areaIndex = int((x - BlockGap)/ AreaWidth) + 
      int((y - BlockGap - movePix)/ AreaHeight) * BlockRow;
    if(areaIndex >= blocks.length || areaIndex < 0)return -1;
    if(!blocks[areaIndex].hitFlag){
      float tmpX = x - blocks[areaIndex].x - vX;
      if(tmpX <= 0 || tmpX >= AreaWidth)vX = -vX;
      else vY = -vY;
      return areaIndex;
    }
    return -1;
  }
  
  void display(){
    fill(255 - life*255/MaxLife);
    ellipse(x, y, radius*2, radius*2);
  }
  
  Boolean isRemove(){
    return y > height || life <= 0 || x < 0 || x > width;
  }
}
