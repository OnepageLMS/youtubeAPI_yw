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

import com.mycom.myapp.playlist.PlaylistService;
import com.mycom.myapp.playlist.PlaylistVO;
import com.mycom.myapp.video.VideoVO;

@Controller
@RequestMapping(value="/playlist")
public class PlaylistController {
	@Autowired
	private PlaylistService playlistService;
	
	//myplaylist(내 playlist) 새창 띄우기
	@RequestMapping(value = "/myPlaylist/{creatorEmail}", method = RequestMethod.GET) 
	public String selectPlaylist(@PathVariable("creatorEmail") String creatorEmail, Model model) {
		model.addAttribute("email", creatorEmail);
		return "myPlaylist";
	}
	
	@RequestMapping(value = "/getAllMyPlaylist", method = RequestMethod.POST) 
	@ResponseBody
	public Object getAllPlaylist(@RequestParam(value = "email") String creatorEmail) {
		List<PlaylistVO> playlists = new ArrayList<PlaylistVO>();
		playlists = playlistService.getAllMyPlaylist(creatorEmail); //playlist의 모든 video 가져오기
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("allPlaylist", playlists);
		
		return map;
	}
	
	
	//선택한 playlist의 자세한정보 가져오기
	@RequestMapping(value = "/getPlaylistInfo", method = RequestMethod.POST)
	@ResponseBody
	public PlaylistVO getPlaylistInfo(@RequestParam(value = "playlistID") String playlistID) {
		PlaylistVO vo = playlistService.getPlaylist(Integer.parseInt(playlistID));
		
		return vo;
	}
	
	//playlist 이름수정
	@RequestMapping(value = "/updatePlaylistName", method = RequestMethod.POST)
	@ResponseBody
	public String updatePlaylistName(@RequestParam(value = "playlistID") String playlistID, 
												@RequestParam(value = "name") String name) {
		PlaylistVO vo = new PlaylistVO();
		vo.setPlaylistID(Integer.parseInt(playlistID));
		vo.setPlaylistName(name);
		
		if (playlistService.updatePlaylistName(vo) == 0)
			System.out.println("playlistname 수정 실패!");
		else
			System.out.println("playlistname 수정 성공!");
		
		return name;
	}
	
	//playlist 설명 수정
	@RequestMapping(value = "/updatePlaylistDesciption", method = RequestMethod.POST)
	@ResponseBody
	public String updatePlaylistDesciption(@RequestParam(value = "playlistID") String playlistID, 
												@RequestParam(value = "description") String description) {
		PlaylistVO vo = new PlaylistVO();
		vo.setPlaylistID(Integer.parseInt(playlistID));
		vo.setDescription(description);
		
		if (playlistService.updateDescription(vo) == 0)
			System.out.println("description 수정 실패!");
		else
			System.out.println("description 수정 성공!");
		
		return description;
	}
}
