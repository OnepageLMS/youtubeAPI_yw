package com.mycom.myapp.youtube;

import java.util.List;

public interface youtubeProvider {
	public List<youtubeVO> fetchVideosByQuery(String keyword, String accessToken);
}
