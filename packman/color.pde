class Color {
  int red;
  int green;
  int blue;
  
  Color(int r, int g, int b) {
    this.red = r;
    this.green = g;
    this.blue = b;
  }
  
  void fillColor() {
    fill(this.red, this.green, this.blue);
  }
}