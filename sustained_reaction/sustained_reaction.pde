/*
The board is to be represented by an array of lines, sorted by
 their coordinates. Since the lines may not be diagonal, we have
 really only have to store them in lists of horizontal and
 vertical. Furthermore, we really only need to draw the squares
 once.
 
 If the gridSize is, for instance, 10, then each cell is 10 x 10
 pixels, and the mouse draws a grid cell over whatever area it is.
 */
int gridSize = 20;  // how large the gridcells for drawing are to be
int maxBalls = 100; // the maximum number of balls that can exist on the screen


SegList[] hori;
SegList[] vert;
FloatList rectsX;
FloatList rectsY;
SegList segs;

void setup() { 
  size(640, 360);
  hori = new SegList[height / gridSize];
  vert = new SegList[width / gridSize];
  for (int idx = 0; idx < hori.length; idx ++) {
    hori[idx] = new SegList();
  }
  for (int idx = 0; idx < vert.length; idx ++) {
    vert[idx] = new SegList();
  }
  print("Vert: ", vert.length, " hori: ", hori.length);
  println("");
  rectsX = new FloatList();  // stores rectangle x-coordintes
  rectsY = new FloatList();  // stores rectangle y-coordinates
}

void draw() {
  background(51);
  for (int idx = 0; idx < rectsX.size(); idx++) {
    rect(rectsX.get(idx), rectsY.get(idx), float(gridSize), float(gridSize));
  }
}

void mouseClicked() {
  print("x:", mouseX, " y:", mouseY);
  println("");
  int rX = (mouseX / gridSize);
  int rY = (mouseY / gridSize);
  print("rX:", rX, " rY:", rY);
  println("");
  boolean addable;
  if (hori[rY].canAdd(rX, rX + gridSize)) {
    hori[rY].add(rX, rX + gridSize);
    addable = true;
  } else {
    hori[rY].remove(rX, rX + gridSize);
    addable = false;
  }
  if (vert[rX].canAdd(rY, rY + gridSize)) {
    vert[rX].add(rY, rY + gridSize);
  } else {
    vert[rX].remove(rY, rY + gridSize);
  }
  if (addable) {
    rectsX.append(float(rX) * gridSize);
    rectsY.append(float(rY) * gridSize);
  } else {
    rectsX.remove(rectsX.index(float(rX) * gridSize));
    rectsY.remove(rectsY.index(float(rY) * gridSize));
  }
}

/*
-------------------- INTERSECTION HANDLING --------------------
 */
boolean intersects(float val, float v1, float v2) {
  // checks if val is between v1 and v2 (order invariant)
  return min(v1, v2) <= val && val <= max(v1, v2);
}

PVector intersection(float m, float b, float x1, float y1, float x2, float y2) {
  // returns the would-be intersection point. Prints NaN if it never
  // 
  if (x1 == x2) {
    // solve for y
    return new PVector((x1 * m) + b, y1);
  } else {
    // solve for x
    return new PVector(x1, (y1 - b) / m);
  }
}