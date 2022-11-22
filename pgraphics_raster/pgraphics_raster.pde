PGraphics img;

int amount = 5;
int[][] state = new int[amount][amount];

float offset = 0;

void setup() {
  size(400, 400, P3D);
  img = createGraphics(400, 400, P3D);
  noStroke();
}

void draw() {
  background(0);
  drawSphere();
  applyRaster();
}

void drawSphere() {
  img.beginDraw();
  img.background(0);
  img.fill(255);
  img.stroke(255);
  img.lights();
  img.push();
  img.translate(width/2, height/2);
  img.sphere((20*sin(offset))+90);
  img.pop();
  img.endDraw();
  //image(img, 0, 0); 
  offset += 0.1;
}

void applyRaster() {
  float tiles = 40;
  float tileSize = width/tiles;
  
  for (int x = 0; x < tiles; x++) {
    for (int y = 0; y < tiles; y++) {
      color c = img.get(int(x*tileSize),int(y*tileSize));
      int state = int(map(brightness(c), 0, 255, 0, 6));
      pushMatrix();
      translate(x*tileSize, y*tileSize);
      if(state == 0) {
        fill(0);
        rect(0,0,tileSize, tileSize);
      } else if (state == 1) {
        fill(40);
        rect(0,0,tileSize, tileSize);
      } else if (state == 2) {
        fill(80);
        rect(0,0,tileSize, tileSize);
      } else if (state == 3) {
        fill(120);
        rect(0,0,tileSize, tileSize);
      } else if (state == 4) {
        fill(180);
        rect(0,0,tileSize, tileSize);
      } else if (state == 5) {
        fill(200);
        rect(0,0,tileSize, tileSize);
      } else if (state == 6) {
        fill(255);
        rect(0,0,tileSize, tileSize);
      }
      popMatrix();
    }
  }
}
