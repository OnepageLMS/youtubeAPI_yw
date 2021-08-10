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
	
	//video 수정/재생page 이동
	@RequestMapping(value = "/watch/{playlistID}/{videoID}", method = RequestMethod.GET) 
	public String getSelectedPlaylistVideos(@PathVariable("playlistID") int playlistID, @PathVariable("videoID") int videoID, Model model) {
		model.addAttribute("videoID", videoID);
		model.addAttribute("videoList", playlistID);
		
		return "selectedPlaylist";
	}
	
	//재생 및 수정할 video가져오기
	@RequestMapping(value = "/getVideo", method = RequestMethod.POST) 
	@ResponseBody
	public VideoVO Video(@RequestParam(value = "id") String id) {
		VideoVO vo = videoService.getVideo(Integer.parseInt(id));
		
		return vo;
	}

	//선택한 playlist에 속한 video list 가져오기
	@RequestMapping(value = "/getOnePlaylistVideos", method = RequestMethod.POST) //homecontroller에 있는것. 
	@ResponseBody
	public Object getOnePlaylist(@RequestParam(value = "id") String playlistID) {
		List<VideoVO> videos = new ArrayList<VideoVO>();
		videos = videoService.getVideoList(Integer.parseInt(playlistID)); //playlist의 모든 video 가져오기
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("allVideo", videos);
		
		return map;
	}


}
