class Factorial {
    public static void main(String[] a) {
	Fac x = new Fac();
        String b = "Hello! \t";
        String c = "This is a program   ";
	String d = " \b that computes factorial of \t";
	String e = b + c + d; 
	System.out.println(e);
	System.out.println(a[0]);
	int number = 7;//Integer.parseInt(a[0]);			
	
	System.out.print("which equals \t");
			
      	//System.out.println(new Fac().ComputeFac(number, "hi!"));

	System.out.println(new Fac2().ComputeFac(number, "boop"));
    }
}
class Fac {
	String bloop="hi";
    public int ComputeFac(int num, String chungus) {
	bloop = "wahoo";
	System.out.println(bloop);
        int num_aux;
        if (num < 1)
            num_aux = 1;
        else
            num_aux = num * (this.ComputeFac(num-1, chungus));
	
        return num_aux;
    }
}

class Fac2 extends Fac {
	public int Printguy(){
		System.out.println(bloop);
		return 1;
	}

}
