final int CURR = 0; // current keyframe
final int NEXT = 1; // next keyframes

final int RECALC = -1;
final float DOTS_PER_FRAME = 2.5; // movementSpeed
final int SHOOT_INTERVAL = 2000; // milliseconds between each shot
float dotsPerUnit; // will be recalculated as the view volume chanes


class Enemy extends Particle{  
  float bound, lastShotTime;
  int steps, currStep;
  float[][] keyframes; // storage for the 2 current and next keyframes, x and y only
  
  Enemy(PVector pos){    
    super(pos, new PVector(), new PVector(), color(0, 0, 0), enemyTextures);
    size = 0.2;
    owner = ParticleOwner.ENEMY;
    bound = SCALE - size * 1.5; // movement bound/range
    lastShotTime = millis(); // keeping track of the last time this enemy fired at the player
    
    // initial keyframes
    keyframes = new float[][]{
      {pos.x, pos.y},
      {random(-bound, bound), random(-bound, bound)}
    };
        
    steps = RECALC;
    currStep = 0;
  }
  
  // lerping related functions, slightly modified, taken from unit 8's examples
  void mylerp(float t, float[] curr, float[] next) {
    ent.pos.x = (1-t)*curr[X] + t*next[X];
    ent.pos.y = (1-t)*curr[Y] + t*next[Y];
  }
  
  int calculateSteps(float[] curr, float[] next) {
    float distance = sqrt(sq(curr[X] - next[X]) + sq(curr[Y] - next[Y]));
    return (int)(distance * dotsPerUnit / DOTS_PER_FRAME);
  }
  
  // enemy's ability to move, by using sinusoidal interpolation to lerp between each keyframes, ensuring smooth ease in and out animation
  private void move(){    
    if ( steps == RECALC ){
      keyframes[CURR] = keyframes[NEXT];
      keyframes[NEXT] = new float[]{random(-bound, bound), random(-bound, bound)};
      
      steps = calculateSteps(keyframes[CURR], keyframes[NEXT]);
    }
      
    float t = currStep/(float)steps;
    float t_ = (1-cos(t*PI))/2; // ease in and out

    mylerp(t_, keyframes[CURR], keyframes[NEXT]);
    
    // advance keyframe
    currStep++;
    if (currStep >= steps) {  
      currStep = 0;
      steps = RECALC;
    }
    
    // collision dectection
    if(doCollision){      
      for (int i=0 ;i< world.particleList.list.size(); i++) {
        Particle p = world.particleList.list.get(i);
        if (p.owner == ParticleOwner.PLAYER)
          collide(p);
      }
    }
  }
  
  // enemy's ability to shoot at the player, called by update()
  private void shoot(){
    // check if should shoot
    if(millis() - lastShotTime > SHOOT_INTERVAL){
      PVector posB = ent.pos.copy();
      PVector velocityB = PVector.sub(world.player.ent.pos, posB);
      velocityB.normalize().mult(BULLET_SPEED);
      
      world.particleList.add(new Bullet(ent.pos.copy(), velocityB, owner, color(1, 0, 0)));
      lastShotTime = millis();
    }
  }
  
  // override to also remove from the spawner, called by move()
  void collide(Particle other) {
    PVector delta = PVector.sub(other.ent.pos, ent.pos);
    delta.z = 0;
    
    if (delta.mag() < size) { // collision  
      world.explosion.explode(ent.pos.copy());
      isDead = true;
      other.isDead = true;
      world.spawner.list.remove(this);
    }
  }
  
  // called every frame by the particle manager
  void update(){
    move();
    shoot();
  }
} // end of Enemy class

// this class is for keeping track of all the enemies in the world
class EnemySpawner{
  ArrayList<Enemy> list;
  int lastSpawnTime; // keeping track of the last time an
  int spawnInterval = 4000; // milisecs between each spawn
  int maxEnemy = 7; // maximum number of enemies per world
  float spawnRadius = .7; // radius to spawn
  
  EnemySpawner(){
    list = new ArrayList<Enemy>();
  }
  
  // check whether or not should spawn an enemy, called by World.run()
  void run(){
    // if there's no enemy left, spawn one
    if(list.size() == 0){
      spawnAnEnemy();
    }
    
    // if the maximum count is not yet reached, and long enough time has passed since the last spawn
    if( list.size() < maxEnemy && (millis() - lastSpawnTime > spawnInterval) ){
      spawnAnEnemy(); // spawn an enemy
      lastSpawnTime = millis(); // also update the last spawn time to the current time
    }
  }
  
  // spawn an enemy to the world, with random position within the radius, height is universally 1.8 * SCALE
  private void spawnAnEnemy(){
    Enemy newEnemy = new Enemy(new PVector(random(-spawnRadius, spawnRadius), random(0, spawnRadius), 1.8 * SCALE));
    // add to both this list and the particleList
    list.add(newEnemy);
    world.particleList.add(newEnemy);
  }
}
