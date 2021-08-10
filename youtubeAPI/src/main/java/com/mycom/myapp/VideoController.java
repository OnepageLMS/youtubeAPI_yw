package com.mycom.myapp;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mycom.myapp.video.VideoService;
import com.mycom.myapp.video.VideoVO;

@Controller
@RequestMapping(value="/video")
public class VideoController {
	@Autowired
	private VideoService videoService;
	
	//선택한 playlist에 속한 video들 가져오기
	@RequestMapping(value = "/getOnePlaylistVideos", method = RequestMethod.POST) //homecontroller에 있는것. 
	@ResponseBody
	public Object getOnePlaylist(@RequestParam(value = "id") String playlistID) {
		List<VideoVO> videos = new ArrayList<VideoVO>();
		videos = videoService.getVideoList(Integer.parseInt(playlistID)); //playlist의 모든 video 가져오기
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("allVideo", videos);
		
		return map;
	}
	
	@RequestMapping(value = "/watch/{playlistID}/{videoID}", method = RequestMethod.GET)
	public String getSelectedPlaylistVideos(@PathVariable("playlistID") int playlistID, @PathVariable("videoID") int videoID, Model model) {
		model.addAttribute("video", videoService.getVideo(videoID));
		model.addAttribute("videoList", videoService.getVideoList(playlistID));
		
		return "selectedPlaylist";
	}
	
	

}
