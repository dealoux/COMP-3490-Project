final float BULLET_SPEED = 0.03f;

class Bullet extends Particle{    
  Bullet(PVector pos, PVector v, ParticleOwner _owner, color c){
    super(pos, new PVector(), v, c, bulletTextures);
    size = 0.05;
    aIndex = _owner.ordinal();
    owner = _owner;
  }
  
  // if the bullet is out of bound, set it to dead, else keep it moving
  void update(){
    if(ent.pos.y < -SCALE*DENSITY || ent.pos.y > SCALE*DENSITY)
      isDead = true;
      
    else
      ent.pos.add(velocity);
  }
}
