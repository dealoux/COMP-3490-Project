// for debuging purposes, moving the camera
final char CAMERA_LEFT = 'j';
final char CAMERA_RIGHT = 'l';
final char CAMERA_UP = 'i';
final char CAMERA_DOWN = 'k';
final char CAMERA_NEAR = 'u';
final char CAMERA_FAR = 'o';
final char CAMERA_POS = 'v';

boolean cameraLeft = false;
boolean cameraRight = false;
boolean cameraUp = false;
boolean cameraDown = false;
boolean cameraNear = false;
boolean cameraFar = false;

class Camera{
  PVector pos; // camera's position
  
  Camera(PVector _pos){
    pos = _pos;
    
    myCamera();
  }
  
  void myCamera(){
    camera(pos.x, pos.y, pos.z, 0, 0, 0, 0, 1 ,0);
  }
  
  // for debuging purposes
  void enableMovement(){
    float speed = 0.1;
    
    if(cameraLeft){
      camera.pos.x -= speed;
    }
      
    if(cameraRight){
      camera.pos.x += speed;
    }
  
    if(cameraUp){
      camera.pos.y += speed;
    }
    
    if(cameraDown){
      camera.pos.y -= speed;
    }
    
    if(cameraNear){
      camera.pos.z -= speed;
    }
    
    if(cameraFar){
      camera.pos.z += speed;
    }
  
    myCamera();
  }
}
