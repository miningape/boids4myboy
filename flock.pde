class Flock {
  ArrayList<boid> boids;
  int c=0;
  Flock (int init_n_boids) {
    boids = new ArrayList<boid>();
    for (int i = 0; i < init_n_boids; i++) {
      this.boids.add(new boid(random(width), random(height/2), randomColor())); 
    }
  }
  
  color randomColor () {
    return color(random(255), random(255), random(255));
  }
  
  void update(ArrayList<kame> has) {
    for (kame ha : has) {
      ha.show(); 
    }
    for (int i = boids.size() - 1; i > 0; i--) {
      boids.get(i).action(boids, has); 
      
      if (boids.get(i).collides(has)) {
        println("collision", c++);
        boids.remove(i);
      }
    }
  }
  
  void addMember (float x, float y) {
    boids.add(new boid(x, y, color(random(255), random(255), random(255))));
  }
  
  void removeMember (int i) {
    boids.remove(i);
  }
}
