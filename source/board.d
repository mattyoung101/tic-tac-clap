import std.bitmanip : BitArray;
import std.stdio;

class Bitboard {
	BitArray noughtBB;
	BitArray crossBB;
	private BitArray draw;
	// see https://softwareengineering.stackexchange.com/a/263489
	private uint[] winStates = [292, 146, 73, 448, 56, 7, 273, 84];

	/** Creates a new bitboard by setting up the bit arrays **/
	this(){
		noughtBB = BitArray(new bool[9]);
		crossBB = BitArray(new bool[9]);
		draw = BitArray([1, 1, 1, 1, 1, 1, 1, 1, 1]);
	}

	/** Clones the other bitboard into this one **/
	this(Bitboard other){
		noughtBB = other.noughtBB.dup();
		crossBB = other.crossBB.dup();
		// pisses me off that this shit can't be defined in the class? TODO seriously find a way
		draw = BitArray([1, 1, 1, 1, 1, 1, 1, 1, 1]);
	}

	/** Pretty prints the board for humans (NOT the bitboard!) **/
	void prettyPrint(){
		writeln("-----------");
		for (int i = 0; i < 9; i++){
			immutable bool hasNought = noughtBB[i];
			immutable bool hasCross = crossBB[i];
			if (hasNought){
				write("O | ");
			} else if (hasCross){
				write("X | ");
			} else {
				write(i, " | ");
			}
			
			// line separator
			if ((i + 1) % 3 == 0) writeln("\n-----------");
		}
	}

	/** Determines if the game was a draw **/
	bool isDraw(){
		// writeln("Combined: ", noughtBB | crossBB, " Draw = ", draw);
		return (noughtBB | crossBB) == draw;
	}

	/** Determines if the nought bitboard is in the winning state **/
	bool isNoughtWinner(){
		foreach (ref winState; winStates){
			// turns the decimal representation of the binary bitboard into a BitArray
			auto winStateBB = BitArray(9u, &winState);

			if ((winStateBB & noughtBB) == winStateBB){
				return true;
			}
		}
		return false;
	}

	/** Determines if the cross bitboard is in the winning state **/
	bool isCrossWinner(){
		foreach (ref winState; winStates){
			auto winStateBB = BitArray(9u, &winState);

			if ((winStateBB & crossBB) == winStateBB){
				return true;
			}
		}
		return false;
	}
}