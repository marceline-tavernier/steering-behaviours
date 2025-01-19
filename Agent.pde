
int VECTOR_MULT = 50;
float MAX_SPEED = 5;
float MAX_FORCE = 1;
float MASS = 10;
float SLOWING_DISTANCE = 300;

class Agent {
  PVector position;
  PVector velocity;
  PVector desired_velocity = new PVector(0, 0);
  PVector steering = new PVector(0, 0);
  color col;

  Agent(PVector position, PVector velocity) {
    this.position = position;
    this.velocity = velocity;
    col = color(random(0, 255), random(0, 255), random(0, 255));
  }

  void draw() {
    pushMatrix();
    translate(position.x, position.y);
    float angle = atan2(velocity.y, velocity.x);
    rotate(angle);
    fill(col);
    triangle(30, 0, -20, 20, -20, -20);
    fill(255);
    popMatrix();
  }

  void debug_vector() {
    draw_vector(position, velocity, color(50, 230, 50));
    draw_vector(position, desired_velocity, color(50, 50, 50));
    draw_vector(position.copy().add(velocity.copy().mult(VECTOR_MULT)), steering.copy().mult(MASS), color(50, 50, 230));
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

  void update_mode(Target target, MODES mode) {
    switch(mode) {
    case SEEK:
      seek(target);
      break;
    case FLEE:
      seek(target);
      desired_velocity.mult(-1);
      break;
    case PURSUIT:
      pursuit(target);
      break;
    case EVADE:
      pursuit(target);
      desired_velocity.mult(-1);
      break;
    case ARRIVAL:
      arrival(target);
      break;
    }
  }

  void seek(Target target) {
    PVector target_offset = target.current_position.copy().sub(position);

    desired_velocity = target_offset.normalize().mult(MAX_SPEED);
  }

  void pursuit(Target target) {
    PVector target_offset = target.current_position.copy().sub(position);
    float distance = target_offset.mag();

    PVector pursuer_forward = velocity.copy().normalize();
    PVector target_forward = target.current_velocity.copy().normalize();

    float forward_alignment = PVector.dot(pursuer_forward, target_forward);
    float position_alignment = PVector.dot(target_forward, target_offset.copy().normalize());

    float c = 0.1;
    float t = abs(c * distance * forward_alignment * position_alignment);
    PVector future_target_pos = target_offset.add(target.current_velocity.copy().mult(t));

    desired_velocity = future_target_pos.normalize().mult(MAX_SPEED);
  }

  void arrival(Target target) {
    PVector target_offset = target.current_position.copy().sub(position);
    float distance = target_offset.mag();

    float ramped_speed = MAX_SPEED * (distance / SLOWING_DISTANCE);
    float clipped_speed = min(ramped_speed, MAX_SPEED);

    desired_velocity = target_offset.normalize().mult(clipped_speed);
  }

  void update_values(Target target, MODES mode) {
    update_mode(target, mode);

    steering = desired_velocity.copy().sub(velocity);
    steering.limit(MAX_FORCE).div(MASS);

    if (PVector.angleBetween(steering, velocity) >= 0.75 * PI) {
      float angle = -HALF_PI;
      if (steering.y * velocity.x > steering.x * velocity.y) {
        angle = HALF_PI;
      }
      steering.lerp(PVector.fromAngle(angle).mult(steering.mag()).rotate(velocity.heading()), 0.5);
    }

    velocity.add(steering).limit(MAX_SPEED);
    position.add(velocity);
  }
}
