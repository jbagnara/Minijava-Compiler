class Factorial {
    public static void main(String[] a) {
	Fac x = new Fac();
        String b = "Hello! \t";
        String c = "This is a program   ";
	String d = " \b that computes factorial of \t";
	String e = b + c + d; 
	System.out.println(e);

	int number = Integer.parseInt(a[0]);			
	
	System.out.println(number);
	System.out.print("which equals \t");
			
      	System.out.println(x.ComputeFac(number));
    }
}
class Fac {
    public int ComputeFac(int num) {
        int num_aux;
        if (num < 1)
            num_aux = 1;
        else
            num_aux = num * (this.ComputeFac(num-1));
        return num_aux;
    }
}
