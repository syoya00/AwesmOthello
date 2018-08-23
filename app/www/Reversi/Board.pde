class Board {
    int x,y;
    int cornerX, cornerY;
    int boardSize;
    int cellSize;
    int blackPointSize;

    int stoneSize;
    int markerSize;
    int beforeCellMarkerSize;
    
    int state [][] = new int[8][8];

    int turn;
    int skipCount;

    Call beforeCell;
    Cell pressedCell;

    boolean finish;

    String drawText = "DRAW";
    String blackWinText = "BLACK WIN";
    String whiteWinText = "WHITE WIN";

    Board() {
        textAlign(CENTER, CENTER);

        x = width/2;
        y = height/2;
        cornerX = x - width/2;
        cornerY = y - width/2;
        boardSize = width;
        cellSize = boardSize/8;
        blackPointSize = boardSize/80;
        stoneSize = boardSize/10;
        markerSize = boardSize/24;
        beforeCellMarkerSize = stoneSize/3

        state[3][3]=-1;
        state[3][4]=1;
        state[4][3]=1;
        state[4][4]=-1;

        //1:黒, -1:白
        turn = 1;
        skipCount = 0;
        finish = false;

        beforeCell = new Cell(-1, -1);
        pressedCell = new Cell(-1, -1);
    }

    void display() {
        displayboard();
        displayStone();
        displayMarker();
        displayBeforeCell();
        displayInfo();

        if (finish) {
            displayFinish();
        }
    }

    void update(){
        if(finish) return;
        skipCheck();                
    }

    void displayboard() {
        rectMode(CENTER);
        fill(0, 120, 0);
        rect(x, y, boardSize, boardSize);

        for (int i=0; i<8; i++) {
            for (int j=0; j<8; j++) {
                noFill();
                stroke(0);
                strokeWeight(2);
                rect( cornerX + cellSize * (i + 1/2), cornerY + cellSize * (j + 1/2), cellSize, cellSize);
            }
        }

        fill(0);
        ellipse( cornerX + boardSize*1/4, cornerY + boardSize*1/4, blackPointSize, blackPointSize);
        ellipse( cornerX + boardSize*3/4, cornerY + boardSize*1/4, blackPointSize, blackPointSize);
        ellipse( cornerX + boardSize*1/4, cornerY + boardSize*3/4, blackPointSize, blackPointSize);
        ellipse( cornerX + boardSize*3/4, cornerY + boardSize*3/4, blackPointSize, blackPointSize);
    }

    void displayStone(){
        for (int i=0; i<8; i++) {
            for (int j=0; j<8; j++) {        
                if (state[i][j]==1) {
                    drawStone(i, j, 0);
                } else if (state[i][j]==-1) {
                    drawStone(i, j, 1);
                }
            }
        }
    }

    void displayMarker(){
        canSetPoints = getCanSetPoints(turn);
        for (int i=0; i<8; i++) {
            for (int j=0; j<8; j++) {
                if (canSetPoints[i][j]!=1) continue;
                if (turn==1) {
                    drawStone(i, j, 2);
                } else {
                    drawStone(i, j, 3);
                }
            }
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

    void displayBeforeCell(){
        if (beforeCell.x == -1) return;
        drawStone(beforeCell.x, beforeCell.y, 4);
    }

    void drawStone(int i, int j, int t) {
        int positionX = cornerX + cellSize * (i + 1/2);
        int positionY = cornerY + cellSize * (j + 1/2);

        noStroke();
        switch(t) {
        case 0:
            //黒の石を描く
            fill(0);
            ellipse(positionX, positionY, stoneSize, stoneSize);
            break;
        case 1:
            //白の石を描く
            fill(255);
            ellipse(positionX, positionY, stoneSize, stoneSize);
            break;
        case 2:
            //黒の石がおける場所を描く
            fill(0);
            ellipse(positionX, positionY, markerSize, markerSize);
            break;
        case 3:
            //白の石がおける場所を描く
            fill(255);
            ellipse(positionX, positionY, markerSize, markerSize);
            break;
        case 4:
            //ひとつ前においた石の場所を描く
            fill(255, 0, 0);
            ellipse(positionX, positionY, beforeCellMarkerSize, beforeCellMarkerSize);
            break;
        default:
            break;
        }
    }

    void displayInfo(){
        // textSize(boardSize/10);
        // fill(0);
        // ellipse(boardSize/8, y/2, boardSize/10, boardSize/10);
        // text(black, boardSize/4, y*2/3);
        // fill(255);
        // ellipse(boardSize*5/8, y/2, boardSize/10, boardSize/10);
        // text(white, boardSize*3/4, y*2/3);
    }

    void displayFinish(){
        fill(255, 255, 255, 200);
        rect(x, y, boardSize, boardSize);

        fill(0);
        int[] stones = getStonesCount();
        textSize(boardSize/10);

        if (stones[0]>stones[1]) {
            text(blackWinText, boardSize/2, height/2);
        } else if (stones[0]<stones[1]) {
            text(whiteWinText, boardSize/2, height/2);
        } else {
            text(drawText, boardSize/2, height/2);
        }

        stroke(0);
        strokeWeight(3);
        noFill();
        rect(x, y + boardSize*1/4, boardSize/2, boardSize/8);

        fill(0);
        textSize(boardSize/16);
        text("reset", x, y + boardSize*1/4);
    }

    void mousePressed() {
        //タッチした場所を保存
        pressedCell = mouseToCell(mouseX,mouseY);
        if (!finish) return;
        if(mouseX > x - boardSize/4 && mouseX < x + boardSize/4 && mouseY > (y + boardSize*1/4) - boardSize*1/16 && mouseY < (y + boardSize*1/4) + boardSize*1/16) {
            reset();
        }
    }

    void mouseReleased() {
        //指が離れた場所がタッチした場所と同じなら石を置く
        Cell relesedCell = mouseToCell(mouseX,mouseY);
        if(relesedCell.x < 0) return;
        if (!pressedCell.isEqual(relesedCell)) return;

        if (setCheck(pressedCell.x, pressedCell.y, turn, 1)) {
            state[pressedCell.x][pressedCell.y]=turn;
            beforeCell.x = pressedCell.x;
            beforeCell.y = pressedCell.y;
            turn = -turn;
        }

        skipCheck();
    }

    Call mouseToCell(int mx,int my){
        for (int i=0; i<8; i++) {
            for (int j=0; j<8; j++) {
                if ( !(mx > cornerX + cellSize*i && mx < cornerX + cellSize*(i+1)) ) continue;
                if ( !(my > cornerY +  cellSize*j && my < cornerY + cellSize*(j+1)) ) continue;

                return new Cell(i,j);
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

    int[] getStonesCount() {
        int[] stones = {0, 0};

        for (int i=0; i<8; i++) {
            for (int j=0; j<8; j++) {
                if (state[i][j]==1) {
                    stones[0]++;
                } else if (state[i][j]==-1) {
                    stones[1]++;
                }
            }
        }
        return stones;
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

        beforeCell.x = -1;
        beforeCell.y = -1;

        finish = false;
    }
}