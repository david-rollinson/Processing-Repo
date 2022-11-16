
//THIS SKETCH EXPORES 3 DIFFERENT DITHERING METHODS. 

PImage img;

float r, g, b, newR, newG, newB, oldR, oldG, oldB;
float errR, errG, errB;

int bayer_n, bayer_grad, col, row;
int run_once;

boolean monochrome, rgb, error;

Button[] buttons;

void setup() {
  size(900,900);
  img = loadImage("kitten.jpg");
  img.resize(900,900);
  //img.filter(GRAY);
  
  bayer_n = 4;  
  bayer_grad = 255;
  col = 0;
  row = 0; 
  
  background(255);
  
  monochrome = false;
  rgb = false;
  error = false;
  run_once = 0;

  buttons = new Button[3];
  buttons[0] = new Button(width/4, height-25, 25, "Monochrome", color(255, 255, 255), color(255,0,0));
  buttons[1] = new Button(width/2, height-25, 25, "RGB", color(255, 255, 255), color(0,255,0));
  buttons[2] = new Button(3*width/4, height-25, 25, "Error", color(255, 255, 255), color(0,0,255));
}

int calcIndex(int _i, int _j, PImage _img) {
  return _i + _j * _img.width;
}

void draw () {
  image(img, 0, 0);
  if (buttons[0].visible) buttons[0].show();
  if (buttons[1].visible) buttons[1].show();
  if (buttons[2].visible) buttons[2].show();
  
  if(monochrome && run_once == 0) {
    applyMonochrome();
  } else if (rgb) {
    applyRGB();
  } else if (error){
    applyErrorProcess();
  } else if (run_once == 1 && monochrome == false && rgb == false && error == false){
    setup();
  }
  
}

void mousePressed()
{  
  if(buttons[0].isClicked())
  {
    
     buttons[0].togCol = !buttons[0].togCol;
     monochrome = !monochrome;
     
  } else if(buttons[1].isClicked())
  {
     buttons[1].togCol = !buttons[1].togCol;
     rgb = !rgb;
     
  } else if(buttons[2].isClicked())
  {
     buttons[2].togCol = !buttons[2].togCol;
     error = !error;
     
  } 
}

void applyMonochrome() {

  img.loadPixels();
  
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
       
       //MULTICOLOURED EFFECT 
       //img.pixels[calcIndex(i, j, img)] = c;
       
       if (red(c) < (bayer_grad / 2) || blue(c) < (bayer_grad / 2) || green(c) < (bayer_grad / 2)) {
         c = color(255);
       } else {
         c = color(0);
       }
       //MONOCHROME EFFECT
       img.pixels[calcIndex(i, j, img)] = c;
       }
  }
  run_once = 1;
  img.updatePixels();
  
}

void applyRGB() {
  img.loadPixels();
  
  float[][] bayer_matrix_4x4 = {
         {    15, 195,  60, 240  },
         {   135,  75, 180, 120  },
         {    45, 225,  30, 210  },
         {   165, 105, 150,  90  }};
  
  for (int i = 0; i < img.width; i++) {
    
     col = i % bayer_n;
     
     for (int j = 0; j < img.height; j++) {
       
       row = j % bayer_n;
       
       r = red(img.pixels[calcIndex(i, j, img)]);
       g = green(img.pixels[calcIndex(i, j, img)]);
       b = blue(img.pixels[calcIndex(i, j, img)]);
       
       newR = ((r < bayer_matrix_4x4[col][row] ? 0 : 255));
       newG = ((g < bayer_matrix_4x4[col][row] ? 0 : 255));
       newB = ((b < bayer_matrix_4x4[col][row] ? 0 : 255));
    
       img.pixels[calcIndex(i, j, img)] = color(newR, newG, newB);
   }
  }
  run_once = 1;
  img.updatePixels();
}

void applyErrorProcess() {
  img.loadPixels();
  for (int j = 0; j < img.height-1; j++) {
       for (int i = 1; i < img.width-1; i++) {
     
       color c = img.pixels[calcIndex(i, j, img)];
       
       oldR = red(c);
       oldG = green(c);
       oldB = blue(c);
       int factor = 1;
       int newR = round(factor * oldR / 255) * (255 / factor); 
       int newG = round(factor * oldG / 255) * (255 / factor); 
       int newB = round(factor * oldB / 255) * (255 / factor); 
       img.pixels[calcIndex(i, j, img)] = color(newR, newG, newB);
       
       errR = oldR - newR;
       errG = oldG - newG;
       errB = oldB - newB; 
       
       color v = calcColorMap(i+1, j, img, errR, errG, errB, 7/16.0);
       img.pixels[calcIndex(i+1, j, img)] = v;
       
       color s = calcColorMap(i-1, j+1, img, errR, errG, errB, 3/16.0);
       img.pixels[calcIndex(i-1, j+1, img)] = s;
       
       color u = calcColorMap(i, j+1, img, errR, errG, errB, 5/16.0);
       img.pixels[calcIndex(i, j+1, img)] = u;
       
       color w = calcColorMap(i+1, j+1, img, errR, errG, errB, 1/16.0);
       img.pixels[calcIndex(i+1, j+1, img)] = w;
   }
  }
  run_once = 1;
  img.updatePixels();  
}

color calcColorMap(int _findIndexX, int _findIndexY, PImage _img, float _errR, float _errG, float _errB, float _mult) {
  color init = _img.pixels[calcIndex(_findIndexX, _findIndexY, _img)];
  float _r = red(init);
  float _g = green(init);
  float _b = blue(init);
  _r = _r + _errR * _mult;
  _g = _g + _errG * _mult;
  _b = _b + _errB * _mult;
  color comp = color(_r, _g, _b);
  return comp; 
}

//adapting the button class from https://www.reddit.com/r/processing/comments/exe6k7/an_extremely_simple_button_class/
class Button {
  PVector pos;
  float radius;
  color offCol;
  color onCol;
  String caption;
  boolean visible;
  boolean togCol;

  Button(float x, float y, float r, String txt, color c, color d) {
    pos = new PVector(x, y);
    radius = r;
    caption = txt;
    offCol = c;
    onCol = d;
    visible = true;
    togCol = false;
  }

  void show() {
    if(this.togCol){
      fill(onCol);
    } else {
      fill(offCol);
    }
    
    strokeWeight(3);
    ellipse(pos.x, pos.y, radius * 2, radius * 2);
    fill(0);
    float fontSize = radius * 0.33;
    textSize(fontSize);
    float tw = textWidth(caption);
    float tx = pos.x - (tw/2);
    float ty = pos.y + (fontSize / 2);
    text(caption, tx, ty);
  }
  
  boolean isClicked()
  {
    if(visible)
    {
    return dist(pos.x,pos.y, mouseX, mouseY) <= radius;
    } else 
    {
      return false;
    }
  }
}
