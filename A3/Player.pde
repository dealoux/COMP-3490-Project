final PVector DEFAULT_POS = new PVector(0, -.7, 1.9);

class Player extends Particle{  
  float driftSpeed, movementSpeed, bound, angle;
  
  Player(){
    super(DEFAULT_POS.copy(), new PVector(), new PVector(), color(0, 0, 1), playerTextures);
    size = 0.15;
    owner = ParticleOwner.PLAYER;
    driftSpeed = 0.01; // speed for drifting back to the centre
    movementSpeed = 0.02; // movement speed for controlling
    bound = SCALE - size * 1.5; // movement bound
    angle = PI/8; // angle for movement rotation
  }
  
  // movement polling, check for bounds and collisions, decide the rotation angle, movement direction, whether or not should drift back to centre
  void update(){
    if(inputLeft){
      ent.pos.x -= (ent.pos.x > -bound) ? movementSpeed : 0;
      ent.theta.y = -angle;
    }
    else if(ent.pos.x < DEFAULT_POS.x && !inputRight && !inputDown && !inputUp){
      ent.pos.x += driftSpeed;
      ent.theta.y = 0;
    }
      
    if(inputRight){
      ent.pos.x += (ent.pos.x < bound) ? movementSpeed : 0;;
      ent.theta.y = angle;
    }
    else if(ent.pos.x > DEFAULT_POS.x && !inputLeft && !inputDown && !inputUp){
      ent.pos.x -= driftSpeed;
      ent.theta.y = 0;
    }
  
    if(inputDown){
      ent.pos.y -= (ent.pos.y > -bound) ? movementSpeed : 0;
      ent.theta.x = angle;
    }
    else{
      ent.theta.x = 0;
    }
    
    if(inputUp){
      ent.pos.y += (ent.pos.y < bound) ? movementSpeed : 0;
      ent.theta.x = -angle;
    }
    else if(ent.pos.y > DEFAULT_POS.y && !inputDown && !inputLeft && !inputRight){
      ent.pos.y -= driftSpeed;
      ent.theta.x = 0;
    }
    
    aIndex = inputUp ? 1 : 0; // switch texture if moving up
    
    // collision dectection
    if(doCollision){
      for (int i=0 ;i< world.particleList.list.size(); i++) {
        Particle p = world.particleList.list.get(i);
        if (p.owner == ParticleOwner.ENEMY)
          collide(p);
      }
    } 
  }
  
  // player's ability to shoot when alive, called directly by keyPressed()
  void shoot(){
    if(!isDead)
      world.particleList.add(new Bullet(ent.pos.copy(), new PVector(0, BULLET_SPEED, 0), owner, color(0, 1, 0)));
  }
}
