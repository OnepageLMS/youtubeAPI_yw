package com.mycom.myapp.youtube;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class YoutubeService implements youtubeProvider{
	@Autowired
	YoutubeDAO youtubeDAO;
	
	@Override
	public List<youtubeVO> fetchVideosByQuery(String keyword, String accessToken){
		return youtubeDAO.fetchVideosByQuery(keyword, accessToken);
	}
}
