package com.mycom.myapp;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mycom.myapp.playlist.PlaylistService;
import com.mycom.myapp.video.VideoService;
import com.mycom.myapp.video.VideoVO;

import net.sf.json.JSONArray;

@Controller
@RequestMapping(value="/video")
public class VideoController {
	@Autowired
	private VideoService videoService;
	@Autowired
	private PlaylistService playlistService;
	
	//video 수정/재생page 이동
	@RequestMapping(value = "/watch/{playlistID}/{videoID}", method = RequestMethod.GET) 
	public String getSelectedPlaylistVideos(@PathVariable("playlistID") int playlistID, @PathVariable("videoID") int videoID, Model model) {
		model.addAttribute("videoID", videoID);
		model.addAttribute("playlistID", playlistID);
		
		return "selectedPlaylist";
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
	
	@RequestMapping(value = "/updateVideo", method = RequestMethod.POST) 
	@ResponseBody
	public String updateVideo(@ModelAttribute VideoVO videoVo) {
		if(videoService.updateVideo(videoVo) != 0) {
			System.out.println("video 수정 성공!");
			
			int playlistID = videoVo.getPlaylistID();
			updateTotalLength(playlistID);
		}
		else
			System.out.println("video 수정 실패!");
		return "";
	}
	
	@RequestMapping(value = "/deleteVideo", method = RequestMethod.POST)
	@ResponseBody
	public String deleteVideo(HttpServletRequest request) {
		int videoID = Integer.parseInt(request.getParameter("videoID"));
		int playlistID = Integer.parseInt(request.getParameter("playlistID"));
		
		if( videoService.deleteVideo(videoID) != 0) {
			System.out.println("controller video 삭제 성공! "); 
			updateTotalVideo(playlistID); //totalVideo 업데이트 
			updateTotalLength(playlistID); //totalVideoLength 업데이트
		}
		else
			System.out.println("controller video 삭제 실패! ");
		
		return "ok";
	}
	
	@RequestMapping(value = "/changeVideosOrder", method = RequestMethod.POST) //video 순서 변경될때
	@ResponseBody
	public String changeVideosOrder(@RequestParam(value = "changedList[]") List<String> changedList) {
		int size = changedList.size()-1;
		
		for(String order : changedList) {
			VideoVO vo = new VideoVO();
			vo.setId(Integer.parseInt(order));
			vo.setSeq(size);
			
			if (videoService.changeSeq(vo) != 0)
				size-=1;
		}

		if (size == -1)
			System.out.println("video 순서 변경 성공! ");
		else
			System.out.println("video 순서 변경 실패! ");
		return "ok";
	}
	
	public void updateTotalVideo (int playlistID) {
		if (playlistService.updateCount(playlistID) != 0)
			System.out.println(playlistID + " : totalVideo업데이트 성공! ");
		else
			System.out.println("totalVideo 업데이트 실패! ");
		
	}
	
	public void updateTotalLength (int playlistID) {
		if (playlistService.updateTotalVideoLength(playlistID) != 0)  //이거 진우오빠에서 이 함수 이렇게 바꿔야함... 
			System.out.println(playlistID + " : totalVideoLength 업데이트 성공! ");
		else
			System.out.println("totalVideoLength 업데이트 실패! ");
		
	}


}
