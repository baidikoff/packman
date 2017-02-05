float startAngle = 30;
float endAngle = 330;

float step = 1.0;
int direction = -1;

void setup() {
  size(800, 600);
  smooth();
  strokeWeight(0);
}

void draw() {
  background(255);
  fill(33, 255, 0);
  arc(250, 250, 150, 150, radians(startAngle), radians(endAngle));
  
  ellipse(450, 250, 50, 50);
  ellipse(550, 250, 50, 50);
  ellipse(650, 250, 50, 50); 
  
  startAngle += step * direction;
  endAngle -= step * direction;

  if ( startAngle <= 0 || startAngle >= 30) {
    direction *= -1;
  }
}