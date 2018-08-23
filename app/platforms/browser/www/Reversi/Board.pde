class Board {
    int boardY;

    int state [][] = new int[8][8];

    int turn;
    int skipCount;

    int black;
    int white;

    int beforeX;
    int beforeY;

    int margin;

    Cell pressedCell;

    boolean finish;

    Board() {
        boardY = height/2-width/2;

        state[3][3]=-1;
        state[3][4]=1;
        state[4][3]=1;
        state[4][4]=-1;

        turn = 1;
        //1:黒
        //-1:白

        skipCount = 0;
        skipCheck();

        black = -1;
        white = -1;

        beforeX = -1;
        beforeY = -1;

        margin = width/20;

        pressedCell = new Cell(-1,-1);

        finish = false;
    }

    void display() {

        boardY = height/2-width/2;

        smooth();
        background(0, 120, 0);

        result();

        textAlign(CORNER, CORNER);
        textSize(width/10);
        fill(0);
        ellipse(width/8, boardY/2, width/10, width/10);
        text(black, width/4, boardY*2/3);
        fill(255);
        ellipse(width*5/8, boardY/2, width/10, width/10);
        text(white, width*3/4, boardY*2/3);

        for (int i=0; i<8; i++) {
            for (int j=0; j<8; j++) {
                noFill();
                stroke(0);
                strokeWeight(2);
                rect((width/8)*i, (width/8)*j+boardY, width/8, width/8);
                if (state[i][j]==0) {
                } else if (state[i][j]==1) {
                    drawStone(i, j, 0);
                } else if (state[i][j]==-1) {
                    drawStone(i, j, 1);
                }
            }
        }

        fill(0);
        ellipse(width*1/4, width*1/4+boardY, width/80, width/80);
        ellipse(width*3/4, width*1/4+boardY, width/80, width/80);
        ellipse(width*1/4, width*3/4+boardY, width/80, width/80);
        ellipse(width*3/4, width*3/4+boardY, width/80, width/80);

        canSetPoints = getCanSetPoints(turn);


        for (int i=0; i<8; i++) {
            for (int j=0; j<8; j++) {
                if (canSetPoints[i][j]==1) {
                    if (turn==1) {
                        drawStone(i, j, 2);
                    } else {
                        drawStone(i, j, 3);
                    }
                } else {
                }
            }
        }

        if (beforeX!=-1) {
            drawStone(beforeX, beforeY, 4);
        }

        if (finish) {
            fill(255, 255, 255, 200);
            rect(0, boardY, width, width);
            result();
            textAlign(CENTER, CENTER);

            if (black>white) {
                textSize(width/10);
                fill(0);
                text("BLACK WIN", width/2, height/2);
            } else if (black<white) {
                textSize(width/5);
                fill(0);
                text("WHITW WIN", width/2, height/2);
            } else {
                fill(255, 255, 0);
                text("DRAW", width/2, height/2);
            }

            stroke(0);
            strokeWeight(3);
            noFill();
            rect(width/4, width*3/4+boardY, width/2, width/8);
            text("reset", width/2, width*19/24+boardY);
        } else {
            skipCheck();
        }
    }

    void drawStone(int x, int y, int t) {
        noStroke();
        int positionX = (width/8)*x+width/16;
        int positionY = (width/8)*y+width/16+boardY;
        switch(t) {
        case 0:
            //黒の石を描く
            noStroke();
            fill(0);
            ellipse(positionX, positionY, width/10, width/10);
            break;
        case 1:
            //白の石を描く
            noStroke();
            fill(255);
            ellipse(positionX, positionY, width/10, width/10);
            break;
        case 2:
            //黒の石がおける場所を描く
            noStroke();
            fill(0);
            ellipse(positionX, positionY, width/24, width/24);
            break;
        case 3:
            //白の石がおける場所を描く
            noStroke();
            fill(255);
            ellipse(positionX, positionY, width/24, width/24);
            break;
        case 4:
            //ひとつ前においた石の場所を描く
            noStroke();
            fill(255, 0, 0);
            ellipse(positionX, positionY, width/24, width/24);
            break;
        default:
            break;
        }
    }

    int[][] getCanSetPoints(int turn) {
        int[][] canSetPoint = new int[8][8];

        for (int i=0; i<8; i++) {
            for (int j=0; j<8; j++) {
                if (setCheck(i, j, turn, 0)) {
                    canSetPoint[i][j] = 1;
                } else {
                    canSetPoint[i][j] = 0;
                }
            }
        }

        return canSetPoint;
    }

    int getCanSetPointsCount() {
        int count = 0;
        int[][] canSetPoints = getCanSetPoints(turn);
        for (int i=0; i<8; i++) {
            for (int j=0; j<8; j++) {
                if(canSetPoints[i][j] == 1){
                    count++;
                }
            }
        }
        return count;
    }

    void mousePressed() {
        //タッチした場所を保存
        pressedCell = getCell(mouseX,mouseY);
        if (finish&&width/4<mouseX&&width/4 + width/2>mouseX&&width*3/4+boardY<mouseY&&width*3/4+boardY + width/8>mouseY) {
            reset();
        }
    }

    void mouseReleased() {
        //指が離れた場所がタッチした場所と同じなら石を置く
        Cell relesedCell = getCell(mouseX,mouseY);
        if (!pressedCell.isEqual(relesedCell)) return;

        if (setCheck(pressedCell.x, pressedCell.y, turn, 1)) {
            state[pressedCell.x][pressedCell.y]=turn;
            beforeX = pressedCell.x;
            beforeY = pressedCell.y;
            turn = -turn;
        }

        skipCheck();
    }

    Call getCell(int x,int y){
        for (int i=0; i<8; i++) {
            for (int j=0; j<8; j++) {
                if (x>(width/8)*i&&x<(width/8)*(i+1)) {
                    if (y>(width/8)*j+boardY&&y<(width/8)*(j+1)+boardY) {
                        return new Cell(i,j);
                    }
                }
            }
        }

        return new Cell(-1, -1);
    }

    boolean setCheck(int x, int y, int t, int m) {
        //0:check
        //1:set
        int change [][] = new int[8][8];
        boolean canSet = false;

        if (state[x][y]==0) {
            //none area

            for (int i=-1; i<2; i++) {
                for (int j=-1; j<2; j++) {
                    if (x+i>=0&&x+i<8&&y+j>=0&&y+j<8) {
                        if (state[x+i][y+j]==-t) {

                            //another color

                            int reverseNum = 0;
                            boolean noReverse = false;

                            for (int k=2; k<8; k++) {
                                if (x+i*k>=0&&x+i*k<8&&y+j*k>=0&&y+j*k<8&&reverseNum==0) {
                                    //same color
                                    if (state[x+i*k][y+j*k]==t&&!noReverse) {
                                        reverseNum = k;
                                    }
                                    if(state[x+i*k][y+j*k]==0&&reverseNum==0){
                                        reverseNum = 0;
                                        noReverse = true;
                                    }
                                }
                            }

                            if (reverseNum>0) {
                                if (m==1) {
                                    //reverse
                                    for (int k=0; k<reverseNum; k++) {
                                        state[x+i*k][y+j*k] = t;
                                        canSet = true;
                                    }
                                } else {
                                    //not reverse
                                    canSet = true;
                                }
                            }
                        }
                    }
                }
            }
        }
        return canSet;
    }

    void skipCheck() {
        if (getCanSetPointsCount() == 0) {
            turn = -turn;
            skipCount++;
        } else {
            skipCount = 0;
        }

        if (skipCount>=2) {
            finish = true;
        }
    }

    void result() {
        black = 0;
        white = 0;

        for (int i=0; i<8; i++) {
            for (int j=0; j<8; j++) {
                if (state[i][j]==1) {
                    black++;
                } else if (state[i][j]==-1) {
                    white++;
                }
            }
        }
    }

    void reset() {
        for (int i=0; i<8; i++) {
            for (int j=0; j<8; j++) {
                state[i][j] = 0;
            }
        }

        state[3][3]=-1;
        state[3][4]=1;
        state[4][3]=1;
        state[4][4]=-1;

        turn = 1;
        //1:kuro
        //-1:siro

        skipCount = 0;
        skipCheck();

        black = -1;
        white = -1;

        beforeX = -1;
        beforeY = -1;

        margin = width/20;

        finish = false;
    }
}