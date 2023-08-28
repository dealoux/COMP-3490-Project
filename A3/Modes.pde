final int X=0;
final int Y=1;

final char KEY_VIEW = 'r';

final char KEY_LEFT = 'a';
final char KEY_RIGHT = 'd';
final char KEY_UP = 'w';
final char KEY_DOWN = 's';
final char KEY_SHOOT = ' ';

final char KEY_BONUS = 'b';
final char KEY_TEX = 't';
final char KEY_COLLISION = 'c';


boolean inputLeft = false;
boolean inputRight = false;
boolean inputUp = false;
boolean inputDown = false;

boolean doBonus = false;
boolean doTextures = false;
boolean doCollision = false;

void keyPressed()
{
  switch(key){
    case KEY_VIEW:
      world.switchViewMode();
      break;
      
    case KEY_LEFT:
      inputLeft = true;
      break;
    
    case KEY_RIGHT:
      inputRight = true;
      break;
      
    case KEY_UP:
      inputUp = true;
      break;
      
    case KEY_DOWN:
      inputDown = true;
      break;
      
    case KEY_SHOOT:
      world.player.shoot();
      break;
      
    case KEY_BONUS:
      doBonus = !doBonus;
      break;
      
    case KEY_TEX:
      doTextures = !doTextures;
      break;
      
    case KEY_COLLISION:
      doCollision = !doCollision;
      println("Collisions: " + doCollision);
      break;
      
    // Camera movement
    case CAMERA_LEFT:
      cameraLeft = true;
      break;
    
    case CAMERA_RIGHT:
      cameraRight = true;
      break;
      
    case CAMERA_UP:
      cameraUp = true;
      break;
      
    case CAMERA_DOWN:
      cameraDown = true;
      break;
      
    case CAMERA_NEAR:
      cameraNear = true;
      break;
      
    case CAMERA_FAR:
      cameraFar = true;
      break;
      
    case CAMERA_POS:
      println(camera.pos);
      break;
  }
}

void keyReleased() {
  switch(key){ 
    case KEY_LEFT:
      inputLeft = false;
      break;
    
    case KEY_RIGHT:
      inputRight = false;
      break;
      
    case KEY_UP:
      inputUp = false;
      break;
      
    case KEY_DOWN:
      inputDown = false;
      break;
      
    // Camera movement
    case CAMERA_LEFT:
      cameraLeft = false;
      break;
    
    case CAMERA_RIGHT:
      cameraRight = false;
      break;
      
    case CAMERA_UP:
      cameraUp = false;
      break;
      
    case CAMERA_DOWN:
      cameraDown = false;
      break;
      
    case CAMERA_NEAR:
      cameraNear = false;
      break;
      
    case CAMERA_FAR:
      cameraFar = false;
      break;
  }
}
