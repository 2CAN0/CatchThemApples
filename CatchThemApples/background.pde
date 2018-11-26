class GroundTile {
  float x, 
    y, 
    h, 
    w;
  PImage tile;

  GroundTile(float xLoc, float yLoc, float tileW, float tileH, PImage texture) {
    x = xLoc;
    y = yLoc;
    w = tileW;
    h = tileH;
    tile = texture;
  }

  void draw() {
    image(tile, x, y, w, h);
  }
}
ArrayList<GroundTile> tiles = new ArrayList<GroundTile>();

class Cloud {
  float x, 
    y, 
    radius;

  Cloud(float xLoc, float yLoc, float cloudR) {
    radius = cloudR; 
    x = xLoc;
    y = yLoc;
  }

  void updateDead() {
    if (x <= width)
      x -= 20; 
    else
      x += 20;
  }

  void draw() {
    fill(255, 245);

    //Bottom Center
    ellipse(x, y, radius*2, radius*2);

    //Top Right
    ellipse(x + radius*0.25, y - radius*0.95, radius*2, radius*2);

    //Top Left - small ball
    ellipse(x - radius*0.875, y - radius, radius*0.62*2, radius*0.625*2);

    //Bottom outside
    ellipse(x- radius*1.25, y, radius*2, radius*2);
    ellipse(x + radius, y, radius*2, radius*2);
  }
}
ArrayList<Cloud> clouds = new ArrayList<Cloud>();

void setupBackground() {
  float margin  = 100;
  float spawnSpace = (width - margin*2)/MAX_CLOUDS;
  float cloudLeftBound = margin;
  for (int iClouds = 0; iClouds < MAX_CLOUDS; iClouds++) {
    clouds.add(new Cloud(random(cloudLeftBound, cloudLeftBound + spawnSpace), random(100, 200), random(40, 61)));
    cloudLeftBound += spawnSpace;
  }

  for (int iTile = 0; iTile < width/tileSize; iTile++) {
    GroundTile prevTile;
    if (iTile == 0) {
      tiles.add(new GroundTile(0.0, height - tileSize, tileSize, tileSize, tileTexture));
    } else {
      prevTile = tiles.get(iTile - 1);

      //GroundTile(float xLoc, float yLoc, float tileW, float tileH, PImage texture)
      tiles.add(new GroundTile(prevTile.x + tileSize, height - tileSize, tileSize, tileSize, tileTexture));
    }
  }
}

void drawBackground() {
  background(bg);

  //fill(45, 147, 39);
  //rect(0, height - groundHeight, width, groundHeight);
  for (int iTile = 0; iTile < width/tileSize; iTile++) {
    GroundTile tile = tiles.get(iTile);
    tile.draw();
  }

  image(sun, width/8*7, 150, 100*2, 100*2);

  if (!inMenu) {
    for (Cloud cloud : clouds) {
      cloud.draw();
    }
  }
}
