import processing.sound.*;
SoundFile goku;
SoundFile bird_s;

Flock boids;
playeR dude;
Kame blast;
PVector angle;

void setup(){
  size(1800,1200);
  dude = new playeR(20, new PVector(width/2, height-175));
  angle = new PVector(mouseX - dude.player.x, mouseY - (dude.player.y+(dude.s*(dude.m*4+225)*9/16)));
  boids = new Flock(50);
  blast = new Kame();
  goku = new SoundFile(this, "fire.wav");
  bird_s = new SoundFile(this, "birds.wav");
  bird_s.amp(.5);
  bird_s.loop();
}

void draw(){
  background(51);
  
  dude.drawplayeR();
  dude.moveplayer();
  
  if (blast.exists) {
    blast.update();
    boids.update(new ArrayList<Kame>().add(blast));
  } else {
    boids.update(new ArrayList<Kame>().add(new Kame()));
  }
}

void keyPressed(){
  if (key == CODED) {
    switch (keyCode) {
      case LEFT:
        dude.velocity = new PVector(-6,0);
      break;
        
      case RIGHT:
        dude.velocity = new PVector(6,0);
        
      break; 
    }
  }
  switch (key) {
    case ' ':
    angle = new PVector(mouseX - dude.player.x, mouseY - (dude.player.y+(dude.s*(dude.m*4+225)*9/16)));
    blast = new Kame(dude.player.x, dude.player.y + (dude.s*(dude.m*4+225)*9/16), angle.heading());
    goku.amp(.25);
    goku.play();
    break;
  }
}
void keyReleased(){
  if (key == CODED){
    switch (keyCode) {
      case LEFT:
        dude.velocity = new PVector(0,0);
      break;
        
      case RIGHT:
        dude.velocity = new PVector(0,0);
        
      break;
    }
  }
}
