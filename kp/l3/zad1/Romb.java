public class Romb extends Czworokat {
	public Romb(int a, int kat) throws IllegalArgumentException
	{
		if (a < 0 || kat < 0 || kat > 179) {
			throw new IllegalArgumentException("argument cannot be negative");
		}
		this.a = a;
		this.kat = kat;
	}
	public double pole()
	{
		return Math.sin(Math.toRadians(kat))*a*a;
	}

	public double obwod()
	{
		return 4*a;
	}

	public String name()
	{
		return "Romb";
	}
}
