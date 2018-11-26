class Menu {
  int AmountButtons;
  int selectedIndex = 0;
  int spacing = 30;

  String[] options;
  String gameName;
  ArrayList<Button> buttons = new ArrayList<Button>();
  boolean changedSelected = false;

  Menu(String[] text, String GN) {
    options = new String[text.length];
    options = text;

    gameName = GN;

    AmountButtons = options.length;
    float tempW = 250;
    float tempH = 75;
    float tempX = width/2;
    float tempY = height / 2 - tempH *(AmountButtons/2);

    for (int iButton = 0; iButton < AmountButtons; iButton++) {
      if (iButton == 0) {
        buttons.add(new Button(tempX - tempW/2, tempY, tempW, tempH, options[iButton]));
        Button btn = buttons.get(0);
        btn.selected = true;
      } else {
        Button btn = buttons.get(iButton - 1);
        buttons.add(new Button(tempX - tempW/2, btn.location.y + tempH + spacing, tempW, tempH, options[iButton]));
      }
    }
  }

  void update() {
    if (keysPressed[UP] && selectedIndex > 0 && !changedSelected) {
      selectedIndex--;
      Button btn1 = buttons.get(selectedIndex);
      btn1.selected = true;
      Button btn2 = buttons.get(selectedIndex + 1);
      btn2.selected = false;
      changedSelected = true;
    }

    if (keysPressed[DOWN] && selectedIndex < options.length - 1 && !changedSelected) {
      selectedIndex++;
      Button btn1 = buttons.get(selectedIndex);
      btn1.selected = true;
      Button btn2 = buttons.get(selectedIndex - 1);
      btn2.selected = false;
      changedSelected = true;
    }

    if (keysPressed[ENTER] && !enterPressed) {
      enterPressed = true;
      Button btn = buttons.get(selectedIndex);
      if (btn.text == options[0]) {
        inMenu = false;
        play = true;
      } else if (btn.text == options[2]) {
        exit();
      } else if (btn.text == options[1]) {
        inShop = true;
        inMenu = false;
      }
    }
  }

  void draw() {
    Button tBtn = buttons.get(0);
    textSize(75);
    textAlign(CENTER, CENTER);
    text(gameName, width/2, tBtn.location.y/2);
    textAlign(LEFT, TOP);
    for (int iButton = 0; iButton < AmountButtons; iButton++) {
      Button btn = buttons.get(iButton);
      btn.draw();
    }
  }

  class Button {
    PVector location, size;
    String text;
    boolean selected;

    Button(float x, float y, float w, float h, String info) {
      location = new PVector(x, y);
      size = new PVector(w, h);
      text = info;
    }

    boolean mouseHover() {
      boolean x = (mouseX > location.x && mouseX < location.x + size.x);
      boolean y = (mouseY > location.y && mouseY < location.y + size.y);
      return (x && y);
    }

    void draw() {

      if (selected) {
        fill(255, 50);
        noStroke();
        rect(location.x, location.y, size.x, size.y);
        stroke(255);
        strokeWeight(4);
        int mini = 4;
        //Left Upper
        line(location.x, location.y, location.x + size.y/mini, location.y);
        line(location.x, location.y, location.x, location.y + size.y/mini);

        //Left Lower
        line(location.x, location.y + size.y, location.x, location.y + size.y - size.y/mini);
        line(location.x, location.y + size.y, location.x + size.y/mini, location.y + size.y);

        //Right Upper
        line(location.x + size.x, location.y, location.x + size.x - size.y/mini, location.y);
        line(location.x + size.x, location.y, location.x + size.x, location.y + size.y/mini);

        //Right Lower
        line(location.x + size.x, location.y + size.y, location.x + size.x - size.y/mini, location.y+ size.y);
        line(location.x + size.x, location.y + size.y, location.x + size.x, location.y + size.y - size.y/mini);
      } else {
        fill(0, 100);
        noStroke();
        rect(location.x, location.y, size.x, size.y);
      }

      fill(255);
      textSize(30);
      textAlign(CENTER, CENTER);
      text(text, location.x + size.x/2, location.y + size.y/2);
    }
  }
}

void menuCharacter() {
  if (!charIsSet) {
    aniChar = (int)Math.floor(random(0, players.length)); 
    aniLocation.x = 0 - playerWidth;
    charIsSet = true;
    aniMovingLeft = false;
  } else {
    aniLocation.add(aniVelocity);
    image(players[aniChar], aniLocation.x, aniLocation.y, playerWidth, playerHeight);

    if (aniLocation.x >= width + playerWidth&& !aniMovingLeft) {
      aniVelocity.x *= -1;
      aniChar = (int)Math.floor(random(0, players.length));
      aniMovingLeft = true;
    } else if (aniLocation.x <= 0 - playerWidth && aniMovingLeft) {
      aniVelocity.x *= -1;
      aniChar = (int)Math.floor(random(0, players.length));
      aniMovingLeft = false;
    }
  }
}
