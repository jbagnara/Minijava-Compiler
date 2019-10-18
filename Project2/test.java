// This example contains straight-line assignment and printing statements in a single method, that is the main method
class simple {
    public static void main(String [] args) {
		int[][] x = new int[2][2];
		int[] b = new int[2];
		b[1] = 2;
		int y = 4*4;
		x[1][0] = y;
		x[0][1] = x[1][0] + 1;
		x[0] = b;
		System.out.println(x[0][1]+x[1][0]);
    }
}
