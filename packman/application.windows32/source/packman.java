import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class packman extends PApplet {

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

float step = 2.0f;
int direction = 1;

boolean moveUp = false;
boolean moveDown = false;
boolean moveLeft = false;
boolean moveRight = false;

float circleBoardSize = 50.0f;
Circle circles[];
Color circleColor = new Color(255, 0, 0);

Circle enemyCircles[];
Color enemyColor = new Color(39, 3, 255);

int enemyAppearTime = 400;
int maxEnemyAppearTime = 400;
int enemyCount = 0;

public void setup() {
  
  
  strokeWeight(0);
  
  pacman = new Pacman(250, 250, new Color(255, 255, 0));
  
  gameOverFont = createFont("28 Days Later.ttf", 40, true);  
  restartButton = new Button(width / 2 - 100, 3 * height / 4 - 35, 200, 70, gameOverFont, "Restart");
  playButton = new Button(width / 2 - 100, 3 * height / 4 - 35, 200, 70, gameOverFont, "Play");

  int count = (int)(width/ circleBoardSize);
  circles = new Circle[count];

  float margin = (width - count * circleBoardSize) / 2;
  for (int i = 0; i < circles.length; i++) {
    float x = margin + i * circleBoardSize + circleBoardSize / 2.0f;
    float y = random(20, height - 70);
    circles[i] = new Circle(x, y, true, 0);
  }

  int enemyCount = (int)(count / 3);
  enemyCircles = new Circle[enemyCount];

  for (int i = 0; i < enemyCircles.length; i++) {
    float x = random(20, width - 20);
    float y = random(20, height - 20);
    enemyCircles[i] = new Circle(x, y, false, 0);
  }
}

public void draw() {
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

public void drawMainMenu() {
  drawPacmanMessage();
  playButton.drawButton();
}

public void drawPacmanMessage() {
  background(0);
  fill(255, 0, 0);
  textFont(gameOverFont, 40);
  textAlign(CENTER, CENTER);
  text("Pacman", width / 2, height / 2);
}

public void prepareGame() {
  selectAngles();
  bounceOnEdges();

  calculateDistancesToEnemies();
  calculateDistancesToCircles();
  calculateEnemyAppearing();
  calculateAnimation();
}

public void drawGameOver() {
  drawGameOverMessage();
  restartButton.drawButton();
}

public void drawGameOverMessage() {
  background(0);
  fill(255, 0, 0);
  textFont(gameOverFont, 40);
  textAlign(CENTER, CENTER);
  text("Game Over\n Points " + points, width / 2, height / 2);
}

public void restart() {
  lifes = 3;
  points = 0;
  gameOver = false;
  
  enemyAppearTime = maxEnemyAppearTime;
  enemyCount = 0;
  for (int i = 0; i < enemyCircles.length; i++) {
    enemyCircles[i].hide();
  }
  
  for (int i = 0; i < circles.length; i++) {
    circles[i].x = random(20, width - 20);
    circles[i].y = random(20, height - 30);
    circles[i].show();
  }
}

public void drawGame() {
  background(255);
  drawCircles();
  drawEnemyCircles();
  pacman.drawPacman();
  drawPoints();  
  drawLifes();
}

public void selectAngles() {
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

public void bounceOnEdges() {
  if (pacman.x - pacman.size / 2 <= 0) pacman.x = pacman.size / 2;
  if (pacman.y - pacman.size / 2 <= 20) pacman.y = pacman.size / 2 + 20;
  if (pacman.x + pacman.size / 2 >= width) pacman.x = width - pacman.size / 2;
  if (pacman.y + pacman.size / 2 >= height - 50) pacman.y = height - 50 - pacman.size / 2;
}

public void drawCircles() {
  for (int i = 0; i < circles.length; i++) {
    if (circles[i].isVisible) {
      circles[i].drawWithColor(circleColor);
    }
  }
}

public void drawEnemyCircles() {
  for (int i = 0; i < enemyCircles.length; i++) {
    if (enemyCircles[i].isVisible) {
      enemyCircles[i].drawWithColor(enemyColor);
    }
  }
}

public void drawPoints() {
  fill(0);
  textFont(gameOverFont, 20);
  textAlign(LEFT, LEFT);
  text("Points " + points, 10, 20);
}

public void drawLifes() {
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

public void calculateDistancesToCircles() {
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

public void calculateDistancesToEnemies() {
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
      } else {
        if (pacman.x > enemyCircles[i].x) {
          enemyCircles[i].x++;
        } else if (pacman.x < enemyCircles[i].x) {
          enemyCircles[i].x--;
        }
        
        if (pacman.y > enemyCircles[i].y) {
          enemyCircles[i].y++;
        } else if (pacman.y < enemyCircles[i].y) {
          enemyCircles[i].y--;
        }
      }
    }
  }
}

public void calculateEnemyAppearing() {
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
      
      enemyCount++;
    }

    enemyAppearTime = maxEnemyAppearTime - (enemyCount / 2 * 100);
    if (enemyAppearTime < 100) {
      enemyAppearTime = 100;
    }
  }
}

public void calculateAnimation() {
  pacman.shift += step * direction; 
  if (pacman.shift <= 0 || pacman.shift >= 30) {
    direction *= -1;
  }
}

public void keyPressed() {
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

public void clearPress() {
  moveLeft = false; 
  moveRight = false; 
  moveUp = false; 
  moveDown = false;
}

public void keyReleased() {
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
class Button {
  float x;
  float y;
  float buttonWidth;
  float buttonHeight;

  PFont font;
  String text;

  Button(float x, float y, float buttonWidth, float buttonHeight, PFont font, String text) {
    this.x = x;
    this.y = y;
    this.buttonWidth = buttonWidth;
    this.buttonHeight = buttonHeight;
    this.font = font;
    this.text = text;
  }

  public void drawButton() {
    fill(255, 0, 0);
    textFont(this.font, 40);
    textAlign(CENTER, CENTER);
    text(this.text, width / 2, 3 * height / 4);
  }

  public boolean needsRestart() {
    if (mousePressed == true) {
      if (mouseX >= this.x && mouseX <= this.x + this.buttonWidth) {
        if (mouseY >= this.y && mouseY <= this.y + this.buttonHeight) {
          return true;
        }
      }
    }
    return false;
  }
}
class Circle {
  float size = 30.0f;
  
  float x;
  float y;
  
  boolean isVisible;
  int time;
  
  Circle(float x, float y, boolean isVisible, int time) {
    this.x = x;
    this.y = y;
    this.isVisible = isVisible;
    this.time = time;
  }
  
  public void show() {
    this.isVisible = true;
  }
  
  public void hide() {
    this.isVisible = false;
  }
  
  public void drawWithColor(Color c) {
    c.fillColor();
    ellipse(this.x, this.y, this.size, this.size);
  }
}
class Color {
  int red;
  int green;
  int blue;
  
  Color(int r, int g, int b) {
    this.red = r;
    this.green = g;
    this.blue = b;
  }
  
  public void fillColor() {
    fill(this.red, this.green, this.blue);
  }
}
class Pacman {
  float x;
  float y;
  int size = 80;
  
  float startAngle;
  float endAngle;
  int shift;
  
  Color pacmanColor;
  
  Pacman(float x, float y, Color pacmanColor) {
    this.x = x;
    this.y = y;
    
    this.startAngle = 0;
    this.endAngle = 360;
    this.shift = 0;
    
    this.pacmanColor = pacmanColor;
  }
  
  public void drawPacman() {
    pacmanColor.fillColor();
    arc(this.x, this.y, this.size, this.size, radians(this.startAngle), radians(this.endAngle));
  }
}
  public void settings() {  size(800, 600);  smooth(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "packman" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
