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

class SegList {
  // represents the list of line segments.
  // maintains these line segments as an IntList of (on, off, on, off, ...)
  //
  // Note, this assumes that the segment being added has some atomic length,
  // i.e., it cannot be the case that given two segments (a1, b1) and (a2, b2)
  // we have that a1 < a2 < b1 < b2
  IntList segs;

  SegList() {
    segs = new IntList();
  }

  boolean canAdd(int start, int stop) {
    // returns True if you can add a segment
    for (int startIdx = 0; startIdx < (segs.size()/2); startIdx++) {
      if (segs.get(startIdx * 2) > stop) {
        // you've gone past the stop, no need to look further
        return true;
      }
      if (segs.get(startIdx * 2) <= start) {
        if (segs.get(startIdx * 2 + 1) >= stop) {
          // you've found a segment that includes this segment
          return false;
        }
      }
    }
    return true;
  }

  boolean canRemove(int start, int stop) {
    return !canAdd(start, stop);
  }

  void add(int start, int stop) {
    if (segs.hasValue(start)) {
      // then another segments ends where this one begins
      int idxStart = segs.index(start);
      if (segs.hasValue(stop)) {
        // then another segment starts where this one ends
        int idxEnd = segs.index(stop);
        segs.remove(idxEnd);
        segs.remove(idxStart);
      } else {
        // just extend the stop of the segment that stops where this one ends.
        segs.set(idxStart, stop);
      }
    } else if (segs.hasValue(stop)) {
      // then there is a segment that starts where this one stops.
      int idxEnd = segs.index(stop);
      segs.set(idxEnd, start);
    } else {
      // it does not intersect with anything.
      segs.append(start);
      segs.append(stop);
      segs.sort();
    }
  }

  void remove(int start, int stop) {
    if (!segs.hasValue(start)) {
      if (!segs.hasValue(stop)) {
        // then you're simply deleting from a line segment interior.
        segs.append(start);
        segs.append(stop);
        segs.sort();
      } else {
        // then another line segment stops when this one
        // stops
        int idxEnd = segs.index(stop);
        segs.set(idxEnd, start);
      }
    } else {
      // then another line segment starts where this
      // one starts.
      int idxStart = segs.index(start);
      segs.set(idxStart, stop);
    }
  }

  void printMe() {
    for (int seg : segs) {
      print(seg, " ");
    }
    println("");
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