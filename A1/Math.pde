/// BASIC Math functions
// populate as needed, and add others you may need. I only needed these.
// HHIINNT:: use test cases and a test function to make sure you don't have a mistake!!!!!!
//   - I spent like 3 hours because I had a typo in my cross product :(

// the "2D cross product", as in class
float cross2(float[] e1, float[] e2)
{
  return e1[X]*e2[Y] - e1[Y]*e2[X];
}

float[] cross3(float[] a, float[] b)
{
  float x = a[Y]*b[Z] - a[Z]*b[Y];
  float y = a[Z]*b[X] - a[X]*b[Z];
  
  float[] result = new float[]{x, y};
  
  if(a.length == 3 && b.length == 3){
    float z = a[X]*b[Y] - a[Y]*b[X];
    result = new float[]{x, y, z};
  }
  
  return result;
}

// normalize v to length 1 in place
void normalize(float[] v)
{
  float vLength = euclideanLength(v);
  v[X] = v[X] / vLength;
  v[Y] = v[Y] / vLength;
}

float dot(float[] v1, float[] v2)
{
  return v1[X]*v2[X] + v1[Y]*v2[Y];
}

// return a new vector representing v1-v2
float[] subtract(float[] v1, float v2[])
{
  final int LENGTH = min(v1.length, v2.length);
  float[] result = new float[LENGTH];
  
  for(int i = X; i<LENGTH; i++){
    result[i] = v1[i] - v2[i];
  }
  
  return result;
}

// return the euclidean length of the given vector
float euclideanLength(float[] v){
  return sqrt(pow(v[X], 2) + pow(v[Y], 2));
}

/* phong lighting specific */
// return the resulting vector after the multiplication
float[] VectorMultiply(float[] v, float scalar){
  float[] result = new float[v.length];
  
  for(int i = X; i<v.length; i++){
    result[i] = v[i]*scalar;
  }
  
  return result;
}

float[] L(float[] a, float[] d, float s){
  return new float[]{ a[X]+d[X]+s, a[Y]+d[Y]+s };
}
