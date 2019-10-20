// This example contains straight-line assignment and printing statements in a single method, that is the main method
class simple {
    public static void main(String [] args) {
		int buh = 2;
		System.out.println("1");
		int[][] x;
		x  = new int[buh][buh];
		System.out.println("2");
		x[1][1] = 50;
		System.out.println(x[1][1]);
	}
}
