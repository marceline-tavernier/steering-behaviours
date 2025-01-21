
boolean DEBUG = false;
boolean MOUSE_TARGET = false;

Target target;
ArrayList<Agent> agents = new ArrayList<Agent>();
MODES mode = MODES.SEEK;

void setup() {
  size(1000, 1000);
  textSize(20);
  windowTitle("Lab 01");
  strokeWeight(3);

  PVector[] path = {new PVector(500, 500), new PVector(900, 500), new PVector(900, 900), new PVector(100, 900), new PVector(100, 500)};
  PVector[] path_velocity = {new PVector(TARGET_MAX_SPEED, 0), new PVector(0, TARGET_MAX_SPEED), new PVector(-TARGET_MAX_SPEED, 0), new PVector(0, -TARGET_MAX_SPEED), new PVector(TARGET_MAX_SPEED, 0)};
  target = new Target(path, path_velocity);

  agents.add(new Agent(new PVector(100, 100), new PVector(1, 5)));
}

void draw_info() {
  if (DEBUG) {
    for (int i = 0; i < agents.size(); i++) {
      agents.get(i).debug_vector();
    }
  }

  draw_mode(mode);

  fill(0);
  text("Changer de mode : S, F, P, E, A, C, O, T", 25, 50);

  text("Nouvel agent : clique", 25, 100);

  text("Cible sur la souris : M", 25, 150);
  text("Debug : D", 25, 175);
}

void draw() {
  background(200);

  target.draw();
  target.update_values(MOUSE_TARGET);

  for (int i = 0; i < agents.size(); i++) {
    agents.get(i).draw();
  }

  for (int i = 0; i < agents.size(); i++) {
    agents.get(i).update_values(target, mode);
  }

  draw_info();
}

void mousePressed() {
  agents.add(new Agent(new PVector(mouseX, mouseY), new PVector(0, 0)));
}

void keyPressed() {
  switch (key) {
  case 'd':
    DEBUG = !DEBUG;
    break;
  case 'm':
    MOUSE_TARGET = !MOUSE_TARGET;
    break;

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
  target.update_mode(mode);
}
