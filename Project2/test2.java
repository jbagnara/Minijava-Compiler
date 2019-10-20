class sample {
    public static void main(String [] args) {
       /* Basic Assignment */
        int a = 3, b = 2;                     //Multi-variable int declaration
        String c = "CS352", s;                // String declaration
        s = "Hello";                          // String assignment
        boolean d1 = true;                    // Boolean declaration
        int[][][] arr;                        // Int 3D Array declaration
        arr = new int[2][2][2];               // Int 3D Array using new
        String[][] arr2 = new String[1][2]; // Single shot memory allocation arr2[3][4] = "hey"
        System.out.println(a);                // SOUT 3

        /* Basic Arithmetic Computations */
        System.out.println(a+b);             // 5 Add and print result
        int dec = 45+b/2*3;                  // Precedence of /,* over +
        int n = dec;                         // Variable assignment to another variable
        n = n+2;                             // Self-variable increment
        n = -n;                              // Unary minus test
        System.out.println(n);               // 50
        System.out.println(c+" Fall 2019");  // "CS352 Fall 2019" String concatenation
        dec = 45+2*(3/b);                    // 47 Parenthesis test 
        System.out.println(1*(dec+3));       // 50
        
        /* Basic Relational Computations */
        System.out.println(2 < 3);           // true Less Than
        System.out.println(!(a > b));        // false Greater Than and Not
        System.out.println(a == b);          // false Equality
        System.out.println(a>b&&(d1==true)); // true AND operator
        System.out.println(a<b||!(d1));      // false OR operator

        /* Conditional Branching Statements */ 
        if(a>b && (d1==true))
        {
            if(d1) if(false) {} else System.out.println("Correct");  else System.out.println("Incorrect");
        }
        else
        {
            System.out.println("Incorrect"); 
        }
        //Should print "Correct" as the final result
        
        /* Looping Constructs */
        int i=0;
        while(i<6)
        {
            System.out.println("Looping");
            i = i+2;
        } //To be printed three times

        /* Array access */
        arr[1][0][1] = 3;
        System.out.println(arr[1][0][1]); // 3
        int[][] Arr2D = new int[2][2];
        Arr2D[0][0] = 2;
        int[][] x;
        x = Arr2D; // Copy reference and set dimension values
        System.out.println(Arr2D[0][0]); // 2
        System.out.println(x[0][0]);     // 2
    }
}
