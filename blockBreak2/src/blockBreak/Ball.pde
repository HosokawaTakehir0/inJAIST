float initBallX;
float initBallY;
float initBallVX = 0.0f;
float initBallVY = 7.0f;
float initBallRadius = 10.0f;

final int SetHitWallFlame = 10;
final int SetHitBarFlame = 5;
final float MaxBallLife = 50;

float normalVecX, normalVecY, tmpA,normSQ,norm;

class Ball{
  float x, y,vX,vY, radius;
  int hitWallFlame,hitBarFlame, hitBallFlame;
  float life;
  
  Ball(float tmpBallX,float tmpBallY,
    float tmpBallVX,float tmpBallVY, float tmpBallRadius, float tmpLife){
    this.x = tmpBallX;
    this.y = tmpBallY;
    this.vX = tmpBallVX;
    this.vY = tmpBallVY;
    this.radius = tmpBallRadius;
    this.hitWallFlame = SetHitWallFlame;
    this.hitBarFlame = SetHitBarFlame;
    this.life = tmpLife;
  }
  
  void move(){
    x += vX;
    y += vY;
  }
  
  Boolean collisionWall(){
    Boolean isCollision = false;
    if(hitWallFlame != 0){
      hitWallFlame--;
      return false;
    }
    
    if(x > width - this.radius || x < this.radius) {
      vX = -vX;
      hitWallFlame = SetHitWallFlame;
      isCollision = true;
    }
    if(this.y < this.radius){
      this.y =  this.radius;
      vY = -vY;;
    }
    return isCollision;
  }
  
  Boolean collisionBar(){
    if(hitBarFlame != 0){
      hitBarFlame--;
      return false;
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
      return true;
    }
    return false;
  }
  
  Boolean collisionBall(float oX, float oY,float oRadius){
    if(hitBallFlame != 0){
      hitBallFlame--;
      return false;
    }
    normalVecX = oX - this.x;
    normalVecY = oY - this.y;
    norm = sqrt(sq(abs(normalVecX)) + sq(abs(normalVecY)));
    //life -= 1;
    Boolean isCol = norm < (this.radius + oRadius);
    if(isCol){
      life -= 1;
      normalVecX /= norm;
      normalVecY /= norm;
      tmpA = -(normalVecX*vX + normalVecY*vY)*2;
      vX = vX + tmpA*normalVecX;
      vY = vY + tmpA*normalVecY;
      
      x -= radius*normalVecX;
      y -= radius*normalVecY;
      hitBallFlame = 5;
    }
    return isCol;
  }
  
  void display(){
    fill(255);
    ellipse(x, y, radius*2, radius*2);
  }
  
  Boolean isRemove(){
    return  y < 0 || y > height || life <= 0 || x < 0 || x > width;
  }
}
