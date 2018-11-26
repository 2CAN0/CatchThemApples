class Player {
  float x, 
    y, 
    balkW, 
    balkH, 
    balkX, 
    balkY, 
    h, 
    w, 
    vx;

  PImage[] skins;

  Player(float playerWidth, float playerHeight, float balkWidth, float balkHeight, PImage[] sk) {
    h = playerHeight;
    w = playerWidth;
    x = width/2;
    y = height - playerHeight + 10 - groundHeight;
    balkW = balkWidth;
    balkH = balkHeight;
    balkX = x + w/2 - balkW/2;
    balkY = y - balkHeight/2;
    vx = 10;
    skins = sk;
  }

  void update() {
    if (!mouseDown) {
      if (keysPressed[LEFT]) if (x - w > spawnLeftBound/4*3)if (keysPressed[SHIFT]) {
        x -= vx * 2;
        balkX -= vx*2;
      } else {
        x -= vx;
        balkX -= vx;
      }
      if (keysPressed[RIGHT]) if (x + w < width - spawnLeftBound/4*3)if (keysPressed[SHIFT]) {
        x += vx * 2;
        balkX += vx *2;
      } else {
        x += vx;
        balkX += vx;
      }
    } else {
      if (mouseX < width/2) if (x - w> spawnLeftBound/4*3)if (keysPressed[SHIFT]) {
        x -= vx * 2;
        balkX -= vx*2;
      } else {
        x -= vx;
        balkX -= vx;
      }
      if (mouseX > width/2) if (x + w< width - spawnLeftBound/4*3)if (keysPressed[SHIFT]) {
        x += vx * 2;
        balkX += vx *2;
      } else {
        x += vx;
        balkX += vx;
      }
    }
  }

  void draw() {
    image(skins[plInfo.selected], x, y, w, h);
    ////Head
    //fill(#E8D0A9);
    //ellipse(x+ w/2, y - w/4, w/1.5, w/1.5);
    ////Body
    //rect(x+w/4, y, w/2, h);
    //stroke(0);
    //line(x + w/2, y + h/3*2, x + w/2, y + h);
    //noStroke();
    if (devMode) {
      fill(0, 0);
      stroke(255, 0, 0);
      rect(balkX, balkY, balkW, balkH);
      noStroke();
    }
    image(basket, balkX, balkY, balkW, balkH);

    ////Catch rect
    //fill(#674700);
    //rect(balkX, balkY, balkW, balkH);
  }
}

void drawStats() {
  fill(0, 150);
  rect(0, 0, 160, 75);
  textAlign(LEFT, TOP);
  fill(255);
  textSize(20);
  text("Score: "+score, 10, 12);
  text("Lives: "+lives, 10, 42);
}

boolean restartClicked = false;

void dead() {
  drawBackground();

  if (!hsUpdated) {
    hs.update(score, playerName);
    hsUpdated = true;
  }
  hs.draw();

  if (hs.restart) {
    restartClicked = true;
    for (int iCloud = 0; iCloud < clouds.size(); iCloud++) {
      Cloud cloud = clouds.get(iCloud);
      cloud.updateDead();
      if (cloud.x + cloud.radius*3 <= 0 | cloud.x - cloud.radius*33 >= width)
        clouds.remove(iCloud);
    }

    if (clouds.size() <= 0) {
      lives = 10;
      powerups.powerInUse = false;
      powerups.savedPowerUps.clear();

      fruits.clear();
      fruits.add(new Fruit(apple));

      setupBackground();

      score = 0;
      player = new Player(playerWidth, playerHeight, balkWidth, balkHeight, players);

      restartClicked = false;
      hsUpdated = false;
      hs.restart = false;
      if (goToMenu){
         inMenu = true;
         play = false;
         goToMenu = false;
      }
    }
    
  }
}
