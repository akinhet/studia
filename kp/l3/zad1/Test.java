import java.util.*;


class Test {
	public static void main(String args[])
	{
		List<Figura> figury = new ArrayList<Figura>();
		for (int i = 0; i < args.length; i++) {
			switch (args[i]) {
				case "o":
					try {
						figury.add(new Kolo(Integer.parseInt(args[++i])));
					} catch (NumberFormatException e) {
						System.out.println("ERROR: illegal argument to a shape: " + args[i]);
						return;
					} catch (IllegalArgumentException e) {
						System.out.println("ERROR: " + e.getMessage());
						return;
					}
					break;
				case "p":
					try {
						figury.add(new Pieciokat(Integer.parseInt(args[++i])));
					} catch (NumberFormatException e) {
						System.out.println("ERROR: illegal argument to a shape: " + args[i]);
						return;
					} catch (IllegalArgumentException e) {
						System.out.println("ERROR: " + e.getMessage());
						return;
					}
					break;
				case "s":
					try {
						figury.add(new Szesciokat(Integer.parseInt(args[++i])));
					} catch (NumberFormatException e) {
						System.out.println("ERROR: illegal argument to a shape: " + args[i]);
						return;
					} catch (IllegalArgumentException e) {
						System.out.println("ERROR: " + e.getMessage());
						return;
					}
					break;
				case "c": {
						List<Integer> cargs = new ArrayList<Integer>();
						String tokens = "cops";
						while (++i < args.length && !tokens.contains(args[i])) {
							try {
								cargs.add(Integer.parseInt(args[i]));
							} catch (NumberFormatException e) {
								System.out.println("ERROR: illegal argument to a shape: " + args[i]);
								return;
							}
						}
						i--;

						if (cargs.size() == 2) {
							if (cargs.get(1) == 90)
								try {
									figury.add(new Kwadrat(cargs.get(0)));
								} catch (IllegalArgumentException e) {
									System.out.println("ERROR: " + e.getMessage());
									return;
								}
							else
								try {
									figury.add(new Romb(cargs.get(0), cargs.get(1)));
								} catch (IllegalArgumentException e) {
									System.out.println("ERROR: " + e.getMessage());
									return;
								}
						} else if (cargs.size() == 5) {
							if (cargs.get(4) != 90) {
								System.out.println("ERROR: unsupported shape");
								return;
							}
							try {
								figury.add(new Prostokat(cargs.get(0), cargs.get(1), cargs.get(2), cargs.get(3)));
							} catch (IllegalArgumentException e) {
								System.out.println("ERROR: " + e.getMessage());
								return;
							}
						} else {
							System.out.println("ERROR: illegal amount of arguments for Czworokat class: " + cargs.size());
							return;
						}
					}
					break;
				default:
					System.out.println("ERROR: illegal instruction: " + args[i]);
					return;
			}
		}

		for (Figura f : figury) {
			System.out.println(f.name() + " - Pole: " + f.pole() + " Obwód: " + f.obwod());
		}

		return;
	}
}
