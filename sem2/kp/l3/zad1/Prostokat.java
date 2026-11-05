public class Prostokat extends Czworokat {
	int b;

	public Prostokat (int a, int c, int b, int d) throws IllegalArgumentException
	{
		if (a < 0 || b < 0) {
			throw new IllegalArgumentException("argument cannot be negative");
		}
		this.a = a;
		this.b = b;
	}

	public double pole()
	{
		return a*b;
	}

	public double obwod()
	{
		return 2*a+2*b;
	}

	public String name()
	{
		return "Prostokąt";
	}
}
