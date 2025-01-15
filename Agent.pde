
int VECTOR_MULT = 50;

class Agent {
  PVector pos;
  PVector vel;
  PVector desired_vel = new PVector(0, 0);
  PVector steering = new PVector(0, 0);
  float max_speed = 5;
  float max_force = 1;
  float mass = 10;
  color c;

  Agent(PVector position, PVector velocity) {
    pos = position;
    vel = velocity;
    c = color(random(0, 255), random(0, 255), random(0, 255));
  }

  void draw() {
    pushMatrix();
    translate(pos.x, pos.y);
    float angle = atan2(vel.y, vel.x);
    rotate(angle);
    fill(c);
    triangle(30, 0, -20, 20, -20, -20);
    fill(255);
    popMatrix();
  }

  void debug_vector() {
    draw_vector(pos, vel, color(50, 230, 50));
    draw_vector(pos, desired_vel, color(50, 50, 50));
    draw_vector(pos.copy().add(vel.copy().mult(VECTOR_MULT)), steering.copy().mult(mass), color(50, 50, 230));
  }

  void draw_vector(PVector origin, PVector vector, color col) {
    stroke(col);
    fill(col);
    strokeWeight(3);
    strokeCap(ROUND);

    float x = origin.x + vector.x * VECTOR_MULT;
    float y = origin.y + vector.y * VECTOR_MULT;
    line(origin.x, origin.y, x, y);

    pushMatrix();
    translate(x, y);
    float angle = atan2(vector.y, vector.x);
    rotate(angle);
    line(0, 0, -20, -20 / 2);
    line(0, 0, -20, 20 / 2);
    popMatrix();

    strokeCap(SQUARE);
    strokeWeight(1);
    fill(255);
    stroke(0);
  }

  void update_mode(PVector target, MODES mode) {
    if (mode == MODES.SEEK) {
      seek(target);
    } else if (mode == MODES.FLEE) {
      flee(target);
    }
  }

  void seek(PVector target) {
    desired_vel = (target.copy().sub(pos)).normalize().mult(max_speed);
    update_values();
  }

  void flee(PVector target) {
    desired_vel = (target.copy().sub(pos)).normalize().mult(-max_speed);
    update_values();
  }

  void update_values() {
    steering = desired_vel.copy().sub(vel);
    steering.limit(max_force);
    steering.div(mass);
    if (PVector.angleBetween(steering, vel) >= 0.75 * PI) {
      if (steering.y * vel.x > steering.x * vel.y) {
        steering.lerp(PVector.fromAngle(HALF_PI).mult(steering.mag()).rotate(vel.heading()), 0.5);
      } else {
        steering.lerp(PVector.fromAngle(-HALF_PI).mult(steering.mag()).rotate(vel.heading()), 0.5);
      }
    }

    vel.add(steering).limit(max_speed);
    pos.add(vel);
  }
}
