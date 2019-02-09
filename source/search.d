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
    int depth;
    /** if this node is the root node, then it contains the shortest depth to a win out of all children **/
    int depthToWin = 999;
    /** if this is the root node, then the shortest depth to a loss out of all children **/
    int depthToLoss = 999;

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
            getRoot().wins++;
            updateWinDepth();
        } else if (board.isCrossWinner()){
            getRoot().losses++;
            updateLossDepth();
        } else if (board.isDraw()){
            // in this case, draws are losses
            getRoot().losses++;
            updateLossDepth();
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

    /** calling this function after a win will notify the root node that this node has the shortest depth to win if applicable **/
    private void updateWinDepth(){
        auto root = getRoot();
        if (root.depthToWin > this.depth){
            root.depthToWin = this.depth;
        }
    }

    private void updateLossDepth(){
        auto root = getRoot();
        if (root.depthToLoss > this.depth){
            root.depthToLoss = this.depth;
        }
    }

    // TODO this is slow, we should pass the root depth
    private Node getRoot(){
        if (parent is null){
            return this;
        } else {
            return parent.getRoot();
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
        immutable auto myScore = this.getScore();
        immutable auto otherScore = other.getScore();

        // pick longest depth to loss (try to draw out the game)
        // just discovered this thorugh trying different ranking algorithms, but this seems to work by trying
        // to draw out the games to be long instead of short by picking moves which are really far from a loss
        if (this.depthToLoss > other.depthToLoss){
            return 1;
        } else if (this.depthToLoss < other.depthToLoss){
            return -1;
        } else {
            // tiebreaker, return highest score
            if (myScore > otherScore){
                return 1;
            } else if (myScore < otherScore){
                return -1;
            } else {
                return 0;
            }
        }

        // pick the highest score
        // if (myScore > otherScore){
        //     return 1;
        // } else if (myScore < otherScore){
        //     return -1;
        // } else {
        //     return 0;
        // }

        // // minimise our losses
        // if (losses < other.losses){
        //     return 1;
        // } else if (losses > other.losses){
        //     return -1;
        // } else {
        //     // hack to detect if it's an instant victory, TODO in future use depth
        //     if (wins == 1 && losses == 0){
        //         return 1; // we can win, we're better
        //     } else if (other.wins == 1 && other.losses == 0){
        //         return -1; // other can win, we're worse
        //     }

        //     // tie breaker #1: number of wins
        //     if (wins > other.wins){
        //         return 1;
        //     } else if (wins < other.wins){
        //         return -1;
        //     } else {
        //         // TODO tiebreaker #2: depth
        //         return 0;
        //     }
        // }
    }
}