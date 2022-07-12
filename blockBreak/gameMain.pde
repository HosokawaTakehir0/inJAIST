int maxBallsNum = 500;
int cntDelBlocks = 0;
int tmpIndex;

float cirLenSQ =  sq(barRadius + initBallRadius);
float cirLen =  sqrt(cirLenSQ);
float barRadiusSQ = sq(barRadius);

float tmpInitX,tmpInitY;

Boolean isReach = false;


Boolean gameUpdate(){
  
  bar.move();
  for(Block target : blocks)target.move();
  for(int i = 0; i < balls.size(); ++i){
    balls.get(i).move();
    if(balls.get(i).collisionWall() && balls.size() < maxBallsNum){
      balls.add(new Ball(balls.get(i).x, balls.get(i).y, 
      balls.get(i).vX - random(-1.0f,1.0f), 
      balls.get(i).vY + random(-1.0f,1.0f),
      balls.get(i).radius));
      
      
    }
    balls.get(i).collisionBar();
    tmpIndex = balls.get(i).collisionBlock();
    if(tmpIndex != -1){
      blocks[tmpIndex].hitFlag = true;
      score++;
      cntDelBlocks++;
    }
  }
  
  
  bar.display();
  for(Ball target : balls)target.display();
  for(Block target : blocks)target.display();
  
  for(int i = 0; i < balls.size(); ++i){
    if(balls.get(i).isRemove()){
      balls.remove(i);
      --i;
    }
  }
  
  flame++;
  movePix += moveFlamePix;
  if(flame == moveAreaTime){
    flame = 0;
    movePix = 0;
    
    for(int i = 0; i < BlockRow; ++i){
      if(!blocks[MaxBlocks - 1 - i].hitFlag)isReach = true;
    }
    
    for(int i = MaxBlocks - BlockRow - 1; i >= 0; --i){
      tmpIndex = i + BlockRow;
      blocks[tmpIndex].paletteIndex = blocks[i].paletteIndex;
      blocks[tmpIndex].hitFlag = blocks[i].hitFlag;
    }
    tmpIndex = blocks[0].paletteIndex;
    for(int i = 0; i < BlockRow; ++i){
      blocks[i].hitFlag = false;
      blocks[i].paletteIndex = (tmpIndex + i + 1) % palette.size();
    }
    nowMaxBlocks += BlockRow;
  }
  
  return balls.size() == 0 || 
         cntDelBlocks == nowMaxBlocks ||
         isReach ;
     
     
}
