class Kame {
  PVector pos;
  PVector velocity;
  PVector direction;
  float mass = 50;
  float r = mass/2;
  float scale =.35;
  float l = 155*scale;
  
  boolean exists;
  
  
  Kame(float x, float y, float theta){
    this.pos = new PVector(x + (this.l * cos(theta)), y + (this.l * sin(theta)));
    this.velocity = new PVector(cos(theta), sin(theta));
    this.velocity.mult(10);
    exists = true;
  }
  
  Kame () {
    exists = false;
  }
  
  void drawchi(){
    stroke(#F5ED00);
    strokeWeight(3);
    fill(#FF2D0D);
    ellipse(pos.x, pos.y, mass, mass);
  }
  
  void movechi(){
    this.pos.add(this.velocity);
  }
  
  void update() {
    drawchi();
    movechi();
  }
}
