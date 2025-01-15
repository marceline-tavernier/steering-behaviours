
boolean DEBUG = false;
boolean MOUSE_TARGET = false;

Target t;
ArrayList<Agent> agents = new ArrayList<Agent>();
MODES mode = MODES.SEEK;

void setup() {
  size(1000, 1000);
  textSize(20);
  windowTitle("Lab 01");

  PVector[] path = {new PVector(500, 500), new PVector(800, 500), new PVector(100, 500)};
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
  text("Debug : D", width - 90, 25);
  text("Target on mouse : M", width - 175, 50);
  text("Change mode : C", width - 150, 75);
  text("Spawn agent : A", width - 140, 100);
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

void keyPressed() {
  switch (key) {
  case 'd':
    DEBUG = !DEBUG;
    break;
  case 'm':
    MOUSE_TARGET = !MOUSE_TARGET;
    break;
  case  'a':
    agents.add(new Agent(new PVector(mouseX, mouseY), new PVector(1, 5)));
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
  }
}
