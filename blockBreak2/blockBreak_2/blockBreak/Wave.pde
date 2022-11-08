Wave wave = new Wave(); 



class Wave{
  final int maxIntervalFlame = 300;
  final int maxWashFlame = 360;
  int waveFlame = 0;
  float bottomY = 0;
  float topY = 0;
  float speedY = Height * 2 / (maxWashFlame - maxIntervalFlame);
  
  Wave(){
    waveFlame = 0;
  };
  
  void wash(){
    ++waveFlame;
    if(waveFlame > maxIntervalFlame){
      if(waveFlame > maxWashFlame){
        waveFlame = 0;
        return;
      }
      bottomY = speedY*(waveFlame - maxIntervalFlame);
      topY = bottomY - Height;
      
      if(bottomY > bar.y - barRadius && !bar.isUp)barLife -= 5;
      
      for(int i = 0; i < badBalls.size(); ++i){
        float tmpY = badBalls.get(i).y;
        if(bottomY > tmpY && tmpY > topY){
          badBalls.get(i).y += speedY;
          --i;
        }
      }
      
      for(int i = 0; i < balls.size(); ++i){
        float tmpY = balls.get(i).y;
        if(bottomY > tmpY && tmpY > topY){
          balls.get(i).y += speedY;
          --i;
        }
      }
      
    }
  }
  
  void display(){
    if(waveFlame > maxIntervalFlame){
    fill(84,192,245, 100);
    rect(0, topY, width,height);
    }
  }
  
  void reset(){
    waveFlame = 0;
  }
  
}
