// I know the explosion is kinda cheesy :|

class ExplosionBit extends Particle{    
  float thetaR;
  PVector acceleration;
  int initTime;
  final int LIFE_SPAN = 200; // life spawn in millisecs
  
  ExplosionBit(PVector pos, PVector v, PVector a, float _thetaR){
    super(pos, new PVector(), v, color(.7, .5, 0), new PImage[1]);
    thetaR = _thetaR;
    size = 0.01;
    owner = ParticleOwner.NONE;
    acceleration = a;
    initTime = millis();
  }
  
  // check whether the bit should be dead
  void update(){
    if(millis() - initTime > LIFE_SPAN)
      isDead = true;
    
    else{
      velocity.add(acceleration);
      ent.pos.add(velocity);
    }
  }
  
  void display(){
    pushMatrix();
    rotate(thetaR);
    super.display();
    popMatrix();
  }
}

class Explosion{
  int density;
  float step;
  final float DEFAULT_V = 0.003;
  final float DEFAULT_A = 0.0005;
  
  Explosion(){
    density = 120;
    step = TWO_PI/density;
  }
  
  // spawn an explosion at the given position
  void explode(PVector pos){    
    float theta = 0;
    float v, a;
    
    // ensuring not exploding backward
    if(pos.y > 0){
      v = DEFAULT_V;
      a = DEFAULT_A;
    }
    else{
      v = -DEFAULT_V;
      a = -DEFAULT_A;
    }
    
    for(int i=0; i<density; i++){
      world.particleList.add(new ExplosionBit(pos.copy(), new PVector(0, a, 0), new PVector(0, v, 0), theta));
      theta += step;
    }
  }
}
