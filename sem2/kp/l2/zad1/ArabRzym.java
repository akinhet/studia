class ArabRzymException extends Exception {
	public ArabRzymException (String m)
	{
		super(m);
	}
}


public class ArabRzym {
	//private static String[] liczby = { "I", "V", "X", "L", "C", "D", "M" };
	private static String liczby = "IVXLCDM";
	private static int[] wartosci  = { 1,   5,   10,  50,  100, 500, 1000 };

	public static int rzym2arab (String r) throws ArabRzymException
	{
		int ret = 0,
			previdx = 0,
			maxidx = 0;

		if (r.contains("IIII") || r.contains("VV") || r.contains("XXXX") || r.contains("LL") ||
			r.contains("CCCC") || r.contains("DD") || r.contains("MMMM")) {
			throw new ArabRzymException("Invalid repetition in roman numeral: " + r);
		}

		for (int i = r.length() - 1; i >= 0; i--) {
			int idx = liczby.indexOf(r.charAt(i));
			if (idx == -1) {
				throw new ArabRzymException("Invalid char in roman numeral: " + r.charAt(i));
			}
			int val = wartosci[idx];

			if (previdx < maxidx && idx < maxidx) {
				throw new ArabRzymException("Invalid roman numeral: " + r);
			}

			if (previdx > idx) {
				if (previdx - idx <= 2 && (idx == 0 || idx == 2 || idx == 4)) {
					ret -= val;
				} else {
					throw new ArabRzymException("Invalid roman numeral: " + r);
				}
			} else {
				ret += val;
			}

			previdx = idx;
			maxidx = idx > maxidx ? idx : maxidx;
		}

		return ret;
	}

	public static String arab2rzym (int n) throws ArabRzymException
	{
		if (n < 1 || n >= 4000) {
			throw new ArabRzymException("liczba spoza zakresu");
		}

		int num = n;
		String ret = "";
		while (num > 0) {
			if (num >= 1000) {
				num -= 1000;
				ret += "M";
				continue;
			}
			if (num >= 900) {
				num -= 900;
				ret += "CM";
				continue;
			}
			if (num >= 500) {
				num -= 500;
				ret += "D";
				continue;
			}
			if (num >= 400) {
				num -= 400;
				ret += "CD";
				continue;
			}
			if (num >= 100) {
				num -= 100;
				ret += "C";
				continue;
			}
			if (num >= 90) {
				num -= 90;
				ret += "XC";
				continue;
			}
			if (num >= 50) {
				num -= 50;
				ret += "L";
				continue;
			}
			if (num >= 40) {
				num -= 40;
				ret += "XL";
				continue;
			}
			if (num >= 10) {
				num -= 10;
				ret += "X";
				continue;
			}
			if (num >= 9) {
				num -= 9;
				ret += "IX";
				continue;
			}
			if (num >= 5) {
				num -= 5;
				ret += "V";
				continue;
			}
			if (num >= 4) {
				num -= 4;
				ret += "IV";
				continue;
			}
			if (num >= 1) {
				num -= 1;
				ret += "I";
				continue;
			}
		}

		return ret;
	}
}
