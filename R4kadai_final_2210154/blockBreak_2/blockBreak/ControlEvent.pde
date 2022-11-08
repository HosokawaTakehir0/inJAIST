DeviceFlip cmdFlip = new DeviceFlip();
DeviceGrab cmdGrab = new DeviceGrab();

class DeviceFlip{
  int valid = -5;
  int[] ord = {0, 1, 2};
  int flipFlame = -5;
  final int[] maxPushFlame = {60, 60, 60};
  final int[] maxPullFlame = {60, 60, 60};
  final float[] pushThr = {-9,-10,-23};
  final float[] pullThr = {8,10,-12};
  final int maxValidFlame = 1;
  int  isValidFlame = maxValidFlame;
  float res;
  
  DeviceFlip(){
  }
  
  void chk(){
    ord[0] = 0;ord[1] = 1;ord[2] = 2;
    for(int i = 0; i < dim; ++i){
      for(int j = i + 1; j < dim; ++j){
        if(abs(devicePos[i]) < abs(devicePos[j])){
          ord[i] ^= ord[j];ord[j] ^= ord[i];ord[i] ^= ord[j];
        }
      }
    }
    
    for(int i = 0; i < dim; ++i){
      int tar = ord[i];
      if(valid == -5 || (valid >> 1) == tar){
        if(flipFlame < 0){
            if(pushThr[tar] > devicePos[tar]){flipFlame = maxPushFlame[tar];valid = 0;}
            if(pullThr[tar] < devicePos[tar]){flipFlame = maxPullFlame[tar];valid = 1;}
            if(valid != -5)valid += (tar << 1);
            else continue;
            
            /*if(isValidFlame < maxValidFlame){
              if( ( (valid & 1) == 0 && (devicePos[tar] - res) <= 0) || 
              ( (valid & 1) == 1 && (devicePos[tar] - res) >= 0) ){
              }else{
                valid = -5;
                isValidFlame = maxValidFlame;
                continue;
              }
            }
            res = devicePos[tar];*/
            isValidFlame--;
        }
      }
    }
    
    if(isValidFlame == 0){
      switch(valid){
        case 0:pullX();break;
        case 1:pushX();break;
        case 2:pullY();break;
        case 3:pushY();break;
        case 4:pullZ();break;
        case 5:pushZ();break;
      }
    }
        
     
    
    if(flipFlame >= 0)--flipFlame;
    else{
      valid = -5;
      isValidFlame = maxValidFlame;
    }
  }
  
  
  void pullX(){println(flipFlame + "pullX", devicePos[0]);

  }
  
  void pushX(){println(flipFlame + "pushX", devicePos[0]);
    if(flipFlame > 0)isExistSpBar = true;
    else{ isExistSpBar = false;return;}
    
    if(flipFlame == maxPushFlame[0]){
      specialBar.x = bar.x;specialBar.y = bar.y;
    }else {
      specialBar.y -= Width / maxPushFlame[0];
      barLife -= (500 / maxPushFlame[0]);
    }
    
    Iterator<BadBall> itBC = badBalls.iterator();
    while(itBC.hasNext()){
    BadBall tmpBC = itBC.next();
    float oX = tmpBC.x, oY = tmpBC.y,oRadius = tmpBC.radius;
    normalVecX = abs(oX - specialBar.x);
    normalVecY = abs(oY - specialBar.y);
    normSQ = sqrt(sq(normalVecX) + sq(normalVecY));
    if(normSQ < barRadius + oRadius)itBC.remove();
    }
    
    itBC = badColonys.iterator();
    while(itBC.hasNext()){
    BadBall tmpBC = itBC.next();
    float oX = tmpBC.x, oY = tmpBC.y,oRadius = tmpBC.radius;
    normalVecX = abs(oX - specialBar.x);
    normalVecY = abs(oY - specialBar.y);
    normSQ = sqrt(sq(normalVecX) + sq(normalVecY));
    if(normSQ < barRadius + oRadius)itBC.remove();
    }
  
    specialBar.display();
  }
  void pullY(){println(flipFlame + "pullY", devicePos[1]);}
  void pushY(){println(flipFlame + "pushY", devicePos[1]);}
  
  void pushZ(){println(flipFlame + "pullZ", devicePos[2]);
  barLife += 3;
  }
  
  void pullZ(){println(flipFlame + "pushZ", devicePos[2]);
  bar.isUp = true;
  if(flipFlame == 0)bar.isUp = false;
  }
  
  void reset(){
    valid = -5;
    flipFlame = -5;
    isValidFlame = maxValidFlame;
  }
}


class DeviceGrab{
  final int maxGrabFlame = 60;
  int grabFlame = 0;
  float maxGrabPower = 0;
  float resGrabPower = 0;
  float maxCreatBall = 15;
  float numCreatBall = 0;
  Boolean isBefCreat = false;
  DeviceGrab(){}
  
  void chk(){
    if(grabFlame < 0){
      if(inData[3] < 100){
        maxGrabPower = inData[3];
        resGrabPower = maxGrabPower;
        grabFlame = maxGrabFlame;
        numCreatBall = 0;
      }else return;
    }
    
    grab();
    if(grabFlame >= 0)--grabFlame;
  }
  
  void grab(){
    println(grabFlame + "grab",inData[3] );
    if(resGrabPower >= inData[3] && numCreatBall < maxCreatBall && !isBefCreat){
      float ang = r.nextFloat()*PI;
      float cos_ = cos(ang);
      float sin_ = sin(ang);
      
      balls.add(new Ball(bar.x - cos_ * cirLen, bar.y - sin_ * cirLen, 
      3 * cos_, 3 * sin_,
      initBallRadius, MaxBallLife / 2));
      barLife -= 5;
      ++numCreatBall;
      isBefCreat = true;
    }else isBefCreat = false;
    resGrabPower = inData[3];
  }
  
  void reset(){
    grabFlame = 0;
    maxGrabPower = 0;
    resGrabPower = 0;
    maxCreatBall = 15;
    numCreatBall = 0;
    isBefCreat = false;
  }
}
