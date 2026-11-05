public class Test {
	public static void main(String[] args)
	{
		if (args.length < 1) {
			return;
		}
		if (args[0].equals("r2a")) {
			for (int i = 1; i < args.length; i++) {
				try {
					System.out.println(ArabRzym.rzym2arab(args[i]));
				} catch (ArabRzymException ex) {
					System.out.println(ex.getMessage());
				}
			}
		} else if (args[0].equals("a2r")) {
			for (int i = 1; i < args.length; i++) {
				try {
					System.out.println(ArabRzym.arab2rzym(Integer.parseInt(args[i])));
				} catch (ArabRzymException ex) {
					System.out.println(ex.getMessage());
				}
			}
		} else {
			System.out.println("Invalid argument: " + args[0]);
			return;
		}
	}
}
