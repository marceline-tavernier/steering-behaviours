
class Target {
  PVector[] path;
  PVector[] path_vel;
  int cur = 0;
  PVector cur_pos;
  boolean moving = false;

  Target (PVector[] path, PVector[] path_velocity) {
    this.path = path;
    cur_pos = path[cur].copy();
    path_vel = path_velocity;
  }

  void draw() {
    fill(255);
    circle(cur_pos.x, cur_pos.y, 50);
  }

  void update_pos(boolean onMouse) {
    if (onMouse) {
      cur = -1;
      cur_pos.x = mouseX;
      cur_pos.y = mouseY;
      return;
    }

    if (cur == -1) {
      cur = 0;
      cur_pos = path[cur].copy();
    }

    if (!moving) {
      cur_pos = path[cur].copy();
      return;
    }

    cur_pos.add(path_vel[cur]);
    if (cur_pos.dist(path[(cur + 1) % path.length]) <= 1) {
      cur = (cur + 1) % path.length;
    }
  }
}
