class IntegerOutOfBounds extends Exception {
	public IntegerOutOfBounds (String m)
	{
		super(m);
	}
}

public class WierszTrojkataPascala {

	private int numer;
	private long wiersz[];

	public WierszTrojkataPascala(int n) throws IntegerOutOfBounds
	{
		if (n < 0) {
			throw new IntegerOutOfBounds("nieprawidłowy numer wiersza");
		}
		numer = n;
	}

	public void GenerateRow()
	{
		wiersz = new long[numer + 1];
		wiersz[0] = 1;
		for (int i = 0; i < numer; i++)
			for (int j = numer; j > 0; j--)
				wiersz[j] = wiersz[j] + wiersz[j - 1];
	}

	public long GetElement (int i) throws IntegerOutOfBounds
	{
		if (i < 0 || i > numer) {
			throw new IntegerOutOfBounds("liczba spoza zakresu");
		}
		return wiersz[i];
	}
}
