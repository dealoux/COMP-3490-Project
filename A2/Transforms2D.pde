// This class handles the camera data's, update the viewMatrix and reflect the changes on the pipeline if necessary
class Camera{
  public PVector up, centre;
  private float zoom, rotation;
  
  public Camera(PVector _centre, float _zoom, float _rotation){
    centre = _centre;
    zoom = _zoom;
    rotation = _rotation;
    CalculateUp(); // up vector
  }
  
  // calculate the up vector base on the current rotation
  void CalculateUp(){
    up = new PVector(cos(rotation), sin(rotation), 1);
  }
  
  // set the viewMatrix base on the current camera's data
  void UpdateViewMatrix(){
    viewMatrix = getCamera(up, centre, zoom);
  }
  
  // update the zoom parameter, then calculate the viewMatrix and reflect the changes on the whole pipeline 
  void UpdateZoom(float multiplier){
    zoom *= multiplier;
    UpdateViewMatrix();
    pipe();
  }
  
  // update the centre by the percentage moved, then calculate the viewMatrix and reflect the changes on the whole pipeline 
  void UpdateCentre(float xPercentage, float yPercentage){
    //centre = new PVector(centre.x - up.y * x * zoom, centre.y + y * sin(rotation) * zoom, 1);
    PVector perp = new PVector(up.y <= 0 ? 1 : up.y, up.x <= 0 ? 1 : -up.x);
    perp.mult(zoom);
    perp.x *= -xPercentage;
    perp.y *= yPercentage;
    centre.add(perp);
    
    UpdateViewMatrix();
    pipe();
  }
  
  // update the theta, then calculate the according up, then the viewMatrix and reflect the changes on the whole pipeline 
  void UpdateRotation(float theta){
    rotation += theta;
    CalculateUp();
    UpdateViewMatrix();
    pipe();
  }
} // end of Camera class

// feel free to add your own transformation functions here
//
//
// return the scale matrix base on the given x, y, z coordinates
PMatrix3D getScale(float x, float y, float z){
  return new PMatrix3D(x, 0, 0, 0, 0, y, 0, 0, 0, 0, z, 0, 0, 0, 0, 1);
}

// return the translate matrix base on the given x, y, z coordinates
PMatrix3D getTranslate(float x, float y, float z){
  return new PMatrix3D(1, 0, 0, x, 0, 1, 0, y, 0, 0, 1, z, 0, 0, 0, 1);
}

// return the rotate matrix base on the given theta
PMatrix3D getRotate(float theta){
  return new PMatrix3D(cos(theta), -sin(theta), 0, 0, sin(theta), cos(theta), 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
}

// reset and pipe the model matrix to the remaining matrices in their respective order
void pipe(){
  modelMatrix.reset();
  
  modelMatrix.preApply(viewMatrix);
  modelMatrix.preApply(projectionMatrix);
  modelMatrix.preApply(viewPortMatrix);
}

// overloads to draw given a PVector, or, floats
void myVertex(PVector vert)
{
  _myVertex(vert.x, vert.y, false);
}

void myVertex(float x, float y)
{
  _myVertex(x, y, false);
}


// translates the given point from object space, all
// the way down to the viewport space. That is, calculates
// Vp.Pr.V.M.point, and then calls vertex with the appropriate VP
// coordinates.
void _myVertex(float x, float y, boolean debug)
{
  // do your transforming here
  PVector p = new PVector(x, y, 1);
  modelMatrix.mult(p, p);
  
  // Suggested debug
  if (debug)
    println(x+" "+y+" --> "+p.x+" "+p.y+" "+p.z); // p.z is actually /w/. Should always be 1.
  
  // this is the only place in your program where you are allowed to use the
  // vertex command
  vertex(p.x, p.y);
}
