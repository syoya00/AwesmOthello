class Cell{
    int x, y;

    Cell(int _x, int _y) {
        this.x = _x;
        this.y = _y;
    }

    boolean isEqual(Cell c) {
        if(this.x == c.x && this.y == c.y) {
            return true;
        } else {
            return false;
        }
    }

}