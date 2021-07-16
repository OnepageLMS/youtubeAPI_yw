package com.mycom.myapp.youtube;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;

import org.springframework.stereotype.Repository;

import com.google.api.client.http.HttpRequest;
import com.google.api.client.http.HttpRequestInitializer;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.client.json.gson.GsonFactory;
import com.google.api.client.util.DateTime;
import com.google.api.services.youtube.YouTube;
import com.google.api.services.youtube.model.ResourceId;
import com.google.api.services.youtube.model.SearchListResponse;
import com.google.api.services.youtube.model.SearchResult;
import com.google.api.services.youtube.model.Thumbnail;
import com.google.api.client.googleapis.json.GoogleJsonResponseException;

@Repository
public class YoutubeDAO {

	/**
	 * Global instance of the max number of videos we want returned (50 = upper
	 * limit per page).
	 */
	private static final long NUMBER_OF_VIDEOS_RETURNED = 25;
	private static final HttpTransport HTTP_TRANSPORT = new NetHttpTransport();
	private static final JsonFactory JSON_FACTORY = new JacksonFactory(); //GsonFactory
	
	//https://www.googleapis.com/youtube/v3/search?key=내KEY값 'GET' ?access_token=oauth2-token

	public List<youtubeVO> fetchVideosByQuery(String keyword, String accessToken) {

		/*
		 apikey를 root-context bean에 저장하기! 
		 Properties properties = new Properties();
		 * try { InputStream in = YoutubeDAO.class.getResourceAsStream("");
		 * properties.load(in);
		 * 
		 * } catch (IOException e) {
		 * System.err.println("There was an error reading root-context : " +
		 * e.getCause() + " : " + e.getMessage()); System.exit(1); }
		 */
		
		//String reuqestHTTP = "https://www.googleapis.com/youtube/v3/search?access_token=" + accessToken; 
		
		List<youtubeVO> videos = new ArrayList<youtubeVO>();
		try {
			YouTube youtube = new YouTube.Builder(HTTP_TRANSPORT, JSON_FACTORY, new HttpRequestInitializer() { //error 발생 구간 
		          public void initialize(HttpRequest request) throws IOException {
		          }
		          
		        }).setApplicationName("youtube-search").build();
			
			/*YouTube youtube = new YouTube.Builder(HTTP_TRANSPORT, JSON_FACTORY, (new HttpRequestInitializer() {
		        public void initialize(HttpRequest request) throws IOException {}
		      })).setApplicationName("youtube-search").build();*/

			// define what info we want to get
			YouTube.Search.List search = youtube.search().list("id,snippet");

			// set our credentials
			// String apiKey = properties.getProperty("youtube.apikey");
			String apiKey = "AIzaSyCnS1z2Dk27-yex5Kbrs5XjF_DkRDhfM-c"; // entered personal API key
			search.setKey(apiKey);
			search.setQ(keyword);

			// we only want video results
			search.setType("video"); // video or playlist or channel

			// set the fields that we're going to use
			search.setFields(
					"items(id/kind,id/videoId,snippet/title,snippet/description,snippet/publishedAt,snippet/thumbnails/default/url)");

			// set the max results
			search.setMaxResults(NUMBER_OF_VIDEOS_RETURNED);

			DateFormat df = new SimpleDateFormat("MMM dd, yyyy");

			// perform the search and parse the results
			SearchListResponse searchResponse = search.execute();

			List<SearchResult> searchResultList = searchResponse.getItems();

			if (searchResultList != null) {
				prettyPrint(searchResultList.iterator(), keyword);

				for (SearchResult result : searchResultList) {
					youtubeVO video = new youtubeVO();
					video.setTitle(result.getSnippet().getTitle());
					video.setVideoID(result.getId().getVideoId());
					video.setThumbnailUrl(result.getSnippet().getThumbnails().getDefault().getUrl());
					video.setDescription(result.getSnippet().getDescription());

					// parse the date
					DateTime dateTime = result.getSnippet().getPublishedAt();
					Date date = new Date(dateTime.getValue());
					String dateString = df.format(date);
					video.setPublishDate(dateString);

					videos.add(video);
				}
			}

		} catch (GoogleJsonResponseException e) {
			System.err.println(
					"There was a service error: " + e.getDetails().getCode() + " : " + e.getDetails().getMessage());
		} catch (IOException e) {
			System.err.println("There was an IO error: " + e.getCause() + " : " + e.getMessage());
		} catch (Throwable t) {
			t.printStackTrace();
		}

		return videos;
	}

	/*
	 * Prints out all SearchResults in the Iterator. Each printed line includes
	 * title, id, and thumbnail.
	 *
	 * @param iteratorSearchResults Iterator of SearchResults to print
	 *
	 * @param query Search query (String)
	 */
	private static void prettyPrint(Iterator<SearchResult> iteratorSearchResults, String query) {

		System.out.println("\n=============================================================");
		System.out.println("   First " + NUMBER_OF_VIDEOS_RETURNED + " videos for search on \"" + query + "\".");
		System.out.println("=============================================================\n");

		if (!iteratorSearchResults.hasNext()) {
			System.out.println(" There aren't any results for your query.");
		}

		while (iteratorSearchResults.hasNext()) {

			SearchResult singleVideo = iteratorSearchResults.next();
			ResourceId rId = singleVideo.getId();

			// Double checks the kind is video.
			if (rId.getKind().equals("youtube#video")) {
				Thumbnail thumbnail = (Thumbnail) singleVideo.getSnippet().getThumbnails().get("default");

				System.out.println(" Video Id" + rId.getVideoId());
				System.out.println(" Title: " + singleVideo.getSnippet().getTitle());
				System.out.println(" Thumbnail: " + thumbnail.getUrl());
				System.out.println("\n-------------------------------------------------------------\n");
			}
		}
	}

}
