package com.mycom.myapp;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.annotation.JsonInclude.Include;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.mycom.myapp.playlist.PlaylistService;
import com.mycom.myapp.video.VideoService;
import com.mycom.myapp.youtube.GoogleOAuthRequest;
import com.mycom.myapp.youtube.GoogleOAuthResponse;
import com.mycom.myapp.youtube.youtubeProvider;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {

	final static String GOOGLE_AUTH_BASE_URL = "https://accounts.google.com/o/oauth2/v2/auth";
	final static String GOOGLE_TOKEN_BASE_URL = "https://accounts.google.com/o/oauth2/token"; //https://oauth2.googleapis.com/token
	final static String GOOGLE_REVOKE_TOKEN_BASE_URL = "https://oauth2.googleapis.com/revoke";
	static String accessToken = "";
	static String refreshToken = "";

	@Autowired
	private youtubeProvider service;
	@Autowired
	PlaylistService playlistService;
	@Autowired
	VideoService videoService;
	

	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home() {

		return "home";
	}

	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String google(RedirectAttributes rttr) {
		String clientID = "99431484339-5lvpv4ieg4gd75l57g0k4inh10tiqkdj.apps.googleusercontent.com";
		String url = "redirect:https://accounts.google.com/o/oauth2/v2/auth?client_id=" + clientID + "&redirect_uri=http://localhost:8080/myapp/oauth2callback"
				+"&response_type=code"
				+"&scope=email%20profile%20openid"+"%20https://www.googleapis.com/auth/youtube%20https://www.googleapis.com/auth/youtube.readonly"
				+"&access_type=offline";

		return url;
	}

	@RequestMapping(value = "/oauth2callback", method = RequestMethod.GET)
	public String googleAuth(Model model, @RequestParam(value = "code") String authCode, HttpServletRequest request,
			HttpSession session, RedirectAttributes redirectAttributes) throws Exception {

		// HTTP Request??? ?????? RestTemplate
		RestTemplate restTemplate = new RestTemplate();

		// Google OAuth Access Token ????????? ?????? ???????????? ??????
		GoogleOAuthRequest googleOAuthRequestParam = new GoogleOAuthRequest();
		googleOAuthRequestParam.setClientId("99431484339-5lvpv4ieg4gd75l57g0k4inh10tiqkdj.apps.googleusercontent.com");
		googleOAuthRequestParam.setClientSecret("NwHS9eyyrYE5LYVy7c0CDIkv");
		googleOAuthRequestParam.setCode(authCode); // access token??? ????????? ??? ?????? ?????? ?????? ??????
		googleOAuthRequestParam.setRedirectUri("http://localhost:8080/myapp/oauth2callback");
		googleOAuthRequestParam.setGrantType("authorization_code");

		// JSON ????????? ?????? ????????? ??????
		// ????????? ??????????????? ???????????? ???????????? ??????????????? Object mapper??? ?????? ???????????????.
		ObjectMapper mapper = new ObjectMapper();
		mapper.setPropertyNamingStrategy(PropertyNamingStrategy.SNAKE_CASE);
		mapper.setSerializationInclusion(Include.NON_NULL);

		// AccessToken ?????? ??????
		ResponseEntity<String> resultEntity = restTemplate.postForEntity(GOOGLE_TOKEN_BASE_URL, googleOAuthRequestParam,
				String.class);

		// Token Request
		GoogleOAuthResponse result = mapper.readValue(resultEntity.getBody(), new TypeReference<GoogleOAuthResponse>() {
		});

		accessToken = result.getAccessToken(); // accesss token ??????
		refreshToken = result.getRefreshToken(); //????????? ????????? ?????? DB??? ???????????? ?????? 

		return "redirect:/main";
	}
	
	@RequestMapping(value = "/main", method = RequestMethod.GET)
	public String main(Model model, String keyword) {
		//String order = "relevance";
		//String maxResults = "50";
		//String requestURL = "https://www.googleapis.com/youtube/v3/search?part=snippet&order=" + order + "&q="+ keyword;
		
		model.addAttribute("accessToken", accessToken);
		
		// String requestURL =
		// "https://www.googleapis.com/youtube/v3/search?access_token="+accessToken+"&part=snippet&q="+keyword+"&type=video";

		//List<youtubeVO> videos = service.fetchVideosByQuery(keyword, accessToken); // keyword, google OAuth2
		//model.addAttribute("videos", videos);																

		return "main";
	}
	
	// (jw) 2021/08/16 : ?????? access Token ??? ?????????????????? ?????? ????????? ????????? ??? ???????????? PlaylistController ?????? ??????????????? 
	@RequestMapping(value = "/youtube", method = RequestMethod.GET)
	public String youtube(Model model, String keyword) {
		model.addAttribute("accessToken", accessToken);														
		return "youtube";
	}
	
	
	
//	@RequestMapping(value = "/deletePlaylist", method = RequestMethod.POST)
//	@ResponseBody
//	public void deletePlaylist(HttpServletRequest request) {
//		int playlistID = Integer.parseInt(request.getParameter("id"));
//		
//		if( playlistService.deletePlaylist(playlistID) != 0) {
//			System.out.println("playlist ?????? ??????! ");
//			//playlist ?????? video?????? ??????? 
//		}
//		else
//			System.out.println("playlist ?????? ??????! ");
//	}
	
//	@RequestMapping(value = "/getAllMyPlaylist", method = RequestMethod.POST) 
//	@ResponseBody
//	public Object getAllPlaylist(@RequestParam(value = "email") String creatorEmail) {
//		List<PlaylistVO> playlists = new ArrayList<PlaylistVO>();
//		playlists = playlistService.getAllMyPlaylist(creatorEmail); //playlist??? ?????? video ????????????
//		
//		Map<String, Object> map = new HashMap<String, Object>();
//		map.put("allPlaylist", playlists);
//		
//		return map;
//	}
//	@RequestMapping(value = "/getAllPlaylist", method = RequestMethod.POST)
//	@ResponseBody
//	public Object getAllPlaylist() {
//		List<PlaylistVO> playlists = new ArrayList<PlaylistVO>();
//		playlists = playlistService.getAllPlaylist();
//		
//		Map<String, Object> map = new HashMap<String, Object>();
//		map.put("allPlaylist", playlists);
//		map.put("code", "ok");
//		
//		return map;
//	}
	
//	@RequestMapping(value = "/changePlaylistOrder", method = RequestMethod.POST) //playlist ?????? ????????????
//	@ResponseBody
//	public String changeItemsOrder(@RequestParam(value = "changedList[]") List<String> changedList) {
//		int size = changedList.size()-1;
//		
//		for(String order : changedList) {
//			PlaylistVO vo = new PlaylistVO();
//			vo.setPlaylistID(Integer.parseInt(order));
//			vo.setSeq(size);
//			
//			if (playlistService.changeSeq(vo) != 0)
//				size-=1;
//		}
//
//		if (size == -1)
//			System.out.println("playlist ?????? ?????? ??????! ");
//		else
//			System.out.println("playlist ?????? ?????? ??????! ");
//		return "ok";
//	}
	
//	@RequestMapping(value = "/updateVideo", method = RequestMethod.POST)
//	@ResponseBody
//	public String updateVideo(@ModelAttribute VideoVO vo){
//		if(videoService.updateVideo(vo) != 0)
//			System.out.println("controller update video ??????! "); 
//		else
//			System.out.println("controller update video ??????! "); 
//		
//		return "home";
//	}
//	
//	@RequestMapping(value = "/deleteVideo", method = RequestMethod.POST)
//	@ResponseBody
//	public String deleteVideo(HttpServletRequest request) {
//		int videoID = Integer.parseInt(request.getParameter("video"));
//		int playlistID = Integer.parseInt(request.getParameter("playlist"));
//		
//		if( videoService.deleteVideo(videoID) != 0) {
//			System.out.println("controller video ?????? ??????! "); 
//			
//			if (playlistService.updateCount(playlistID) != 0)
//				System.out.println("playlist totalVideo ???????????? ??????! ");
//			else
//				System.out.println("playlist totalVideo ???????????? ??????! ");
//		}
//		else
//			System.out.println("controller video ?????? ??????! ");
//		
//		return "home";
//	}
//	
//	@RequestMapping(value = "/changeVideosOrder", method = RequestMethod.POST) //video ?????? ????????????
//	@ResponseBody
//	public String changeVideosOrder(@RequestParam(value = "changedList[]") List<String> changedList) {
//		int size = changedList.size()-1;
//		
//		for(String order : changedList) {
//			VideoVO vo = new VideoVO();
//			vo.setId(Integer.parseInt(order));
//			vo.setSeq(size);
//			
//			if (videoService.changeSeq(vo) != 0)
//				size-=1;
//		}
//
//		if (size == -1)
//			System.out.println("video ?????? ?????? ??????! ");
//		else
//			System.out.println("video ?????? ?????? ??????! ");
//		return "ok";
//	}
	
	
	
	
}
