World world;
Camera camera;

PImage[] playerTextures;
PImage[] enemyTextures;
PImage[] bulletTextures;
PImage[] groundTexturesTop;
PImage[] groundTexturesSide;


void setup() {
  size(640, 640, P3D);
  colorMode(RGB, 1.0f);
  textureMode(NORMAL); // uses normalized 0..1 texture coords
  playerTextures = new PImage[]{loadImage("assets/player1.png"), loadImage("assets/player2.png")};
  enemyTextures = new PImage[]{loadImage("assets/enemy1.png"), loadImage("assets/enemy2.png")};
  bulletTextures = new PImage[]{loadImage("assets/laserP.png"), loadImage("assets/laserE.png")};
  groundTexturesTop = new PImage[]{loadImage("assets/crateTop1.png"), loadImage("assets/crateTop2.png")};
  groundTexturesSide = new PImage[]{loadImage("assets/crateSide1.png"), loadImage("assets/crateSide2.png")};
  textureWrap(REPEAT);
  frameRate(60);
  noStroke();
  
  world = new World();
  camera = new Camera(new PVector(0, 0, 2*SCALE));
  
  setupPOGL(); // setup our hack to ProcesingOpenGL to let us modify the projection matrix manually 
}


void draw() {
  clear();
  
  world.run();
  camera.enableMovement(); // for debugging purpose
}
