class ParticleList{
  ArrayList<Particle> list;
  
  ParticleList(){
    list = new ArrayList<Particle>();
  }
  
  void add(Particle p){
    list.add(p);
  }
  
  void remove(Particle p){
    list.remove(p);
  }
  
  // update the list everyframe, called by World.run()
  void run(){
    // go through the list 
    for(int i=0; i<list.size(); i++){
      Particle p = list.get(i); // get the current particle
      
      // check if the particle is marked dead, if so remove from the list
      if (p.isDead) {
        list.remove(p);
      }
      // else update and display them
      else{
        p.update();
        p.display();
      }
    } // end of for loop
    
  }
  
} // end of ParticleList class
