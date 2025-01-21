
float TARGET_MAX_SPEED = 6;

class Target {
  PVector[] path;
  PVector[] path_velocity;
  int current_index = 0;
  PVector current_position;
  PVector current_velocity;
  boolean is_moving = false;
  boolean is_path = false;
  boolean is_path_looping = false;

  Target (PVector[] path, PVector[] path_velocity) {
    this.path = path;
    current_position = path[current_index].copy();
    this.path_velocity = path_velocity;
  }

  void draw() {
    fill(255);
    if (is_path) {
      for (int i = 0; i < path.length; i++) {
        circle(path[i].x, path[i].y, 50);
        if (i > 0) {
          line(path[i - 1].x, path[i - 1].y, path[i].x, path[i].y);
        } 
        if (i == path.length - 1 && is_path_looping) {
          line(path[0].x, path[0].y, path[i].x, path[i].y);
        }
      }
    } else {
      circle(current_position.x, current_position.y, 50);
    }
  }

  void update_mode(MODES mode) {
    switch(mode) {
    case SEEK:
    case FLEE:
    case ARRIVAL:
      target.is_moving = false;
      target.is_path = false;
      target.current_index = 0;
      break;
    case PURSUIT:
    case EVADE:
      target.is_moving = true;
      target.is_path = false;
      break;
    case CIRCUIT:
      target.is_moving = false;
      target.is_path = true;
      target.is_path_looping = true;
      target.current_index = 0;
      break;
    case ONE_WAY:
    case TWO_WAYS:
      target.is_moving = false;
      target.is_path = true;
      target.is_path_looping = false;
      target.current_index = 0;
      break;
    }
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
