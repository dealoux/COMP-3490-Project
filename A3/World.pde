final float SCALE = 1; // 2x2 from -1 to 1, world scale
final int DENSITY = 2; // density of the blocks in each section, total = TILES*DENSITY
final int TILES = 20; // number of blocks each section that are in view (ortho)

// enum for 2 view modes
enum ViewMode {
  ORTHO,
  PERSPEC
}

class World{
  ViewMode mode;
  
  float y, traverseSpeed; // world's y position and its traverse/scrolling speed
  
  // 2 sections for swapping
  WorldSection world1; 
  WorldSection world2;
  
  ParticleList particleList; // particle manager
  EnemySpawner spawner; // enemy spawner/manager
  Player player; // player instance
  Explosion explosion; // explosion manager
  
  // init all the properties of our new world
  World(){
    // default view mode
    mode = ViewMode.ORTHO;
    ortho(-SCALE, SCALE, SCALE, -SCALE, 0, SCALE*2);
    dotsPerUnit = max(width, height)/2;
    
    y = 0;
    traverseSpeed = 0.01;
    
    float offset = -.3;
    world1 = new WorldSection(offset);
    world2 = new WorldSection(SCALE*DENSITY*2 + offset);
    
    particleList = new ParticleList();
    spawner = new EnemySpawner();
    
    player = new Player();
    particleList.add(player);
    
    explosion = new Explosion();
  }
  
  // toggle between the two view modes
  void switchViewMode(){
    // find out what the current mode is, then switch to the other mode, reconfigure the camera's position
    switch(mode){
      case ORTHO:
        mode = ViewMode.PERSPEC;        
        frustum(-SCALE, SCALE, -SCALE, SCALE, SCALE, -SCALE);
        fixFrustumYFlip();
        camera = new Camera(new PVector(0, -0.8, 5.6 * SCALE));
        break;
        
      case PERSPEC:
        mode = ViewMode.ORTHO;
        ortho(-SCALE, SCALE, SCALE, -SCALE, 0, SCALE*2);
        camera = new Camera(new PVector(0, 0, SCALE*2));
        break;
    }
    
    dotsPerUnit = max(width, height)/2; // recalculate dots per unit to match the current view volume
    println(mode); // informing the current mode
  }
  
  // swap the 2 section's positions  when they are out of range
  void sectionSwap(){
    float temp = world1.posY;
    world1.posY = world2.posY;
    world2.posY = temp;
  }
  
  // this method is called everyframe by draw, updating and keeping track of the y coordinate to emulate infinite scrolling
  void run(){
    if(mode == ViewMode.PERSPEC){
      translate(0, -.3, 0);
      scale(2);
    }
    
    particleList.run();
    spawner.run();
    
    // check if the current section is still in range, if so keep scrolling
    if(y > -SCALE*DENSITY*2)
      y -= traverseSpeed;
    // else swap the two section and reset the y postion of the entire world, this emulates a seamless infinite scrolling
    else{
      sectionSwap();
      y = 0;
    }
    
    // draw the sections
    pushMatrix();
    translate(0, y, 1.5);
    world1.drawSection();
    world2.drawSection();
    popMatrix();
  } //<>//
} // end of World class


class WorldSection{
  private Block[] list; // list to store all the blocks that form the section
  float size, posY; // size of a rectangle, the section's y coordinate
  
  WorldSection(float y){
    size = 2*SCALE/TILES; // size of a tile block
    posY = y;
    
    list = new Block[(int) sq(TILES * DENSITY)];    
    
    initSection(); // init the section
  }
  
  // init the blocks in the section, called once in the constructor
  private void initSection(){
    float offset = size * .5f;
    float x = -SCALE*DENSITY + offset;
    float y = -SCALE*DENSITY + offset;
    int index = 0;
    
    // for loop going through all the tile blocks in t he section, assign it's x, y, random z, identity velocity, and a random color
    for(int i=0; i<TILES*DENSITY; i++){
      y = -SCALE;
      for(int j = 0; j<TILES*DENSITY; j++){  
        // x, z, random height from .4 * SCALE to 1.7 *SCALE, no velocity, random colour, random textures
        Block block = new Block(new PVector(x, y, random(SCALE * .4, SCALE * 1.7)), new PVector(), color(random(0,1), random(0,1), random(0,1)), new PImage[] {groundTexturesTop[random(1) < .5 ? 0 : 1], groundTexturesSide[random(1) < .5 ? 0 : 1]});
        list[index++] = block;
        y += size;
      }
      x += size;
    }
  }
  
  // display the section, called by World.run()
  void drawSection(){
    pushMatrix();
    translate(0, posY); // translate the section in it's correct position
    
    // draw all the blocks for the sections
    for(Block block : list){
      block.drawBlock(size);
    }
    
    popMatrix();
  } //<>//
} // end of WorldSection class
