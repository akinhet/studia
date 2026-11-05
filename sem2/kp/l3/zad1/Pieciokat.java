public class Pieciokat extends Figura {
	int a;

	public Pieciokat (int a) throws IllegalArgumentException
	{
		if (a < 0) {
			throw new IllegalArgumentException("argument cannot be negative");
		}
		this.a = a;
	}

	public double pole()
	{
		return 5*a*a*1.376/4;
	}

	public double obwod()
	{
		return 5*a;
	}

	public String name()
	{
		return "Pieciokąt";
	}
}
