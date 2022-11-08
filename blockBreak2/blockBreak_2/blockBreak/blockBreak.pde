import processing.serial.*;
Serial serial;

import java.util.Iterator;
import java.util.Random;
Random r = new Random();

int nowScene = 0;

float sleepTime = 0;
final float MaxSleepTime = 50;

final int charSize = 60;

ArrayList<Ball> balls  = new ArrayList<Ball>();
ArrayList<BadBall> badBalls = new ArrayList<BadBall>();
ArrayList<BadBall> badColonys = new ArrayList<BadBall>();

int score = 0;
int nowMaxBlocks = 0;
int flame = 0;

int level = 1;
final int MaxLevel = 3;

final float Width = 1280.0f, Height = 720.0f;

final int numInData = 4;

float[] inData = new float[numInData];
float[] befInData = new float[numInData];
final int numHaveInData = 10;

final int dim = 3;

float[] devicePos = new float[dim];
float[] deviceSpd = new float[dim];


float[][] inAccs = new float[dim][];
float[][] inSpds = new float[dim][];

int endState;

void setup(){
  PFont font = createFont("Meiryo", 50);
  textFont(font);
  size(1280,720);
  textSize(charSize);
  
  initBallX = width/2;
  initBallY = height/2;
  
  initBarX = width/2;
  initBarY = height;

  
  setColors();
  
  serial = new Serial(this, "COM3", 9600);
  
  for(int i = 0; i < dim; ++i){
    inAccs[i] = new float[numHaveInData];
    inSpds[i] = new float[numHaveInData];
  }
  
}


void draw(){
  background(255,255,255);
  getSerial(serial);
  switch(nowScene){
    case 0 : drawStart(); break;
    case 1 : drawGame(); break;
    case 2 : drawEnd(); break;
  }
}

void drawStart(){
  fill(0);
  textAlign(CENTER, CENTER);
  text("brick breaker(2210154) \n Squeeze Sponge!", width/2, height/2);
  if(inData[3] < 100 && inData[3] != 0){
    initGame();
    nowScene = 1; 
    String tmpStr = serial.readStringUntil('\n');
    tmpStr = serial.readStringUntil('\n');
    tmpStr = serial.readStringUntil('\n');
    println(tmpStr);
  }
}

int baseTime = millis();
int endTime = 0;

void drawGame(){
  
  fill(0);
  textAlign(LEFT, BOTTOM);
  text("time:" +
    str((millis() - baseTime)/1000)+"s:: 洗剤パワー:" + str(int(barLife)),
      0.0f,height);//"スコア:" + str(score) + 
  
  fill(255,255,255);
  
  endState = gameUpdate();
  if(endState != 0){
    
    nowScene = 2;
    balls.clear();
    badBalls.clear();
    badColonys.clear();
    cmdFlip.reset();
    cmdGrab.reset();
    wave.reset();
    sleepTime = 0;
    endTime = millis();
  }
  
}


void drawEnd(){
  fill(0);
  textAlign(CENTER, CENTER);
  
   switch(endState){
     case -1: text("洗剤パワーがなくなってしまった", width/2, height/2);break;
     case -2:text("諦めました...", width/2, height/2);break;
     case 1:text("ゲームクリア", width/2, height/2);break;
   }
  sleepTime += 1;

  if(sleepTime >= MaxSleepTime){
    if(inData[3] < 100 && inData[3] != 0){
      if(cntDelBlocks == nowMaxBlocks && level < MaxLevel)level += 1;
      initGame();
      nowScene = 1;
    }
  }
  
}

void initGame(){
  setBlocks();
  endState = 0;
  barLife = maxBarLife;
  balls.add(new Ball(initBallX, initBallY, 
  initBallVX, initBallVY, initBallRadius, MaxBallLife));
  barLife = maxBarLife;
  bar.x = initBarX;
  bar.y = initBarY;
  score = 0;
  cntDelBlocks = 0;
  baseTime = millis();
  flame = 0;
  movePix = 0;
  isReach = false;
}


float alpha = 0.2;
float[] lowPassInData = new float[3];
float beta = 0.5;
float[] lowPassPos = new float[3];

void getSerial(Serial p){
  String inString = p.readStringUntil('\n');
  
  for(int i = 0; i < numInData; ++i)befInData[i] = inData[i];
  
  if (inString != null) {  
    inData = float(split(inString, ' ')); 
    for(int i = 0; i < numInData; ++i)if(Float.isNaN(inData[i]))inData[i] = 0;
  }else {
    for(int i = 0; i < numInData; ++i)inData[i] = befInData[i];
  }
  
  for(int i = 0; i < 3; ++i){
    lowPassInData[i] = alpha*lowPassInData[i] + (1 - alpha) * inData[i];
    inData[i] = inData[i] - lowPassInData[i]*0.3;
  }
  
  
  for(int i = 0; i < dim; ++i){
    
    devicePos[i] -= inSpds[i][0];
    deviceSpd[i] -= inAccs[i][0];
  
    for(int j = 1; j < numHaveInData; ++j)inAccs[i][j-1] = inAccs[i][j];
    for(int j = 1; j < numHaveInData; ++j)inSpds[i][j-1] = inSpds[i][j];
 
    inAccs[i][numHaveInData - 1] = (inData[i] + befInData[i]) / numHaveInData * 100; 
    inSpds[i][numHaveInData - 1] = (inAccs[i][numHaveInData - 3] + inAccs[i][numHaveInData - 2]
    + inAccs[i][numHaveInData - 1]) / numHaveInData;
    devicePos[i] += inSpds[i][numHaveInData - 1];
    deviceSpd[i] += inAccs[i][numHaveInData - 1];
  }
  
  for(int i = 0; i < 3; ++i){
    lowPassPos[i] = beta*lowPassPos[i] + (1 - beta) * devicePos[i];
    devicePos[i] = lowPassPos[i];
    if(abs(devicePos[i]) < 0.5)devicePos[i] = 0;
  }
  
  //println(devicePos[0],devicePos[1],devicePos[2],inData[3]);
  
}
