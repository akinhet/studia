import java.awt.*;
import java.awt.event.*;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.ArrayList;


public class Test {
	static String generateOutput(int n)
	{
		List<String> output = new ArrayList<String>();
		try {

			for (int i = 0; i <= n; i++) {
				String tmp = "";
				for (int j = 0; j <= i; j++) { 
					tmp += " " + j;
				}
				Process p = Runtime.getRuntime().exec("./main " + i + tmp);

				BufferedReader reader = new BufferedReader(new InputStreamReader(p.getInputStream(), StandardCharsets.UTF_8));
				String line;
				output.add(new String(""));

				while ((line = reader.readLine()) != null) {
					String[] parts = line.trim().split(" - ");
					if (parts.length == 2) {
						int num = Integer.parseInt(parts[1]);
						output.set(i, output.get(i) + parts[1] + " ");
					}
				}

			}

			String ret = "";

			for (int i = 0; i <= n; i++) {
				int diff = (output.get(n).length() - output.get(i).length()) / 2;
				ret += " ".repeat(diff) + output.get(i) + "\n";
			}

			return ret;

		} catch (IOException e) {
			return "Error occured";
		} catch (NumberFormatException e) {
			return "An internal error has occured";
		}
	}


    public static void main(String[] args)
    {
        Frame frame = new Frame("Trójkąt Pascala");
		Panel panel = new Panel();
		GridBagConstraints gbc = new GridBagConstraints();

		Scrollbar slider = new Scrollbar(Scrollbar.HORIZONTAL, 10, 1, 0, 50);
        Label sliderLabel = new Label("Value: 10");
		Button button = new Button("Generate");
		Button darkmode = new Button("Dark");
		TextArea result = new TextArea();

		slider.addAdjustmentListener(new AdjustmentListener() {
			public void adjustmentValueChanged(AdjustmentEvent e) {
				sliderLabel.setText("Value: " + slider.getValue());
			}
		});

		button.addActionListener(new ActionListener() {
			int clicks = 0;
			public void actionPerformed(ActionEvent e) {
				result.setText(generateOutput(slider.getValue()));
			}
		});

		darkmode.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				if (darkmode.getLabel() == "Dark") {
					darkmode.setLabel("Light");
					frame.setBackground(Color.BLACK);
					frame.setForeground(Color.GREEN);
					result.setBackground(Color.BLACK);
					result.setForeground(Color.GREEN);
					sliderLabel.setBackground(Color.BLACK);
					sliderLabel.setForeground(Color.GREEN);
					button.setBackground(Color.BLACK);
					button.setForeground(Color.GREEN);
					darkmode.setBackground(Color.BLACK);
					darkmode.setForeground(Color.GREEN);
					slider.setBackground(Color.BLACK);
					slider.setForeground(Color.GREEN);
				} else {
					darkmode.setLabel("Dark");
					frame.setBackground(Color.WHITE);
					frame.setForeground(Color.BLACK);
					result.setBackground(Color.WHITE);
					result.setForeground(Color.BLACK);
					sliderLabel.setBackground(Color.WHITE);
					sliderLabel.setForeground(Color.BLACK);
					button.setBackground(Color.WHITE);
					button.setForeground(Color.BLACK);
					darkmode.setBackground(Color.WHITE);
					darkmode.setForeground(Color.BLACK);
					slider.setBackground(Color.WHITE);
					slider.setForeground(Color.BLACK);
				}
			}
		});

		frame.setFont(new Font(Font.SANS_SERIF, Font.PLAIN, 12));
		frame.setLayout(new BorderLayout());
		panel.setLayout(new GridBagLayout());
		frame.setBackground(Color.WHITE);
		frame.setForeground(Color.BLACK);

		gbc.gridx = 0;
		gbc.gridy = 0;
		gbc.weightx = 0.5;
		gbc.weighty = 0;
		gbc.fill = GridBagConstraints.HORIZONTAL;
		gbc.anchor = GridBagConstraints.WEST;
		panel.add(slider, gbc);

		gbc.gridx = 1;
		gbc.gridy = 0;
		gbc.weightx = 0.15;
		gbc.fill = GridBagConstraints.HORIZONTAL;
		panel.add(sliderLabel, gbc);

		gbc.gridx = 2;
		gbc.gridy = 0;
		gbc.weightx = 0.25;
		gbc.fill = GridBagConstraints.HORIZONTAL;
		panel.add(button, gbc);

		gbc.gridx = 3;
		gbc.gridy = 0;
		gbc.weightx = 0.05;
		gbc.fill = GridBagConstraints.HORIZONTAL;
		panel.add(darkmode, gbc);

		gbc.gridx = 0;
		gbc.gridy = 1;
		gbc.gridwidth = 4;
		gbc.weightx = 1.0;
		gbc.weighty = 1.0;
		gbc.fill = GridBagConstraints.BOTH;
		gbc.anchor = GridBagConstraints.CENTER;
		result.setEditable(false);
		result.setFont(new Font(Font.MONOSPACED, Font.PLAIN, 10));
		result.setBackground(Color.WHITE);
		result.setForeground(Color.BLACK);
		panel.add(result, gbc);


		frame.add(panel, BorderLayout.CENTER);
        frame.setSize(700, 700);
        frame.setVisible(true);

        frame.addWindowListener(new WindowAdapter() {
            @Override
            public void windowClosing(WindowEvent e)
            {
				frame.dispose();
            }
        });
    }
}
