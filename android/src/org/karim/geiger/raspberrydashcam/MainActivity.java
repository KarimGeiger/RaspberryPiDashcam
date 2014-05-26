package org.karim.geiger.raspberrydashcam;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class MainActivity extends Activity {

	private final String secret = "secret";

	private final String url = "http://example.com";

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		Button btnSave = (Button) findViewById(R.id.btnSave);

		btnSave.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				saveVideo();
			}
		});
	}

	public void saveVideo() {
		new FetchTask(url + "/?secret=" + secret + "&set=save", this).execute();
	}
}
