PShader warp;
PShape horse;
PImage txtr;
PGraphics img;

float offset;
float scale;

void setup() {
  size(384, 768, P3D);
  img = createGraphics(384, 768, P3D);
  noStroke();
  fill(204);
  warp = loadShader("warp.frag", "warp.vert");
  warp.set("fraction", 1.0);
  scale = 80;
  warp.set("scale", scale);
  offset = 0;
  warp.set("offset", offset);
  
  horse = loadShape("horse_test.obj");
  txtr = loadImage("Horse_Texture.png");
  //txtr.loadPixels();
  horse.setTexture(txtr);
}

void draw() {
  shader(warp);
  background(0);
  float dirY = (mouseY / float(height) - 0.5) * 2;
  float dirX = (mouseX / float(width) - 0.5) * 2;
  directionalLight(204, 204, 204, -dirX, -dirY, -1);
  pushMatrix();
  translate(width/2, height/2);
  //scale(100,100,100);
  shape(horse);
  popMatrix();
  
  offset += 0.1; 
  warp.set("offset", offset);
}
