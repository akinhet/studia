public class Kolo extends Figura {
	int r;

	public Kolo (int r) throws IllegalArgumentException
	{
		if (r < 0) {
			throw new IllegalArgumentException("argument cannot be negative");
		}
		this.r = r;
	}

	public double pole()
	{
		return 3.14*r*r;
	}

	public double obwod()
	{
		return 6.28*r;
	}

	public String name()
	{
		return "Koło";
	}
}
