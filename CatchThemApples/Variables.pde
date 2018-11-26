//Development Options
boolean devMode = false;

//Gravity
final float gravityCon = 0.01713;

//Main
final int MAX_KEYSPRESSED = 1024;
final int MAX_SCORES = 10;
final int MAX_NAMELENGTH = 8;
PFont font;
int countDownTime = 5; //In seconds
boolean[] keysPressed = new boolean[MAX_KEYSPRESSED];
boolean mouseDown = false; //for android version later on
boolean countDone = false;
boolean inMenu = true;
boolean play = false;
boolean inShop = false;
boolean enterPressed = false;
boolean hsUpdated = false;
boolean goToMenu = false;
boolean nameCreated = false;
String[] options = {"Play", "S h o p", "E x i t"};
String hsLocation = "data/highScore.csv";
float minFrame = 80; //Prefert fps
Player player;
PlayerInfo plInfo;
StopWatchTimer countdown = new StopWatchTimer();
Menu mn;
HighScore hs;
NameCreater nc;

//Sound




//Fruits
int spawTimeIncreament = 5; //Used to increase the spawnTime
int spawnTime = 15; //Used to add an extra fruit object
float spawnLeftBound;
float spawnRightBound;
PImage apple;
StopWatchTimer timer = new StopWatchTimer();

//PowerUps
int powerUpCount = 2;
int magTime = 10; //Time in seconds
int powerUpSpawnFreq = 10; //Power up spawn frequencie in seconds
float basketGrow = 1.5;
float magnetRadius = 200;
float slowDown = 4;
float powerUpSlotW = 50;
float powerUpSlotH = powerUpSlotW;
float powerUpSlotSpacing = 15;
float slotStrokeWeight = 3;
float remTime = 0;
float blinked = 0 ;
boolean powerUpTimerStarted = false;
boolean magTimerStarted = false;
boolean hasBeenSlowedDown = false;
boolean mag = false;
boolean gro = false;
boolean slo = false;
PImage magneetje;
PImage snail;
PImage mushRoom;
PowerUps powerups;
StopWatchTimer magTimer = new StopWatchTimer();
StopWatchTimer powerUpTimer = new StopWatchTimer();


//Player
int score = 0;
int lives = 10;
float playerWidth = 100;
float playerHeight = 100;
float balkWidth = 140;
float balkHeight = 60;
String[] charN = {"blocky", "viking", "adventure", "boy", "girl"}; //Use the fileNames for the char name and make sure your file is a .png
String playerName;
PImage chara; //char image
PImage[] players = new PImage[charN.length];
PImage basket;

//Player Selecter
float pSkinZoom = 1.5;
float pSkinH = playerHeight*pSkinZoom;
float pSkinW = playerWidth*pSkinZoom;
float pSkinX;
float pSkinY;
float skinBtnSize = 40;
String plInfoLoc = "data/info.csv";
Selector skinSelecter;

//Background
final int MAX_CLOUDS = 5;
float groundHeight = 125;
float tileSize = groundHeight;
PImage sun;
PImage bg;
PImage tileTexture;

//Animation
int aniChar = 0;
PVector aniLocation;
PVector aniVelocity;
boolean hitSide = false;
boolean aniMovingLeft = false;
boolean charIsSet = false;

void setupImages() {
  //Main
  font = loadFont("8Bit.vlw");
  textFont(font);
  mn = new Menu(options, "Catch Them Apples");
  hs = new HighScore(loadTable(hsLocation, "header"), hsLocation, MAX_SCORES, 350, 400);
  plInfo = new PlayerInfo(loadTable(plInfoLoc, "header"), plInfoLoc);
  playerName = plInfo.info.getString(0, 4);
  nc = new NameCreater(MAX_NAMELENGTH);

  //PowerUps


  //Fruits
  apple = loadImage("apple.png");

  //Player
  for (int iSkin = 0; iSkin < charN.length; iSkin++) {
    chara = loadImage(charN[iSkin]+".png");
    players[iSkin] = chara;
  }
  basket = loadImage("basket.png");  
  pSkinX = width/2;
  pSkinY = height - groundHeight - pSkinH/2;
  skinSelecter = new Selector(pSkinX, pSkinY, pSkinW, pSkinH, skinBtnSize, plInfo.selected, charN, players);

  //PowerUps
  magneetje = loadImage("magnet.png");
  snail = loadImage("snail.png");
  mushRoom = loadImage("grow.png");
  powerups =  new PowerUps(powerUpSlotW, powerUpSlotH);

  //Background
  spawnLeftBound = width*0.375;
  spawnRightBound = width - spawnLeftBound;
  sun = loadImage("sun.png");
  bg = loadImage("background.png");
  tileTexture = loadImage("ground_texture.png");
  
  //Animation Menu
  aniLocation = new PVector(0 - playerWidth,height - groundHeight - playerHeight);
  aniVelocity = new PVector(5,0);
}
