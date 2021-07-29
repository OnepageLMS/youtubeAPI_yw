<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
body {
	padding: 10px;
}

.video {
	padding: 7px;
}

.info {
	font-size: 12px;
}

img {
	width: 128px;
	height: 80px;
	padding: 5px;
}

.playlistSeq{
	background-color: #cecece;
	padding: 10px;
	margin: 5px;
}
.container-fluid{
	margin : 7px;
	width: 400px;
	float: right;
}
/* 이동 타켓 */
.card-placeholder {
	border: 1px dashed grey;
	margin: 0 1em 1em 0;
	height: 50px;
	margin-left:auto;
	margin-right:auto;
	background-color: #E8E8E8;
}
/* 마우스 포인터을 손가락으로 변경 */
.card:not(.no-move) .card-header{
	cursor: pointer;
}

.card{
	border-radius: 5px;
}
.card-header{
	border-bottom: 1px solid;
	margin: 0px -10px;
	padding: 5px 10px;
	padding-top: 0px;
}
/* playlist 구간 끝 */

</style>
</head>
<script src="https://code.jquery.com/jquery-3.5.1.js"
	integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc="
	crossorigin="anonymous"></script>
	
<link href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css" rel="stylesheet" type="text/css" /> <!-- jquery for drag&drop list order -->
<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">

<!-- 아래 script는 youtube-search, video API 사용해서 video 검색결과 가져오기. 변경할 때 예원에게 말해주세요!!! -->
<script>
	var maxResults = "20";
	var idList = [ maxResults ]; //youtube Search 결과 저장 array
	var titleList = [ maxResults ];
	var dateList = [ maxResults ];
	var viewCount = [ maxResults ];
	var likeCount = [ maxResults ];
	var dislikeCount = [ maxResults ];
	var durationCount = [ maxResults ];
	var count = 0;

	function fnGetList(sGetToken) { // youtube api로 검색결과 가져오기 
		count = 0;
		var $getval = $("#search_box").val();
		var $getorder = $("#opt").val();
		if ($getval == "") {
			alert("검색어를 입력하세요.");
			$("#search_box").focus();
			return;
		}
		$("#get_view").empty();
		$("#nav_view").empty();

		var key = "AIzaSyAAwiwQmW9kVJT5y-_no-A5lGJwk4B2QK8"; //AIzaSyCnS1z2Dk27-yex5Kbrs5XjF_DkRDhfM-c
		var accessToken = "${accessToken}";
		var sTargetUrl = "https://www.googleapis.com/youtube/v3/search?part=snippet&order="
				+ $getorder
				+ "&q="
				+ encodeURIComponent($getval) //encoding
				+ "&key=" + key
				//+ "&access_token="
				//+ accessToken
				+ "&maxResults="
				+ maxResults
				+ "&type=video";

		if (sGetToken != null) { //이전 or 다음페이지 이동할때 해당 페이지 token
			sTargetUrl += "&pageToken=" + sGetToken + "";
		}
		$.ajax({
					type : "POST",
					url : sTargetUrl, //youtube-search api 
					dataType : "jsonp",
					async : false,
					success : function(jdata) {
						if (jdata.error) { //api 할당량 끝났을 때 에러메세지
							$("#nav_view").append(
									'<p>검색 일일 한도가 초과되었습니다 나중에 다시 시도해주세요!</p>');
						}
						//console.log(jdata);
						$(jdata.items)
								.each(
										function(i) {
											setAPIResultToList(i, this.id.videoId,
													this.snippet.title,
													this.snippet.publishedAt);
										})
								.promise()
								.done(
										$(jdata.items)
												.each(
														function(i) {
															var id = idList[i];
															var getVideo = "https://www.googleapis.com/youtube/v3/videos?part=statistics,contentDetails&id="
																	+ id
																	+ "&key=" + key;
																	//+ "&access_token="
																	//+ accessToken;

															$.ajax({
																		type : "GET",
																		url : getVideo, //youtube-videos api
																		dataType : "jsonp",
																		success : function(jdata2) {
																			//console.log(jdata2);
																			setAPIResultDetails(
																					i,
																					jdata2.items[0].statistics.viewCount,
																					jdata2.items[0].statistics.likeCount,
																					jdata2.items[0].statistics.dislikeCount,
																					jdata2.items[0].contentDetails.duration);
																		},
																		error : function(xhr, textStatus) {
																			console.log(xhr.responseText);
																			alert("video detail 에러");
																			return;
																		}

																	})
														}));

						if (jdata.prevPageToken) {
							lastAndNext(jdata.prevPageToken, " <-이전 ");
						}
						if (jdata.nextPageToken) {
							lastAndNext(jdata.nextPageToken, " 다음-> ");
						}

					},

					error : function(xhr, textStatus) {
						console.log(xhr.responseText);
						alert("an error occured for searching");
						return;
					}
				});
	}

	function displayResultList() { //페이지별로 video 정보가 다 가져와지면 이 함수를 통해 결과 list 출력
		for (var i = 0; i < maxResults; i++) {
			var id = idList[i];
			var view = viewCount[i];
			
			var thumbnail = '<img src="https://img.youtube.com/vi/' + id + '/0.jpg">';
			//var url = '<a href="https://youtu.be/' + id + '">';
			$("#get_view").append(
					//'<div class="video" onclick="selectVideo(\'' + id.toString() + '\')" >' 
					'<div class="searchedVideo" onclick="showForm(); selectVideo(\'' + id.toString()
							+ '\'' + ',\'' + titleList[i] + '\''
							+ ',\'' + durationCount[i] + '\');" >' + thumbnail
							+ titleList[i] + '</p>'
							+ '<p class="info"> publised: <b>' + dateList[i]
							+ '</b> view: <b>' + view
							+ '</b> like: <b>' + likeCount[i]
							+ '</b> dislike: <b>' + dislikeCount[i]
							+ '</b> </p></div>');
		}
	}
	function lastAndNext(token, direction) { // 검색결과 이전/다음 페이지 이동
		$("#nav_view").append(
				'<a href="javascript:fnGetList(\'' + token + '\');"> '
						+ direction + ' </a>');
	}

	function setAPIResultToList(i, id, title, date) { // search api사용할 때 데이터 저장
		idList[i] = id;
		titleList[i] = title.replace("'", "\\'").replace("\"","\\\""); // 싱글따옴표나 슬래시 들어갼것 따로 처리해줘야함!!!!
		dateList[i] = date.substring(0, 10);
	}

	function setAPIResultDetails(i, view, like, dislike, duration) { // videos api 사용할 때 디테일 데이터 저장 
		viewCount[i] = convertNotation(view);
		likeCount[i] = convertNotation(like);
		dislikeCount[i] = convertNotation(dislike);
		durationCount[i] = duration;
		count += 1;
		if (count == 20)
			displayResultList();
	}

	function convertNotation(value) { //조회수 등 단위 변환
		var num = parseInt(value);

		if (num >= 1000000)
			return (parseInt(num / 1000000) + "m");
		else if (num >= 1000)
			return (parseInt(num / 1000) + "k");
		else if (value === undefined)
			return 0;
		else
			return value;
	}
</script>

<body>
<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

<!-- playlist CRUD -->
<script>
	$(function() { //페이지 처음 불러올때 playlist 띄우기
	 	getAllPlaylist();
	});

	function getAllPlaylist(){ //all playlist 출력
	  $.ajax({
	    type:'post',
	    url : 'http://localhost:8080/myapp/getAllPlaylist',
	    async : false,
	    success : function(result) {
		    if(result.code == "ok"){
		    	$('#allPlaylist').empty();
			    playlists = result.allPlaylist; //order seq desc 로 가져온다.
			    total = 0;
			    
			    $.each(playlists, function( index, value ){ //여기서 index는 playlistID가 아님! 
					var playlistID = value.playlistID;

					var html = '<div class = "playlistSeq card text-white bg-info mb-10" >' 
						+ '<div class="card-header" listID="' + playlistID + '" >' 
						+ (total+1) + ' : ' + value.playlistName 
						+ '<a href="#" onclick="deletePlaylist(\'' + playlistID + '\')"> 삭제 </a></div>'
						+ '<div class="card-body" videoTotal="0"></div>'
						+ '</div>';
					
					$('#allPlaylist').append(html);
					total += 1;
					getAllVideo(total-1);
					
				});
				document.getElementById("allPlaylist").setAttribute("total", total); //전체 playlist 갯수 저장
			}
		    else
			    alert('playlist 불러오기 실패! ');
	      
	    },error:function(json){
	 		console.log("ajax로 youtube api 부르기 실패 ");
	    }
	  }); 
	}

	function createPlaylist(){ //playlist 추가
		var playlistName = $("#playlistName").val();
		var creatorEmail = "yewon.lee@onepage.edu"; //나중에 사용자 로그인 정보 가져오기!
		var total = $("#allPlaylist").attr("total"); //저장되야 할 seq 순서

		$.ajax({
			'type' : "post",
			'url' : "http://localhost:8080/myapp/addPlaylist",
			'data' : {
						name : playlistName,
						creator : creatorEmail,
						total : total
			},
			success : function(data){
				getAllPlaylist();
		
			}, error : function(err){
				alert("playlist 추가 실패! : ", err.responseText);
			}

		});
	}

	function deletePlaylist(id){ // playlist 삭제
		if (confirm("playlist에 속한 비디오들까지 삭제됩니다. 정말 삭제하시겠습니까? " == true)){
			$.ajax({
				'type' : "post",
				'url' : "http://localhost:8080/myapp/deletePlaylist",
				'data' : {id : id},
				success : function(data){
					changeAllList(id); // 삭제된 playlistID를 넘겨줘야한다. 
			
				}, error : function(err){
					alert("playlist 삭제 실패! : ", err.responseText);
				}

			});
		}
	}

	function changeAllList(deletedID){ // playlist 추가, 삭제 뒤 전체 list order 재정렬
		var idList = new Array();
		
		$(".card-header").each(function(index){
			var playlistID = $(this).attr('listID'); // listID(playlistID)의 value값 가져오기
			if (deletedID != null){ // 이 함수가 playlist 삭제 뒤에 실행됐을 땐 삭제된 playlistID	 제외하고 재정렬
				if (deletedID != playlistID)
					idList.push(playlistID);
			}
			else
				idList.push(playlistID);
		});

		$.ajax({
		      type: "post",
		      url: "http://localhost:8080/myapp/changeItemsOrder", //새로 바뀐 순서대로 db update
		      data : { changedList : idList },
		      dataType  : "json", 
		      success  : function(data) {
		  	  		getAllPlaylist(); 
		    	  
		      }, error:function(request,status,error){
		          //alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		    	  getAllPlaylist(); 
		       }
		    });
	}

	$(function() { // playlist drag&drop으로 순서변경
		$("#allPlaylist").sortable({
			connectWith: "#allPlaylist", // 드래그 앤 드롭 단위 css 선택자
			handle: ".card-header", // 움직이는 css 선택자
			cancel: ".no-move", // 움직이지 못하는 css 선택자
			placeholder: "card-placeholder", // 이동하려는 location에 추가 되는 클래스

			stop : function(e, ui){ // 이동 완료 후, 새로운 순서로 db update
				changeAllList();
			}
		});
			
			$( "#allPlaylist .card" ).disableSelection(); //해당 클래스 하위의 텍스트는 변경x
	
	});

	function getAllVideo(playlistSeq){ //해당 playlistID에 해당하는 비디오들을 가져온다
		var playlistID = $(".card-header")[playlistSeq].getAttribute('listid');
		
		$.ajax({
			type:'post',
		    url : 'http://localhost:8080/myapp/getOnePlaylist',
		    data : {id : playlistID},
		    success : function(result){
			    videos = result.allVideo;
			    total = 0;
			   
			    $.each(videos, function( index, value ){ 
					var html2 = '<div class="videos" onclick=openSavedVideo(this) '
					+ ' playlistSeq="' + playlistSeq
					//+ '" videoSeq="' + (value.seq+1)
					+ '" videoID="' + value.id 
					+ '" youtubeID="' + value.youtubeID 
					+ '" start_s="' + value.start_s
					+ '" end_s="' + value.end_s + '" > ' + value.seq + value.title
					+ '<a href="#" onclick="deleteVideo(' + playlistSeq + ',' 
						+ value.id + ')"> 삭제 </a>'
					+ '</div>';
					
					$(document.getElementsByClassName("card-body")[playlistSeq]).append(html2);
				    total += 1;
				    
				});
			    document.getElementsByClassName("card-body")[playlistSeq].setAttribute("videoTotal", total); //해당하는 playlist에 속한 video 전체 갯수 저장
			}
		});
	}

	function createVideo(){ // video 저장 		
		event.preventDefault(); // avoid to execute the actual submit of the form.
		var seq = $("#inputPlaylistSeq").val() - 1; //1. 사용자가 입력한 playlist의 실제 인덱스(윗쪽에서 0부터 차례로 시작하는)를 가져온다 
		
		var total = $(".card-body")[seq].getAttribute('videoTotal'); //2. 해당하는 playlist에서 새로운 video의 순서가 될 숫자를 가져와서 저장한다
		document.getElementById("inputYoutubeSeq").value = total; 
		
		var playlistID = $(".card-header")[seq].getAttribute('listid'); //3. 해당하는 playlist의 실제 playlistID를 가져와서 새로운 video정보를 업데이트 할 때 같이 저장할 용도
		document.getElementById("inputPlaylistID").value = playlistID; 
		
		var passData = $('#createVideoForm').serialize(); //4. form에 있는 데이터들을 전송하기 위한 처리과정 

		$.ajax({
			'type': "POST",
			'url': "http://localhost:8080/myapp/addVideo",
			'data': passData,
			success: function(data) {
				console.log("ajax video저장 완료!");
				getAllPlaylist(); 
				// 해당 playlist만 불러오도록 변경필요!!
			},
			error: function(error) {
				getAllPlaylist(); 
				console.log("ajax video저장 실패!" + error);
			}

		});
		return false;
	}

	function deleteVideo(playlistSeq, videoID){ // video 삭제
					
		/*
		if (confirm("정말 삭제하시겠습니까?" == true)){
			$.ajax({
				'type' : "post",
				'url' : "http://localhost:8080/myapp/deleteVideo",
				'data' : {id : videoID},
				success : function(data){
					changeAllVideo(playlistSeq, videoID); //삭제한 videoID도 넘겨줘야 함.
			
				}, error : function(err){
					alert("video 삭제 실패! : ", err.responseText);
				}

			});
		}else
			return false;
		
		*/
		changeAllVideo(playlistSeq, videoID);
		console.log("deletedVideo: " + videoID);

	}

	function changeAllVideo(playlistSeq, deletedID){ // video 추가, 삭제, 순서변경 뒤 해당 playlist의 전체 video order 재정렬
		var idList = new Array();
		var childs = $(".card-body")[playlistSeq].childNodes;
		console.log(childs[0].attributes);

		for (var i in childs) {
			var videoID = childs[i].attributes.videoid.value;
			console.log(videoID);
			
			if (deletedID != null){ // 이 함수가 playlist 삭제 뒤에 실행됐을 땐 삭제된 playlistID	 제외하고 재정렬 (db에서 delete하는것보다 더 빨리 실행되서 이렇게 해줘야함)
				if (deletedID != videoID)
					idList.push(videoID);
			}
			else
				idList.push(videoID);
		}
		console.log(idList);

		
		/*
		$.ajax({
		      type: "post",
		      url: "http://localhost:8080/myapp/changeVideosOrder", //새로 바뀐 순서대로 db update
		      data : { changedList : idList },
		      dataType  : "json", 
		      success  : function(data) {
		  	  		getAllVideo(playlistSeq); 
		    	  
		      }, error:function(request,status,error){
		          //alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		    	  getAllVideo(playlistSeq); 
		       }
		    });
	    */
	}
	</script>
	
	
	 <div class="container-fluid playlist"> <!-- Playlist CRUD -->
	 	<h3>Playlist</h3>
	 	
		<div id="addPlaylist">
			<input type="text" id="playlistName" />
			<button onclick="createPlaylist()">생성</button>
		</div>
		
		<div id="allPlaylist" class="" >
			<!-- 각 카드 리스트 박스 추가되는 공간-->
		</div>
	</div>

	<form name="form1" method="post" onsubmit="return false;">
		<select name="opt" id="opt">
			<option value="relevance">관련순</option>
			<option value="date">날짜순</option>
			<option value="viewCount">조회순</option>
			<option value="title">문자순</option>
			<option value="rating">평가순</option>
		</select> <input type="text" id="search_box">
		<button onclick="fnGetList();">검색</button>
	</form>

	<div id="player_info"></div>
	<div id="player"></div>
	
	<!-- (jw) 영상 구간 설정 부분  -->
	<br>
	<form id="createVideoForm" onsubmit="return validation(event)" style="display: none">
		<input type="hidden" name="youtubeID" id="inputYoutubeID">
		<input type="hidden" name="start_s" id="start_s">
		<input type="hidden" name="end_s" id="end_s"> 
		<input type="hidden" name="title" id="inputYoutubeTitle"> 
		
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
		
		playlist : <input type="text" id="inputPlaylistSeq" required>
		<input type="hidden" name="playlistID" id="inputPlaylistID"> <!-- 실제 저장되는 플레이리스트 -->
		<input type="hidden" name="seq" id="inputYoutubeSeq"> <!-- 실제 저장되는 비디오 seq -->
		
		<button type="submit" > submit </button>
		<!-- id="btn-submit" disabled="disabled" -->
	</form>
	

	<!-- Youtube video player -->
	<script>
	
		// 각 video를 클릭했을 때 함수 parameter로 넘어오는 정보들
		var videoId;
		var videoTitle;
		var videoDuration;

		// player api 사용 변수 
		var tag;
		var firstScriptTag;
		var player;

		// (jw) 구간 설정: 유효성 검사시 필요 
		var limit;
		var start_s;
		var end_s;

		function showYoutubePlayer(id, title){
			videoId = id;
			videoTitle = title;
			
			document.getElementById("player_info").innerHTML = '<h3 class="videoTitle">' + videoTitle + '</h3>';

			//아래는 youtube-API 공식 문서에서 iframe 사용방법으로 나온 코드.
			tag = document.createElement('script');
			tag.src = "https://www.youtube.com/iframe_api";
			firstScriptTag = document.getElementsByTagName('script')[0];
			firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
		}

		function selectVideo(id, title, duration) { // 유튜브 검색결과에서 영상 아이디를 가지고 플레이어 띄우기
			showYoutubePlayer(id, title);

			videoDuration = duration;
			var regex = /PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?/;
	        var regex_result = regex.exec(duration); //Can be anything like PT2M23S / PT2M / PT28S / PT5H22M31S / PT3H/ PT1H6M /PT1H6S
	        var hours = parseInt(regex_result[1] || 0);
	        var minutes = parseInt(regex_result[2] || 0);
	        var seconds = parseInt(regex_result[3] || 0) - 1;
	        
	        document.getElementById("end_hh").value = hours;
	        document.getElementById("end_mm").value = minutes;
        	document.getElementById("end_ss").value = seconds;
        	
	        var total_seconds = hours * 60 * 60 + minutes * 60 + seconds;
			// validty check: 
	        limit = parseInt(total_seconds);
	        // 클릭한 영상의 videoId form에다가 지정. 
	        document.getElementById("inputYoutubeID").value = id;
	        document.getElementById("inputYoutubeTitle").value = videoTitle;
	        
			//이미 다른 영상이 player로 띄워져 있을 때 새로운 id로 띄우기
			player.loadVideoById(videoId, 0, "large");
	
			document.getElementById("start_hh").value = 0;
	        document.getElementById("start_mm").value = 0;
        	document.getElementById("start_ss").value = 0;
		}
		
		// 3. This function creates an <iframe> (and YouTube player)
		//    after the API code downloads. 
		function onYouTubeIframeAPIReady() {
			player = new YT.Player('player', {
				height : '360',
				width : '640',
				videoId : videoId,
				events : {
					'onReady' : onPlayerReady,
				}
				
			});
		}
		// 4. The API will call this function when the video player is ready.
		function onPlayerReady() {
			player.playVideo();
		}
		
		// (jw) playlist 저장된 영상 (구간) 불러오기 (2021/07/27: 화요일 저녁)
		function openSavedVideo(item) {
			var youtubeTitle = item.innerText; //youtubeTitle 영상제목
			var youtubeID = item.getAttribute('youtubeID');
			showYoutubePlayer(youtubeID, youtubeTitle);
						
			start_s = item.getAttribute('start_s');
			end_s = item.getAttribute('end_s');

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

			var index = item.getAttribute('playlistSeq');
			document.getElementById("inputPlaylistSeq").value = (parseInt(index) + 1); //사용자에게 playlist 순서를 1부터 시작하도록 보이기
			document.getElementById("inputPlaylistID").value = $(".card-header")[index].getAttribute('listid');

			document.getElementById("inputYoutubeID").value = youtubeID;
	        document.getElementById("inputYoutubeTitle").value = youtubeTitle;

	        player.loadVideoById({
				'videoId': youtubeID, 
				'startSeconds': start_s, 
				'endSeconds':end_s
			});
		}


		// (jw) 여기서 부터 구간 설정 자바스크립트 
		
		// 영상 검색과 함께 영상 구간 설정을 위한 form (원래 숨겨있던 것) 보여주기:
		function showForm(){
			var saveForm = document.getElementById("createVideoForm");
			saveForm.style.display = "block";
		} 
		// Youtube player 특정 위치로 재생 위치 이동 : 
		function seekTo1(){
			// 사용자가 input에서 수기로 시간을 변경했을 시에 필요. 
			var start_hh = $('#start_hh').val();
			var start_mm = $('#start_mm').val();
			var start_ss = $('#start_ss').val();
			start_time = start_hh * 3600.00 + start_mm * 60.00 + start_ss * 1.00;
			player.seekTo(start_time);	
		}	
		function seekTo2(){
			var end_hh = $('#end_hh').val();
			var end_mm = $('#end_mm').val();
			var end_ss = $('#end_ss').val();
			
			end_time = end_hh * 3600.00 + end_mm * 60.00 + end_ss * 1.00;
			player.seekTo(end_time);	
		}	
		// 현재 재생위치를 시작,끝 시간에 지정 
		function getCurrentPlayTime1(){	
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
		function getCurrentPlayTime2(){
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
		function validation(event){
			document.getElementById("warning1").innerHTML = "";
			document.getElementById("warning2").innerHTML = "";	
			// 사용자가 input에서 수기로 시간을 변경했을 시에 필요. 
			var start_hh = $('#start_hh').val();
			var start_mm = $('#start_mm').val();
			var start_ss = $('#start_ss').val();
			start_time = start_hh * 3600.00 + start_mm * 60.00 + start_ss * 1.00;
			$('#start_s').val(start_time); 
			var end_hh = $('#end_hh').val();
			var end_mm = $('#end_mm').val();
			var end_ss = $('#end_ss').val();
			
			end_time = end_hh * 3600.00 + end_mm * 60.00 + end_ss * 1.00;
			$('#end_s').val(end_time);
			//console.log("start= ", start_time);
			//console.log("end= ", end_time);
			
			if(start_time > end_time) {
				document.getElementById("warning1").innerHTML = "start time cannot exceed end time";
				document.getElementById("start_ss").focus();
				return false;
			}
			if(end_time > limit){
				//console.log("value of x: "+ x);
				document.getElementById("warning2").innerHTML = "Please insert again";
				document.getElementById("end_ss").focus();
				return false;
			}
			else {
				return createVideo(event);
			}
		}
	</script>

	<div id="get_view"></div>

	<div id="nav_view"></div>


</body>
</html>

