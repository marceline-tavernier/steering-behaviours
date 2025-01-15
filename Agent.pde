
int VECTOR_MULT = 50;
float MAX_SPEED = 5;
float MAX_FORCE = 1;
float MASS = 10;
float SLOWING_DISTANCE = 300;

class Agent {
  PVector pos;
  PVector vel;
  PVector desired_vel = new PVector(0, 0);
  PVector steering = new PVector(0, 0);
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
    draw_vector(pos.copy().add(vel.copy().mult(VECTOR_MULT)), steering.copy().mult(MASS), color(50, 50, 230));
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
    switch(mode) {
    case SEEK:
      seek(target);
      break;
    case FLEE:
      flee(target);
      break;
    case PURSUIT:
      break;
    case EVADE:
      break;
    case ARRIVAL:
      arrival(target);
      break;
    }
  }

  void seek(PVector target) {
    desired_vel = (target.copy().sub(pos)).normalize().mult(MAX_SPEED);
    update_values();
  }

  void flee(PVector target) {
    desired_vel = (target.copy().sub(pos)).normalize().mult(-MAX_SPEED);
    update_values();
  }

  void arrival(PVector target) {
    PVector target_offset = target.copy().sub(pos);
    float ramped_speed = MAX_SPEED * (target_offset.mag() / SLOWING_DISTANCE);
    float clipped_speed = min(ramped_speed, MAX_SPEED);
    desired_vel = target_offset.copy().normalize().mult(clipped_speed);
    update_values();
  }

  void update_values() {
    steering = desired_vel.copy().sub(vel);
    steering.limit(MAX_FORCE);
    steering.div(MASS);
    if (PVector.angleBetween(steering, vel) >= 0.75 * PI) {
      float angle = -HALF_PI;
      if (steering.y * vel.x > steering.x * vel.y) {
        angle = HALF_PI;
      }
      steering.lerp(PVector.fromAngle(angle).mult(steering.mag()).rotate(vel.heading()), 0.5);
    }

    vel.add(steering).limit(MAX_SPEED);
    pos.add(vel);
  }
}
