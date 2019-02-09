import std.conv;
import core.stdc.stdlib;
import std.stdio;
import std.string;
import core.memory : GC;
import std.algorithm.sorting;
import std.algorithm.mutation;
import std.datetime.stopwatch;
import std.conv;
import board;
import search;
import utils;

/** An individual whomst can participate in the classical paper game of tic tac toe **/
interface Player {
    int getMove(Bitboard board);
}

/** Player of tic tac toe who enters their moves with console input. Prone to making terrible moves. **/
class HumanPlayer : Player {
    int getMove(Bitboard board){
        auto playerMoveStr = input("Your move (0-8): ");
        toLowerInPlace(playerMoveStr);
        
        if (playerMoveStr == "exit"){
            writeln("Goodbye!");
            exit(0);
        }

        return to!int(playerMoveStr);
    }
}

/** AI player using depth first search**/
class AIPlayer : Player {
    int getMove(Bitboard board){
        // find all unexplored positions to go down the tree on
        auto boardCpy = new Bitboard(board);
        auto available = boardCpy.crossBB | boardCpy.noughtBB; 
        available.flip();
        //writeln("Noughts BB: ", boardCpy.noughtBB, "\tCross BB: ", boardCpy.crossBB, "\tAvailable BB: ", available);
        // TODO auto resign if all scores == inf (it's a guaranteed win/draw)
        // TODO there's an issue where sometimes the losses aren't calculated properly or something (it's possible to beat)?

        Node[] moves;
        search.totalMovesEvaluated = 0;
        auto sw = new StopWatch(AutoStart.yes);

        // the actual search algorithm
        for (int i = 0; i < 9; i++){
            if (available[i]){
                // explore the game tree from this position, assuming we were to play it out
                auto playedOutPosition = new Bitboard(board);
                playedOutPosition.noughtBB[i] = true;

                auto node = new Node(playedOutPosition, null, 0);
                node.moveId = i;
                node.search(false); // we've already made the move, AI cannot play again

                writeln("Node #", i, ": wins: ", node.wins, ", losses: ", node.losses, ", probability: ", 
                        node.getScore(), "%, depth to win: ", 
                        node.depthToWin == 999 ? "impossible" : to!string(node.depthToWin), ", depth to loss: ", 
                        node.depthToLoss == 999 ? "impossible" : to!string(node.depthToLoss));


                // hack so that it can detect instant wins
                if (node.depthToWin == 0){
                    writeln("Returning #", i, " since I can win instantly");
                    return node.moveId;
                }
                //playedOutPosition.prettyPrint();
                moves ~= node;
            }
        }

        sort(moves);
        reverse(moves); // sort does lowest to highest but we want highest to lowest, so reverse it
        Node bestMove = moves[0];

        writeln("Best move is ", bestMove.moveId, " with a probability of ", bestMove.getScore(), "%");
        
        sw.stop();
        auto secondsTotal = to!float(sw.peek.total!"msecs") / 1000.0;
        auto movesPerSecond = to!float(totalMovesEvaluated) / secondsTotal; 
        writeln("Evaluated ", totalMovesEvaluated, " moves in ", secondsTotal, " seconds (", movesPerSecond, 
                " moves/second)");

        return bestMove.moveId;
    }


}