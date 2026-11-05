public class Test {
	public static void main(String[] args)
	{
		WierszTrojkataPascala wiersz;

		try {
			wiersz = new WierszTrojkataPascala(Integer.parseInt(args[0]));
			wiersz.GenerateRow();
		} catch (NumberFormatException ex) {
			System.out.println(args[0] + " - nieprawidłowa dana");
			return;
		} catch (IntegerOutOfBounds ex) {
			System.out.println(args[0] + " - " + ex.getMessage());
			return;
		}

		for (int i = 1; i < args.length; i++) {
			try {
				System.out.println(args[i] + " - " + wiersz.GetElement(Integer.parseInt(args[i])));
			} catch (NumberFormatException ex) {
				System.out.println(args[i] + " - nieprawidłowa dana");
			} catch (IntegerOutOfBounds ex) {
				System.out.println(args[i] + " - " + ex.getMessage());
			}
		}
	}
}
