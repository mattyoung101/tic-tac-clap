import std.stdio;
import std.string;

char[] input(string question){
	char[] userInput;

    write(question ~ " ");
    readln(userInput);
    userInput = strip(userInput);
	toLowerInPlace(userInput);

	return userInput;
}