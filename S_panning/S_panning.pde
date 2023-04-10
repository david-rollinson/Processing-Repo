PImage img;
float p = 0;
float offsetX = 0;
float offsetY = 0;
float a = -90;

int state;

void setup() {
  size(512,512);
  img = loadImage("2.jpg");
  state = 0;
}

void draw() {
  image(img, offsetX, offsetY, 1024, 1024);
  if(state == 0){
    float sinA = abs(sin(a)) * 128;
    a+=0.01;
    offsetX = map(sinA, 0, 180, 0, -512);
    if(offsetX == -512) {
      state = 1;
    }
  } else if(state == 1) {
    
    offsetY-=4;
    if(offsetY == -512) {
      state = 2;
    }
  } else if(state == 2) {
    
    offsetX+=4;
    if(offsetX == 0){
      state = 3;
    }
  } else if(state == 3) {
    offsetY+=4;
    if(offsetY == 0) {
      state = 0;
    }
  }
}
