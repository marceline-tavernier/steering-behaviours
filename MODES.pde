
enum MODES {
  SEEK, FLEE, PURSUIT, EVADE, ARRIVAL;
};

MODES next(MODES mode) {
  switch(mode) {
  case SEEK:
    return MODES.FLEE;
  case FLEE:
    return MODES.PURSUIT;
  case PURSUIT:
    return MODES.EVADE;
  case EVADE:
    return MODES.ARRIVAL;
  case ARRIVAL:
  default:
    return MODES.SEEK;
  }
}

void draw_mode(MODES mode) {
  switch(mode) {
  case SEEK:
    fill(0, 0, 200);
    text("Mode : Seek", 25, 25);
    break;
  case FLEE:
    fill(200, 0, 0);
    text("Mode : Flee", 25, 25);
    break;
  case PURSUIT:
    fill(0, 200, 0);
    text("Mode : Pursuit", 25, 25);
    break;
  case EVADE:
    fill(0, 200, 200);
    text("Mode : Evade", 25, 25);
    break;
  case ARRIVAL:
    fill(200, 0, 200);
    text("Mode : Arrival", 25, 25);
    break;
  }
}
