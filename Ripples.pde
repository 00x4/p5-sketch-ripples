java.util.List<Ripple> _ripples;
color _bgcolor = 0;

void setup() {
  size(800, 600);
  _ripples = new java.util.LinkedList<Ripple>();
}

void draw() {
  background(_bgcolor);
  if (mousePressed) {
    addRandomRipples(10);
  }
  drawRipples();
  float move = (abs(pmouseX - mouseX) + abs(pmouseY - mouseY)) / 2;
  if (move > 20) {
    _ripples.add(new Ripple(pmouseX, pmouseY, random(100, 300)));
  }
  delay(50);
  //saveFrame("_frames/######.png");
}

class Ripple {
  private static final int LIFE_LIMIT = 30;

  private int _age;
  private float _x;
  private float _y;
  private float _diameter;
  private float _orbitStartAngle;
  private boolean _isOrbitReverse;

  Ripple(float x, float y, float diameter) {
    _x = x;
    _y = y;
    _diameter = diameter;
    _orbitStartAngle = random(360);
    _isOrbitReverse = (random(100) > 50);
  }

  void step() {
    _diameter += _age;
    _age++;
  }
  boolean isAlive() {
    return (_age < LIFE_LIMIT);
  }
  
  void draw(boolean onlyOrbit) {
    if (!onlyOrbit) {
      drawBody();
    }
    drawOrbit();
  }

  void drawBody() {
    noFill();
    stroke(200, 255 - _age * 10);
    for (float child = _diameter; child > 0; child -= 100) {
      ellipse(_x, _y, child, child);
    }
  }

  void drawOrbit() {
    pushMatrix();
    translate(_x, _y);
    fill(random(200, 255), random(200, 255), random(150, 200), 50);
    noStroke();
    if (_isOrbitReverse) {
      rotate((360 - (_orbitStartAngle + _age * 10)) * PI / 180);
    } else {
      rotate((_orbitStartAngle + _age * 10) * PI / 180);
    }
    float orbitSize = _age * 10;
    ellipse(0, _diameter / 2, orbitSize, orbitSize);
    ellipse(0, _diameter / -2, orbitSize / 2, orbitSize / 2);
    popMatrix();
  }
}

void addRandomRipples(int num) {
    for (int i = 0; i < num; i++) {
      _ripples.add(new Ripple(random(width), random(height), random(100, 300)));
    }
}

void drawRipples() {
  for (java.util.Iterator<Ripple> it = _ripples.iterator(); it.hasNext(); ) {
    Ripple ripple = it.next();
    ripple.draw(keyPressed && keyCode == SHIFT);
    ripple.step();
    if (!ripple.isAlive()) {
      it.remove();
    }
  }
}

void keyPressed() {
  if (keyCode == TAB) {
    if (_bgcolor == 0) {
      _bgcolor = 255;
    } else {
      _bgcolor = 0;
    }
  }
}
