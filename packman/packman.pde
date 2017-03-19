PFont gameOverFont;

int points = 0;
int lifes = 3;
boolean gameOver = false;

float restartButtonWidth;
float restartButtonHeight;
float restartButtonX;
float restartButtonY;

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
float enemyCircleX[];
float enemyCircleY[];
boolean enemyCircles[];
int enemyCirclesTime[];
int enemyAppearTime = 400;

void setup() {
  size(800, 600);
  smooth();
  strokeWeight(0);
  
  gameOverFont = createFont("28 Days Later.ttf", 40, true);
  
  restartButtonWidth = 200;
  restartButtonHeight = 70;
  restartButtonX = width / 2 - restartButtonWidth / 2;
  restartButtonY = 3 * height / 4 - restartButtonHeight / 2;

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

  int enemyCount = (int)(count / 5);
  enemyCircleX = new float[enemyCount];
  enemyCircleY = new float[enemyCount];
  enemyCircles = new boolean[enemyCount];
  enemyCirclesTime = new int[enemyCount];

  for (int i = 0; i < enemyCircleX.length; i++) {
    enemyCircleX[i] = random(20, width - 20);
    enemyCircleY[i] = random(20, height - 20);
    enemyCircles[i] = false;
    enemyCirclesTime[i] = 0;
  }
}

void draw() {
  if (gameOver == false) {
    prepareGame();
    drawGame();
  } else {
    drawGameOver();
    checkRestart();
  }
}

void prepareGame() {
  selectAngles();
  bounceOnEdges();

  calculateDistancesToEnemies();
  calculateDistancesToCircles();
  calculateEnemyAppearing();
  calculateAnimation();
}

void drawGameOver() {
  drawGameOverMessage();
  drawRestartButton();
}

void drawGameOverMessage() {
  background(0);
  fill(255, 0, 0);
  textFont(gameOverFont, 40);
  textAlign(CENTER, CENTER);
  text("Game Over\n Points " + points, width / 2, height / 2);
}

void drawRestartButton() {  
  fill(255, 0, 0);
  textFont(gameOverFont, 40);
  textAlign(CENTER, CENTER);
  text("Restart", width / 2, 3 * height / 4);
}

void checkRestart() {
  if (mousePressed == true) {
    if (mouseX >= restartButtonX && mouseX <= restartButtonX + restartButtonWidth) {
      if (mouseY >= restartButtonY && mouseY <= restartButtonY + restartButtonHeight) {
        restart();        
      }
    }
  }
}

void restart() {
  lifes = 3;
  points = 0;
  gameOver = false;
}

void drawGame() {
  background(255);
  drawCircles();
  drawEnemyCircles();
  drawPacman();
  drawPoints();  
  drawLifes();
}

void selectAngles() {
  if (moveUp == true) {
    startAngle = startAngleUp - animationStep;
    endAngle = endAngleUp + animationStep;
    pacmanY -= 5;
  } else if (moveDown == true) {
    startAngle = startAngleDown - animationStep;
    endAngle = endAngleDown + animationStep;
    pacmanY += 5;
  } else if (moveLeft == true) {
    startAngle = startAngleLeft - animationStep;
    endAngle = endAngleLeft + animationStep;
    pacmanX -= 5;
  } else if (moveRight == true) {
    startAngle = startAngleRight - animationStep;
    endAngle = endAngleRight + animationStep;
    pacmanX += 5;
  }
}

void bounceOnEdges() {
  if (pacmanX - pacmanWidth / 2 <= 0) pacmanX = pacmanWidth / 2;
  if (pacmanY - pacmanHeigth / 2 <= 20) pacmanY = pacmanHeigth / 2 + 20;
  if (pacmanX + pacmanWidth / 2 >= width) pacmanX = width - pacmanWidth / 2;
  if (pacmanY + pacmanHeigth / 2 >= height - 50) pacmanY = height - 50 - pacmanHeigth / 2;
}

void drawCircles() {
  fill(250, 5, 9);
  for (int i = 0; i < circleX.length; i++) {
    if (circles[i] == true) {
      ellipse(circleX[i], circleY[i], circleSize, circleSize);
    }
  }
}

void drawEnemyCircles() {
  fill(39, 3, 255);
  for (int i = 0; i < enemyCircles.length; i++) {
    if (enemyCircles[i] == true) {
      ellipse(enemyCircleX[i], enemyCircleY[i], circleSize, circleSize);
    }
  }
}

void drawPacman() {
  fill(250, 201, 5);
  arc(pacmanX, pacmanY, pacmanWidth, pacmanHeigth, radians(startAngle), radians(endAngle));
}

void drawPoints() {
  fill(0);
  textFont(gameOverFont, 20);
  textAlign(LEFT, LEFT);
  text("Points " + points, 10, 20);
}

void drawLifes() {
  fill(255, 0, 0);
  float startX = 30;
  float startY = height;
  for (int i = 0; i < lifes; i++) {
    arc(startX, startY - 30, 40, 30, radians(0), radians(180));
    arc(startX - 10, startY - 30, 20, 15, radians(180), radians(360));
    arc(startX + 10, startY - 30, 20, 15, radians(180), radians(360));

    startX += 50;
  }
}

void calculateDistancesToCircles() {
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
}

void calculateDistancesToEnemies() {
  for (int i = 0; i < enemyCircles.length; i++) {
    if (enemyCircles[i] == true) {
      float ac = pacmanY - enemyCircleY[i];  
      float bc = pacmanX - enemyCircleX[i];

      float distance = sqrt(ac * ac +bc * bc);

      if (distance <= (pacmanWidth + circleSize) / 2) {
        lifes--;
        enemyCircles[i] = false;
        
        if (lifes == 0) {
          gameOver = true;
        }
      }
    }
  }
}

void calculateEnemyAppearing() {
  enemyAppearTime--; 
  if (enemyAppearTime == 0) {
    int i = 0; 
    while (i < enemyCircles.length && enemyCircles[i] == true) {
      i++;
    }

    if (i < enemyCircles.length) {
      enemyCircleX[i] = random(20, width - 20);
      enemyCircleY[i] = random(20, height - 70);
      enemyCircles[i] = true;
    }

    enemyAppearTime = 400;
  }
}

void calculateAnimation() {
  animationStep += step * direction; 
  if (animationStep <= 0 || animationStep >= 30) {
    direction *= -1;
  }
}



void keyPressed() {
  if (key == CODED) {
    switch  (keyCode) {
    case UP : 
      clearPress(); 
      moveUp = true; 
      break; 
    case DOWN : 
      clearPress(); 
      moveDown = true; 
      break; 
    case LEFT : 
      clearPress(); 
      moveLeft = true; 
      break; 
    case RIGHT : 
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
    case UP : 
      moveUp = false; 
      break; 
    case DOWN : 
      moveDown = false; 
      break; 
    case LEFT : 
      moveLeft = false; 
      break; 
    case RIGHT : 
      moveRight = false; 
      break;
    }
  }
}