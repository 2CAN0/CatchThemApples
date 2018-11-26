class NameCreater {
  PVector position;
  float size;
  int fontSize;
  int selectedIndex = 0;
  boolean changed = false;

  ArrayList<character> chars = new ArrayList<character>();

  NameCreater(float amount) {
    position = new PVector(width/2, height/2);
    size = amount;
    fontSize = 40;
    for (int iChar = 0; iChar < size; iChar++) {
      if (iChar == 0) {
        try {
          chars.add(new character(width/2 - size/2*fontSize, height/2, playerName.charAt(iChar)));
        }
        catch (Exception ex) {
          chars.add(new character(width/2 - size/2*fontSize, height/2, char('a')));
        }
      } else {
        character prChar = chars.get(iChar - 1);
        try {
          chars.add(new character(prChar.position.x + 5 + fontSize, height/2, playerName.charAt(iChar)));
        } 
        catch (Exception ex) {
          chars.add(new character(prChar.position.x + 5 + fontSize, height/2, char(' ')));
        }
      }
    }
  }

  void update() {
    if (keysPressed[LEFT] && selectedIndex > 0 && !changed) {
      selectedIndex--;
      changed = true;
      character prevC = chars.get(selectedIndex + 1);
      prevC.selected = false;
    }
    if (keysPressed[RIGHT] && selectedIndex < size - 1 && !changed) {
      selectedIndex++;
      changed = true;
      character prevC = chars.get(selectedIndex - 1);
      prevC.selected = false;
    }

    if (keysPressed[ENTER] && !enterPressed) {
      enterPressed = true;
      nameCreated = true;
      playerName = "";
      for (character t : chars) {
        playerName += char(t.charCode);
      }
      plInfo.info.setString(0, 4, playerName);
      plInfo.save();
    } else {   
      character c = chars.get(selectedIndex);
      c.selected = true;
      c.update();
    }
  }

  void draw() {
    for (int iChar = 0; iChar < size; iChar++) {
      character c = chars.get(iChar);
      c.draw();
    }
    textAlign(CENTER,CENTER);
    text("Press Enter to continue", width/2, height - groundHeight/2.5);
    textAlign(TOP, LEFT);
  }

  class character {
    int charCode;
    PVector position;
    boolean selected = false;

    character(float x, float y, char d) {
      charCode = char(d);
      position = new PVector(x, y);
    }

    void update() {
      if (selected) {
        if (keysPressed[DOWN] && !changed) {
          charCode++;
          changed = true;
        }
        if (keysPressed[UP] && !changed) {
          charCode--;
          changed = true;
        }

        if (keyPressed && !changed) {
          charCode = char(keyCode);
        }
      }
    }

    void draw() {      
      if (selected) {
        fill(255, 50);
        rect(position.x, position.y - fontSize*1.5, fontSize, fontSize*1.5);
      }

      fill(255);
      stroke(255);
      line(position.x, position.y, position.x + fontSize, position.y);
      textSize(fontSize);
      textAlign(LEFT, BOTTOM);
      text(char(charCode), position.x, position.y);
    }
  }
}
