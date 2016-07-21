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
  
  int size() {
    // returns the size of the SegList
    return segs.size();
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