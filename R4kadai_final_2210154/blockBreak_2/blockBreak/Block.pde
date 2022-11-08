final int BlockRow = 14;
final int BlockColumn = 9;
final int MaxBlocks = BlockRow*BlockColumn;

final float BlockGap = 0f;
final float BlockWidth = Width / BlockRow - BlockGap;
final float BlockHeight = (Height - barRadius)/ BlockColumn - BlockGap;
final float AreaHeight = BlockGap + BlockHeight;
final float AreaWidth = BlockGap + BlockWidth;
float badColonyRadius = AreaHeight / 2;

final float MaxBadColonys = 10;

float validHeight = Height - twoBarRadius;

int moveAreaTime = 60;
float moveFlamePix = AreaHeight / moveAreaTime;
float movePix = 0;

IntList palette;

void setColors(){
  palette = new IntList();
  for(int i = 0; i < 2; ++i){
    for(int j = 0; j < 2; ++j){
      for(int k = 0; k < 2; ++k){
        if(i == j && j ==k)continue;
        palette.append(color(255*i,255*j,255*k));
      }
    }
  }
}

  
 
class BadBall extends Ball{
  int paletteIndex;
  
  BadBall(float tmpBallX,float tmpBallY,
    float tmpBallVX,float tmpBallVY, float tmpBallRadius,
    float tmpLife,int tmpPaletteIndex){
    super( tmpBallX,tmpBallY,
    tmpBallVX,tmpBallVY,tmpBallRadius, tmpLife);
    this.paletteIndex = tmpPaletteIndex;
  }
  
  void display(){
    fill(palette.get(paletteIndex));
    ellipse(x, y, radius*2, radius*2);
  }
}



void setBlocks(){

  for ( int i = 0; i <  MaxBadColonys ; i++ ){
    badColonys.add(new BadBall(
    r.nextFloat() * Width,r.nextFloat() * validHeight,
    0, 0, badColonyRadius,1,
    i % palette.size()
  ));
  }
  
}
