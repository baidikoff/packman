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
    circleY[i] = random(20, height - 20);
    circles[i] = true;
  }
}

void draw() {
  background(255);

  if (moveUp == true) pacmanY -= 5;
  if (moveDown == true) pacmanY += 5;
  if (moveLeft == true) pacmanX -= 5;
  if (moveRight == true) pacmanX += 5;
  
  if(pacmanX - pacmanWidth / 2<= 0) pacmanX =pacmanWidth / 2;
  if(pacmanY - pacmanHeigth / 2<= 0) pacmanY =pacmanHeigth / 2;
  if(pacmanX + pacmanWidth / 2>=width ) pacmanX = width - pacmanWidth / 2;
  if(pacmanY + pacmanHeigth / 2>=height ) pacmanY = height - pacmanHeigth / 2;
  
  fill(250, 5, 9);
  for (int i = 0; i < circleX.length; i++) {
    if (circles[i] == true) {
      ellipse(circleX[i], circleY[i], circleSize, circleSize);
    }
  }

  fill(250, 201, 5);
  arc(pacmanX, pacmanY, pacmanWidth, pacmanHeigth, radians(startAngle), radians(endAngle));

  for (int i = 0; i < circleX.length; i++) {
    if (circles[i] == true) {
      float distance = sqrt((pacmanX - circleX[i]) * (pacmanX - circleX[i]) + (pacmanY - circleY[i]) * (pacmanY - circleY[i]));
      if (distance < (pacmanWidth + circleSize) / 2) {
        circles[i] = false;
        circlesTime[i] = 200;
      }
    } else {
     circlesTime[i]--;
     if(circlesTime[i] == 0) {
       circles[i] = true;
       circleX[i] = random(20, width - 20);
       circleY[i] = random(20, height - 20);
     }
    }
  }
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