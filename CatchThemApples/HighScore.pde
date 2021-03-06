class HighScore {
  Table scores;
  String fileLocation;
  int maxScores;
  PVector size;
  boolean restart = false;
  MiniMenu mm;

  HighScore(Table s, String fL, int mS, float w, float h) {
    scores = s;
    fileLocation = fL;
    maxScores = mS;
    size = new PVector(w, h);
    mm = new MiniMenu(opt);
  }

  void update(double s, String n) {
    sortTable(scores, s, n);
    while (scores.getRowCount() > maxScores) {
      scores.removeRow(scores.getRowCount() - 1);
    }

    int iRow = 0;
    for (TableRow r : scores.rows()) {
      r.setInt(0, iRow);
      iRow++;
    }
    save();
  }

  void drawScores() {
    fill(0, 100);
    rect(width/2 - size.x/2, height/2 - size.y/1.5, size.x, size.y);
    textAlign(CENTER, TOP);
    fill(255);
    textSize(30);
    text("Highscores", width/2, height/2 - size.y/1.5 + 15);
    int fontSize = 25;
    textSize(fontSize);
    float scoreY = height/2 - size.y/1.5 + fontSize*3.15;
    for (int iScore = 0; iScore < scores.getRowCount(); iScore++) {
      textAlign(LEFT, CENTER);
      TableRow tr = scores.getRow(iScore);
      if (tr.getInt("score") == score && tr.getString("name") == playerName){
         fill(255,255,0); 
      } else {
         fill(255); 
      }
      text((tr.getInt(0) + 1)+".", width/2 - size.x/2 + 10, scoreY);
      textAlign(CENTER, CENTER);
      text(tr.getString("name"), width/2, scoreY);
      textAlign(RIGHT, CENTER);
      text((int)Float.parseFloat(tr.getString("score")), width/2 + size.x/2 - 10, scoreY);

      scoreY += fontSize + fontSize/3;
    }
  }

  void draw() {
    drawScores();
    mm.update();
    mm.draw();
  }

  void save() {
    try {
      saveTable(scores, fileLocation);
      println("Saved succesfully");
    } 
    catch (Exception ex) {
      println("Something went wrong while saving the table");
      println("Error: "+ex.getMessage());
    }
  }

  void read() {
    for (TableRow r : scores.rows()) {
      println("ID: "+r.getInt(0)+"    Name: "+r.getString(1)+"    Score: "+ r.getDouble(2));
    }
  }

  Table sortTable(Table t, double high, String nam) {
    TableRow previous;
    int hD = t.getInt(t.getRowCount() - 1, 0);
    String hN = nam;
    double hS = high;

    int d;
    String n;
    double s;

    for (int iRow = t.getRowCount() - 2; iRow >= 0; iRow--) {
      previous = t.getRow(iRow);
      d = previous.getInt(0);
      n = previous.getString(1);
      s = previous.getDouble(2);
      if (hS > s) {
        t.setInt(iRow, 0, hD);
        t.setString(iRow, 1, hN);
        t.setDouble(iRow, 2, hS);

        t.setInt(iRow + 1, 0, d);
        t.setString(iRow + 1, 1, n);
        t.setDouble(iRow + 1, 2, s);
      }
    }
    return t;
  }


  String[] opt = {"Play", "Main"};

  class MiniMenu {
    int AmountButtons;
    int selectedIndex = 0;
    int spacing = 30;

    String[] options;
    String gameName;
    ArrayList<Button> buttons = new ArrayList<Button>();
    boolean changedSelected = false;

    MiniMenu(String[] text) {
      options = new String[text.length];
      options = text;
      
      AmountButtons = options.length;
      float tempW = 250;
      float tempH = 75;
      float tempX = width/2 - tempW * (AmountButtons/2);
      float tempY = height/2 + size.y/2;

      for (int iButton = 0; iButton < AmountButtons; iButton++) {
        if (iButton == 0) {
          buttons.add(new Button(tempX, tempY + tempH/2, tempW, tempH, options[iButton]));
          Button btn = buttons.get(0);
          btn.selected = true;
        } else {
          Button btn = buttons.get(iButton - 1);
          buttons.add(new Button(btn.location.x + tempW + spacing, tempY + tempH/2, tempW, tempH, options[iButton]));
        }
      }
    }

    void update() {
      if (keysPressed[LEFT] && selectedIndex > 0 && !changedSelected) {
        selectedIndex--;
        Button btn1 = buttons.get(selectedIndex);
        btn1.selected = true;
        Button btn2 = buttons.get(selectedIndex + 1);
        btn2.selected = false;
        changedSelected = true;
      }

      if (keysPressed[RIGHT] && selectedIndex < options.length - 1 && !changedSelected) {
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
          restart = true;
        } else if (btn.text == options[1]) {
          restart = true;
          goToMenu = true;
        }
      }
    }

    void draw() {
      Button tBtn = buttons.get(0);
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
          fill(0,100);
          noStroke();
        }
        
        noStroke();
        rect(location.x, location.y, size.x, size.y);
        fill(255);
        textSize(30);
        textAlign(CENTER, CENTER);
        text(text, location.x + size.x/2, location.y + size.y/2);
        noStroke();
      }
    }
  }
}
