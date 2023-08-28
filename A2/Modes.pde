
// DONT change these keys, as the marker will use them
final char KEY_ROTATE_RIGHT = ']';
final char KEY_ROTATE_LEFT = '[';
final char KEY_ZOOM_IN = '='; // plus sign without the shift
final char KEY_ZOOM_OUT = '-';
final char KEY_ORTHO_CHANGE = 'o';
final char KEY_TEST_MODE = 't';

enum OrthoMode {
  IDENTITY,        // no change. straight to viewport. Load the identity matrix.
    CENTER640,     // 0x0 at center, width/height is 640 (+- 320)
    BOTTOMLEFT640, // 0x0 at bottom left, top right is 640x640
    FLIPX,         // same as CENTER640 but x is flipped
    ASPECT         // uneven aspect ratio: x is from -320 to 320, y is from -100 to 100
 
 }
OrthoMode orthoMode = OrthoMode.IDENTITY;

final OrthoMode DEFAULT_ORTHO_MODE = OrthoMode.IDENTITY;
final float ROTATION_ADDITION = PI/16; // angle to add each time the rotation keys are pressed
final float ZOOM_MULTIPLIER_BASE = .125f; // base for calculating the zoom multiplier each time the zoom keys are pressed

enum TestMode {
  PATTERN, 
    SCENE, 
    STARFIELD
}
TestMode testMode = TestMode.PATTERN;

// Input handler, modified from AS1
void keyPressed()
{
  switch(key){
    case KEY_ROTATE_RIGHT:
      camera.UpdateRotation(ROTATION_ADDITION);
      break;
      
    case KEY_ROTATE_LEFT:
      camera.UpdateRotation(-ROTATION_ADDITION);
      break;
      
    case KEY_ZOOM_IN:
      camera.UpdateZoom(1 - ZOOM_MULTIPLIER_BASE);
      break;
      
    case KEY_ZOOM_OUT:
      camera.UpdateZoom(1 + ZOOM_MULTIPLIER_BASE);
      break;
      
    case KEY_ORTHO_CHANGE:
      orthoMode = OrthoMode.values()[(orthoMode.ordinal()+1)%OrthoMode.values().length];
      
      // change the projection matrix base on it's correspond orthographic mode
      switch(orthoMode){
        case IDENTITY:
          projectionMatrix.reset();
          break;
        case CENTER640:
          projectionMatrix = getOrtho(-320, 320, -320, 320);
          break;
        case BOTTOMLEFT640:
          projectionMatrix = getOrtho(0, 640, 0, 640);
          break;
        case FLIPX:
          projectionMatrix = getOrtho(320, -320, -320, 320);
          break;
        case ASPECT:
          projectionMatrix = getOrtho(-320, 320, -100, 100);
          break;
      }
      
      pipe(); // reflect the change on the whole pipeline
      announceOrthoMode(); 
      break;
      
    case KEY_TEST_MODE:
      testMode = TestMode.values()[(testMode.ordinal()+1)%TestMode.values().length];
      announceTestMode(); 
      break;
  }
}

// print the current ortho mode to the console
void announceOrthoMode()
{
  println("Orthographic Mode: "+orthoMode+"  ");
}

// print the current tes mode to the console
void announceTestMode()
{
  println("Test Mode: "+testMode+"  ");
}
