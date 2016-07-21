class BallList {
  // Maintains a list of balls.
  ArrayList<Ball> balls;
  int curNumBalls;  // the current number of balls
  int maxBalls; // the maximum number of balls on the board
  SegList[] hori;
  SegList[] vert;
  
  BallList(int cmaxBalls, SegList[] chori, SegList[] cvert){
     balls = new ArrayList<Ball>(cmaxBalls);
     curNumBalls = 0;
     maxBalls = cmaxBalls;
     hori = chori;
     vert = cvert;
  }
  
  void spawn(int idx){
    // reproduces the ball at index idx
  }
  
  void kill(int idx){
    // kills the ball at index idx
  }
  
}

class Ball {
  PVector position; // the current position of the ball
  PVector velocity; // the velocity of the ball
  int stepsToCollision; // the number of steps BEFORE the next collision
  PVector newVelocity; // the balls velocity after the next collision
  PVector newPosition; // the balls position after the next collision
  int age; // how long the ball has been alive for
  boolean isAlive; // whether or not the ball is alive
  int id; // the ball's ID
  float m; // the slope of the ball's path
  float b; // the y-intercept of the ball's path
  
  Ball(float posx, float posy, float velx, float vely, int bid) {
    id = bid;
    position = new PVector(posx, posy);
    velocity = new PVector(velx, vely);
    // initialize the next position and velocity
    newVelocity = new PVector(0., 0.);
    newPosition = new PVector(0., 0.);
    age = 0;
    isAlive = true;
    m = velocity.y / velocity.x;
    b = position.y - m * position.x;
  }
  
  void setNextIntersect(SegList[] hori, SegList[] vert){
    // determines the next intersection that the ball
    // will encounter. It conducts a search through the
    // horizontal and vertical segment lists, and when
    // it finds an intersection, it indicates whether
    // or not it's a vertical line (vertSeg), what the
    // major coordinate value is (i.e., if it's a horizontal
    // segment, this is the x value) call major, the start
    // and stop of the segment, and finally the distance
    // away from the ball.
    float dist = height * width;  // distance cannot be greater than this
    float curMajor; // the current major coordinate
    float curSegStart; // the current seg start
    float curSegStop;  // the current seg stop
    float curDist; // the current distance
    PVector curIntersectionVal; // where the currently considered segment intersects the line
    // finds the next intersection point, given the horizontal
    // and vertical segment lists.
    if (velocity.x != 0) {
      // otherwise, it never intersects any horizontal lines,
      // so you can skip to vertical.
      for (int idx = 0; idx < hori.length / 2; idx++){
        curMajor = float(idx * gridSize);
        for (int idxs = 0; idx < hori[idx].size() / 2; idxs++){
          curSegStart = hori[idx].segs.get(idxs * 2);
          curSegStop = hori[idx].segs.get(idxs * 2 + 1);
          curIntersectionVal = intersection(m, b, curSegStart, curMajor, curSegStop, curMajor);
          if (intersects(curIntersectionVal.x, curSegStart, curSegStop)){
            curDist = position.dist(curIntersectionVal);
            if (curDist < dist){
              // then the y value of the velocity is reversed
              newVelocity.y = -velocity.y;
              newVelocity.x = velocity.x;
              stepsToCollision = int(sqrt(pow(velocity.x, 2) + pow(velocity.y, 2)));
              // normally, the ball would bounce a bit back off the wall, but this
              // calculation is confusing (or at least I don't want to figure it
              // out) so I'm just going to just set it to the intersection point.
              newPosition.x = curIntersectionVal.x;
              newPosition.y = curIntersectionVal.y;
            }
          }
        }
      }
    }
    if (velocity.y != 0) {
      // otherwise, it never intersects any horizontal lines,
      // so you can skip to vertical.
      for (int idx = 0; idx < vert.length / 2; idx++){
        curMajor = float(idx * gridSize);
        for (int idxs = 0; idx < vert[idx].size() / 2; idxs++){
          curSegStart = vert[idx].segs.get(idxs * 2);
          curSegStop = vert[idx].segs.get(idxs * 2 + 1);
          curIntersectionVal = intersection(m, b, curMajor, curSegStart, curMajor, curSegStop);
          if (intersects(curIntersectionVal.y, curSegStart, curSegStop)){
            curDist = position.dist(curIntersectionVal);
            if (curDist < dist){
              // then the x value of the velocity is reversed
              newVelocity.y = velocity.y;
              newVelocity.x = -velocity.x;
              stepsToCollision = int(sqrt(pow(velocity.x, 2) + pow(velocity.y, 2)));
              newPosition.x = curIntersectionVal.x;
              newPosition.y = curIntersectionVal.y;
            }
          }
        }
      }
    }
  }
  
  void step(){
    // steps the ball forward one timestep
  }
  
  void explode(){
    // blows the ball up
  }
}