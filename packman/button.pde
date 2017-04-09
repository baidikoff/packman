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

  void drawButton() {
    fill(255, 0, 0);
    textFont(this.font, 40);
    textAlign(CENTER, CENTER);
    text(this.text, width / 2, 3 * height / 4);
  }

  boolean needsRestart() {
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