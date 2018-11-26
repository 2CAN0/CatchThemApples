class PowerUps {
  String[] powerNames = {"Magnet", "Grow", "SlowMo"};
  ArrayList<String> savedPowerUps = new ArrayList<String>();

  final int MAX_POWERUPS = 3;
  int powerUpCount = 0;

  float x, 
    y, 
    spacing, 
    w, 
    h;

  boolean powerInUse;

  ArrayList<Magnet> magList = new ArrayList<Magnet>();
  ArrayList<Grow> growList = new ArrayList<Grow>();
  ArrayList<SlowMo> slowList = new ArrayList<SlowMo>();
  ArrayList<Slot> slots = new ArrayList<Slot>();

  void update() {
    for (int iMag = savedPowerUps.size(); iMag < magList.size(); iMag++) {
      Magnet mag = magList.get(iMag);
      mag.update();
      mag.draw();
    }

    for (int iGrow = savedPowerUps.size(); iGrow < growList.size(); iGrow++) {
      Grow gro = growList.get(iGrow);
      gro.update();
      gro.draw();
    }

    for (int iSlow = savedPowerUps.size(); iSlow < slowList.size(); iSlow++) {
      SlowMo slowmo = slowList.get(iSlow);
      slowmo.update();
      slowmo.draw();
    }

    if (savedPowerUps.size() < MAX_POWERUPS - 1&& !powerUpTimerStarted) {
      powerUpTimer.start();
      powerUpTimerStarted = true;
    } else if (powerUpTimer.second() >= powerUpSpawnFreq && powerUpTimerStarted) {
      powerUpTimer.stop();
      powerUpTimer = new StopWatchTimer();
      powerUpTimerStarted = false;

      int randomPowerUpIndex = (int)random(0, powerNames.length);
      if (powerNames[randomPowerUpIndex] == "Magnet") {
        magList.add(new Magnet(spawnLeftBound));
      } else if (powerNames[randomPowerUpIndex] == "Grow") {
        growList.add(new Grow(spawnLeftBound));
      } else if (powerNames[randomPowerUpIndex] == "SlowMo") {
        slowList.add(new SlowMo(spawnLeftBound));
      }
    }

    if (keysPressed[ENTER] && savedPowerUps.size() != 0 || powerInUse) {
      if (savedPowerUps.get(0) == powerNames[0]) {
        Magnet mag = magList.get(0);
        mag.use(player);
      } else if (savedPowerUps.get(0) == powerNames[1]) {
        Grow gro = growList.get(0);
        gro.use();
      } else if (savedPowerUps.get(0) == powerNames[2]) {
        SlowMo slowmo = slowList.get(0);
        slowmo.use();
      }
    }

    for (int iSlot = 0; iSlot < MAX_POWERUPS; iSlot++) {
      Slot slot = slots.get(iSlot);
      slot.draw();

      //stroke(255);
      //fill(0,0);
      //rect(slot.x, slot.y, slot.w, slot.h);
      //noStroke();

      try {
        if (savedPowerUps.get(iSlot) == powerNames[0])
          image(magneetje, slot.x, slot.y, slot.w, slot.h);
        else if (savedPowerUps.get(iSlot) == powerNames[1])
          image(mushRoom, slot.x, slot.y, slot.w, slot.h);
        else if (savedPowerUps.get(iSlot) == powerNames[2])
          image(snail, slot.x, slot.y, slot.w, slot.h);
      }
      catch (Exception ex) {
        //Nothing to draw
      }
    }
  }

  PowerUps(float wi, float he) {
    w = wi;
    h = he;
    x = width/2 - w*3/2;
    y = height - slotStrokeWeight - h;
    for (int iSlot = 0; iSlot < MAX_POWERUPS; iSlot++) {
      if (iSlot != 0) {
        x += w;
      }
      slots.add(new Slot(w, h, x, y));
    }
  }


  class Slot {
    float x, 
      y, 
      w, 
      h;

    Slot (float wi, float he, float xLoc, float yLoc) {
      h = he;
      w = wi;
      x = xLoc;
      y = yLoc;
    }

    void draw() {
      stroke(255);
      strokeWeight(slotStrokeWeight);
      fill(0, 0);
      rect(x, y, w, h);
      noStroke();
    }
  }

  class SlowMo {
    float x, 
      y, 
      vy, 
      radius, 
      weight, 
      gravity;

    SlowMo(float spawnLeftBound) {
      x = random(spawnLeftBound, width - spawnLeftBound + 1);
      y = random(-100, 0);
      vy = 1;

      radius = random(10, 31);
      weight = radius*2/5;
      gravity = weight * gravityCon;
    }

    boolean hitDetected(float x1, float y1, float x2, float y2, float x3, float x4, float balkH) {
      boolean x = ((x1 > x2 && x1 < x4)||(x3 > x2 && x3 < x4));
      boolean y = (y1 > y2);
      return (x &&y);
    }

    void use() { 
      powerInUse = true;
      if (!magTimerStarted) {
        magTimer.start();
        magTimerStarted = true;
        slo = true;
      } else if (magTimerStarted) {
        blink();
      }

      if (magTimer.second() >= magTime) {
        slowList.remove(0);
        magTimer.stop();
        savedPowerUps.remove(0);
        magTimer = new StopWatchTimer();
        powerInUse = false;
        magTimerStarted = false; 
        slo = false;
      }
    }

    void update() {
      if (y + radius >= height - groundHeight) {
        slowList.remove(0);
      } else {        
        if (hitDetected(x, y, player.balkX, player.balkY, x + radius*2, player.balkX + player.balkW, player.balkH)) {
          savedPowerUps.add("SlowMo");
        } else {
          y += vy;
          vy += gravity;
        }
      }
    }

    void draw() {
      image(snail, x, y, radius*2, radius*2);
      if (devMode) {
        fill(0, 0);
        stroke(255, 0, 0);
        rect(x, y, radius*2, radius*2);
        noStroke();
      }
    }
  }

  class Grow {
    float x, 
      y, 
      vy, 
      radius, 
      weight, 
      gravity;

    Grow(float spawnLeftBound) {
      x = random(spawnLeftBound, width - spawnLeftBound + 1);
      y = random(-100, 0);
      vy = 1;

      radius = random(10, 31);
      weight = radius*2/5;
      gravity = weight * gravityCon;
    }

    boolean hitDetected(float x1, float y1, float x2, float y2, float x3, float x4, float balkH) {
      boolean x = ((x1 > x2 && x1 < x4)||(x3 > x2 && x3 < x4));
      boolean y = (y1 > y2);
      return (x &&y);
    }

    boolean hasGrown = false;

    void use() {
      powerInUse = true;
      if (!magTimerStarted) {
        magTimer.start();
        magTimerStarted = true;
        gro = true;
      } else if (magTimerStarted) {
        if (!hasGrown) {
          player.balkW = player.balkW * basketGrow;
          player.balkH = player.balkH * basketGrow;
          player.balkX = player.x + player.w/2 - player.balkW/2;
          player.balkY = player.y - player.balkH/1.3;
          hasGrown = true;
        }

        blink();
      }

      if (magTimer.second() >= magTime) {
        growList.remove(0);
        magTimer.stop();
        savedPowerUps.remove(0);
        magTimer = new StopWatchTimer();
        powerInUse = false;
        magTimerStarted = false;
        hasGrown = false;
        gro = false;
        player.balkW = player.balkW / basketGrow;
        player.balkH = player.balkH / basketGrow;
        player.balkX = player.x + player.w/2 - player.balkW/2;
        player.balkY = player.y - player.balkH/2;
      }
    }

    void update() {
      if (y + radius >= height - groundHeight) {
        growList.remove(0);
      } else {        
        if (hitDetected(x, y, player.balkX, player.balkY, x + radius*2, player.balkX + player.balkW, player.balkH)) {
          savedPowerUps.add("Grow");
        } else {
          y += vy;
          vy += gravity;
        }
      }
    }

    void draw() {
      image(mushRoom, x, y, radius*2, radius*2);
      if (devMode) {
        fill(0, 0);
        stroke(255, 0, 0);
        rect(x, y, radius*2, radius*2);
        noStroke();
      }
    }
  }

  class Magnet {
    float x, 
      y, 
      vy, 
      radius, 
      weight, 
      gravity;
    float magRadius, inUseShow, opacity;

    Magnet(float spawnLeftBound) {
      x = random(spawnLeftBound, width - spawnLeftBound + 1);
      y = random(0, -100);
      vy = 1;

      radius = random(10, 31);
      weight = radius*2/5;
      gravity = weight * gravityCon;
      magRadius = magnetRadius;
      inUseShow = magRadius;
      opacity = 255;
    }

    boolean hitDetected(float x1, float y1, float x2, float y2, float x3, float x4, float balkH) {
      boolean x = ((x1 > x2 && x1 < x4)||(x3 > x2 && x3 < x4));
      boolean y = (y1 > y2 && y1 < y2 + balkH);
      return (x && y);
    }

    void use(Player player) {
      //code for magnet active 
      powerInUse = true;
      if (!magTimerStarted) {
        magTimer.start();
        magTimerStarted = true;
        mag = true;
      } else if (magTimerStarted) {
        fill(0, 0);
        stroke(0, 0, 255, opacity);
        ellipse(player.balkX + player.balkW/2, player.balkY + player.balkH/2, inUseShow*2, inUseShow*2);
        noStroke();
        inUseShow -= 2.5;
        opacity -= 3.2;
        if (inUseShow < 0) {
          inUseShow = magRadius;
        }
        if (opacity < 0){
           opacity = 255; 
        }

        if (devMode) {
          fill(0, 0);
          stroke(255, 0, 0);
          ellipse(player.balkX + player.balkW/2, player.balkY + player.balkH/2, magRadius*2, magRadius*2);
          noStroke();
        }
        blink();
      }

      if (magTimer.second() >= magTime) {
        magList.remove(0);
        magTimer.stop();
        savedPowerUps.remove(0);
        magTimer = new StopWatchTimer();
        powerInUse = false;
        magTimerStarted = false;
        mag = false;
      }
    }

    void update() {
      if (y + radius >= height - groundHeight) {
        magList.remove(0);
      } else {        
        if (hitDetected(x, y, player.balkX, player.balkY, x + radius*2, player.balkX + player.balkW, player.balkH)) {
          savedPowerUps.add("Magnet");
        } else {
          y += vy;
          vy += gravity;
        }
      }
    }

    void draw() {
      fill(255, 255, 0);
      image(magneetje, x, y, radius*2, radius*2);
      if (devMode) {
        fill(0, 0);
        stroke(255, 0, 0);
        rect(x, y, radius*2, radius*2);
        noStroke();
      }
    }
  }

  void blink() {
    fill(0, 150);
    remTime = magTime * 1000 - magTimer.getElapsedTime();
    if (remTime <= 4000 && blinked < 4) {
      rect(0, 0, width, height);
      blinked++;
    } else if (remTime <= 3000 && blinked < 8) {
      rect(0, 0, width, height);
      blinked++;
    } else if (remTime <= 2000 && blinked < 12) {
      rect(0, 0, width, height);
      blinked++;
    } else if (remTime <= 1500 && blinked < 14) {
      rect(0, 0, width, height);
      blinked++;
    } else if (remTime <= 1000 && blinked < 16) {
      rect(0, 0, width, height);
      blinked++;
    } else if (remTime <= 500 && blinked < 18) {
      rect(0, 0, width, height);
      blinked++;
    } else if (remTime <= 250 && blinked < 19) {
      rect(0, 0, width, height);
      blinked++;
    } else if (remTime <= 0 && blinked < 20) {
      rect(0, 0, width, height);
      blinked++;
    } 
    if (remTime < 0) {
      blinked = 0;
      remTime = magTime;
    }
  }
}
