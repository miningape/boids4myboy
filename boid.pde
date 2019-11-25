class boid {
  PVector pos, vel, acc;
  float theta;
  public float maxSpeed, maxForce;
  float len, wid, mass;
  
  color my_color;
  
  boid (float x, float y, color col) {
    theta = random(TWO_PI);
     
    pos = new PVector(x, y);
    vel = new PVector(cos(theta), sin(theta));
    acc = new PVector();
    
    my_color = col;
    
    maxSpeed = 2;
    maxForce = 0.05;
    
    wid = 7;
    len = (int)(PI * wid) + random(0, 1.0f)*5;
    mass = 1;
  }
  
  void applyForce (PVector force) {
    // Force with mass since A = F/M
    this.acc.add(force).div(this.mass);
  }
  
  PVector seek (PVector target_pos) {
    PVector desired = PVector.sub(target_pos, this.pos);
    
    desired.normalize();
    desired.mult(maxSpeed);
    
    // Reynolds: Steering Force = Desired - Velocity
    PVector steering = PVector.sub(desired, this.vel);
    steering.limit(maxForce);
    return steering;
  }
  
  // Creates a hidden circle around the boid, if the ball and the circle
  // intersect the method returns true as the ball and bird are colliding
  boolean collides (ArrayList<Kame> has) {
    for (Kame ha : has) {
      PVector dir = vel.copy().normalize();
      
      // Tracks the center of our boid
      PVector center = new PVector(this.pos.x - ((this.len/2) * dir.x), this.pos.y - ((this.len/2) * dir.y));
      
      // Draw the collision box
      /*noFill();
      stroke(#ff0000);
      ellipse(center.x, center.y, this.len, this.len);*/
      
      if (PVector.dist(ha.pos, center) < (this.len/2 + ha.r)) {
        ellipse(center.x, center.y, 20, 20);
        return true; 
      }
    }
    
    return false;
  }
  
  // Container method to call all the actions a boid will take in a frame
  void action (ArrayList<boid> boids, ArrayList<Kame> has) {
    behaviour_force(boids, has);      // Gets the resultant force on boid
    update ();                   // Updates pos, and vel
    border_loop ();              // Makes sure the boids are on screen
    show();                      // Draws our boid
  }
  
  // Function applys a force to the boid based on its neighbors
  // This function is more of a wrapper to calculate all the forces
  // on a boid at once
  void behaviour_force (ArrayList<boid> boids, ArrayList<Kame> has) {
    for (Kame ha : has) {
      if (PVector.dist(ha.pos, this.pos) < 40)
        applyForce( seek(ha.pos).mult(-1) );
    }
    
    applyForce( align(boids) );        // Alignment Force
    applyForce( separate(boids) );     // Separation Force
    applyForce( cohesion(boids) );     // Cohesion Force
    
    
    applyForce( bounds() );
    // PVector avoidForce = avoid( stork );
    
    // The sum of the forces is the resultant force on the boid based on its
    // neighbors
  }
  
  // Propegates the acceleration down to the position by adding vel and acc
  void update () {
    // Increase the velocity by the resultant force
    this.vel.add(this.acc);
    this.vel.limit(maxSpeed); // But limit it so the boid's speed doesn't increase
    
    // Update the position
    this.pos.add(this.vel);
    
    // Reset our acceleration so every frame is indipendant and doesn't depend
    // on the last frame
    this.acc.mult(0);
  }
  
  // Method checks whether the boid is on or off screen, and loops it to the other side
  void border_loop () {
    if (this.pos.x > width)
      this.pos.x = 0;
     
    if (this.pos.x < 0)
      this.pos.x = width;
  }
  
  void show () {
    noStroke();
    fill(my_color);
    
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(vel.heading());
    
    // Actual drawing
    triangle(0, 0, -this.len, (this.wid/2), -this.len, -(this.wid/2));
    
    popMatrix();
  }
  
  // Alignment 
  // For every near by boid
  PVector align (ArrayList<boid> boids) {
    float max_dist = 50f;
    PVector sum = new PVector(0, 0);    // This is our desired velocity
    int count = 0;
    
    for (boid other : boids) {
      float d_between = PVector.dist(this.pos, other.pos);
      
      if ((d_between > 0) && (d_between <= max_dist)) {
        sum.add(other.vel);
        count++;
      }
    }
    
    if (count > 0) {
        sum.div(count); // Average direction of all nearby boids
        
        // Unit vector to actual vector with a magnitude of maxspeed but direction
        // of sum
        sum.normalize();
        sum.mult(maxSpeed);
        
        // Reynolds: Steering Force = Desired Vel - Current Vel
        PVector steer = PVector.sub(sum, vel);
        steer.limit(maxForce);
        return steer;
        
      } else { return new PVector(0, 0); }
  };
  
  PVector separate (ArrayList<boid> boids) {
    float sep_dist = 30f;
    PVector steer = new PVector(0, 0);
    int count = 0;
    
    for (boid other : boids) {
      float dist = PVector.dist(this.pos, other.pos);
      
      if ((dist > 0) && (dist <= sep_dist)) {
        PVector difference = PVector.sub(this.pos, other.pos); // Vector pointing from other to current
        difference.normalize();
        difference.div(dist); // Scale with distance
        steer.add(difference);
        count++;
      }
    }
    
    if (count > 0) {
      steer.div(count);
    }
    
    if (steer.mag() > 0) {
      steer.normalize();
      steer.mult(maxSpeed);
      
      // Reynolds: Steering Force = Desired - velocity
      steer.sub(this.vel);
      steer.limit(1.5* maxForce);
    }
    
    return steer;
  }
  PVector cohesion (ArrayList<boid> boids) {
    float cohesion_dist = 50f;
    PVector position_avg = new PVector(0, 0);
    int count = 0;
    
    for (boid other : boids) {
      float dist = PVector.dist(this.pos, other.pos);
      
      if ((dist > 0) && dist < cohesion_dist) {
        position_avg.add(other.pos);
        count++;
      }
    }
    
    if (count > 0) {
      position_avg.div(count);
      return seek(position_avg);
    } else {
      return new PVector(0, 0);
    }
  }
  
  PVector bounds () {
    PVector desired = new PVector(0, 0);
       
    if (this.pos.y < 0)
      desired.y = 10;
      
    if (this.pos.y > height/2)
      desired.y = -10;
      
    desired.normalize();
    desired.mult(maxForce * maxSpeed);
    
    return desired;
    
  }
}
