package com.mycom.myapp.playlist;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


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
	
//	@RequestMapping(value = "/getAllMyPlaylist", method = RequestMethod.POST) 
//	@ResponseBody
//	public Object getAllPlaylist(@RequestParam(value = "email") String creatorEmail) {
//		List<PlaylistVO> playlists = new ArrayList<PlaylistVO>();
//		playlists = playlistService.getAllMyPlaylist(creatorEmail); //playlist의 모든 video 가져오기
//		
//		Map<String, Object> map = new HashMap<String, Object>();
//		map.put("allPlaylist", playlists);
//		
//		return map;
//	}
	
	@RequestMapping(value= "/addPlaylistPopup/{creatorEmail}", method= RequestMethod.GET)
	public String popup(@PathVariable("creatorEmail") String creatorEmail, Model model) {
		model.addAttribute("email", creatorEmail);
		return "addPlaylistPopup";
	}
	
	@RequestMapping(value = "/addPlaylist", method = RequestMethod.POST)
	@ResponseBody
	public void addPlaylist(HttpServletRequest request) {
		
		PlaylistVO vo = new PlaylistVO();
		vo.setCreatorEmail(request.getParameter("creator"));
		vo.setPlaylistName(request.getParameter("name"));
		vo.setSeq(playlistService.getCount()); //새로운 playlist의 seq가 될 숫자 구하기

		if(playlistService.addPlaylist(vo) != 0) 
			System.out.println("playlist 추가 성공! ");
		else
			System.out.println("playlist 추가 실패! ");
	}
	
	@RequestMapping(value = "/getAllPlaylist", method = RequestMethod.POST)
	@ResponseBody
	public Object getAllPlaylist() {
		List<PlaylistVO> playlists = new ArrayList<PlaylistVO>();
		playlists = playlistService.getAllPlaylist();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("allPlaylist", playlists);
		map.put("code", "ok");
		
		return map;
	}
	
	@RequestMapping(value = "/getAllMyPlaylist", method = RequestMethod.POST) 
	@ResponseBody
	public Object getAllPlaylist(@RequestParam(value = "email") String creatorEmail) {
		List<PlaylistVO> playlists = new ArrayList<PlaylistVO>();
		playlists = playlistService.getAllMyPlaylist(creatorEmail); //playlist의 모든 video 가져오기
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("allMyPlaylist", playlists);
		
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
	
	@RequestMapping(value = "/player", method = RequestMethod.POST)
	public String player(Model model,
			@RequestParam(required = false) String playerId,
			@RequestParam(required = false) String playerTitle,
			@RequestParam(required = false) String playerDuration,
			@RequestParam(required = false) String keyword) throws Exception{
		
		System.out.println(playerId);
		
		model.addAttribute("id", playerId);
		model.addAttribute("title", playerTitle);
		model.addAttribute("duration", playerDuration);
		
		return "player";
	}
	
	// (jw) 2021/08/16 : 일단 access Token 을 사용해야하니 이건 여기에 냅두고 그 이후에는 Controller 에서 처리하도록 
	@RequestMapping(value = "/searchLms", method = RequestMethod.GET)
	public String searchLms(Model model, String keyword) {													
		return "search";
	}

}

