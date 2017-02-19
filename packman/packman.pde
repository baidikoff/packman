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

float circleBoardSize = 50.0;
float circleSize = 30.0;
float circleX[];
float circleY[];

void setup() {
  size(800, 600);
  smooth();
  strokeWeight(0);
  
  int count = (int)(width/ circleBoardSize);
  circleX = new float[count];
  circleY = new float[count];
  
  float margin = (width - count * circleBoardSize) / 2;
  for (int i = 0; i < circleX.length; i++) {
    circleX[i] = margin + i * circleBoardSize + circleBoardSize / 2.0;
    circleY[i] = 100;
  }
}

void draw() {
  background(255);

  if (moveUp == true) pacmanY -= 5;
  if (moveDown == true) pacmanY += 5;
  if (moveLeft == true) pacmanX -= 5;
  if (moveRight == true) pacmanX += 5;

  fill(250, 5, 9);
  for(int i = 0; i < circleX.length; i++)  {
    ellipse(circleX[i], circleY[i], circleSize, circleSize);
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