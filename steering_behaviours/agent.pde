
// Variables
int VECTOR_MULT = 50;
float MAX_SPEED = 5;
float MAX_FORCE = 1;
float MASS = 10;
float SLOWING_DISTANCE = 300;

///////////////////////

// Agent's class
class Agent {
  
  // Agent's variables
  PVector position;
  PVector velocity;
  PVector desired_velocity = new PVector(0, 0);
  PVector steering = new PVector(0, 0);
  color col;
  int target_path_index = -1;
  boolean normal_direction = true;

  // Agent's constructor (setting position and velocity)
  Agent(PVector position, PVector velocity) {
    this.position = position;
    this.velocity = velocity;
    col = color(random(0, 255), random(0, 255), random(0, 255));
  }

  // Draw the agent
  void draw() {
    
    // Draw a triangle at the right orientation
    pushMatrix();
    translate(position.x, position.y);
    float angle = atan2(velocity.y, velocity.x);
    rotate(angle);
    fill(col);
    triangle(30, 0, -20, 20, -20, -20);
    fill(255);
    popMatrix();
  }

  // Draw the debug vectors
  void debug_vector() {
    draw_vector(position, velocity, color(50, 230, 50));
    draw_vector(position, desired_velocity, color(50, 50, 50));
    draw_vector(position.copy().add(velocity.copy().mult(VECTOR_MULT)), steering.copy().mult(MASS), color(50, 50, 230));
  }

  // Draw the vector
  void draw_vector(PVector origin, PVector vector, color col) {
    
    // Setup
    stroke(col);
    fill(col);
    strokeCap(ROUND);

    // Draw the line
    float x = origin.x + vector.x * VECTOR_MULT;
    float y = origin.y + vector.y * VECTOR_MULT;
    line(origin.x, origin.y, x, y);

    // Draw the arrow head
    pushMatrix();
    translate(x, y);
    float angle = atan2(vector.y, vector.x);
    rotate(angle);
    line(0, 0, -20, -20 / 2);
    line(0, 0, -20, 20 / 2);
    popMatrix();

    // Reset
    strokeCap(SQUARE);
    fill(255);
    stroke(0);
  }

  // Update the mode of the target
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
    case CIRCUIT:
      circuit(target);
      break;
    case ONE_WAY:
      one_way(target);
      break;
    case TWO_WAYS:
      two_ways(target);
      break;
    }
  }

  // Seek behaviours
  void seek(Target target) {
    PVector target_offset = target.current_position.copy().sub(position);

    desired_velocity = target_offset.normalize().mult(MAX_SPEED);
  }

  // Pursuit behaviours
  void pursuit(Target target) {
    PVector target_offset = target.current_position.copy().sub(position);
    float distance = target_offset.mag();

    // Calculate forward vectors
    PVector pursuer_forward = velocity.copy().normalize();
    PVector target_forward = target.current_velocity.copy().normalize();

    // Calculate alignment
    float forward_alignment = PVector.dot(pursuer_forward, target_forward);
    float position_alignment = PVector.dot(target_forward, target_offset.copy().normalize());

    // Calculate how much we look into the future for the target
    float c = 0.1;
    float t = abs(c * distance * forward_alignment * position_alignment);
    PVector future_target_pos = target_offset.add(target.current_velocity.copy().mult(t));

    desired_velocity = future_target_pos.normalize().mult(MAX_SPEED);
  }

  // Arrival behaviours
  void arrival(Target target) {
    PVector target_offset = target.current_position.copy().sub(position);
    float distance = target_offset.mag();

    // Calculate new speed based on distance
    float ramped_speed = MAX_SPEED * (distance / SLOWING_DISTANCE);
    float clipped_speed = min(ramped_speed, MAX_SPEED);

    desired_velocity = target_offset.normalize().mult(clipped_speed);
  }

  // Find the closest path to the target (used for circuit, one way and two ways)
  void find_closest_path_target(Target target) {
    
    // If the agent does not have a target, find the closest target
    if (target_path_index == -1) {
      float min_distance = target.path[0].copy().sub(position).mag();
      target_path_index = 0;
      for (int i = 1; i < target.path.length; i++) {
        float distance = target.path[i].copy().sub(position).mag();
        if (distance < min_distance) {
          min_distance = distance;
          target_path_index = i;
        }
      }
    }
  }

  // Circuit behaviours
  void circuit(Target target) {
    
    // Find the closest target
    find_closest_path_target(target);
    
    // Seek to the target
    PVector target_position = target.path[target_path_index];
    seek(new Target(new PVector[]{target_position}, new PVector[]{new PVector(0, 0)}));

    // If the agent is in the target, change target to the next one
    if (position.dist(target_position) < TARGET_MAX_SPEED / 2) {
      target_path_index = (target_path_index + 1) % target.path.length;
    }
  }

  // One way behaviours
  void one_way(Target target) {
    
    // Find the closest target
    find_closest_path_target(target);

    // Seek to the target, unless it's the last one then use arrival instead
    PVector target_position = target.path[target_path_index];
    if (target_path_index == target.path.length - 1) {
      arrival(new Target(new PVector[]{target_position}, new PVector[]{new PVector(0, 0)}));
    } else {
      seek(new Target(new PVector[]{target_position}, new PVector[]{new PVector(0, 0)}));
    }

    // If the agent is in the target and it's not the last one, change to the next one
    if (target_path_index < target.path.length - 1 && position.dist(target_position) < TARGET_MAX_SPEED / 2) {
      target_path_index = (target_path_index + 1) % target.path.length;
    }
  }

  // Two ways behaviours
  void two_ways(Target target) {
    
    // Find the closest target
    find_closest_path_target(target);

    // Seek to the target, unless it's the first or last one then use arrival instead
    PVector target_position = target.path[target_path_index];
    if (target_path_index == target.path.length - 1 || target_path_index == 0) {
      arrival(new Target(new PVector[]{target_position}, new PVector[]{new PVector(0, 0)}));
    } else {
      seek(new Target(new PVector[]{target_position}, new PVector[]{new PVector(0, 0)}));
    }

    // If the agent is in the target, change target to the next one
    if (position.dist(target_position) < TARGET_MAX_SPEED / 2) {
      target_path_index = target_path_index + (normal_direction ? 1 : -1);

      // If the next target is before the first or after the last, switch direction and go to the next target
      if (target_path_index == -1) {
        target_path_index = 1;
        normal_direction = true;
      } else if (target_path_index == target.path.length) {
        target_path_index = target.path.length - 2;
        normal_direction = false;
      }
    }
  }

  // Update the values (used for every behaviours)
  void update_values(Target target, MODES mode) {
    
    // Calculate the desired velocity based on the current mode
    update_mode(target, mode);

    // Calculate steering
    steering = desired_velocity.copy().sub(velocity);
    steering.limit(MAX_FORCE).div(MASS);

    // If the angle between steering and current velocity is more than 135°
    if (PVector.angleBetween(steering, velocity) >= 0.75 * PI) {
      float angle = -HALF_PI;
      if (steering.y * velocity.x > steering.x * velocity.y) {
        angle = HALF_PI;
      }
      
      // Limit the steering angle
      steering.lerp(PVector.fromAngle(angle).mult(steering.mag()).rotate(velocity.heading()), 0.5);
    }
    
    // Update velocity and position
    velocity.add(steering).limit(MAX_SPEED);
    position.add(velocity);
  }
}
