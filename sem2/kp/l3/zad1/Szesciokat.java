public class Szesciokat extends Figura {
	int a;

	public Szesciokat(int a) throws IllegalArgumentException
	{
		if (a < 0) {
			throw new IllegalArgumentException("argument cannot be negative");
		}
		this.a = a;
	}

	public double pole()
	{
		return Math.sqrt(3)*3*a*a/2;
	}

	public double obwod()
	{
		return 6*a;
	}

	public String name()
	{
		return "Sześciokąt";
	}
}
