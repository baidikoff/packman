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
  
  void drawPacman() {
    pacmanColor.fillColor();
    arc(this.x, this.y, this.size, this.size, radians(this.startAngle), radians(this.endAngle));
  }
}