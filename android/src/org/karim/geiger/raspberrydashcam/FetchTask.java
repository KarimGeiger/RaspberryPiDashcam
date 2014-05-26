package org.karim.geiger.raspberrydashcam;

import java.io.BufferedReader;
import java.io.InputStreamReader;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.AsyncTask;

public class FetchTask extends AsyncTask<Void, Void, String> {

	String url;
	Activity activity;

	public FetchTask(String url, Activity activity) {
		this.url = url;
		this.activity = activity;
	}

	@Override
	protected String doInBackground(Void... params) {
		try {
			HttpClient httpclient = new DefaultHttpClient();
			HttpGet httpget = new HttpGet(this.url);

			// Execute HTTP Get Request
			HttpResponse response = httpclient.execute(httpget);

			BufferedReader reader = new BufferedReader(new InputStreamReader(response.getEntity().getContent(), "iso-8859-1"), 8);
			StringBuilder sb = new StringBuilder();
			sb.append(reader.readLine() + "\n");
			String line = "0";
			while ((line = reader.readLine()) != null) {
				sb.append(line + "\n");
			}
			reader.close();
			String result = sb.toString();

			return result;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	@Override
	protected void onPostExecute(String result) {
		String title;
		String message;

		if (result != null) {
			title = "Triggered successfully.";
			message = "Your video will be saved.";
		} else {
			title = "An error occured.";
			message = "Please try again later.";
		}
		new AlertDialog.Builder(this.activity).setTitle(title).setMessage(message)
				.setPositiveButton(android.R.string.yes, new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {

					}
				}).show();
	}
}