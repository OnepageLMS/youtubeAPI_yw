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

import com.mycom.myapp.classContent.ClassContentsService;
import com.mycom.myapp.classContent.ClassContentsVO;
import com.mycom.myapp.classes.ClassesService;
import com.mycom.myapp.playlist.PlaylistService;
import com.mycom.myapp.playlist.PlaylistVO;
import com.mycom.myapp.video.VideoService;
import com.mycom.myapp.video.VideoVO;

import net.sf.json.JSONArray;

@Controller
@RequestMapping(value="/class")
public class ContentsController {
	
	@Autowired
	private ClassesService classService;
	@Autowired
	private ClassContentsService classContentsService;
	@Autowired
	private PlaylistService playlistService;
	@Autowired
	private VideoService videoService;
	
	@RequestMapping(value = "/contentList/{classID}", method = RequestMethod.GET)
	public String contentList(@PathVariable("classID") int classID, Model model) {
		classID = 1;//임의로 1번 class 설정

		model.addAttribute("classInfo", classService.getClass(classID)); 
		model.addAttribute("allContents", JSONArray.fromObject(classContentsService.getAllClassContents(classID)));
		return "contentsList";
	}
	
	@RequestMapping(value = "/contentDetail/{id}", method = RequestMethod.GET)
	public String contentDetail(@PathVariable("id") int id, Model model) {
		ClassContentsVO vo = classContentsService.getOneContent(id);
		model.addAttribute("vo", vo);
		return "contentDetail";
	}
	
	
	@RequestMapping(value = "/addContent/{classID}/{week}/{day}", method = RequestMethod.GET)
	public String addContent(@PathVariable("classID") int classID, @PathVariable("week") int week, 
			@PathVariable("day") int day, Model model) {
		
		ClassContentsVO vo = new ClassContentsVO();
		vo.setClassID(classID);
		vo.setWeek(week);
		vo.setDay(day);
		model.addAttribute("content", vo);
		
		return "addContent";
	}
	
	@RequestMapping(value = "/myPlaylist/{creatorEmail}", method = RequestMethod.GET)
	public String selectPlaylist(@PathVariable("creatorEmail") String creatorEmail, Model model) {
		model.addAttribute("playlist", playlistService.getAllMyPlaylist(creatorEmail));
		return "myPlaylist";
	}
	
	@RequestMapping(value = "/getOnePlaylistVideos", method = RequestMethod.POST) //homecontroller에 있는것. 
	@ResponseBody
	public Object getOnePlaylist(@RequestParam(value = "id") String id) {
		List<VideoVO> videos = new ArrayList<VideoVO>();
		videos = videoService.getVideoList(Integer.parseInt(id)); //playlist의 모든 video 가져오기
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("allVideo", videos);
		
		return map;
	}
	
	@RequestMapping(value = "/getPlaylistInfo", method = RequestMethod.POST)
	@ResponseBody
	public PlaylistVO getPlaylistInfo(@RequestParam(value = "playlistID") String playlistID) {
		PlaylistVO vo = playlistService.getPlaylist(Integer.parseInt(playlistID));
		
		return vo;
	}
	
	@RequestMapping(value = "/updatePlaylistName", method = RequestMethod.POST)
	@ResponseBody
	public String updatePlaylistName(@RequestParam(value = "playlistID") String playlistID, 
												@RequestParam(value = "name") String name) {
		PlaylistVO vo = new PlaylistVO();
		vo.setPlaylistID(Integer.parseInt(playlistID));
		vo.setPlaylistName(name);
		
		if (playlistService.updatePlaylistName(vo) == 0)
			System.out.println("description 수정 실패!");
		else
			System.out.println("description 수정 성공!");
		
		return name;
	}
	
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
	
	@RequestMapping(value = "/addContentOK", method = RequestMethod.POST)
	public String addContentOK(ClassContentsVO vo) {
		int classID = vo.getClassID();
		vo.setDaySeq(classContentsService.getDaySeq(vo));
		
		if (classContentsService.insertContent(vo) == 0)
			System.out.println("classContents 추가 실패!");
		else
			System.out.println("classContents 추가 성공!");
		
		return "redirect:contentList/" + classID;
	}
	
	@RequestMapping(value = "/editContent/{id}", method = RequestMethod.GET)
	public String editContent(@PathVariable("id") int id, Model model) {
		ClassContentsVO vo = classContentsService.getOneContent(id);
		model.addAttribute("vo", vo);
		return "editContent";
	}
	
	@RequestMapping(value = "/editContentOK", method = RequestMethod.POST)
	public String editContentOK(ClassContentsVO vo) {
		int classID = vo.getClassID();
		
		if (classContentsService.updateContent(vo) == 0)
			System.out.println("classContents 수정 실패!");
		else
			System.out.println("classContents 수정 성공!");
		
		return "redirect:contentList/" + classID;
	}
	
	@RequestMapping(value = "/deleteContent/{classID}/{id}", method = RequestMethod.GET)
	public String deleteContent(@PathVariable("classID") int classID, @PathVariable("id") int id) {
		if (classContentsService.deleteContent(id) == 0)
			System.out.println("classContents 삭제 실패!");
		else
			System.out.println("classContents 삭제 성공!");
		
		return "redirect:../../contentList/" + classID;
	}

}
