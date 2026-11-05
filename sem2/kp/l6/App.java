import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JPanel;

/**
 * Entry point for the simulation application. Handles GUI setup and simulation control.
 * @author Piotr Zieniewicz
 */
class App {
	static Simulation simulation;

	/**
	 * Initializes the GUI, creates input fields and starts the simulation upon button click.
	 * @param args Command-line arguments (unused).
	 * @see Simulation
	 */
	public static void main(String[] args) {
		JFrame frame = new JFrame();
		JPanel mainPanel = new JPanel();
		mainPanel.setLayout(new BorderLayout());

		JPanel settings = new JPanel();
		Label rabbitLabel = new Label("Zające:");
		TextField rabbitInput = new TextField("5", 3);
		Label delayLabel = new Label("Opóźnienie w ms:");
		TextField delayInput = new TextField("100", 6);
		Label widthLabel = new Label("Szerokość:");
		TextField widthInput = new TextField("20", 3);
		Label heightLabel = new Label("Wysokość:");
		TextField heightInput = new TextField("20", 3);
		Button startButton = new Button("Start symulacji");
		startButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				try {
					int rabbits = Integer.parseInt(rabbitInput.getText());
					int delay = Integer.parseInt(delayInput.getText());
					int width = Integer.parseInt(widthInput.getText());
					int height = Integer.parseInt(heightInput.getText());
					if (simulation != null) {
						simulation.stop();
						mainPanel.remove(simulation);
						simulation = null;
					}
					simulation = new Simulation(width, height, rabbits, delay);
					mainPanel.add(simulation, BorderLayout.CENTER);
					mainPanel.revalidate();
					mainPanel.repaint();
					simulation.start();
				} catch (NumberFormatException exc) {
					JOptionPane.showMessageDialog(frame, "Złe ustawienia: " + exc.toString(), "Złe ustawienia",
							JOptionPane.ERROR_MESSAGE);
				}
			}
		});

		settings.add(rabbitLabel);
		settings.add(rabbitInput);
		settings.add(delayLabel);
		settings.add(delayInput);
		settings.add(widthLabel);
		settings.add(widthInput);
		settings.add(heightLabel);
		settings.add(heightInput);
		settings.add(startButton);
		mainPanel.add(settings, BorderLayout.NORTH);

		frame.setContentPane(mainPanel);
		frame.setSize(700, 700);
		frame.setVisible(true);

		frame.addWindowListener(new WindowAdapter() {
			@Override
			public void windowClosing(WindowEvent e) {
				frame.dispose();
				simulation.stop();
			}
		});
	}
}
