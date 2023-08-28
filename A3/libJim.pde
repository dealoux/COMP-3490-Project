// ONLY useful for the bonus and the hack.
PGraphicsOpenGL pogl = null; 

// Make sure to call at the start of your program to enable the hack
void setupPOGL() {
  pogl = (PGraphicsOpenGL)g;
  printProjection();
}

// for debugging only
void printProjection() {
  pogl.projection.print();
}


// Call this after setting your frustum, and it'll pre-apply a Y flip to it.
void fixFrustumYFlip() {
  PMatrix3D proj = getProjection();
  proj.preApply(new PMatrix3D(
    1, 0, 0, 0, 
    0, -1, 0, 0, 
    0, 0, 1, 0, 
    0, 0, 0, 1
    ));
  setProjection(proj);
}


// The next two load and set the internal projection matrix.

void setProjection(PMatrix3D mat) {
assert pogl != null: 
  "no PGraphics Open GL Conext";
  //pogl.setProjection(mat.get());
  pogl.projection.set(mat.get());
  pogl.updateProjmodelview();
}

PMatrix3D getProjection() {
assert pogl != null: 
  "no PGraphics Open GL Conext";
  return pogl.projection.get();
}
