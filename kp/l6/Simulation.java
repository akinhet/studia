import java.awt.Color;
import java.awt.Graphics;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import javax.swing.JPanel;
import javax.swing.Timer;

/**
 * Main simulation panel. Manages the grid, entities and rendering.
 * @author Piotr Zieniewicz
 * @see Rabbit
 * @see Wolf
 */
public class Simulation extends JPanel {
	/**
	 * Width of the simulation grid.
	 */
	public int width;
	/**
	 * Height of the simulation grid.
	 */
	public int height;
	/**
	 * Number of rabbits in the simulation.
	 */
	public int numRabbits;
	/**
	 * The base cycle time of the simulation.
	 */
	public int cycleTime;

	private Cell[][] grid;
	private List<Rabbit> rabbits = new ArrayList<>();
	private Wolf wolf;
	private static Random rand = new Random();
	private Timer timer;
	private boolean running = true;

	/**
	 * Initializes the simulation grid and mouse interaction.
	 * @param width Width of the grid.
	 * @param height Height of the grid.
	 * @param numRabbits Number of rabbits to spawn.
	 * @param cycleTime Cycle time in milliseconds.
	 */
	public Simulation(int width, int height, int numRabbits, int cycleTime) {
		this.width = width;
		this.height = height;
		this.numRabbits = numRabbits;
		this.cycleTime = cycleTime;

		grid = new Cell[width][height];

		for (int x = 0; x < width; x++)
			for (int y = 0; y < height; y++)
				grid[x][y] = new Cell();

		addMouseListener(new MouseAdapter() {
			public void mouseClicked(MouseEvent e) {
				int x = (int) (e.getX() * width / getWidth());
				int y = (int) (e.getY() * height / getHeight());
				grid[x][y].toggleSuspended();
			}
		});
	}

	/**
	 * Spawns all simulation entities (rabbits and wolf) and starts rendering.
	 */
	void start() {
		int wx, wy;
		do {
			wx = rand.nextInt(width);
			wy = rand.nextInt(height);
		} while (!grid[wx][wy].isEmpty());
		wolf = new Wolf(wx, wy, this);
		grid[wx][wy].setWolf(wolf);
		wolf.start();

		for (int i = 0; i < numRabbits; i++) {
			int x, y;
			do {
				x = rand.nextInt(width);
				y = rand.nextInt(height);
			} while (!grid[x][y].isEmpty());
			Rabbit r = new Rabbit(x, y, this);
			rabbits.add(r);
			grid[x][y].setRabbit(r);
			r.start();
		}

		timer = new Timer(100, e -> {
			repaint();
			System.out.print("");
		});
		// timer = new Timer(100, e -> repaint());
		timer.start();
	}

	/**
	 * Draws the current state of the simulation on screen.
	 * @param g Graphics context used for rendering.
	 */
	public void paint(Graphics g) {
		float cellWidth = (float) getWidth() / width;
		float cellHeight = (float) getHeight() / height;

		{
			g.setColor(Color.WHITE);
			g.fillRect(0, 0, getWidth(), getHeight());
		}

		for (int i = 0; i < width; i++) {
			for (int j = 0; j < height; j++) {
				if (!grid[i][j].isEmpty()) {
					if (grid[i][j].isSuspended()) {
						g.setColor(Color.BLUE);
					} else if (grid[i][j].hasRabbit()) {
						g.setColor(Color.GREEN);
					} else {
						g.setColor(Color.RED);
					}

					int x = Math.round(i * cellWidth);
					int y = Math.round(j * cellHeight);
					int w = Math.round((i + 1) * cellWidth) - x;
					int h = Math.round((j + 1) * cellHeight) - y;

					g.fillRect(x, y, w, h);
				}
			}
		}

		g.setColor(Color.GRAY);
		for (int r = 0; r <= getHeight(); r++) {
			int y = Math.round(r * cellHeight);
			g.drawLine(0, y, getWidth(), y);
		}
		for (int c = 0; c <= getWidth(); c++) {
			int x = Math.round(c * cellWidth);
			g.drawLine(x, 0, x, getHeight());
		}
	}

	/**
	 * Gets the simulation's wolf.
	 * @return The simulation's wolf.
	 */
	public synchronized Wolf getWolf() {
		return wolf;
	}

	/**
	 * Gets the simulation's RNG.
	 * @return The simulation's RNG.
	 */
	public synchronized Random getRand() {
		return rand;
	}

	/**
	 * Gets the simulation grid.
	 * @return 2D array of Cell objects.
	 */
	public synchronized Cell[][] getGrid() {
		return grid;
	}

	/**
	 * Gets the list of rabbits currently in the simulation.
	 * @return List of Rabbit objects.
	 */
	public synchronized List<Rabbit> getRabbits() {
		return rabbits;
	}

	/**
	 * Removes a rabbit from the simulation.
	 * @param r The rabbit to remove.
	 */
	public synchronized void removeRabbit(Rabbit r) {
		rabbits.remove(r);
	}

	/**
	 * Checks whether the simulation is active.
	 * @return true if running, false otherwise.
	 */
	public synchronized boolean isRunning() {
		return running;
	}

	/**
	 * Stops the simulation and halts the rendering timer.
	 */
	public void stop() {
		if (timer != null && timer.isRunning())
			timer.stop();
		running = false;
		repaint();
	}
}

/**
 * Represents a single cell in the simulation grid.
 * Holds state about whether a rabbit or wolf occupies it.
 * @author Piotr Zieniewicz
 * @see Rabbit
 * @see Wolf
 */
class Cell {
	private Rabbit rabbit;
	private Wolf wolf;
	private boolean suspended = false;

	/**
	 * Checks if the cell has no animals.
	 * @return true if empty, false otherwise.
	 */
	public synchronized boolean isEmpty() {
		return rabbit == null && wolf == null;
	}

	/**
	 * Checks if the cell contains a rabbit.
	 * @return true if it contains a rabbit, false otherwise.
	 */
	public synchronized boolean hasRabbit() {
		return rabbit != null;
	}

	/**
	 * Checks if the cell contains a wolf.
	 * @return true if it contains a wolf, false otherwise.
	 */
	public synchronized boolean hasWolf() {
		return wolf != null;
	}

	/**
	 * Gets the rabbit in this cell.
	 * @return Rabbit object or null.
	 */
	public synchronized Rabbit getRabbit() {
		return rabbit;
	}

	/**
	 * Sets the rabbit in this cell.
	 * @param r Rabbit to place in this cell.
	 */
	public synchronized void setRabbit(Rabbit r) {
		this.rabbit = r;
	}

	/**
	 * Sets the wolf in this cell.
	 * @param w Wolf to place in this cell.
	 */
	public synchronized void setWolf(Wolf w) {
		this.wolf = w;
	}

	/**
	 * Clears both rabbit and wolf from this cell.
	 */
	public synchronized void clear() {
		rabbit = null;
		wolf = null;
	}

	/**
	 * Checks whether this cell is in a suspended state.
	 * @return true if suspended, false otherwise.
	 */
	public synchronized boolean isSuspended() {
		return suspended;
	}

	/**
	 * Toggles the suspended state of the cell and its occupants.
	 */
	public synchronized void toggleSuspended() {
		if (isEmpty()) {
			return;
		}
		if (hasWolf()) {
			this.wolf.toggleSuspended();
		}
		if (hasRabbit()) {
			this.rabbit.toggleSuspended();
		}
		suspended = !suspended;
	}
}
