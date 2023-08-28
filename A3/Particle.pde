enum ParticleOwner{
  PLAYER,
  ENEMY,
  NONE
}

abstract class Particle{
  Entity ent; // entity instance for displaying
  PVector velocity; // velocity of the particle
  float size; // size of the particle
  boolean isDead; // keep track of current status
  ParticleOwner owner; // keep track of the owner of this particle
  PImage[] textures; // textures for rendering
  int aIndex; // index for traversing textures array
  
  Particle(PVector pos, PVector theta, PVector v, color c, PImage[] t){
    ent = new Entity(pos, theta, c);
    textures = t;
    velocity = v;
    isDead = false;
  }
  
  abstract void update();
  
  // default display
  void display(){
    ent.drawPlane(size, textures[aIndex]);
  }
  
  // default collision
  void collide(Particle other) {
    PVector delta = PVector.sub(other.ent.pos, ent.pos);
    delta.z = 0; // ignore z
    
    // collision  
    if (delta.mag() < size) { 
      world.explosion.explode(ent.pos.copy()); // explode
      isDead = true;
      other.isDead = true;
    }
  }
} // end of Particle abstract class

// particle entity
class Entity{
  PVector pos, theta;
  color c;
    
  Entity(PVector _pos, PVector _theta, color _c){
    pos = _pos;
    theta = _theta;
    c = _c;
  }
  
  // main display, draw only a plane, do all the transformations, fill with assigned colour/display texture, called by Particle.display() and its children
  void drawPlane(float size, PImage texture){
    fill(c);
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    
    if(theta != new PVector()){
      rotateY(theta.y);
      rotateX(theta.x);
      rotateZ(theta.z);
    }
    
    scale(size);
    
    // 1x1 plane from (-0.5, -0.5) to (0.5, 0.5)
    beginShape(TRIANGLE_STRIP);
      if(doTextures)
        //try {texture(texture);} catch(NullPointerException e){}
        texture(texture);
        
      vertex(-.5, -.5, 0, 1, 1);
      vertex(.5, -.5, 0, 0, 1);
      vertex(-.5, .5, 0, 1, 0);
      vertex(.5, .5, 0, 0, 0);
    endShape();
      
    popMatrix();
  }
}

// world section block
class Block extends Entity{
  PImage[] textures;
  
  Block(PVector pos, PVector theta, color c, PImage[] t){
    super(pos, theta, c);
    textures = t;
  }
  
  // draw a rectangular block, do all the transformations, fill with assigned colour/display texture, **called only by WorldSection.display()
  void drawBlock(float size){
    fill(c);
    pushMatrix();
    translate(pos.x, pos.y);
    
    if(theta != new PVector()){
      rotateY(theta.y);
      rotateX(theta.x);
      rotateZ(theta.z);
    }
    
    scale(size);
    
    // 1x1xz rect block from (-0.5, -0.5, 0) to (0.5, 0.5, z)
    beginShape(TRIANGLE_STRIP);
      if(doTextures)
        texture(textures[0]);
      vertex(-.5, -.5, pos.z, 1, 1);
      vertex(.5, -.5, pos.z, 0, 1);
      vertex(-.5, .5, pos.z, 1, 0);
      vertex(.5, .5, pos.z, 0, 0);
    endShape();
    
    beginShape(TRIANGLE_STRIP);
      if(doTextures)
        texture(textures[0]);
      vertex(-.5, -.5, 0, 0, 0);
      vertex(.5, -.5, 0, 1, 0);
      vertex(-.5, .5, 0, 0, 1);
      vertex(.5, .5, 0, 1, 1);
    endShape();
    
    beginShape(TRIANGLE_STRIP);  
      if(doTextures)
        texture(textures[1]);
      vertex(.5, .5, pos.z, 1, 1);
      vertex(.5, .5, 0, 1, 0);
      vertex(.5, -.5, pos.z, 0, 1);
      vertex(.5, -.5, 0, 0, 0);
    endShape();
    
    beginShape(TRIANGLE_STRIP); 
      if(doTextures)
        texture(textures[1]);
      vertex(-.5, .5, 0, 1, 1);
      vertex(-.5, .5, pos.z, 1, 0);
      vertex(-.5, -.5, 0, 0, 1);
      vertex(-.5, -.5, pos.z, 0, 0);
    endShape();
    
    beginShape(TRIANGLE_STRIP);  
      if(doTextures)
        texture(textures[1]);
      vertex(-.5, .5, pos.z, 1, 1);
      vertex(-.5, .5, 0, 1, 0);
      vertex(.5, .5, pos.z, 0, 1);
      vertex(.5, .5, 0, 0, 0);
    endShape();
    
    beginShape(TRIANGLE_STRIP); 
      if(doTextures)
        texture(textures[1]);
      vertex(.5, -.5, 0, 1, 1);
      vertex(.5, -.5, pos.z, 1, 0);
      vertex(-.5, -.5, 0, 0, 1);
      vertex(-.5, -.5, pos.z, 0, 0);
    endShape();
    
    popMatrix();
  }
}
