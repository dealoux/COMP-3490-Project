import java.util.Arrays;

// GLOBAL CONSTANTS
// -- use float[] for vectors, and int[] for vectors, indexed as below
final int X = 0;    ///****USE THESE NAMED CONSTANTS to access your arrays, for readability
final int Y = 1; 
final int Z = 2;
final int R = 0; 
final int G = 1; 
final int B = 2;
final int CUBE_SIZE = 200;

// reasonable defaults for Phong lighting
final float[] LIGHT = {200, 200, 350}; // location
final float[] EYE = {0, 0, 600}; // location

final float[] OUTLINE_COLOR = {1.0f, .2f, .5f};  // RGB
final float[] FILL_COLOR    = {1.0f, 1.0f, 1.0f}; // RGB
final float[] MATERIAL = {.35, .45, 0.3  }; // ambient, diffuse, specular %
final int M_AMBIENT = 0; 
final int M_DIFFUSE = 1; 
final int M_SPECULAR = 2;  

final float PHONG_SPECULAR = 30;


// set the pixel using current color. 0,0 is the middle, x axis right, y going up
void setPixel(int x, int y)
{
  x += width/2; // offset by half screen
  y = height - (y + height/2);  // offset by half screen and reverse Y direction
  int pixel = x+y*width;   // x,y -> pixel # as per notes
  if (pixel < 0 || pixel >= buffer.pixels.length)
    println("ERROR: pixel out of bounds");
  else
    buffer.pixels[pixel] = _curColor;
}

// sets the drawing color using the RGB values
int _curColor = color(0, 0, 0);
void setColor(float cr, float cg, float cb)
{
  _curColor = color(cr, cg, cb);
}


// projects a 3D point (parameter v) into 2D using perspective projection, and returns a new 2D point
// - returns null if the point is no longer visible after projection (behind the camera). WATCH FOR THIS DOWNSTREAM.
// - you will learn the math later in the course

final float PERSPECTIVE = 0.002; // 1/500, don't bother changing 
float[] project(float[] v)
{
  float adjZ = v[Z]-EYE[Z];  // RHS, Z negative into screen. relative to Eye Z.
  if (adjZ>0) return null; // clipping plane
  adjZ *=- 1; // ABS z value for division.
  float px = v[X] / (adjZ*PERSPECTIVE);  // vanishing point calculation
  float py = v[Y] / (adjZ*PERSPECTIVE);
  return new float[]{px, py, v[Z]};
}


// rotates a vertex in place by theta. Does subsequent Euclidean axis rotations: Y, then Z, then X. 
// - you will learn the math later in the course
void rotateVertex(float[] v, float theta)
{
  float rx = v[X]*cos(theta) - v[Z]*sin(theta);
  float rz = v[X]*sin(theta) + v[Z]*cos(theta);
  v[X]=rx; 
  v[Z]=rz;

  rx = v[X]*cos(theta) - v[Y]*sin(theta);
  float ry = v[X]*sin(theta) + v[Y]*cos(theta);
  v[X]=rx; 
  v[Y]=ry;

  ry = v[Y]*cos(theta) - v[Z]*sin(theta);
  rz = v[Y]*sin(theta) + v[Z]*cos(theta);
  v[Y]=ry; 
  v[Z]=rz;
}


// takes a list of triangles, and for each one:
// - copies it into the rotated triangle list
// - roates it using the theta provided
void rotateTriangles(Triangle[] original, Triangle[] rotated, float theta)
{
  if (original == null || rotated == null) return;
  for (int i = 0; i < original.length; i++)
  {
    if (rotated[i] == null)
      rotated[i] = new Triangle(original[i].v1, original[i].v2, original[i].v3);
    else
    {
      System.arraycopy(original[i].v1, 0, rotated[i].v1, 0, original[i].v1.length);
      System.arraycopy(original[i].v2, 0, rotated[i].v2, 0, original[i].v2.length);
      System.arraycopy(original[i].v3, 0, rotated[i].v3, 0, original[i].v3.length);
    }

    rotateVertex(rotated[i].v1, theta);
    rotateVertex(rotated[i].v2, theta);
    rotateVertex(rotated[i].v3, theta);
  }
}

final int LINE_OFFSET = 10;
void _lineHelper(float x, float y, float x2, float y2) // converts from 0,0 being top left, to the coord system used in the assignment
{
  final float centerX=width/2;
  final float centerY=height/2;
  final float offset = LINE_OFFSET;
  buffer.line(x+centerX+offset, centerY-y+offset, x2+centerX+offset, centerY-y2+offset);
}

// a test function that checks all the drawing octants using your bresenham line implementation,
// and compars against the built-in line function
void drawLinePattern()
{
  int dsmall = 90; // small and large horizontal offsets for lines
  int dlarge = 180;

  buffer.updatePixels(); // save anything that's been changed so far on the raster copy, to the image buffer.. So we can use processing's drawing.
  buffer.stroke(1.0f, 1.0f, 1.0f);
  _lineHelper(0, 0, dlarge, dsmall);
  _lineHelper(0, 0, -dlarge, dsmall);
  _lineHelper(0, 0, dlarge, -dsmall);
  _lineHelper(0, 0, -dlarge, -dsmall);
  _lineHelper(0, 0, dsmall, dlarge);
  _lineHelper(0, 0, -dsmall, dlarge);
  _lineHelper(0, 0, dsmall, -dlarge);
  _lineHelper(0, 0, -dsmall, -dlarge);
  _lineHelper(-dlarge, 0, dlarge, 0);
  _lineHelper(0, -dlarge, 0, dlarge);

  buffer.loadPixels(); // move back to the raster

  // test all the octants for your algorithm, + horizontal and vertical
  setColor(1, 0, 0);
  bresLine(0, 0, dlarge, dsmall);
  bresLine(0, 0, -dlarge, dsmall);
  bresLine(0, 0, dlarge, -dsmall);
  bresLine(0, 0, -dlarge, -dsmall);

  bresLine(0, 0, dsmall, dlarge);
  bresLine(0, 0, -dsmall, dlarge);
  bresLine(0, 0, dsmall, -dlarge);
  bresLine(0, 0, -dsmall, -dlarge);

  bresLine(-dlarge, 0, dlarge, 0);
  bresLine(0, -dlarge, 0, dlarge);
}
