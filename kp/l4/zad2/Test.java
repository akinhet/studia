import javafx.application.Application;
import javafx.event.*;
import javafx.geometry.*;
import javafx.scene.control.*;
import javafx.scene.layout.*;
import javafx.scene.text.*;
import javafx.scene.Scene;
import javafx.stage.Stage;
import java.util.List;
import java.util.ArrayList;

public class Test extends Application {

    static String generateOutput(int n) {
		List<String> output = new ArrayList<String>();

		try {
			for (int i = 0; i <= n; i++) {
				output.add(new String(""));
				WierszTrojkataPascala wiersz = new WierszTrojkataPascala(i);
				wiersz.GenerateRow();
				for (int j = 0; j <= i; j++) {
					output.set(i, output.get(i) + wiersz.GetElement(j) + " ");
				}
			}
		} catch (IntegerOutOfBounds e) {
			return "Invalid input";
		}

		String ret = "";

		for (int i = 0; i <= n; i++) {
			int diff = (output.get(n).length() - output.get(i).length()) / 2;
			ret += " ".repeat(diff) + output.get(i) + "\n";
		}

		return ret;
    }

    @Override
    public void start(Stage stage) {
        GridPane grid = new GridPane();
        grid.setHgap(10);
        grid.setVgap(10);
		grid.setPadding(new Insets(10));

        Scene scene = new Scene(grid);
        stage.setTitle("Trójkąt Pascala");
        stage.setScene(scene);
		scene.getStylesheets().add(getClass().getResource("style.css").toExternalForm());

        ColumnConstraints col1 = new ColumnConstraints();
        col1.setHgrow(Priority.ALWAYS);
        ColumnConstraints col2 = new ColumnConstraints();
        col2.setHgrow(Priority.ALWAYS);
        ColumnConstraints col3 = new ColumnConstraints();
        col3.setHgrow(Priority.ALWAYS);
        ColumnConstraints col4 = new ColumnConstraints();
        col4.setHgrow(Priority.NEVER);
        grid.getColumnConstraints().addAll(col1, col2, col3, col4);

		RowConstraints row1 = new RowConstraints();
		row1.setVgrow(Priority.NEVER);
		RowConstraints row2 = new RowConstraints();
		row2.setVgrow(Priority.ALWAYS);
		grid.getRowConstraints().addAll(row1, row2);

		Slider slider = new Slider(0,50,10);
        Label sliderLabel = new Label("Value: " + (int) slider.getValue());
		sliderLabel.setFont(new Font(12));
        Button button = new Button("Generate");
		button.setFont(new Font(12));
        Button darkmode = new Button("Dark");
		darkmode.setFont(new Font(12));

        TextArea result = new TextArea();
        result.setEditable(false);
		result.setFont(Font.font("Monospaced", FontWeight.NORMAL, 12));

        slider.valueProperty().addListener((observable, oldValue, newValue) -> {
            sliderLabel.setText("Value: " + newValue.intValue());
        });

        button.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
                result.setText(generateOutput((int) slider.getValue()));
            }
        });

        darkmode.setOnAction(new EventHandler<ActionEvent>() {
			static boolean dark = false;

            @Override
            public void handle(ActionEvent event) {
				if (dark) {
					scene.getStylesheets().clear();
					scene.getStylesheets().add(getClass().getResource("style.css").toExternalForm());
					dark = false;
				} else {
					scene.getStylesheets().clear();
					scene.getStylesheets().add(getClass().getResource("style-dark.css").toExternalForm());
					dark = true;
				}
            }
        });

        grid.add(slider, 0, 0, 2, 1);
        grid.add(sliderLabel, 2, 0);
        grid.add(button, 3, 0);
        grid.add(darkmode, 4, 0);
        grid.add(result, 0, 1, 5, 1);

		grid.setPrefSize(700,700);
		stage.setMinHeight(300);
		stage.setMinWidth(300);
        stage.show();
    }

    public static void main(String[] args) {
        launch(args);
    }
}
