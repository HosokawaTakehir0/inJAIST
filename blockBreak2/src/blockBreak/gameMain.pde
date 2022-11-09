int maxBallsNum = 500;
int maxFlame = 300;
int cntDelBlocks = 0;
int tmpIndex;

float cirLenSQ =  sq(barRadius + initBallRadius);
float cirLen =  sqrt(cirLenSQ);
float barRadiusSQ = sq(barRadius);

float tmpInitX,tmpInitY;

Boolean isReach = false;



 //<>//
int gameUpdate(){
  flame++;
  flame %= maxFlame;
  
  cmdFlip.chk();
  cmdGrab.chk();
  
  bar.move();
  for(int i = 0; i < balls.size(); ++i){
    balls.get(i).move();
    balls.get(i).collisionWall();
    
    if(!bar.isUp)balls.get(i).collisionBar();
   
   for(int j = 0; j < badColonys.size(); ++j){
      if(balls.get(i).collisionBall(badColonys.get(j).x, badColonys.get(j).y, badColonys.get(j).radius)){
        badColonys.remove(j);
        //existBall = false;
        break;
      }
    }
    
    for(int j = 0; j < badBalls.size(); ++j){
      if(balls.get(i).life > 0){ 
        if(balls.get(i).collisionBall(badBalls.get(j).x, badBalls.get(j).y, badBalls.get(j).radius)){
          badBalls.remove(j);
        }
      }
    }
    
    if(balls.get(i).life < 0){
      balls.remove(i);
      --i;
    }
  }
  
  Iterator<BadBall> itBC = badBalls.iterator();
  while(itBC.hasNext()){
    BadBall tmpBC = itBC.next();
    tmpBC.move();
    if(bar.isUp)continue;
    if(tmpBC.collisionBar()){
      barLife -= 10;
      itBC.remove();
    }
  } //<>//
  
  
  wave.wash();
  
  

  for(BadBall target : badColonys){
    if(r.nextFloat() < 0.03){
      float ang = r.nextFloat()*TWO_PI;
      float cos_ = cos(ang);
      float sin_ = sin(ang);
      badBalls.add(new BadBall(
      target.x + target.radius * cos_ , target.y +  target.radius * sin_,
      3*cos_ - 0.01, 3*sin_ + 0.01, badColonyRadius / 2, 1,
      target.paletteIndex
      ));
    }
  }
  
  
  
  bar.display(); //<>//
  for(BadBall target : badColonys)target.display();
  for(BadBall target : badBalls)target.display();
  for(Ball target : balls)target.display();
  
  for(int i = 0; i < balls.size(); ++i){
    if(balls.get(i).isRemove()){
      balls.remove(i);
      --i;
    }
  }
  
  for(int i = 0; i < badBalls.size(); ++i){
    if(badBalls.get(i).isRemove()){
      badBalls.remove(i);
      --i;
    }
  }
  
  wave.display();
  
  
  movePix += moveFlamePix;
  
  if(barLife < 0)return -1;
  if(badColonys.size() == 0)return 1;
  if(cmdFlip.valid == 0 && cmdFlip.isValidFlame == 0)return -2;
  
  return 0;
     
     
}
