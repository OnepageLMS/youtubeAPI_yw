package com.mycom.myapp.youtube;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Repository;

import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import com.google.api.client.util.DateTime;
import com.google.api.services.youtube.YouTube;
import com.google.api.services.youtube.model.SearchListResponse;
import com.google.api.services.youtube.model.SearchResult;

@Repository
public class YoutubeDAO {
	
	private static final long MAX_SEARCH_RESULTS = 10;
	
	public List<youtubeVO> fetchVideosByQuery(String keyword) {
		List<youtubeVO> videos = new ArrayList<youtubeVO>();

		try {
			// instantiate youtube object
			YouTube youtube = getYouTube();

			// define what info we want to get
			YouTube.Search.List search = youtube.search().list("id,snippet");

			// set our credentials
			String apiKey = "AIzaSyCnS1z2Dk27-yex5Kbrs5XjF_DkRDhfM-c"; //entered personal API key
			search.setKey(apiKey);

			// set the search term
			search.setQ(keyword);

			// we only want video results
			search.setType("video");

			// set the fields that we're going to use
			search.setFields(
					"items(id/kind,id/videoId,snippet/title,snippet/description,snippet/publishedAt,snippet/thumbnails/default/url)");

			// set the max results
			search.setMaxResults(MAX_SEARCH_RESULTS);

			DateFormat df = new SimpleDateFormat("MMM dd, yyyy");

			// perform the search and parse the results
			SearchListResponse searchResponse = search.execute();
			List<SearchResult> searchResultList = searchResponse.getItems();
			if (searchResultList != null) {
				for (SearchResult result : searchResultList) {
					youtubeVO video = new youtubeVO();
					video.setTitle(result.getSnippet().getTitle());
					video.setUrl(buildVideoUrl(result.getId().getVideoId()));
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
		} catch (Exception e) {
			e.printStackTrace();
		}

		return videos;
	}

	/**
	 * Constructs the URL to play the YouTube video
	 */
	private String buildVideoUrl(String videoId) {
		StringBuilder builder = new StringBuilder();
		builder.append("https://www.youtube.com/watch?v=");
		builder.append(videoId);

		return builder.toString();
	}

	/**
	 * Instantiates the YouTube object
	 */
	private YouTube getYouTube() {
		YouTube youtube = new YouTube.Builder(new NetHttpTransport(), new GsonFactory(), (reqeust) -> {
		}).setApplicationName("youtube-search").build(); //google API발급받을 때 등록한 application 이름! 

		return youtube;
	}

}
