PFont gameOverFont;

int points = 0;
int lifes = 3;
boolean gameOver = false;

Button restartButton;

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
Circle circles[];
Color circleColor = new Color(255, 0, 0);

Circle enemyCircles[];
Color enemyColor = new Color(39, 3, 255);
int enemyAppearTime = 400;

void setup() {
  size(800, 600);
  smooth();
  strokeWeight(0);
  
  gameOverFont = createFont("28 Days Later.ttf", 40, true);  
  restartButton = new Button(width / 2 - 100, 3 * height / 4 - 35, 200, 70, gameOverFont, "Restart");

  int count = (int)(width/ circleBoardSize);
  circles = new Circle[count];

  float margin = (width - count * circleBoardSize) / 2;
  for (int i = 0; i < circles.length; i++) {
    float x = margin + i * circleBoardSize + circleBoardSize / 2.0;
    float y = random(20, height - 70);
    circles[i] = new Circle(x, y, true, 0);
  }

  int enemyCount = (int)(count / 5);
  enemyCircles = new Circle[enemyCount];

  for (int i = 0; i < enemyCircles.length; i++) {
    float x = random(20, width - 20);
    float y = random(20, height - 20);
    enemyCircles[i] = new Circle(x, y, false, 0);
  }
}

void draw() {
  if (gameOver == false) {
    prepareGame();
    drawGame();
  } else {
    drawGameOver();
    if (restartButton.needsRestart()) {
      restart();
    }
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
  restartButton.drawButton();
}

void drawGameOverMessage() {
  background(0);
  fill(255, 0, 0);
  textFont(gameOverFont, 40);
  textAlign(CENTER, CENTER);
  text("Game Over\n Points " + points, width / 2, height / 2);
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
  for (int i = 0; i < circles.length; i++) {
    if (circles[i].isVisible) {
      circles[i].drawWithColor(circleColor);
    }
  }
}

void drawEnemyCircles() {
  for (int i = 0; i < enemyCircles.length; i++) {
    if (enemyCircles[i].isVisible) {
      enemyCircles[i].drawWithColor(enemyColor);
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
  for (int i = 0; i < circles.length; i++) {
    if (circles[i].isVisible) {
      float distance = sqrt((pacmanX - circles[i].x) * (pacmanX - circles[i].x) + (pacmanY - circles[i].y) * (pacmanY - circles[i].y));
      if (distance < (pacmanWidth + circles[i].size) / 2) {
        points += random(5, 10);
        circles[i].hide();
        circles[i].time = 200;
      }
    } else {
      circles[i].time--;
      if (circles[i].time == 0) {
        circles[i].show();
        circles[i].x = random(20, width - 20);
        circles[i].y = random(20, height - 70);
      }
    }
  }
}

void calculateDistancesToEnemies() {
  for (int i = 0; i < enemyCircles.length; i++) {
    if (enemyCircles[i].isVisible) {
      float ac = pacmanY - enemyCircles[i].y;  
      float bc = pacmanX - enemyCircles[i].x;

      float distance = sqrt(ac * ac +bc * bc);

      if (distance <= (pacmanWidth + enemyCircles[i].size) / 2) {
        lifes--;
        enemyCircles[i].hide();
        
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
    while (i < enemyCircles.length && enemyCircles[i].isVisible) {
      i++;
    }

    if (i < enemyCircles.length) {
      enemyCircles[i].x = random(20, width - 20);
      enemyCircles[i].y = random(20, height - 70);
      enemyCircles[i].show();
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