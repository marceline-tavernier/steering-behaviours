
enum MODES {
  SEEK, FLEE, PURSUIT, EVADE, ARRIVAL, CIRCUIT, ONE_WAY, TWO_WAYS;
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
    return MODES.CIRCUIT;
  case CIRCUIT:
    return MODES.ONE_WAY;
  case ONE_WAY:
    return MODES.TWO_WAYS;
  case TWO_WAYS:
  default:
    return MODES.SEEK;
  }
}

void draw_mode(MODES mode) {
  switch(mode) {
  case SEEK:
    fill(0, 0, 255);
    text("Mode : Seek", 25, 25);
    break;
  case FLEE:
    fill(255, 0, 0);
    text("Mode : Flee", 25, 25);
    break;
  case PURSUIT:
    fill(0, 255, 0);
    text("Mode : Pursuit", 25, 25);
    break;
  case EVADE:
    fill(0, 255, 255);
    text("Mode : Evade", 25, 25);
    break;
  case ARRIVAL:
    fill(255, 0, 255);
    text("Mode : Arrival", 25, 25);
    break;
  case CIRCUIT:
    fill(255, 255, 0);
    text("Mode : Circuit", 25, 25);
    break;
  case ONE_WAY:
    fill(255, 255, 255);
    text("Mode : One way", 25, 25);
    break;
  case TWO_WAYS:
    fill(0, 0, 0);
    text("Mode : Two ways", 25, 25);
    break;
  }
}
