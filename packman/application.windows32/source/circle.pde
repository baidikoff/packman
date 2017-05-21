class Circle {
  float size = 30.0;
  
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
  
  void show() {
    this.isVisible = true;
  }
  
  void hide() {
    this.isVisible = false;
  }
  
  void drawWithColor(Color c) {
    c.fillColor();
    ellipse(this.x, this.y, this.size, this.size);
  }
}