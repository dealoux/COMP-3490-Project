final char KEY_OUTLINE = 'o';
final char KEY_ROTATE = ' ';
final char KEY_NORMALS = 'n';
final char KEY_ACCELERATED = '!';
final char KEY_NEXT_MODE = 'm';
final char KEY_PREV_MODE = 'M';
final char KEY_SIMULATE_ROUND = 'r';

enum DisplayMode {
  TEST1_DOTS,
  TEST2_LINES,
  //TEST3_TRIANGLE,   OPTIONAL. consider setting up only 1 Triangle if you are having problems.
  // the rest of the modes below draw your whole cube shape
  NONE,  // no shading / see through
  FLAT, // solid colour
  BARYCENTRIC, // visualize bary coords
  PHONG_FACE, // phong calculated at center of face, solid shading
  PHONG_VERTEX, // phong calculated at each vertex, averaged for face, solid shading
  PHONG_GOURAUD, // phone calculated at each vertex, Gouraud shaded
  PHONG_SHADING // pixel-level Phong  
}
DisplayMode displayMode = DisplayMode.TEST1_DOTS;

boolean doOutline = true; // to draw, or not to draw (outline).. is the question
boolean doRotate = false;
boolean doNormals = false;

void keyPressed()
{
  if (key == KEY_NEXT_MODE)
    displayMode = DisplayMode.values()[
    (displayMode.ordinal()+1)%DisplayMode.values().length
    ];
  else if (key == KEY_PREV_MODE) 
    displayMode = DisplayMode.values()[
    displayMode.ordinal()==0? DisplayMode.values().length-1 : displayMode.ordinal()-1
    ];
  
  if (key == KEY_OUTLINE)
    doOutline = !doOutline;

  if (key == KEY_ROTATE)
    doRotate = !doRotate;

  if (key == KEY_NORMALS)
    doNormals = !doNormals;
    
  announceSettings();
}

void announceSettings()
{
  String msg = "";
  msg += "Display Mode: "+displayMode+"  ";
  if (doRotate) msg += "(rotate) ";
  if (doNormals) msg += "(normals) ";
  if (doOutline) msg += "(outlines) ";
  println(msg);
}
