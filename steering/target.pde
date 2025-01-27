
// Variable
float TARGET_MAX_SPEED = 6;

///////////////////////

// Target's class
class Target {

  // Target's variables
  PVector[] path;
  PVector[] path_velocity;
  int current_index = 0;
  PVector current_position;
  PVector current_velocity;
  boolean is_moving = false;
  boolean is_path = false;
  boolean is_path_looping = false;

  // Target's constructor (setting the path and path velocity)
  Target (PVector[] path, PVector[] path_velocity) {
    this.path = path;
    current_position = path[current_index].copy();
    this.path_velocity = path_velocity;
  }

  // Draw the target
  void draw() {
    fill(255);

    // If we draw a path, draw circles on corner and lines between
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
    }

    // Else only draw one circle
    else {
      circle(current_position.x, current_position.y, 50);
    }
  }

  // Update the way of drawing the target based on the mode
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

  // Update the values of the target (when moving)
  void update_values(boolean use_mouse_position) {

    // If we use the mouse, set the position and velocity
    if (use_mouse_position) {
      current_index = -1;
      current_position.x = mouseX;
      current_position.y = mouseY;
      current_velocity.set(mouseX - pmouseX, mouseY - pmouseY);
      return;
    }

    // If we unset the mouse, set to use the first target in the path
    if (current_index == -1) {
      current_index = 0;
      current_position = path[current_index].copy();
    }

    // If the target is not moving, set the positon to the first target in the path
    if (!is_moving) {
      current_position = path[current_index].copy();
      current_velocity = new PVector(0, 0);
      return;
    }

    // Update velocity and position
    current_velocity = path_velocity[current_index].copy();
    current_position.add(current_velocity);

    // If the target is moving and reached a point of the path, go to the next point in the path
    if (current_position.dist(path[(current_index + 1) % path.length]) <= TARGET_MAX_SPEED / 2) {
      current_index = (current_index + 1) % path.length;
    }
  }
}
