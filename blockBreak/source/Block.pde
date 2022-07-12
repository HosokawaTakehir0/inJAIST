final int BlockRow = 11;
final int BlockColumn = 30;
final int MaxBlocks = BlockRow*BlockColumn;

final float BlockGap = 6.0f;
final float BlockWidth = Width / BlockRow - BlockGap;
final float BlockHeight = (Height - barRadius)/ BlockColumn - BlockGap;
final float AreaHeight = BlockGap + BlockHeight;
final float AreaWidth = BlockGap + BlockWidth;

int moveAreaTime = 60;
float moveFlamePix = AreaHeight / moveAreaTime;
float movePix = 0;

Block[] blocks = new Block[MaxBlocks];

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


class Block{
  float x,y,_width,_height,initX,initY;
  int paletteIndex;
  Boolean hitFlag;
  int moveFlame;
  
  Block(float tmpX, float tmpY,
  float tmpWidth,float tmpHeight, 
  int tmpPaletteIndex, Boolean tmpHitFlag){
    this.initX = tmpX;
    this.initY = tmpY;
    this._width = tmpWidth;
    this._height = tmpHeight;
    this.paletteIndex = tmpPaletteIndex;
    this.hitFlag = tmpHitFlag;
    
    this.x = this.initX;
    this.y = this.initY;
  }
  
  void move(){
    y = initY + movePix;
  }
  
  void display(){
    if(!hitFlag){
      fill(palette.get(paletteIndex));
      rect(x,y,_width,_height);
    }
  }
}


void setBlocks(){
  Boolean tmpBool;
  nowMaxBlocks = 0;
  for ( int i = 0; i < MaxBlocks; i++ ){
    if(i >= BlockRow * level * 5)tmpBool = true;
    else {
      tmpBool = false;
      nowMaxBlocks++;
    }
    
    blocks[i] = new Block(BlockGap + i % BlockRow * AreaWidth,
      BlockGap + i / BlockRow * AreaHeight,
      BlockWidth, BlockHeight, i % palette.size(), tmpBool);
      
  }
  
}
