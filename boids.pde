Flock birds;
ArrayList<kame> has = new ArrayList<kame>();
int a;
void setup () {
  size(820, 640);
  
  has.add(new kame());
  birds = new Flock(100);
}

void draw () {
  a++;
  background(51, a%255);
  birds.update(has);
}
