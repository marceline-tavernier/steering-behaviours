
// Variables
boolean DEBUG = false;
boolean MOUSE_TARGET = false;

Target target;
ArrayList<Agent> agents = new ArrayList<Agent>();
MODES mode = MODES.SEEK;

///////////////////////

// Setup
void setup() {

  // Set size to 1000x1000, title, font size and stroke size
  size(1000, 1000);
  textSize(20);
  windowTitle("Steering behaviours");
  strokeWeight(3);

  // Initialise the path and the target
  PVector[] path = {new PVector(500, 500), new PVector(900, 500), new PVector(900, 900), new PVector(100, 900), new PVector(100, 500)};
  PVector[] path_velocity = {new PVector(TARGET_MAX_SPEED, 0), new PVector(0, TARGET_MAX_SPEED), new PVector(-TARGET_MAX_SPEED, 0), new PVector(0, -TARGET_MAX_SPEED), new PVector(TARGET_MAX_SPEED, 0)};
  target = new Target(path, path_velocity);

  // Initialise one agent
  agents.add(new Agent(new PVector(100, 100), new PVector(1, 5)));
}

// Draw the info on the top left
void draw_info() {

  // If in debug mode, draw the vectors of agents
  if (DEBUG) {
    for (int i = 0; i < agents.size(); i++) {
      agents.get(i).debug_vector();
    }
  }

  // Draw all the infos about mode and keyboard
  draw_mode(mode);

  fill(0);
  text("Changer de mode : S, F, P, E, A, C, O, T", 25, 50);

  text("Nouvel agent : clique", 25, 100);

  text("Cible sur la souris : M", 25, 150);
  text("Debug : D", 25, 175);
}

// Draw everything
void draw() {

  // Grey background
  background(200);

  // Draw the target and update its values
  target.draw();
  target.update_values(MOUSE_TARGET);

  // Draw all the agents and update all the values
  for (int i = 0; i < agents.size(); i++) {
    agents.get(i).draw();
    agents.get(i).update_values(target, mode);
  }

  // Draw the info on the top left
  draw_info();
}

// If we click, spawn a new agent at the mouse position
void mousePressed() {
  agents.add(new Agent(new PVector(mouseX, mouseY), new PVector(0, 0)));
}

// If a key is pressed
void keyPressed() {
  switch (key) {

    // Switch debug mode
  case 'd':
    DEBUG = !DEBUG;
    break;

    // Switch mouse mode
  case 'm':
    MOUSE_TARGET = !MOUSE_TARGET;
    break;

    // Set the mode
  case 's':
    mode = MODES.SEEK;
    break;
  case 'f':
    mode = MODES.FLEE;
    break;
  case 'p':
    mode = MODES.PURSUIT;
    break;
  case 'e':
    mode = MODES.EVADE;
    break;
  case 'a':
    mode = MODES.ARRIVAL;
    break;
  case 'c':
    mode = MODES.CIRCUIT;
    break;
  case 'o':
    mode = MODES.ONE_WAY;
    break;
  case 't':
    mode = MODES.TWO_WAYS;
    break;
  }

  // Update the mode of the target
  target.update_mode(mode);
}
