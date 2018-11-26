class Fruit {
  PVector location, velocity;
  float  radius, 
    weight, 
    gravity;

  PImage fruit;
  boolean magHit = false;

  Fruit(PImage fruitSort) {
    location = new PVector(random(spawnLeftBound, spawnRightBound), random(-100, 0));
    velocity = new PVector(0, 0.2);

    radius = random(10, 31);

    weight = radius*2/5;
    gravity = 0.01813* weight;
    fruit = fruitSort;
  }

  void reset() {
    location = new PVector(random(spawnLeftBound, spawnRightBound), random(-100, 0));
    velocity = new PVector(0, 0.2);

    radius = random(25, 31);

    weight = radius*2/5;
    gravity = gravityCon * weight;
    magHit = false;
  }

  void update() {
    if (location.y + radius >= height - groundHeight || location.x + radius < 0 || location.x - radius > width) {
      reset();
      if (!devMode && !magHit) {
        lives--;
      }
    }

    if (!magHit && !slo) {
      location.y += velocity.y;
      velocity.y += gravity;
    }

    if (magTimerStarted && mag) {
      if (magHitDetected(player, this)) {
        velocity.x = (player.balkX - location.x)/15;
        velocity.y = (player.balkY - location.y)/15;
        location.x += velocity.x;
        location.y += velocity.y;
        magHit = true;
      }
    } else if (magTimerStarted && slo) {
      float nVy = velocity.y /slowDown;
      nVy = (nVy < 1) ? 1 : nVy;
      location.y += nVy;
      nVy += gravity;
      velocity.y += gravity;
    } else 
      magHit = false;
    

    if (keysPressed[32])devMode = (devMode)? false : true;
  }

  void draw() {
    fill(255, 0, 0);
    image(fruit, location.x, location.y, radius*2, radius*2);

    if (devMode) {
      fill(255, 0);
      stroke(255, 0, 0);
      rect(location.x, location.y, radius*2, radius*2);
      noStroke();

      fill(255);
      textAlign(RIGHT, BOTTOM);
      text("DevMode", width, height );
    }
  }
  boolean magHitDetected(Player player, Fruit obj) {
    float a = player.balkX + player.balkW/2 - obj.location.x;
    float b = player.balkY + player.balkH/2 - obj.location.y;
    float c = sqrt(a*a+b*b);
    float distance = c - magnetRadius - obj.radius;

    return (distance <= 0);
  }

  boolean hitDetected(float x1, float y1, float x2, float y2, float x3, float x4) {
    boolean x = ((x1 > x2 && x1 < x4)||(x3 > x2 && x3 < x4));
    boolean y = (y1 > y2);
    return (x && y);
  }
}

ArrayList<Fruit> fruits = new ArrayList<Fruit>();
void setupFruit() {
  fruits.add( new Fruit(apple));
  timer.start();
}

void drawFruit() {
  if (timer.second() == spawnTime) {
    fruits.add(new Fruit(apple));
    timer = new StopWatchTimer();
    timer.start();
    spawnTime += spawTimeIncreament;
  }

  for (int iFruit = 0; iFruit < fruits.size(); iFruit++) {
    Fruit fr = fruits.get(iFruit);   
    if (fr.hitDetected(fr.location.x, fr.location.y+ fr.radius*2, player.balkX, player.balkY, fr.location.x + fr.radius*2, player.balkX + player.balkW)) {
      score += 1;
      fr.reset();
    } else {
      fr.update();
      fr.draw();
    }
  }
}
