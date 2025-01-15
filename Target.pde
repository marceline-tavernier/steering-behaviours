
class Target {
  PVector pos;

  Target (PVector position) {
    pos = position;
  }

  void draw(boolean onMouse) {
    if (onMouse) {
      pos.x = mouseX;
      pos.y = mouseY;
    }
    fill(255);
    circle(pos.x, pos.y, 50);
  }
}
