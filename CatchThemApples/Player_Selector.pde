class Selector {
  int selectedChar;
  String[] charNames;
  PImage[] characters;
  Button btnLeft;
  Button btnRight;
  boolean clicked = false;
  PVector location, size;
  
  void update() {
    if ((mousePressed && btnLeft.hover()) || keysPressed[LEFT] && selectedChar > 0 && !clicked){
        selectedChar--;
        clicked = true;
    } else if ((mousePressed && btnRight.hover()) || keysPressed[RIGHT] && selectedChar  < charNames.length - 1 && !clicked){
        selectedChar++;
        clicked = true;
    }
    
    if (keysPressed[ENTER] && !enterPressed){
       plInfo.selected = selectedChar;
       plInfo.update();
       plInfo.read();
       plInfo.save();
       inMenu = true;
       inShop = false;
       enterPressed = true;
    }
  }
  
  void readSelected(){
     println("CharID: "+selectedChar+"    CharName: "+charNames[selectedChar]); 
  }
  
  void drawButton() {
    textAlign(CENTER, CENTER);
    text("Press enter to select", width/2, height - groundHeight/2.5);
    btnLeft.update();
    btnLeft.draw();
    btnRight.update();
    btnRight.draw();
  }
  
  void draw(){
    imageMode(CENTER);
    image(characters[selectedChar], location.x, location.y, size.x, size.y);
    imageMode(CORNER);
    drawButton();
  }
  
  Selector(float pX, float pY, float pW, float pH, float sI, int sC, String[] names, PImage[] chars) {
     btnLeft = new Button(width/2 - 150, pY, sI, "left");
     btnRight = new Button(width/2 + 150, pY, sI, "right");
     selectedChar = sC;
     charNames = names;
     characters = chars;
     location = new PVector(pX, pY);
     size = new PVector(pW, pH);
  }
  
  class Button {
    PVector location;
    float size;
    boolean left = false;

    Button(float x, float y, float s, String d) {
      location = new PVector(x, y);
      size = s;
      left = (d.toLowerCase() == "left");
    }

    boolean hover() {
      float dX = mouseX - location.x;
      float dY = mouseY - location.y;
      float d = (dY*dY + dX*dX) - size*size;

      return (d <= 0);
    }

    void update() {
      if (hover())
        fill(180);
      else
        fill(255);
        
      if (left && selectedChar == 0)
        fill(180,100);
      else if (!left && selectedChar == charNames.length - 1) 
        fill(180, 100);
    }

    void draw() {
      noStroke();
      if (left)
        triangle(location.x - size/2, location.y, location.x + size/2, location.y - size/2, location.x + size/2, location.y + size/2);
      else
        triangle(location.x + size/2, location.y, location.x - size/2, location.y - size/2, location.x - size/2, location.y + size/2);
    }
  }
}
