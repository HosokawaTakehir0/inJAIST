int nowScene = 0;

float sleepTime = 0;
final float MaxSleepTime = 50;

final int charSize = 80;

ArrayList<Ball> balls;
int score = 0;
int nowMaxBlocks = 0;
int flame = 0;

int level = 1;
final int MaxLevel = 3;

final float Width = 1280.0f, Height = 720.0f;

void setup(){
  size(1280,720);
  textSize(charSize);
  
  initBallX = width/2;
  initBallY = height/2;
  
  initBarX = width/2;
  initBarY = height;
  
  balls = new ArrayList<Ball>();
  
  setColors();
}


void draw(){
  background(255,255,255);
  switch(nowScene){
    case 0 : drawStart(); break;
    case 1 : drawGame(); break;
    case 2 : drawEnd(); break;
  }
}

void drawStart(){
  fill(0);
  textAlign(CENTER, CENTER);
  text("brick breaker(2210154) \n Please Press any key", width/2, height/2);
  
  if(keyPressed){
    initGame();
    nowScene = 1; 
  }
}

int baseTime = millis();
int endTime = 0;

void drawGame(){
  
  fill(0);
  textAlign(LEFT, BOTTOM);
  text("score:" + str(score) + ":: time:" +
    str((millis() - baseTime)/1000)+"s",
      0.0f,height);
  
  fill(255,255,255);
  
  if(gameUpdate()){
    nowScene = 2;
    balls.clear();
    sleepTime = 0;
    endTime = millis();
  }
  
}


void drawEnd(){
  fill(0);
  textAlign(CENTER, CENTER);
  if(cntDelBlocks == nowMaxBlocks)text("Clear Time: " + str((endTime - baseTime)/1000.0f) + "s", width/2, height/2);
  else text("You break " + str(score) + " blocks.", width/2, height/2);
  text("Please Press any key & restart!", width/2, height/2 + charSize);
  sleepTime += 1;
  if(sleepTime >= MaxSleepTime){
    if(keyPressed){
      if(cntDelBlocks == nowMaxBlocks && level < MaxLevel)level += 1;
      initGame();
      nowScene = 1;
    }
  }
  
}

void initGame(){
  setBlocks();
  balls.add(new Ball(initBallX, initBallY, 
  initBallVX, initBallVY, initBallRadius));
  bar.x = initBarX;
  bar.y = initBarY;
  score = 0;
  cntDelBlocks = 0;
  baseTime = millis();
  flame = 0;
  movePix = 0;
  isReach = false;
}
