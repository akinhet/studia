import java.io.IOException;
import java.net.ServerSocket;

public class Server {
	public static void main(String[] args) {
		int port = 4444;
		boolean verbose = false;

		for (int i = 0; i < args.length; i++) {
			if (args[i].equals("-v"))
				verbose = true;
			else if (args[i].equals("-p")) {
				if (i + 1 >= args.length) {
					System.err.println("ERROR: no port number given to flag");
					System.exit(1);
				}

				try {
					port = Integer.parseInt(args[++i]);
				} catch (NumberFormatException ex) {
					System.err.println("ERROR: " + ex.getMessage());
					System.exit(1);
				}
			} else {
				System.err.println("ERROR: unknown option: " + args[i]);
				System.exit(1);
			}
		}

		try (ServerSocket serverSocket = new ServerSocket(port)) {
			System.out.println("Server listening on port " + port);
		} catch (IOException ex) {
			System.err.println("Server exception: " + ex.getMessage());
			ex.printStackTrace();
		};
	}
}
