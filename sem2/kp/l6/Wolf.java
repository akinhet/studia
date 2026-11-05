import java.awt.Point;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

/**
 * Represents a wolf in the simulation that hunts rabbits.
 * @author Piotr Zieniewicz
 * @see Rabbit
 * @see Simulation
 */
public class Wolf extends Thread {
	private int x, y;
	private int restCycles = 0;
	private Simulation sim;
	private long cycleTime;
	private boolean suspended = false;

	/**
	 * Initializes the wolf with position and simulation context.
	 * @param x Initial X coordinate.
	 * @param y Initial Y coordinate.
	 * @param sim Simulation instance the wolf belongs to.
	 */
	public Wolf(int x, int y, Simulation sim) {
		this.x = x;
		this.y = y;
		this.sim = sim;
		this.cycleTime = (long) ((0.5 + sim.getRand().nextFloat(0, 1)) * sim.cycleTime);
	}

	/**
	 * Gets the x coordinate of this wolf.
	 * @return The x coordinate of this wolf.
	 */
	public synchronized int getX() {
		return x;
	}

	/**
	 * Gets the y coordinate of this wolf.
	 * @return The y coordinate of this wolf.
	 */
	public synchronized int getY() {
		return y;
	}

	/**
	 * Toggles the suspended state of the wolf.
	 */
	public synchronized void toggleSuspended() {
		suspended = !suspended;
		if (!suspended)
			notify();
	}

	/**
	 * Makes the wolf sleep for the remaining duration of its cycle.
	 * @param cycleStart Start time of the current cycle.
	 */
	private void sleepCycle(Instant cycleStart) {
		try {
			long toSleep = (long) cycleTime - Duration.between(cycleStart, Instant.now()).toMillis();
			if (toSleep > 0) {
				Thread.sleep(toSleep);
			}

		} catch (InterruptedException e) {
			System.err.println("EXCEPTION: thread interrupted");
		}
	}

	/**
	 * Main logic for the wolf’s behavior. Hunts rabbits by moving closer to them.
	 */
	public void run() {
		while (sim.isRunning()) {
			Instant start = Instant.now();

			if (restCycles > 0) {
				restCycles--;
				sleepCycle(start);
				continue;
			}

			try {
				synchronized (this) {
					while (suspended)
						wait();
				}
			} catch (InterruptedException e) {
				System.err.println("EXCEPTION: thread interrupted");
			}

			synchronized (sim) {
				if (sim.getRabbits().isEmpty()) {
					sim.stop();
					return;
				}

				Rabbit nearest = null;

				int minDist = Integer.MAX_VALUE;
				for (int i = 0; i < sim.getRabbits().size(); i++) {
					Rabbit r = sim.getRabbits().get(i);

					if (r.isSuspended())
						continue;

					int dist = (x - r.getX()) * (x - r.getX()) + (y - r.getY()) * (y - r.getY());
					if (dist < minDist) {
						minDist = dist;
						nearest = r;
					}
				}

				if (nearest == null) {
					sleepCycle(start);
					continue;
				}

				final int fnearestx = nearest.getX();
				final int fnearesty = nearest.getY();


				int[] dx = { -1, 0, 1 };
				int[] dy = { -1, 0, 1 };
				List<Point> options = new ArrayList<>();

				//for (int i = -1; i <= 1; i++) {
					//for (int j = -1; j <= 1; j++) {
				for (int i : dx) {
					for (int j : dy) {
						if (i == 0 && j == 0)
							continue;
						int nx = x + i;
						int ny = y + j;
						if (nx >= 0 && ny >= 0 && nx < sim.width && ny < sim.height) {
							if (!sim.getGrid()[nx][ny].hasWolf() && !sim.getGrid()[nx][ny].isSuspended())
								options.add(new Point(nx, ny));
						}
					}
				}

				options.sort(Comparator.comparingInt(
						p -> (p.x - fnearestx) * (p.x - fnearestx) + (p.y - fnearesty) * (p.y - fnearesty)));
				List<Point> bestMoves = new ArrayList<>();
				int bestDist = (options.isEmpty() ? Integer.MAX_VALUE
						: (options.get(0).x - fnearestx) * (options.get(0).x - fnearestx)
								+ (options.get(0).y - fnearesty) * (options.get(0).y - fnearesty));

				for (Point p : options) {
					int dist = (p.x - fnearestx) * (p.x - fnearestx) + (p.y - fnearesty) * (p.y - fnearesty);
					if (dist == bestDist)
						bestMoves.add(p);
				}

				if (!bestMoves.isEmpty()) {
					Point move = bestMoves.get(sim.getRand().nextInt(bestMoves.size()));
					sim.getGrid()[x][y].setWolf(null);
					x = move.x;
					y = move.y;
					if (sim.getGrid()[x][y].hasRabbit()) {
						Rabbit caught = sim.getGrid()[x][y].getRabbit();
						caught.kill();
						sim.getRabbits().remove(caught);
						sim.getGrid()[x][y].setRabbit(null);
						restCycles = 5;
					}
					sim.getGrid()[x][y].setWolf(this);
				}
			}

			sleepCycle(start);
		}
	}
}
