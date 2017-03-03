int points = 0;
int lifes = 3;

float startAngle = 30;
float endAngle = 330;
float animationStep = 0;

float startAngleRight = 30;
float endAngleRight = 330;

float startAngleLeft = 210;
float endAngleLeft = 510;

float startAngleDown = 120;
float endAngleDown = 420;

float startAngleUp = 300;
float endAngleUp = 600;

float pacmanX = 250;
float pacmanY = 250;
float pacmanWidth = 100;
float pacmanHeigth = 100;

float step = 2.0;
int direction = 1;

boolean moveUp = false;
boolean moveDown = false;
boolean moveLeft = false;
boolean moveRight = false;

float circleBoardSize = 50.0;
float circleSize = 30.0;
float circleX[];
float circleY[];
boolean circles[];

int circlesTime[];

void setup() {
  size(800, 600);
  smooth();
  strokeWeight(0);

  int count = (int)(width/ circleBoardSize);
  circleX = new float[count];
  circleY = new float[count];
  circles = new boolean[count];
  circlesTime = new int[count];

  float margin = (width - count * circleBoardSize) / 2;
  for (int i = 0; i < circleX.length; i++) {
    circleX[i] = margin + i * circleBoardSize + circleBoardSize / 2.0;
    circleY[i] = random(20, height - 70);
    circles[i] = true;
  }
}

void draw() {
  background(255);

  if (moveUp == true) {
    startAngle = startAngleUp - animationStep;
    endAngle = endAngleUp + animationStep;
    pacmanY -= 5;
  }
  if (moveDown == true) {
    startAngle = startAngleDown - animationStep;
    endAngle = endAngleDown + animationStep;
    pacmanY += 5;
  }
  if (moveLeft == true) {
    startAngle = startAngleLeft - animationStep;
    endAngle = endAngleLeft + animationStep;
    pacmanX -= 5;
  }
  if (moveRight == true) {
    startAngle = startAngleRight - animationStep;
    endAngle = endAngleRight + animationStep;
    pacmanX += 5;
  }
  
  if (pacmanX - pacmanWidth / 2 <= 0) pacmanX = pacmanWidth / 2;
  if (pacmanY - pacmanHeigth / 2 <= 0) pacmanY = pacmanHeigth / 2;
  if (pacmanX + pacmanWidth / 2 >= width) pacmanX = width - pacmanWidth / 2;
  if (pacmanY + pacmanHeigth / 2 >= height - 50) pacmanY = height - 50 - pacmanHeigth / 2;

  fill(250, 5, 9);
  for (int i = 0; i < circleX.length; i++) {
    if (circles[i] == true) {
      ellipse(circleX[i], circleY[i], circleSize, circleSize);
    }
  }

  fill(250, 201, 5);
  arc(pacmanX, pacmanY, pacmanWidth, pacmanHeigth, radians(startAngle), radians(endAngle));
  fill(0);
  text("Points: " + points, 10, 15);

  fill(255, 0, 0);
  float startX = 30;
  float startY = height;
  for (int i = 0; i < lifes; i++) {
    arc(startX, startY - 30, 40, 30, radians(0), radians(180));
    arc(startX - 10, startY - 30, 20, 15, radians(180), radians(360));
    arc(startX + 10, startY - 30, 20, 15, radians(180), radians(360));

    startX += 50;
  }
  
  for (int i = 0; i < circleX.length; i++) {
    if (circles[i] == true) {
      float distance = sqrt((pacmanX - circleX[i]) * (pacmanX - circleX[i]) + (pacmanY - circleY[i]) * (pacmanY - circleY[i]));
      if (distance < (pacmanWidth + circleSize) / 2) {
        points += random(5, 10);
        circles[i] = false;
        circlesTime[i] = 200;
      }
    } else {
      circlesTime[i]--;
      if (circlesTime[i] == 0) {
        circles[i] = true;
        circleX[i] = random(20, width - 20);
        circleY[i] = random(20, height - 70);
      }
    }
  }

  animationStep += step * direction;
  if (animationStep <= 0 || animationStep >= 30) {
    direction *= -1;
  }
}

void keyPressed() {
  if (key == CODED) {
    switch  (keyCode) {
    case UP: 
      clearPress();
      moveUp = true; 
      break;
    case DOWN: 
      clearPress();
      moveDown = true; 
      break;
    case LEFT:
      clearPress();
      moveLeft = true; 
      break;
    case RIGHT: 
      clearPress();
      moveRight = true; 
      break;
    }
  }
}

void clearPress() {
  moveLeft = false;
  moveRight = false;
  moveUp = false;
  moveDown = false;
}

void keyReleased() {
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