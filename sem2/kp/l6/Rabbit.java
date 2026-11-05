import java.awt.Point;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

/**
 * Represents a rabbit in the simulation that moves to avoid the wolf.
 * @author Piotr Zieniewicz
 * @see Simulation
 */
public class Rabbit extends Thread {
	private int x, y;
	private Simulation sim;
	private long cycleTime;
	private boolean alive = true;
	private boolean suspended = false;

	/**
	 * Initializes a rabbit with position and simulation context.
	 * @param x Initial X coordinate.
	 * @param y Initial Y coordinate.
	 * @param sim Simulation instance this rabbit belongs to.
	 */
	public Rabbit(int x, int y, Simulation sim) {
		this.x = x;
		this.y = y;
		this.sim = sim;
		this.cycleTime = (long) ((0.5 + sim.getRand().nextFloat(0, 1)) * sim.cycleTime);
	}

	/**
	 * Gets the x coordinate of this rabbit.
	 * @return The x coordinate of this rabbit.
	 */
	public synchronized int getX() {
		return x;
	}

	/**
	 * Gets the y coordinate of this rabbit.
	 * @return The y coordinate of this rabbit.
	 */
	public synchronized int getY() {
		return y;
	}

	/**
	 * Marks the rabbit as no longer alive.
	 */
	public void kill() {
		alive = false;
	}

	/**
	 * Checks if the rabbit is currently suspended.
	 * @return true if suspended, false otherwise.
	 */
	public synchronized boolean isSuspended() {
		return suspended;
	}

	/**
	 * Toggles the suspended state of the rabbit.
	 */
	public synchronized void toggleSuspended() {
		suspended = !suspended;
		if (!suspended) {
			notify();
		}
	}

	/**
	 * Controls the rabbit's movement behavior while the simulation is running.
	 * Avoids the wolf and updates its position.
	 */
	public void run() {
		while (sim.isRunning()) {
			Instant start = Instant.now();

			synchronized (sim) {
				if (!sim.isRunning() || sim.getRabbits().isEmpty() || !alive)
					break;
				int[] dx = { -1, 0, 1 };
				int[] dy = { -1, 0, 1 };
				int wx = sim.getWolf().getX();
				int wy = sim.getWolf().getY();
				List<Point> options = new ArrayList<>();

				for (int i : dx) {
					for (int j : dy) {
						int nx = x + i;
						int ny = y + j;
						if (i == 0 && j == 0)
							continue;
						if (nx >= 0 && ny >= 0 && nx < sim.width && ny < sim.height) {
							if (sim.getGrid()[nx][ny].isEmpty()) {
								if (x == 0 || x == sim.width - 1 || y == 0 || y == sim.height - 1) {
									options.add(new Point(nx, ny));
									continue;
								} else {
									int distOld = (x - wx) * (x - wx) + (y - wy) * (y - wy);
									int distNew = (nx - wx) * (nx - wx) + (ny - wy) * (ny - wy);
									if (distNew > distOld)
										options.add(new Point(nx, ny));
								}
							}
						}
					}
				}

				if (!options.isEmpty()) {
					Point move = options.get(sim.getRand().nextInt(options.size()));
					sim.getGrid()[x][y].setRabbit(null);
					x = move.x;
					y = move.y;
					sim.getGrid()[x][y].setRabbit(this);
				}
			}

			try {
				long toSleep = (long) cycleTime - Duration.between(start,
						Instant.now()).toMillis();
				if (toSleep > 0)
					Thread.sleep(toSleep);

				synchronized (this) {
					while (suspended && alive)
						wait();
				}
			} catch (InterruptedException e) {
				System.out.println("EXCEPTION: thread interrupted");
				break;
			}
		}
	}
}
