class Triangle {
  Triangle(float[] V1, float[] V2, float[] V3) {  // does DEEP copy!!
    v1 = Arrays.copyOf(V1, V1.length); 
    v2 = Arrays.copyOf(V2, V2.length);
    v3 = Arrays.copyOf(V3, V3.length);
  }

  // position data. in 3D space
  float[] v1; // 3 triangle vertices
  float[] v2;
  float[] v3;
  
  // projected data. On the screen raster
  float[] pv1; // (p)rojected vertices
  float[] pv2;
  float[] pv3;
  
  // add other data that you may need
  float[] v12; // edge vectors
  float[] v23;
  float[] v31;
  
  float[] faceNormal; // face normal of the triangle
}

Triangle[] rotatedList;
Triangle[] cubeList;

final float MARGIN_ERR = 0.0f;

PGraphics buffer;

void setup() {
  colorMode(RGB, 1.0f);  // set RGB to 0..1 instead of 0..255

  buffer = createGraphics(640, 640);
    
  cubeList = makeCube(300, 3); // make your cube
  rotatedList = new Triangle[cubeList.length]; // make rotated list the same size
  announceSettings();
}

void settings() {
  size(640, 640); // hard coded 640x640 canvas
}

// don't change these. They're used in the rotation.
float theta = 0.0;  // current rotation value
float delta = 0.01; // rotation speed

// you probably don't want to change this at all. It's all setup for you. Make sure you understand how it works.
void draw() {
  buffer.beginDraw();
  buffer.colorMode(RGB, 1.0f);  // seems to need to be re-set each time..?

  buffer.background(0); // clear to black each frame
  buffer.loadPixels(); // put the canvas into an array to represent the raster

  if (doRotate)
  {
    theta += delta;
    while (theta > PI*2) theta -= PI*2;
  } 

  if (displayMode == DisplayMode.TEST1_DOTS)
    drawTrefoilKnot();

  else if (displayMode == DisplayMode.TEST2_LINES)
    drawLinePattern();

  else
  {
    rotateTriangles(cubeList, rotatedList, theta); // copy your triangle list, rotate it, and store in rotatedList
    drawTriangles(rotatedList);  // draw the list of rotated triangles */
  }

  buffer.updatePixels(); // copy from the raster array back onto the image canvas
  buffer.endDraw(); // clean up the buffer before drawing / flush buffers
  image(buffer, 0, 0); // draw our raster image on the screen
}

// Draws a given array of triangles, projects them into 2D space, and draws them on the raster by calling draw2DTriangle
void drawTriangles(Triangle[] list)
{
  for(Triangle t : list){
    if(t != null)
      draw2DTriangle(t);
  } 
}


// Tesselates a cube of the given size, centred on 0,0,0, and returns a triangle list
// divisions refers to number of divisions /per face/, /per dimension/. 1 division gives 2x2x2 cube
Triangle[] makeCube(int size, int divisions) {
  divisions = divisions < 2 ? 2 : divisions;
  
  float edge = size/(divisions); // the lenght of each triangle's edge
  final float DEFAULT_COORD = -edge*divisions/2; // default starting coordnate to keep the cube centred
  final float FINAL_COORD = abs(DEFAULT_COORD); // final coodnate 
  
  float[] v = new float[]{DEFAULT_COORD, DEFAULT_COORD, DEFAULT_COORD}; // first point in the loop
  float[] v2, v3, v4; // variables to store the point's remaining 3 neighbour points
  Triangle[] list = new Triangle[(int)pow(divisions, 2)*12]; // array of the triangles
  float[][] faceNormal = new float[6][3];
  int index = 0; // index to traverse the triangles array
  
  /* a nested for loop going through every X, Y, then Z for each side
  for every point, i calculate all the remain neighbours forming a square, sperate them in order of to 2 triangles, and put the 2 triangles into the array */
  for(int i=0; i<divisions; i++){
    for(int j=0; j<divisions; j++){
      // backward-facing side
      v2 = new float[] {v[X], v[Y]+edge, v[Z]};
      v3 = new float[] {v[X]+edge, v[Y], v[Z]};
      v4 = new float[] {v[X]+edge, v[Y]+edge, v[Z]};
      list[index++] = new Triangle(v, v2, v3);
      list[index++] = new Triangle(v2, v4, v3);
      faceNormal[0] = v;
      // end of backward-facing side
      
      // foward-facing side (backward-facing side's mirror)
      v[Z] = FINAL_COORD;
      v2[Z] = FINAL_COORD;
      v3[Z] = FINAL_COORD;
      v4[Z] = FINAL_COORD;
      list[index++] = new Triangle(v3, v2, v);
      list[index++] = new Triangle(v3, v4, v2);
      v[Z] = DEFAULT_COORD; // reset Z  
      // end of foward-facing side
      
      // left-facing side
      if(i == 0){
        for(int k=0; k<divisions; k++){
          v2 = new float[] {v[X], v[Y], v[Z]+edge};
          v3 = new float[] {v[X], v[Y]+edge, v[Z]};
          v4 = new float[] {v[X], v[Y]+edge, v[Z]+edge};
          list[index++] = new Triangle(v, v2, v3);
          list[index++] = new Triangle(v2, v4, v3);
          v[Z] += edge; // increase Z
        }
        v[Z] = DEFAULT_COORD; // reset Z
      } // end of left-facing side
      
      // right-facing side (left-facing side's mirror)
      else if(i == divisions-1) {
        v[X] += edge; // increase X to get the largest edge as the loop will not go through it
        for(int k=0; k<divisions; k++){
          v2 = new float[] {v[X], v[Y], v[Z]+edge};
          v3 = new float[] {v[X], v[Y]+edge, v[Z]};
          v4 = new float[] {v[X], v[Y]+edge, v[Z]+edge};
          list[index++] = new Triangle(v3, v2, v);
          list[index++] = new Triangle(v3, v4, v2);
          v[Z] += edge; // increase Z
        }
        v[X] -= edge; // reset X
        v[Z] = DEFAULT_COORD; // reset Z
      } // end of right-facing side
      
      // downward-facing side
      if(j == 0){
        for(int k=0; k<divisions; k++){
          v2 = new float[] {v[X], v[Y], v[Z]+edge};
          v3 = new float[] {v[X]+edge, v[Y], v[Z]};
          v4 = new float[] {v[X]+edge, v[Y], v[Z]+edge};
          list[index++] = new Triangle(v3, v2, v);
          list[index++] = new Triangle(v3, v4, v2);
          v[Z] += edge; // increase Z
        }
        v[Z] = DEFAULT_COORD; // reset Z
      } // end of downward-facing side
      
      // upward-facing side (downward-facing side's mirror)
      else if(j == divisions-1){
        v[Y] += edge; // increase Y to get the largest edge as the loop will not go through it
        for(int k=0; k<divisions; k++){
          v2 = new float[] {v[X], v[Y], v[Z]+edge};
          v3 = new float[] {v[X]+edge, v[Y], v[Z]};
          v4 = new float[] {v[X]+edge, v[Y], v[Z]+edge};
          list[index++] = new Triangle(v, v2, v3);
          list[index++] = new Triangle(v2, v4, v3);
          v[Z] += edge; // increase Z
        }
        v[Y] -= edge; // reset Y
        v[Z] = DEFAULT_COORD; // reset Z
      } // end of upward-facing side
      
      v[Y] += edge; // increase y
    } // end of j for loop
    v[Y] = DEFAULT_COORD; // reset y
    v[X] += edge; // increase x
  } // end of nested for loop (i)
  
  return list;
}

// this function project all 3 3D vertices of the given triangles into 2D space and store them accordingly
private void projectTriangle(Triangle t){
  t.pv1 = project(t.v1);
  t.pv2 = project(t.v2);
  t.pv3 = project(t.v3);
} 

// This function draws the 2D, already-projected triangle, on the raster
// - it culls degenerate or back-facing triangles
// - it calculates face and vertex colours as needed using the global shading model noted by displayMode
// - it uses fillTriangle and bresLine to do the actual work if needed depending on the global flags
void draw2DTriangle(Triangle t)
{
  projectTriangle(t);
  
  // culling check
  t.v12 = subtract(t.pv2, t.pv1);
  t.v23 = subtract(t.pv3, t.pv2);
  
  if(cross2(t.v12, t.v23) < MARGIN_ERR){ return; } 
  
  t.v31 = subtract(t.pv1, t.pv3);
  
  // drawing the triangles with Bresline
  bresLine((int) t.pv1[X], (int) t.pv1[Y], (int) t.pv2[X], (int) t.pv2[Y]);
  bresLine((int) t.pv3[X], (int) t.pv3[Y], (int) t.pv2[X], (int) t.pv2[Y]);
  bresLine((int) t.pv1[X], (int) t.pv1[Y], (int) t.pv3[X], (int) t.pv3[Y]);
  
  // no filling or shading
  if(displayMode == DisplayMode.NONE){
    setColor(OUTLINE_COLOR[X], OUTLINE_COLOR[Y], OUTLINE_COLOR[Z]);
  }
  else{
    // filling & shading
    fillTriangle(t);
  }
}

// return the average vector of all the three
private float[] averageV(float[] p, float[] p2, float[] p3){
  float x = (p[X] + p2[X] + p3[X])/3;
  float y = (p[Y] + p2[Y] + p3[Y])/3;
  
  return new float[]{ x, y };
}

// uses a scanline algorithm to fill the 2D on-raster triangle
// - it refers to the current displayMode to set the shading color
// - it uses setColor and setPixel to modify the raster
void fillTriangle(Triangle t)
{
  // min, max X
  float minX = min(t.pv1[X], t.pv2[X], t.pv3[X]);
  float maxX = max(t.pv1[X], t.pv2[X], t.pv3[X]);
  
  // min, max Y
  float minY = min(t.pv1[Y], t.pv2[Y], t.pv3[Y]);
  float maxY = max(t.pv1[Y], t.pv2[Y], t.pv3[Y]);
  
  float[] n = cross3(t.v31, t.v23); // face normal
  
  // flat filling
  if(displayMode == DisplayMode.FLAT){
    setColor(FILL_COLOR[X], FILL_COLOR[Y], FILL_COLOR[Z]);
  }
  
  for(int y=(int)minY; y<maxY; y++){
    for(int x=(int)minX; x<maxX; x++){
      // a float to store the point at a given instance
      float[] p = new float[]{x, y};
      
      // calculate all vectors pointing from each vertex to the point
      float[] v1P = subtract(p, t.pv1);
      float[] v2P = subtract(p, t.pv2);
      float[] v3P = subtract(p, t.pv3);
      
      // cross products of the edge vectors and theirs according vertex to point vectors (also parallelogam's area defined by the 2 vectors)
      float crossU = cross2(t.v12, v1P);
      float crossV = cross2(t.v23, v2P);
      float crossW = cross2(t.v31, v3P);
        
      // check if the point is inside the triangle
      if(crossU > MARGIN_ERR && crossV > MARGIN_ERR && crossW > MARGIN_ERR){
        
        switch(displayMode){
          // barycentric, calculate the u, v, w coordinates, correspond to R, G, B values
          case BARYCENTRIC:
            float crossT = cross2(t.v12, t.v31); // parallelogam's area defined by the 2 edge vectors of the triangle
            setColor(abs(crossU/crossT), abs(crossV/crossT), abs(crossW/crossT));
            break;
    
          // phong calculated at center of face, solid shading
          case PHONG_FACE: 
            float[] colour =  phong(p, n, EYE, LIGHT, MATERIAL, FILL_COLOR, PHONG_SPECULAR);
            setColor(colour[X], colour[Y], colour[Z]);
            break;
          
          // phong calculated at each vertex, averaged for face, solid shading
          case PHONG_VERTEX: 
            break;
          
          // phone calculated at each vertex, Gouraud shaded
          case PHONG_GOURAUD:
            break;
          
          // pixel-level Phong  
          case PHONG_SHADING:
            break; 
        }
        
        setPixel(x, y);
      } 
    } // end of for loop going through all X
  } // end of for loop going through all Y
}


// given point p, normal n, eye location, light location, material properties (see libJim) and fill properties,
// - calculates the phong (based on diffuse, specular, and ambient) and multiplies it by the given material and fillcolor
// - returns the resulting RGB color
float[] phong(float[] p, float[] n, float[] eye, float[] light,
  float[] material, float[] fillColor, float s)
{
  // calculate ambient lighting
  normalize(material);
  float ambientL = euclideanLength(material);
  
  // calculate difuse lighting
  float[] vL = subtract(light, n);
  float[] vE = subtract(eye, n);
  normalize(vL);
  normalize(n);
  float difuseL =  dot(vL, n);
  
  // calculate specular lighting
  float[] vR  = subtract(VectorMultiply(n, (dot(n, vL) * 2)), vL);
  normalize(vR);
  float specularL = pow(dot(vR,vE), s);
    
  float L = ambientL*M_AMBIENT + difuseL*M_DIFFUSE + specularL*M_SPECULAR;
  return new float[]{ fillColor[X]*L, fillColor[Y]*L, fillColor[Z]*L };
} 


// draws a Trefoil Knot (https://en.wikipedia.org/wiki/Trefoil_knot) with fixed parameters,
// for t from 0 - 2PI. Uses setColor and setPixel.
void drawTrefoilKnot() {
  int step = 800;
  
  for(int i=0; i<step; i++){
    // float t
    float t = i * TWO_PI/step;
    
    // calculating floats x, y then multiply to their perspective sizes and covert to integerss for coordinates
    int x = (int) ( (sin(t) + 2*sin(2*t)) * width/6.5 );
    int y = (int) ( (cos(t) - 2*cos(2*t)) * height/6.5 );
    setPixel(x, y);
    
    // calculating float z for colouring, take the absolute value as to make sure it's ranging form 0 to 1
    float z = -sin(3*t);
    z = z < 0f ? abs(z) * 0.5f : z*0.5 + 0.5;
    setColor(0, z, 0);
  } // end of for loop
}


// implements Bresenham's line algorithm
void bresLine(int fromX, int fromY, int toX, int toY)
{
  float err = 0.5f; // error
  float halfPixel = 0.5f;
  float marginErr = 0.0001f; // margin of error to check if a float is positive (greater than this margin of error)
  
  float deltaX = toX - fromX; // changes in x
  float deltaY = toY - fromY; // changes in y
  float m; // slope
  int x = fromX;
  int y = fromY;
  
  int stepX = deltaX > marginErr ? 1 : -1; // step between each pixel for x, 1 if delta X is positive or -1 otherwise
  int stepY = deltaY > marginErr ? 1 : -1; // step between each pixel for y, 1 if delta Y is positive or -1 otherwise
  
  // checks if delta X is greater than delta Y
  if(abs(deltaX) > abs(deltaY)){
    m = abs(deltaY/deltaX); // take absolute value to keep the slope's polarity
        
    while(deltaX > marginErr ? x <= toX : x > toX){ // check for either cases of going left/right
      setPixel(x, y);
      x +=  stepX; // move x by stepX
      err += m;
      
      if(err >= halfPixel){
        y += stepY; // move y by stepY
        err--; // update error
      }
    } // end of while loop
  }
  // else delta  Y is larger than delta X
  else{
    m = abs(deltaX/deltaY); // take absolute value to keep the slope's polarity
    
    while(deltaY > marginErr ? y <= toY : y > toY){ // compare the absolute values to check for either cases of going up/down
      setPixel(x, y);
      y += stepY; // move y by stepY
      err += m;
      
      if(err >= halfPixel){
        x += stepX; // move x by stepX
        err--; // update error
      }
    } // end of while loop
  }
}




/* make cube ordered version
// Tesselates a cube of the given size, centred on 0,0,0, and returns a triangle list
// divisions refers to number of divisions /per face/, /per dimension/. 1 division gives 2x2x2 cube
Triangle[] makeCubeOrdered(int size, int divisions) {
  divisions = divisions < 2 ? 2 : divisions;
  
  float edge = size/(divisions); // the lenght of each triangle's edge
  final float DEFAULT_COORD = -edge*divisions/2; // default starting coordnate to keep the cube centred
  final float FINAL_COORD = abs(DEFAULT_COORD); // final coodnate 
  
  float[] v = new float[]{DEFAULT_COORD, DEFAULT_COORD, DEFAULT_COORD}; // first point in the loop
  float[] v2, v3, v4; // variables to store the point's remaining 3 neighbour points
  Triangle[] list = new Triangle[(int)pow(divisions, 2)*12]; // array of the triangles
  Triangle[][] list2 = new Triangle[2][(int)pow(divisions, 2)*2]; // array of the triangles for the backward/forward facing sides
  float[][] faceNormal = new float[6][3];
  int index = 0; // index to traverse the list triangles array
  int index2 = 0; // index to traverse the list2 1st array
  int index3 = 0; // index to traverse the list2 2ndt array
  
  // a nested for loop going through every X, Y, then Z for each side
  // for every point, i calculate all the remain neighbours forming a square, sperate them in order of to 2 triangles, and put the 2 triangles into the array 
  for(int i=0; i<divisions; i++){
    for(int j=0; j<divisions; j++){
      // backward-facing side
      v2 = new float[] {v[X], v[Y]+edge, v[Z]};
      v3 = new float[] {v[X]+edge, v[Y], v[Z]};
      v4 = new float[] {v[X]+edge, v[Y]+edge, v[Z]};
      list2[0][index2++] = new Triangle(v, v2, v3);
      list2[0][index2++] = new Triangle(v2, v4, v3);
      faceNormal[0] = v;
      // end of backward-facing side
      
      // foward-facing side (backward-facing side's mirror)
      v[Z] = FINAL_COORD;
      v2[Z] = FINAL_COORD;
      v3[Z] = FINAL_COORD;
      v4[Z] = FINAL_COORD;
      list2[1][index3++] = new Triangle(v3, v2, v);
      list2[1][index3++] = new Triangle(v3, v4, v2);
      v[Z] = DEFAULT_COORD; // reset Z  
      // end of foward-facing side
      
      // left-facing side
      if(i == 0){
        for(int k=0; k<divisions; k++){
          v2 = new float[] {v[X], v[Y], v[Z]+edge};
          v3 = new float[] {v[X], v[Y]+edge, v[Z]};
          v4 = new float[] {v[X], v[Y]+edge, v[Z]+edge};
          list[index++] = new Triangle(v, v2, v3);
          list[index++] = new Triangle(v2, v4, v3);
          v[Z] += edge; // increase Z
        }
        v[Z] = DEFAULT_COORD; // reset Z
      } // end of left-facing side
      
      // right-facing side (left-facing side's mirror)
      else if(i == divisions-1) {
        v[X] += edge; // increase X to get the largest edge as the loop will not go through it
        for(int k=0; k<divisions; k++){
          v2 = new float[] {v[X], v[Y], v[Z]+edge};
          v3 = new float[] {v[X], v[Y]+edge, v[Z]};
          v4 = new float[] {v[X], v[Y]+edge, v[Z]+edge};
          list[index++] = new Triangle(v3, v2, v);
          list[index++] = new Triangle(v3, v4, v2);
          v[Z] += edge; // increase Z
        }
        v[X] -= edge; // reset X
        v[Z] = DEFAULT_COORD; // reset Z
      } // end of right-facing side
      
      // downward-facing side
      if(j == 0){
        for(int k=0; k<divisions; k++){
          v2 = new float[] {v[X], v[Y], v[Z]+edge};
          v3 = new float[] {v[X]+edge, v[Y], v[Z]};
          v4 = new float[] {v[X]+edge, v[Y], v[Z]+edge};
          list[index++] = new Triangle(v3, v2, v);
          list[index++] = new Triangle(v3, v4, v2);
          v[Z] += edge; // increase Z
        }
        v[Z] = DEFAULT_COORD; // reset Z
      } // end of downward-facing side
      
      // upward-facing side (downward-facing side's mirror)
      else if(j == divisions-1){
        v[Y] += edge; // increase Y to get the largest edge as the loop will not go through it
        for(int k=0; k<divisions; k++){
          v2 = new float[] {v[X], v[Y], v[Z]+edge};
          v3 = new float[] {v[X]+edge, v[Y], v[Z]};
          v4 = new float[] {v[X]+edge, v[Y], v[Z]+edge};
          list[index++] = new Triangle(v, v2, v3);
          list[index++] = new Triangle(v2, v4, v3);
          v[Z] += edge; // increase Z
        }
        v[Y] -= edge; // reset Y
        v[Z] = DEFAULT_COORD; // reset Z
      } // end of upward-facing side
      
      v[Y] += edge; // increase y
    } // end of j for loop
    v[Y] = DEFAULT_COORD; // reset y
    v[X] += edge; // increase x
  } // end of nested for loop (i)
  
  for(int i=0; i<2; i++){
    for(int j=0; j<list2[i].length; j++){
      list[index++] = list2[i][j];
    }
  }
  
  return list;
} */
