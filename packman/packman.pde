PFont gameOverFont;

int points = 0;
int lifes = 3;

boolean mainMenu = true;
boolean gameOver = false;

Button playButton;
Button restartButton;

float startAngleRight = 30;
float endAngleRight = 330;
float startAngleLeft = 210;
float endAngleLeft = 510;
float startAngleDown = 120;
float endAngleDown = 420;
float startAngleUp = 300;
float endAngleUp = 600;

Pacman pacman;

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
  
  pacman = new Pacman(250, 250, new Color(255, 255, 0));
  
  gameOverFont = createFont("28 Days Later.ttf", 40, true);  
  restartButton = new Button(width / 2 - 100, 3 * height / 4 - 35, 200, 70, gameOverFont, "Restart");
  playButton = new Button(width / 2 - 100, 3 * height / 4 - 35, 200, 70, gameOverFont, "Play");

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
  if (mainMenu == true) {
    drawMainMenu();
    if (playButton.needsRestart()) {
      mainMenu = false;
    }
  } else if (gameOver == false) {
    prepareGame();
    drawGame();
  } else {
    drawGameOver();
    if (restartButton.needsRestart()) {
      restart();
    }
  }
}

void drawMainMenu() {
  drawPacmanMessage();
  playButton.drawButton();
}

void drawPacmanMessage() {
  background(0);
  fill(255, 0, 0);
  textFont(gameOverFont, 40);
  textAlign(CENTER, CENTER);
  text("Pacman", width / 2, height / 2);
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
  pacman.drawPacman();
  drawPoints();  
  drawLifes();
}

void selectAngles() {
  if (moveUp == true) {
    pacman.startAngle = startAngleUp - pacman.shift;
    pacman.endAngle = endAngleUp + pacman.shift;
    pacman.y -= 5;
  } else if (moveDown == true) {
    pacman.startAngle = startAngleDown - pacman.shift;
    pacman.endAngle = endAngleDown + pacman.shift;
    pacman.y += 5;
  } else if (moveLeft == true) {
    pacman.startAngle = startAngleLeft - pacman.shift;
    pacman.endAngle = endAngleLeft + pacman.shift;
    pacman.x -= 5;
  } else if (moveRight == true) {
    pacman.startAngle = startAngleRight - pacman.shift;
    pacman.endAngle = endAngleRight + pacman.shift;
    pacman.x += 5;
  }
}

void bounceOnEdges() {
  if (pacman.x - pacman.size / 2 <= 0) pacman.x = pacman.size / 2;
  if (pacman.y - pacman.size / 2 <= 20) pacman.y = pacman.size / 2 + 20;
  if (pacman.x + pacman.size / 2 >= width) pacman.x = width - pacman.size / 2;
  if (pacman.y + pacman.size / 2 >= height - 50) pacman.y = height - 50 - pacman.size / 2;
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
      float distance = sqrt((pacman.x - circles[i].x) * (pacman.x - circles[i].x) + (pacman.y - circles[i].y) * (pacman.y - circles[i].y));
      if (distance < (pacman.size + circles[i].size) / 2) {
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
      float ac = pacman.y - enemyCircles[i].y;  
      float bc = pacman.x - enemyCircles[i].x;

      float distance = sqrt(ac * ac +bc * bc);

      if (distance <= (pacman.size + enemyCircles[i].size) / 2) {
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
  pacman.shift += step * direction; 
  if (pacman.shift <= 0 || pacman.shift >= 30) {
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