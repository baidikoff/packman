float startAngle = 30;
float endAngle = 330;
int minStartAngle = 0;
int maxStartAngle = 30;

float pacmanX = 250;
float pacmanY = 250;
float pacmanWidth = 150;
float pacmanHeigth = 150;

float step = 2.0;
int direction = -1;

boolean moveUp = false;
boolean moveDown = false;
boolean moveLeft = false;
boolean moveRight = false;

void setup() {
  size(800, 600);
  smooth();
  strokeWeight(0);
}

void draw() {
  background(255);

  if (moveUp == true) pacmanY -= 5;
  if (moveDown == true) pacmanY += 5;
  if (moveLeft == true) pacmanX -= 5;
  if (moveRight == true) pacmanX += 5;

  fill(250, 5, 9);
  for (int i = 0; i < 5; i++) {
    ellipse (350 + i * 100, 250, 50, 50);
  }

  fill(250, 201, 5);
  arc(pacmanX, pacmanY, pacmanWidth, pacmanHeigth, radians(startAngle), radians(endAngle));

  startAngle += step * direction;
  endAngle -= step * direction;
  
  if (startAngle <= minStartAngle || startAngle >= maxStartAngle) {
    direction *= -1;
  }
}

void keyPressed() {
  if (key == CODED) {
    switch  (keyCode) {
    case UP: 
      moveUp = true; 
      break;
    case DOWN: 
      moveDown = true; 
      break;
    case LEFT: 
      moveLeft = true; 
      break;
    case RIGHT: 
      moveRight = true; 
      break;
    }
  }
}

void keyReleased () {
  if (key == CODED) {
    switch  (keyCode) {
    case UP: 
      moveUp = false; 
      break;
    case DOWN: 
      moveDown = false; 
      break;
    case LEFT: 
      moveLeft = false; 
      break;
    case RIGHT: 
      moveRight = false; 
      break;
    }
  }
}