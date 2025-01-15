
boolean DEBUG = false;
boolean MOUSE_TARGET = false;

Target t;
ArrayList<Agent> agents = new ArrayList<Agent>();
MODES mode = MODES.SEEK;

void setup() {
  size(1000, 1000);
  textSize(20);
  windowTitle("Lab 01");

  PVector[] path = {new PVector(500, 500), new PVector(900, 500), new PVector(100, 500)};
  PVector[] path_vel = {new PVector(5, 0), new PVector(-5, 0), new PVector(5, 0)};
  t = new Target(path, path_vel);

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
  text("Change mode : S, F, P, E, A", 25, 50);
  text("Cycle mode : C", 25, 75);

  text("New agent : click", 25, 125);

  text("Target on mouse : M", 25, 175);
  text("Debug : D", 25, 200);
}

void draw() {
  background(200);

  t.draw();
  t.update_pos(MOUSE_TARGET);

  for (int i = 0; i < agents.size(); i++) {
    agents.get(i).draw();
  }

  for (int i = 0; i < agents.size(); i++) {
    agents.get(i).update_mode(t.cur_pos, mode);
  }

  draw_info();
}

void mousePressed() {
  agents.add(new Agent(new PVector(mouseX, mouseY), new PVector(random(-5, 5), random(-5, 5))));
}

void keyPressed() {
  switch (key) {
  case 'd':
    DEBUG = !DEBUG;
    break;
  case 'm':
    MOUSE_TARGET = !MOUSE_TARGET;
    break;
  case  'c':
    mode = next(mode);
    if (mode == MODES.PURSUIT || mode == MODES.EVADE) {
      t.moving = true;
    } else {
      t.moving = false;
      t.cur = 0;
    }
    break;

  case 's':
    mode = MODES.SEEK;
    t.moving = false;
    t.cur = 0;
    break;
  case 'f':
    mode = MODES.FLEE;
    t.moving = false;
    t.cur = 0;
    break;
  case 'p':
    mode = MODES.PURSUIT;
    t.moving = true;
    break;
  case 'e':
    mode = MODES.EVADE;
    t.moving = true;
    break;
  case 'a':
    mode = MODES.ARRIVAL;
    t.moving = false;
    t.cur = 0;
    break;
  }
}
