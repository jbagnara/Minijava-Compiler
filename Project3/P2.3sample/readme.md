The test cases are supposed to be free of type violations
and are tested with standard `javac` compiler and gives the desired output.
The cases (in the following order) are approximately increasing in their complexities in terms of the language features covered. Simpler cases covered by P2.1 and P2.2 are not included.

1. `loop.java`: Method invocation with no parameters. The method belongs to a class with no instance variables. It has a loop to compute factorial and prints the result.

2. `array.java`: Array accesseses. A parameterless method is invoked to perform bubble sort.

3. `numbers.java`: Two methods (with parameters) are invoked. 
One of them computes the combinations of k out of n. 
The other computes the greatest common devisor (GCD) of two numbers.

4. `HanoiDemo.java`: Recursive method call.

5. 'factorial.java': Reads a commandline argument, converts it by calling
the standard method Integer.ParseInt, concatenate strings that contain
escape characters, makes recursive calls to compute factorial.
