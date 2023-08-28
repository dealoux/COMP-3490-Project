import java.util.Stack;  // useful for your matrix stack
Stack<PMatrix3D> matrixStack = new Stack<PMatrix3D>();

// Global matrices
PMatrix3D viewPortMatrix;
PMatrix3D projectionMatrix;
PMatrix3D viewMatrix;
PMatrix3D modelMatrix; 
Camera camera; // class is defined in Transforms2D

void setup() {
  size(640, 640);  // don't change / don't use P3D renderer
  colorMode(RGB, 1.0f);
  
  // put your setup in here
  camera = new Camera(new PVector(0, 0, 1), 1, PI/2); // default camera
  camera.UpdateViewMatrix(); // default view matrix
  viewPortMatrix = getViewPort(); // default viewport matrix
  modelMatrix = projectionMatrix = new PMatrix3D(); // default model & projection matrix
  pipe();
  announceOrthoMode();
  announceTestMode();
}


// uses Processing's beginShape/endShape commands, not working
// on the raster directly any more.
// use stroke/fill, etc., as documented in the Processing API reference.
void draw() {  
  clear();

  // HELLO world, so to speak
  // draw a line from the top left to the center, in Processing coordinate system
  //  highlights what coordinate system you are currently in.
  stroke(1, 1, 1);
  beginShape(LINES);
  stroke(0,1,0);
  myVertex(0, 0);
  myVertex(width/2, height/2);
  endShape();

  switch (testMode) {
  case PATTERN:
    drawTest(1000); // scale 1000 units
    drawTest(100);
    drawTest(1);
    break;

  case SCENE:
    drawScene();
    break;

  case STARFIELD:
    resetMatrices();
    pipe();
    moveStars();
    drawStars();
    break;
  }
}

void drawScene(){
  drawFlowerBed(1.5, .05);
}

void mouseDragged()
{
  // calculates how much the mouse dragged since the last event
  // -- Processing UI interface, this gives you percentages across the screen
  float xMove = (mouseX-pmouseX) / (float)width;
  float yMove = (mouseY-pmouseY) / (float)height;
  
  // do something with the mouse move information here
  int orthoSize = orthoMode == OrthoMode.IDENTITY ? 2 : 640;
  xMove *= orthoSize;
  yMove *= orthoSize;

  camera.UpdateCentre(xMove, yMove);
}

PMatrix3D getViewPort(){
  PMatrix3D scale = getScale(width/2, -height/2, 0);
  PMatrix3D translateToBottomCorner = getTranslate(width/2, height/2, 0);
  
  scale.preApply(translateToBottomCorner);
  return scale;
}

PMatrix3D getOrtho(float left, float right, float bottom, float top){  
  //PVector centre = new PVector(-(left+right)/2, -(top+bottom)/2, -(far+near)/2);
  
  PMatrix3D translateToCentre = getTranslate(-(left+right)/2, -(top+bottom)/2, 0); 
  PMatrix3D scale = getScale(2/(right-left), 2/(top-bottom), 0);
  PMatrix3D flipToLHS = new PMatrix3D(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1);
  
  // multiply the matrices together and return the result
  translateToCentre.preApply(scale);
  translateToCentre.preApply(flipToLHS);
  return translateToCentre; 
    
  //return  new PMatrix3D(2/(right-left), 0, 0, -(right+left)/(right-left), 0, 2/(top-bottom), 0, -(top+bottom)/(top-bottom), 0, 0, 0, 0, 0, 0, 0, 1);
}

PMatrix3D getCamera(PVector up, PVector centre, float zoom){
  //PVector perp = new PVector(up.y, -up.x);
  
  PMatrix3D translateToCentreInverse = getTranslate(-centre.x, -centre.y, 0); 
  PMatrix3D scaleInverse = getScale(1/zoom, 1/zoom, 0);
  PMatrix3D basisInverse = new PMatrix3D(up.y, -up.x, 0, 0, up.x, up.y, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1); 
  
  //// multiply the matrices together and return the result
  translateToCentreInverse.preApply(scaleInverse);
  translateToCentreInverse.preApply(basisInverse);
  return translateToCentreInverse;
}


// Task 3
void myPush(){
  matrixStack.push( modelMatrix.get() );
}

void myPop(){
  modelMatrix.set( matrixStack.pop() );
}

void myRotate(float theta){
  modelMatrix.apply( getRotate(theta) );
}

void myScale(float s){
  modelMatrix.apply( getScale(s, s, 1) );
}

void myTranslate(float tx, float ty){
  modelMatrix.apply( getTranslate(tx, ty, 0) );
}

// draw a flower bed, resizble, call drawFlowers() to draw multiple flowers, then rotate & translate them 
void drawFlowerBed(float bedSize, float bedHeight){
  color stemColour = color(.4, .8, .3);
  float angleStep = PI/3.5;
  
  // draw the flower bed
  stroke(color(139,69,19));
  fill(color(139,69,19));
  beginShape();
    myVertex(bedSize/2, -bedHeight);
    myVertex(bedSize/2, 0);
    myVertex(-bedSize/2, 0);
    myVertex(-bedSize/2, -bedHeight);
    myVertex(bedSize/2, -bedHeight);
  endShape();
  
  // draw the flowers
  // draw the middle flowers pack
  myPush();
  
  myRotate(-angleStep);
  drawFlower(6, 2, color(.8, .4, .4), color(.2, .6, .3), stemColour);
  
  myRotate(angleStep);
  drawFlower(10, 1, color(.4, .5, .7), color(.1, .3, .4), stemColour);
  
  myRotate(angleStep);
  drawFlower(4, 3, color(.2, .2, .6), color(.7, .1, .3), stemColour);
  myPop();
  
  
  // draw the right flowers pack
  myPush();
  
  myTranslate(-.75, 0);
  myRotate(PI/3);
  
  myRotate(-angleStep);
  drawFlower(16, 1, color(.7, 0, .3), color(.4, .2, .6), stemColour);
  
  myRotate(angleStep);
  drawFlower(14, 1, color(.4, .5, .7), color(.7, .2, .8), stemColour);
  
  myRotate(angleStep);
  drawFlower(8, 1, color(.8, .2, .3), color(.5, .7, .6), stemColour);
  
  myPop();
  
  // draw the left flowers pack
  myPush();
  
  myTranslate(.75, 0);
  myRotate(-PI/3);
  
  myRotate(-angleStep);
  drawFlower(8, 2, color(.4, .7, .6), color(.2, .5, .7), stemColour);
  
  myRotate(angleStep);
  drawFlower(12, 1, color(.6, .2, .4), color(.3, 0, .4), stemColour);
  
  myRotate(angleStep);
  drawFlower(6, 1, color(.2, .2, .6), color(.6, .8, .3), stemColour);
  myPop();
  
  myPush();
  myTranslate(.75, 0);
  
  myPop();
}

// call the drawFlowerFace(), drawStem(), rescale, rotate and translate appropriately to draw a whole complete flower
void drawFlower(int petals, int petal_k, color faceColour, color petalColour, color stemColour){
  // draw the stem
  drawStem(stemColour, .025);
  
  // draw the flower face, scale it down by 4 and move up by 0.5 on the y axis
  myPush();
  myTranslate(0, .5);
  myScale(.25);
  drawFlowerFace(petals, petal_k, petalColour, .15, faceColour);
  
  myPop();
}

// draw a flower stem, colour it with the given colour, resizable
void drawStem(color stemColour, float stemWidth){
  stroke(stemColour);
  fill(stemColour);
  beginShape();
    myVertex(stemWidth/2, .5);
    myVertex(stemWidth/2, 0);
    myVertex(-stemWidth/2, 0);
    myVertex(-stemWidth/2, .5);
    myVertex(stemWidth/2, .5);
  endShape();
}

// call drawPetal() to draw multiple petals, draw a polygon flower face, colour them with the given colours
void drawFlowerFace(int petals, int petal_k, color petalColour, float faceSize, color faceColour){
  float step = TWO_PI/petals; // step for petal rotation
  
  // draw the petals
  myPush();
  
  for(int i=0; i < petals; i++){
    myRotate(step);
    drawPetal(petal_k, petalColour);
  }
  
  myPop();
  
  // draw the face
  stroke(faceColour);
  fill(faceColour);
  beginShape();
    myVertex(faceSize/2, faceSize);
    myVertex(-faceSize/2, faceSize);
    myVertex(-faceSize, faceSize/2);
    myVertex(-faceSize, -faceSize/2);
    myVertex(-faceSize/2, -faceSize);
    myVertex(faceSize/2, -faceSize);
    myVertex(faceSize, -faceSize/2);
    myVertex(faceSize, faceSize/2);
    myVertex(faceSize/2, faceSize);
  endShape();
}

// draw a single petal, colour it with the given colour
void drawPetal(int petal_k, color petalColour){  
  float x = .1 * petal_k;
  float y = .8;
  
  stroke(petalColour);
  fill(petalColour);
  beginShape();
    myVertex(0, 0);
    myVertex(x, y);
    myVertex(-x, y);
    myVertex(0, 0);
  endShape();
}


// Task 5
// indicies to traverse the stars array
final static int X = 0;
final static int Y = 1;
final static int Z = 2;
final static int W = 3;

final static float movementSpeed = 3f; // stars movement spped
final static float fieldWidthHalf = 320;
final static float fieldHeightHalf = 320;
final static float fieldRange = 500;

final static int STARS = 5000;
float[][] stars = new float[STARS][4];

// reset all the matrices, except the viewport one, back to identity
void resetMatrices(){
  //viewPortMatrix.reset();
  projectionMatrix.reset();
  viewMatrix.reset(); 
  modelMatrix.reset(); 
}

PMatrix3D viewFrustum(float left, float right, float bottom, float top, float near, float far){  
  return new PMatrix3D(2*near/(right-left), 0, (right+left)/(right-left), 0, 0, 2*near/(top-bottom), (top+bottom)/(top-bottom), 0, 0, 0, -(far+near)/(far-near), -2*far/(far-near), 0, 0, -1, 0);
}

void GenerateRandomPoints(){
  for(float[] star : stars){
    star[X] = random(-fieldWidthHalf, fieldWidthHalf);
    star[Y] = random(-fieldHeightHalf, fieldHeightHalf);
    star[Z] = random(-fieldRange, 0);
    star[W] = 1;
  }
}

void moveStars(){  
  for(float[] star : stars){
    if(star[Z] > 0)
      star[Z] = random(-fieldRange, 0);
    star[Z] -= movementSpeed;
  }
}

void drawStars(){
  PMatrix3D frustum = viewFrustum(-fieldWidthHalf, fieldWidthHalf, -fieldHeightHalf, fieldHeightHalf, -fieldRange, 0);
  float[] proj = new float[4];
  
  beginShape(POINTS);
  
  for(float[] star : stars){
    frustum.mult(star, proj);
    //myVertex(proj[X]/proj[W], proj[Y]/proj[W]);
    myVertex(proj[X], proj[Y]);
  }
  endShape(POINTS);
}

/* my failed attemp trying to ulilize the flowerPacks variable
void drawFlowerBed(int flowerPacks, float bedSize, float bedHeight){
  color stemColour = color(.4, .8, .3);
  float angleStep = PI/3.5;
  
  // draw the flower bed
  stroke(color(139,69,19));
  fill(color(139,69,19));
  beginShape();
    myVertex(bedSize/2, -bedHeight);
    myVertex(bedSize/2, 0);
    myVertex(-bedSize/2, 0);
    myVertex(-bedSize/2, -bedHeight);
    myVertex(bedSize/2, -bedHeight);
  endShape();
  
  // draw the flowers

  float stepX = bedSize/(flowerPacks - 1);
  float posX = -stepX * (flowerPacks - 2);
  float angle2Step = bedSize/(flowerPacks - 2);
  float angle2 = -angle2Step;
  
  for(int i=0; i< flowerPacks; i++){
    myPush();
  
    myTranslate(posX, 0);
    myRotate(-angle2);
  
    myRotate(-angle2Step);
    drawFlower(16, 1, color(.7, 0, .3), color(.4, .2, .6), stemColour);
  
    myRotate(angle2Step);
    drawFlower(14, 1, color(.4, .5, .7), color(.7, .2, .8), stemColour);
  
    myRotate(angle2Step);
    drawFlower(8, 1, color(.8, .2, .3), color(.5, .7, .6), stemColour);
  
    myPop();
    
    posX += stepX;
    angle2 += angle2Step;
  }
} */
