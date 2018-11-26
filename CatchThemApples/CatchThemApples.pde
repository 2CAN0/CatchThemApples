//Ook rotte appels toevoegen

void setup() {
  size(1600, 900, P2D);
  frameRate(80);
  smooth();
  noStroke();
  noCursor();
  orientation(PORTRAIT);
  countdown.start();
  setupImages();
  player = new Player(playerWidth, playerHeight, balkWidth, balkHeight, players);
  setupFruit();
  setupBackground();
}

void draw() {
  drawBackground();
  if (!nameCreated) {
    nc.update();
    nc.draw();
  } else if (inMenu) {
    mn.update();
    mn.draw();
    menuCharacter();
  } else if (play) {
    if (countdown.second() == 5 && !countDone) {
      countDone = true;
      countdown.stop();
    }

    if (lives > 0) {
      powerups.update();

      player.update();
      player.draw();  
      drawFruit();

      if (slo) {
        fill(95, 242, 128, 80);
        rect(0, 0, width, height);
      }

      drawStats();

      if (devMode) {
        if (countDone) {
          if (frameRate < minFrame)
            minFrame = frameRate;
        }
      }
    } else {
      dead();
    }
  } else if (inShop) {
    skinSelecter.update();
    skinSelecter.draw();
  }

  if (devMode) {
    textAlign(RIGHT, TOP);
    if (frameRate <= 80 - 5) {
      fill(255, 0, 0);
    } else
      fill(255);
    text("FPS: "+frameRate, width, 0);
    println(minFrame);
  }
}

void mouseReleased() {
  mouseDown = false;
  if (inShop)
    skinSelecter.clicked = false;
}

void mousePressed() {
  mouseDown = true;
}

void keyPressed() {
  keysPressed[keyCode] = true;
}

void keyReleased() {
  keysPressed[keyCode] = false;
  if (inMenu)
    mn.changedSelected = false;
  if (!play) {
    skinSelecter.clicked = false;
  } 
  if (!nameCreated)
    nc.changed = false;
  hs.mm.changedSelected = false; 
  enterPressed = false;
}
