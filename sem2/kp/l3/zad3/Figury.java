public class Figury {
	public enum OneArg implements OneArgInter {
		KOLO {
			public double ObliczPole(int a)
			{
				return 3.14*a*a;
			}
			public double ObliczObwod(int a)
			{
				return 6.28*a;
			}
			public String PodajNazwe()
			{
				return "Koło";
			}
		},
		KWADRAT {
			public double ObliczPole(int a)
			{
				return a*a;
			}
			public double ObliczObwod(int a)
			{
				return 2*a;
			}
			public String PodajNazwe()
			{
				return "Kwadrat";
			}
		},
		PIECIOKAT {
			public double ObliczPole(int a)
			{
				return 5*a*a*1.376/4;
			}
			public double ObliczObwod(int a)
			{
				return 5*a;
			}
			public String PodajNazwe()
			{
				return "Pięciokąt";
			}
		},
		SZESCIOKAT {
			public double ObliczPole(int a)
			{
				return Math.sqrt(3)*3*a*a/2;
			}
			public double ObliczObwod(int a)
			{
				return 6*a;
			}
			public String PodajNazwe()
			{
				return "Sześciokąt";
			}
		},
	};

	public enum TwoArg implements TwoArgInter {
		PROSTOKAT {
			public double ObliczPole(int a, int b)
			{
				return a*b;
			}
			public double ObliczObwod(int a, int b)
			{
				return 2*(a+b);
			}
			public String PodajNazwe()
			{
				return "Prostokąt";
			}
		},
		ROMB {
			public double ObliczPole(int a, int b)
			{
				return Math.sin(Math.toRadians(b))*a*a;
			}
			public double ObliczObwod(int a, int b)
			{
				return 4*a;
			}
			public String PodajNazwe()
			{
				return "Prostokąt";
			}
		},
	};

	public interface OneArgInter {
		double ObliczPole(int a);
		double ObliczObwod(int a);
		String PodajNazwe();
	}

	public interface TwoArgInter {
		double ObliczPole(int a, int b);
		double ObliczObwod(int a, int b);
		String PodajNazwe();
	}

	public static void main(String args[])
	{
		if (args.length < 2) {
			System.out.println("ERROR: not enough args");
			return;
		}

		switch (args[0]) {
			case "o":
				try {
					System.out.println(OneArg.KOLO.PodajNazwe() + " - Pole: " + OneArg.KOLO.ObliczPole(Integer.parseInt(args[1])) + " Obwód: " + OneArg.KOLO.ObliczObwod(Integer.parseInt(args[1])));
				} catch (NumberFormatException e) {
					System.out.println("ERROR: not a number: " + e.getMessage());
				}
				return;
			case "k":
				try {
					System.out.println(OneArg.KWADRAT.PodajNazwe() + " - Pole: " + OneArg.KWADRAT.ObliczPole(Integer.parseInt(args[1])) + " Obwód: " + OneArg.KWADRAT.ObliczObwod(Integer.parseInt(args[1])));
				} catch (NumberFormatException e) {
					System.out.println("ERROR: not a number: " + e.getMessage());
				}
				return;
			case "p":
				try {
					System.out.println(OneArg.PIECIOKAT.PodajNazwe() + " - Pole: " + OneArg.PIECIOKAT.ObliczPole(Integer.parseInt(args[1])) + " Obwód: " + OneArg.PIECIOKAT.ObliczObwod(Integer.parseInt(args[1])));
				} catch (NumberFormatException e) {
					System.out.println("ERROR: not a number: " + e.getMessage());
				}
				return;
			case "s":
				try {
					System.out.println(OneArg.SZESCIOKAT.PodajNazwe() + " - Pole: " + OneArg.SZESCIOKAT.ObliczPole(Integer.parseInt(args[1])) + " Obwód: " + OneArg.SZESCIOKAT.ObliczObwod(Integer.parseInt(args[1])));
				} catch (NumberFormatException e) {
					System.out.println("ERROR: not a number: " + e.getMessage());
				}
				return;
			case "t":
				try {
					if (args.length != 3) {
						System.out.println("ERROR: invalid number of arguments");
						return;
					}
					System.out.println(TwoArg.PROSTOKAT.PodajNazwe() + " - Pole: " + TwoArg.PROSTOKAT.ObliczPole(Integer.parseInt(args[1]), Integer.parseInt(args[2])) + " Obwód: " + TwoArg.PROSTOKAT.ObliczObwod(Integer.parseInt(args[1]), Integer.parseInt(args[2])));
				} catch (NumberFormatException e) {
					System.out.println("ERROR: not a number: " + e.getMessage());
				}
				return;
			case "r":
				try {
					if (args.length != 3) {
						System.out.println("ERROR: invalid number of arguments");
						return;
					}
					System.out.println(TwoArg.ROMB.PodajNazwe() + " - Pole: " + TwoArg.ROMB.ObliczPole(Integer.parseInt(args[1]), Integer.parseInt(args[2])) + " Obwód: " + TwoArg.ROMB.ObliczObwod(Integer.parseInt(args[1]), Integer.parseInt(args[2])));
				} catch (NumberFormatException e) {
					System.out.println("ERROR: not a number: " + e.getMessage());
				}
				return;
		}
	}
}
