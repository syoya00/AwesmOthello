Board board;

void setup() {
  size(innerWidth,innerHeight);
  board = new Board();
}

void draw() {
  board.display();
}

void mousePressed() {
  board.mousePressed();
};

void mouseReleased() {
  board.mouseReleased();
}
