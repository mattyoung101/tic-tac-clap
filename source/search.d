import board;
import std.stdio;
import std.conv;

long totalMovesEvaluated = 0;

class Node {
    Bitboard board;
    Node parent;
    int wins;
    int losses;
    /** used only so the AI player can sort properly **/
    int moveId;
    int depth = 69;

    this(){}
    this(Bitboard b, Node p, int d){
        this.board = b;
        this.parent = p;
        this.depth = d;
    }

    /** If no moves are available, propagates win/loss up to the parent node, otherwise continues searching down the tree **/
    void search(bool aiTurn){
        totalMovesEvaluated++;
        
        if (board.isNoughtWinner()){
            propagateWin();
            //writeln("Found win at depth ", depth);
        } else if (board.isCrossWinner()){
            propagateLoss();
        } else if (board.isDraw()){
            propagateWin();
        } else {
            // get available cells
            auto available = board.crossBB | board.noughtBB; 
            available.flip();
            //writeln("Searching, parent is ", parent, ", available: ", available);

            // go through possible cells available, making new nodes
            for (int i = 0; i < 9; i++){
                if (available[i]){
                    auto bitboardCpy = new Bitboard(board);
                    
                    // let's imagine we played the move
                    if (aiTurn){
                        bitboardCpy.noughtBB[i] = true;
                    } else {
                        bitboardCpy.crossBB[i] = true;
                    }

                    auto newNode = new Node(bitboardCpy, this, depth + 1);
                    newNode.search(!aiTurn);
                }
            }
        }
    }

    /** notifies the root node that there is a potential win here **/
    void propagateWin(){
        if (parent !is null){
            parent.propagateWin();
        } else {
            // writeln("Found winner to propagate");
            wins++;
        }
    }

    /** notifies the root node that there is a potential loss here **/
    void propagateLoss(){
        if (parent !is null){
            parent.propagateLoss();
        } else {
            // writeln("Found loser to propagate");
            losses++;
        }
    }

    float getScore() const {
        // balanced
        //return (to!float(this.wins) / to!float(this.losses)) * 100.0;

        // probability
        immutable auto total = to!float(wins + losses);
        return (to!float(wins) / total) * 100.0;
    }

    /** used for sorting **/
    int opCmp(ref const Node other) const {
        // sort by scoring
        // immutable auto myScore = this.getScore();
        // immutable auto otherScore = other.getScore();

        // if (myScore > otherScore){
        //     return 1;
        // } else if (myScore < otherScore){
        //     return -1;
        // } else {
        //     return 0;
        // }

        // minimise our losses
        if (losses < other.losses){
            return 1;
        } else if (losses > other.losses){
            return -1;
        } else {
            // tie breaker #1: number of wins
            if (wins > other.wins){
                return 1;
            } else if (wins < other.wins){
                return -1;
            } else {
                // TODO tiebreaker #2: depth
                return 0;
            }
        }
    }
}