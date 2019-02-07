import std.stdio;
import std.random;
import std.string;
import std.uni;
import std.bitmanip : BitArray;
import core.stdc.stdlib : exit;
import board;
import player;
import utils;

void main(){
	auto bitboard = new Bitboard;
	auto humanPlayer = new HumanPlayer;
	auto aiPlayer = new AIPlayer;
	
	writeln("Tic Tac Clap v0.2 - a tic tac toe program in D");
	writeln("(c) 2019 Matt Young, MIT license.");
	auto isAITurn = input("Would you like to go first (y/n)? ") != "y";

	while (true){
		bitboard.prettyPrint();

		writeln(isAITurn ? "The AI is playing" : "You are playing");
		auto move = isAITurn ? aiPlayer.getMove(bitboard) : humanPlayer.getMove(bitboard);

		if (isAITurn){
			if (bitboard.noughtBB[move]) writeln("Illegal move.");
			bitboard.noughtBB[move] = true;
		} else {
			if (bitboard.crossBB[move]) writeln("Illegal move.");
			bitboard.crossBB[move] = true;
		}


		if (bitboard.isCrossWinner()){
			bitboard.prettyPrint();
			writeln("Cross wins!");
			break;
		} else if (bitboard.isNoughtWinner()){
			bitboard.prettyPrint();
			writeln("Nought wins!");
			break;
		} else if (bitboard.isDraw()){
			bitboard.prettyPrint();
			writeln("Draw!");
			break;
		}

		isAITurn = !isAITurn;
	}

	input("Press ENTER to exit.");
}
