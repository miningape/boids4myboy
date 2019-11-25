class playeR {
  public PVector player;
  public PVector velocity;
  PVector dir;
  public float m;
  public float s = .35;
  
 playeR(float m, PVector cent){
   this.m = m;
   this.player = cent;
   this.velocity = new PVector(0,0);
   
 }

 void drawplayeR(){
   pushMatrix();
   translate(this.player.x, this.player.y);
   
   stroke(0);
   strokeWeight(10);
   fill(#2D28E8);
   ellipse(0, 0, s*(this.m*8), s*(this.m*8));
   line(0 , s*(this.m*4), 0 , s*(this.m*4+225));
   line(0, s*(this.m*2+225), 35*s, s*(this.m*2 +450));
   line(0, s*(this.m*2+225), -35*s, s*(this.m*2 +450));
   
   dir = new PVector(mouseX - this.player.x, mouseY - (this.player.y+(s*(this.m*4+225)*9/16)));
  

   pushMatrix();
   translate(0, s*(this.m*4+225)*9/16);
   rotate(this.dir.heading()+PI/2);
   line(0, 0, -10*s, -100*s);
   line(0, -100*s, 40*s, -130*s);
   line(0, -100*s, -40*s, -130*s);
   line(0, 0, 10*s, -100*s);
   popMatrix();
   
   popMatrix();
 }
 
  
  
  void moveplayer(){
    this.player.add(velocity);
  }
}
