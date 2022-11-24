PGraphics mono;

color b1, b2;

void setup() {
  size(256, 16);
  mono = createGraphics(256, 16);
  
  b1 = color(0, 0, 0);
  b2 = color(255, 255, 255);
  
  background(255,0,0);
  drawGradientToBuffer();
  applyMonochrome(mono);
  image(mono, 0, 0);
}

void draw() {

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
  mono.endDraw();
}

int calcIndex(int _i, int _j, PImage _img) {
  return _i + _j * _img.width;
}

void applyMonochrome(PImage img) {

  img.loadPixels();
  int bayer_n, bayer_grad, col, row;
  float r, g, b;
  
  bayer_n = 4;  
  bayer_grad = 255;
  col = 0;
  row = 0; 
  
    float[][] bayer_matrix_4x4 = {
    {    -0.5,       0,  -0.375,   0.125 },
    {    0.25,   -0.25,   0.375, - 0.125 },
    { -0.3125,  0.1875, -0.4375,  0.0625 },
    {  0.4375, -0.0625,  0.3125, -0.1875 } };
  
  for (int i = 0; i < img.width; i++) {
    
     col = i % bayer_n;
     
     for (int j = 0; j < img.height; j++) {
       
       row = j % bayer_n;
       
       r = red(img.pixels[calcIndex(i, j, img)]);
       g = green(img.pixels[calcIndex(i, j, img)]);
       b = blue(img.pixels[calcIndex(i, j, img)]);
       
       color c = color(r + (bayer_grad * bayer_matrix_4x4[col][row]), g + (bayer_grad * bayer_matrix_4x4[col][row]), b + (bayer_grad * bayer_matrix_4x4[col][row]));
              
       if (red(c) < (bayer_grad / 2) || blue(c) < (bayer_grad / 2) || green(c) < (bayer_grad / 2)) {
         c = color(0);
       } else {
         c = color(255);
       }
       //MONOCHROME EFFECT
       img.pixels[calcIndex(i, j, img)] = c;
       }
  }
  //run_once = 1;
  img.updatePixels();
  
}
