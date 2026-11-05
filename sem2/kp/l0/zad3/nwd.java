
public class nwd {
	public static void main(String[] args) {
		for (int i = 0; i < args.length; i++) {
			try {
				System.out.println(div(Integer.parseInt(args[i])));
			}
			catch (NumberFormatException ex) {
				System.out.println(args[i] + " nie jest liczba calkowita");
			}
		}
	}


	public static int div(int n) {
		for (int i = n/2; i > 0; i--) {
			if (n % i == 0)
				return i;
		}
		return 1;
	}
}
