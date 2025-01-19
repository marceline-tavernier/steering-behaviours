
float TARGET_MAX_SPEED = 6;

class Target {
  PVector[] path;
  PVector[] path_velocity;
  int current_index = 0;
  PVector current_position;
  PVector current_velocity;
  boolean is_moving = false;

  Target (PVector[] path, PVector[] path_velocity) {
    this.path = path;
    current_position = path[current_index].copy();
    this.path_velocity = path_velocity;
  }

  void draw() {
    fill(255);
    circle(current_position.x, current_position.y, 50);
  }

  void update_values(boolean use_mouse_position) {
    if (use_mouse_position) {
      current_index = -1;
      current_position.x = mouseX;
      current_position.y = mouseY;
      current_velocity.set(mouseX - pmouseX, mouseY - pmouseY);
      return;
    }

    if (current_index == -1) {
      current_index = 0;
      current_position = path[current_index].copy();
    }

    if (!is_moving) {
      current_position = path[current_index].copy();
      current_velocity = new PVector(0, 0);
      return;
    }

    current_velocity = path_velocity[current_index].copy();
    current_position.add(current_velocity);
    if (current_position.dist(path[(current_index + 1) % path.length]) <= TARGET_MAX_SPEED / 2) {
      current_index = (current_index + 1) % path.length;
    }
  }
}
