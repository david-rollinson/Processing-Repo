import peasy.*;

PGraphics img;

int amount = 16;
int[][] state = new int[amount][amount];

float offset = 0;
float tiles = 50;

PShape horse;
PImage txtr;

//Gradient Buffer Variables.
PGraphics mono;
color b1, b2;

PeasyCam cam; 

void setup() {
  size(800, 800, P3D);
  img = createGraphics(800, 800, P3D);
  noStroke();
  
  //SETUP GRADIENT BUFFER.
  mono = createGraphics(256, 16);
  b2 = color(0, 0, 255);
  b1 = color(255, 255, 0);
  
  txtr = loadImage("Horse_Texture.png");
  horse = loadShape("horse_test.obj");
  horse.setTexture(txtr);
  
  //USE CAMERA
  //cam = new PeasyCam(this, 300);
  //cam.setMaximumDistance(5000);
}

void draw() {
  background(0); //arbitrary value, overruled by graphics buffer.
  drawGradientToBuffer();
  applyMonochrome8x8(mono);
  drawOBJ();
  applyRaster();
  //image(img, 0, 0); //draw obj graphics 
  image(mono, width-mono.width, height-mono.height); //draw gradient
  
  pushMatrix();
  translate(mono.width-mono.height, height);
  rotate(-HALF_PI);
  image(mono, width-mono.width, height-mono.width);
  popMatrix();
  
  pushMatrix();
  translate(width, height);
  rotate(-PI);
  image(mono, width-mono.width, height-mono.height);
  popMatrix();
  
  pushMatrix();
  translate(width, 0);
  rotate(-HALF_PI*3);
  image(mono, width-mono.width, height-mono.height);
  popMatrix();
  
  //saveFrame("output/image####.png");
}

void drawOBJ() {
  
  //PRELIMS
  img.beginDraw();
  img.background(0);
  
  //LIGHTING
  img.lights();
  img.directionalLight(255,255,255, 1, 0, -1);
  
  //ADD TO SCENE AND TRANSFORM TO FIT
  img.pushMatrix();
  img.translate(width/2-10, height/2);
  img.rotate(PI+offset);
  img.rotateY(offset);
  img.scale(210, 210, 210);
  img.shape(horse);
  img.popMatrix();
  
  //COMPLETE SCENE AND DRAW
  img.endDraw();
  
  //OFFSET PARAMS
  offset += 0.1;
}

void drawGradientToBuffer() {
  mono.beginDraw();
  mono.background(255);
  mono.noFill();
  for(int i = 0; i <= mono.width; i++){
    float inter = map(i, 0, mono.width, 0, 1);
    color c = lerpColor(b1, b2, inter);
    mono.stroke(c);
    mono.line(i, 0, i, mono.height);
  }
  //mono.noStroke();
  //mono.fill(0);
  //mono.rect(0,0,mono.height,mono.height);
  mono.endDraw();
}

int calcIndex(int _i, int _j, PImage _img) {
  return _i + _j * _img.width;
}

void applyMonochrome8x8(PImage img) {

  img.loadPixels();
  int bayer_n, bayer_grad, col, row;
  float r, g, b;
  
  bayer_n = 8;  
  bayer_grad = 255;
  col = 0;
  row = 0;
  
    float[][] bayer_matrix_8x8 = {
    {0,  0,  -0.375,  0.125,  -0.46875,  0.03125,  -0.34375,  0.15625},
    {0.25,  -0.25,  0.375,  -0.125,  0.28125,  -0.21875,  0.40625,  -0.09375},
    {-0.3125,  0.1875,  -0.4375,  0.0625,  -0.28125,  0.21875,  -0.40625,  0.09375},
    {0.4375,  -0.0625,  0.3125,  -0.1875,  0.46875,  -0.03125,  0.34375,  -0.15625},
    {-0.453125,  0.046875,  -0.328125,  0.171875,  -0.484375,  0.015625,  -0.359375,  0.140625},
    {0.296875,  -0.203125,  0.421875,  -0.078125,  0.265625,  -0.234375,  0.390625,  -0.109375},
    {-0.265625,  0.234375,  -0.390625,  0.109375,  -0.296875,  0.203125,  -0.421875,  0.078125},
    {0.484375,  -0.015625,  0.359375,  -0.140625,  0.453125,  -0.046875,  0.328125,  -0.171875}};
  
  for (int i = 0; i < img.width; i++) {
  
     col = i % bayer_n;
     
     for (int j = 0; j < img.height; j++) {
       
       row = j % bayer_n;
       
       r = red(img.pixels[calcIndex(i, j, img)]);
       g = green(img.pixels[calcIndex(i, j, img)]);
       b = blue(img.pixels[calcIndex(i, j, img)]);
       
       color c = color(r + (bayer_grad * bayer_matrix_8x8[col][row]), g + (bayer_grad * bayer_matrix_8x8[col][row]), b + (bayer_grad * bayer_matrix_8x8[col][row]));
       
       //MULTICOLOURED EFFECT 
       img.pixels[calcIndex(i, j, img)] = c;
       
       if (red(c) < (bayer_grad / 2) || blue(c) < (bayer_grad / 2) || green(c) < (bayer_grad / 2)) {
         c = color(0);
       } else {
         c = color(255);
       }
       //MONOCHROME EFFECT
       //img.pixels[calcIndex(i, j, img)] = c;
       }
  }
  img.updatePixels();
}


void assignState(PImage _img, int _state, int _x, int _y, int _tileSize){
      fill(_state * (255/amount)); //not necessary here but keeping it in case I change copy to a pshape. 
      if(_state == 14) {
        tint(0,0,255); //this isnt working at the moment - perhaps needs custom glyphs to work. 
      } else {
        noTint(); 
      }
      copy(_img, _state*amount, 0, int(_img.width/amount), _img.height, int(_x*_tileSize), int(_y*_tileSize), int(_tileSize), int(_tileSize));
}

void applyRaster() {
  float tileSize = width/tiles;
  
  for (int x = 0; x < tiles; x++) {
    for (int y = 0; y < tiles; y++) {
      color c = img.get(int(x*tileSize),int(y*tileSize));
      int state = int(map(brightness(c), 0, 255, 0, 16));
      //int mono = int(brightness(c));
      pushMatrix();
      translate(x*tileSize, y*tileSize);
      
      //------------------------------
      //ASSIGN MONO STATES
      assignState(mono, state, x, y, int(tileSize));
      
      //------------------------------
      //ALTERNATIVE: ASSIGN COLOUR.
      //fill(c);
      //rect(0,0,tileSize,tileSize);
      
      
      popMatrix();
    }
  }
}
