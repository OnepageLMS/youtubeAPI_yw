<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>SelectedPlaylist</title>
<style>
	.displayVideo{
		display: inline;
		float: left;
		width: 70%;
	}
	#allVideo{
		display: inline;
		float: right;
		width: 30%;
	}
	.playlistName {
		margin: 0;
		padding-bottom: 10px;
		font-size: 25px;
	}
	
	.description {
		background-color: #DCDCDC;
		padding: 5px;
	}
	.totalInfo{
		display: inline;
		padding-right: 5%;
	}
	
	.videoPic {
		width: 120px;
		height: 70px;
		padding: 5px;
	}
	
	.videoNewTitle{
		font-size: 18px;
	}
	
	.videoOriTitle {
		font-size: 14px;
	}
	
	.tag {
		font-size: 13px;
		color: #0033CC;
	}
	
	.videoLine{
		border: 1px solid grey;
		width: 95%;
	}
	
</style>
</head>
<script 
  src="http://code.jquery.com/jquery-3.5.1.js"
  integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc="
  crossorigin="anonymous"></script>

<script>
	//youtube-API 공식 문서에서 iframe 사용방법으로 나온 변수.
	var videoId;
	var videoTitle;
	var videoDuration;
	
	// player api 사용 변수 
	var tag;
	var firstScriptTag;
	var player;
	
	var limit;
	var start_s;
	var end_s;
	var youtubeID;
	var videoTitle;
	
	$(document).ready(function(){ 
		getAllVideo(${playlistID}, ${videoID});
	});
	
	function getAllVideo(playlistID, defaultVideoID){ //해당 playlistID에 해당하는 비디오 list를 가져온다
		$.ajax({
			type : 'post',
		    url : '${pageContext.request.contextPath}/video/getOnePlaylistVideos',
		    data : {id : playlistID},
		    success : function(result){
			    videos = result.allVideo;
			    
			    $('#allVideo').empty();
			        
			    $.each(videos, function( index, value ){ 
			    	var newTitle = value.newTitle;
			    	var title = value.title;
			    	//if (title.length > 45
						//title = title.substring(0, 45) + " ..."; 
					
			    	if (newTitle == null || newTitle == ''){
			    		newTitle = title;
						title = '';
				    }
	
			    	var thumbnail = '<img src="https://img.youtube.com/vi/' + value.youtubeID + '/0.jpg" class="videoPic">';
	
			    	if (value.tag != null && value.tag.length > 0){
				    	var tags = value.tag.replace(', ', ' #');
			    		tags = '#'+ tags;
			    	}
			    	else 
				    	var tags = '';

					
			    	if (value.id == defaultVideoID){ //이전 페이지에서 선택한 video 왼쪽에 띄우기
				    	start_s = value.start_s;
				    	end_s = value.end_s;
				    	limit = value.maxLength;
				    	youtubeID = value.youtubeID;
				    	videoTitle = newTitle;
						setYouTubePlayer();
						
				    	setDisplayVideoInfo(index); //player 제외 선택한 video 표시 설정
						//$('.displayVideo').attr('videoID', value.id);
						var addStyle = '" style="background-color:lightgrey;" ';
				    }
			    	else {
			    		var addStyle = '';
					}
				    
					var html = '<div class="video" onclick="playVideoFromPlaylist(this)"'
							+ ' seq="' + index //이부분 seq로 바꿔야할듯?
							+ '" videoID="' + value.id 
							+ '" youtubeID="' + value.youtubeID 
							+ '" start_s="' + value.start_s
							+ '" end_s="' + value.end_s
							+ '" maxLength="' + value.maxLength
							+ addStyle
							+ '>'
								+ '<p class="seq">' + (index+1) + '</p>'
								+ thumbnail
								+ '<p class="tag" tag="' + value.tag + '">' + tags + '</p>'
								+ '<p class="videoNewTitle">' + newTitle + '</p>'
								+ '<p class="videoOriTitle">' + title + '</p>'
								+ '<p class="duration"> 재생시간 ' + convertTotalLength(value.duration) + '</p>'
								+ '<a href="#" class="aDeleteVideo" onclick="deleteVideo(' + value.id + ')"> 삭제</a>'
							+ '</div>'
							+ '<div class="videoLine"></div>';
					$('#allVideo').append(html); 
				});
			}
		});
	}
	
	function playVideoFromPlaylist(item){
		$('html, body').animate({scrollTop: 0 }, 'slow'); //화면 상단으로 이동 
		$('.video').css({'background-color' : 'unset'});
		item.style.background = "lightgrey";

		youtubeID = item.getAttribute('youtubeID');
		start_s = item.getAttribute('start_s');
		end_s = item.getAttribute('end_s');
		limit = item.getAttribute('maxLength');

		setDisplayVideoInfo(item.getAttribute('seq'));
		
		player.loadVideoById({
			'videoId' : youtubeID,
			'startSeconds' : start_s,
			'endSeconds' : end_s
		});
	}

	function setDisplayVideoInfo(index){
		var videoID = $('.video:eq(' + index + ')').attr('videoID');
		
		$('#videoTitle').empty();
		var html = '<h3>' + videoTitle + '</h3>';
		$('#videoTitle').append(html);
		
		showForm();
				
		var start_hh = Math.floor(start_s / 3600);
		var start_mm = Math.floor(start_s % 3600 / 60);
		var start_ss = start_s % 3600 % 60;

		document.getElementById("start_hh").value = start_hh;
		document.getElementById("start_mm").value = start_mm;
		document.getElementById("start_ss").value = start_ss;

		var end_hh = Math.floor(end_s / 3600);
		var end_mm = Math.floor(end_s % 3600 / 60);
		var end_ss = end_s % 3600 % 60;

		document.getElementById("end_hh").value = end_hh;
		document.getElementById("end_mm").value = end_mm;
		document.getElementById("end_ss").value = end_ss;

		document.getElementById("inputVideoID").value = videoID;
        //document.getElementById("tag").value = item.getAttribute('tag');
	}

	function setYouTubePlayer() { //한번만 실행되도록 
		tag = document.createElement('script');
		tag.src = "https://www.youtube.com/iframe_api";
		firstScriptTag = document.getElementsByTagName('script')[0];
		firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
	}

	// This function creates an <iframe> (and YouTube player)
	//    after the API code downloads. 
	function onYouTubeIframeAPIReady() {
		player = new YT.Player('player', {
			height : '360',
			width : '640',
			videoId : videoId,
			events : {
				'onReady' : onPlayerReady,
				'onStateChange' : onPlayerStateChange
			}
		});
	}
	// The API will call this function when the video player is ready.
	function onPlayerReady() {
		if (youtubeID == null) {
			player.playVideo();
		}
		// 플레이리스트에서 영상 선택시 player가 바로 뜰 수 있도록 함. 
		else {
			player.loadVideoById({
				'videoId' : youtubeID,
				'startSeconds' : start_s,
				'endSeconds' : end_s
			});
		}
	}
	// player가 끝시간을 넘지 못하게 만들기 --> 선생님한테는 끝시간을 넘길수있도록..
	function onPlayerStateChange(state) {
		if (player.getCurrentTime() >= end_s) {
			player.pauseVideo();
			player.loadVideoById({
				'videoId' : youtubeID,
				'startSeconds' : start_s,
				'endSeconds' : end_s
			});
		}
	}
	
	// 구간 설정 자바스크립트 
	// 영상 검색과 함께 영상 구간 설정을 위한 form (원래 숨겨있던 것) 보여주기:
	function showForm() {
		var saveForm = document.getElementById("createVideoForm");
		saveForm.style.display = "block";
	}
	
	// Youtube player 특정 위치로 재생 위치 이동 : 
	function seekTo1() {
		// 사용자가 input에서 수기로 시간을 변경했을 시에 필요. 
		var start_hh = $('#start_hh').val();
		var start_mm = $('#start_mm').val();
		var start_ss = $('#start_ss').val();
		start_time = start_hh * 3600.00 + start_mm * 60.00 + start_ss
				* 1.00;
		player.seekTo(start_time);
	}
	
	function seekTo2() {
		var end_hh = $('#end_hh').val();
		var end_mm = $('#end_mm').val();
		var end_ss = $('#end_ss').val();
		end_time = end_hh * 3600.00 + end_mm * 60.00 + end_ss * 1.00;
		player.seekTo(end_time);
	}
	
	// 현재 재생위치를 시작,끝 시간에 지정 
	function getCurrentPlayTime1() {
		var d = Number(player.getCurrentTime());
		var h = Math.floor(d / 3600);
		var m = Math.floor(d % 3600 / 60);
		var s = d % 3600 % 60;
		document.getElementById("start_ss").value = parseFloat(s).toFixed(2);
		document.getElementById("start_hh").value = h;/* .toFixed(2); */
		document.getElementById("start_mm").value = m;/* .toFixed(2); */
		document.getElementById("start_s").value = parseFloat(d).toFixed(2);
		start_time = parseFloat(d).toFixed(2);
		start_time *= 1.00;
		//console.log("check:", typeof start_time);
	}
	function getCurrentPlayTime2() {
		var d = Number(player.getCurrentTime());
		var h = Math.floor(d / 3600);
		var m = Math.floor(d % 3600 / 60);
		var s = d % 3600 % 60;
		document.getElementById("end_ss").value = parseFloat(s).toFixed(2);
		document.getElementById("end_hh").value = h;/* .toFixed(2); */
		document.getElementById("end_mm").value = m;/* .toFixed(2); */
		document.getElementById("end_s").value = parseFloat(d).toFixed(2);
		end_time = parseFloat(d).toFixed(2);
		end_time *= 1.00;
		//console.log("check", typeof end_time);
	}
	
	// 재생 구간 유효성 검사: 
	function validation(event) { //video 추가 form 제출하면 실행되는 함수
		document.getElementById("warning1").innerHTML = "";
		document.getElementById("warning2").innerHTML = "";
		// 사용자가 input에서 수기로 시간을 변경했을 시에 필요. 
		var start_hh = $('#start_hh').val();
		var start_mm = $('#start_mm').val();
		var start_ss = $('#start_ss').val();
		start_time = start_hh * 3600.00 + start_mm * 60.00 + start_ss* 1.00;
		$('#start_s').val(start_time);
		
		var end_hh = $('#end_hh').val();
		var end_mm = $('#end_mm').val();
		var end_ss = $('#end_ss').val();
		end_time = end_hh * 3600.00 + end_mm * 60.00 + end_ss * 1.00;
		$('#end_s').val(end_time);
		
		//console.log(end_time - start_time);
		$('#duration').val(end_time - start_time);
		
		if (start_time > end_time) {
			document.getElementById("warning1").innerHTML = "시작시간은 끝시간보다 크지 않아야 합니다.";
			document.getElementById("start_ss").focus();
			return false;
		}
		if (end_time > limit) {
			//console.log(end_time,"  ", limit);
			document.getElementById("warning2").innerHTML = "끝시간은 영상 길이보다 크지 않아야 합니다.";
			document.getElementById("end_ss").focus();
			return false;
		} else {
			if ($('#inputVideoID').val() > -1)
				return updateVideo(event);
			return createVideo(event);
		}
	}

	function convertTotalLength(seconds){
		var seconds_hh = Math.floor(seconds / 3600);
		var seconds_mm = Math.floor(seconds % 3600 / 60);
		var seconds_ss = seconds % 3600 % 60;
		var result = "";
		
		if (seconds_hh > 0)
			result = seconds_hh + ":";
		result += seconds_mm + ":" + seconds_ss;
		
		return result;
	}

	function updateVideo(){ // 기존 playlist에 있던 video 정보 수정		
		event.preventDefault(); // avoid to execute the actual submit of the form.

		var videoID = $("#inputVideoID").val();
		var playlistID = $("#inputPlaylistID").val();
		$.ajax({
			'type': "POST",
			'url': "${pageContext.request.contextPath}/video/updateVideo",
			'data': {
					start_s : $("#start_s").val(),
					end_s : $("#end_s").val(),
					tag : $("#inputTag").val(),
					id : videoID
				},
			success: function(data) {
				console.log("ajax videot수정 완료!");
				getAllVideo(playlistID, defaultVideoID);
			},
			error: function(error) {
				getAllPlaylist(videoID); 
				console.log("ajax video수정 실패!" + error);
			}

		});
		return false;
	}

</script>
<body>
	<div class="displayVideo">
		<div id="videoTitle"></div>
		<div id="player"></div>
		
		<form id="createVideoForm" onsubmit="return validation(event)" style="display: none">
			<input type="hidden" name="start_s" id="start_s">
			<input type="hidden" name="end_s" id="end_s"> 
		 	<input type="hidden" name="title" id="inputYoutubeTitle">
		 	<input type="hidden" name="duration" id="duration">
		 	<input type="hidden" name="playlistID" id="inputPlaylistID">
			
			<button onclick="getCurrentPlayTime1()" type="button"> start time </button> : 
			<input type="text" id="start_hh" maxlength="2" size="2"> 시 
			<input type="text" id="start_mm" maxlength="2" size="2"> 분 
			<input type="text" id="start_ss" maxlength="5" size="5"> 초 
			<button onclick="seekTo1()" type="button"> 위치이동 </button>
			<span id=warning1 style="color:red;"></span> <br>
			
			<button onclick="getCurrentPlayTime2()" type="button"> end time </button> : 
			<input type="text" id="end_hh" max="" maxlength="2" size="2"> 시 
			<input type="text" id="end_mm" max="" maxlength="2" size="2"> 분 
			<input type="text" id="end_ss" maxlength="5" size="5"> 초 
			<button onclick="seekTo2()" type="button"> 위치이동 </button> 
			<span id=warning2 style="color:red;"></span> <br>
			
			tag: <input type="text" id="inputTag" name="tag">
			<input type="hidden" name="videoID" id="inputVideoID">
			
		</form>
		<button form="createVideoForm" type="submit">업데이트</button>
	</div>	
	<div id="allVideo"></div>

</body>
</html>