public class Kwadrat extends Czworokat {
	public Kwadrat(int a) throws IllegalArgumentException
	{
		if (a < 0) {
			throw new IllegalArgumentException("argument cannot be negative");
		}
		this.a = a;
	}

	public double pole()
	{
		return a*a;
	}

	public double obwod()
	{
		return 4*a;
	}

	public String name()
	{
		return "Kwadrat";
	}
}
