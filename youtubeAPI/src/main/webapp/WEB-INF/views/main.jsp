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

.playlist {	/* playlist 구간 시작 */
	width: 400px;
}

.playlistSeq{
	background-color: #cecece;
	padding: 10px;
	margin: 5px;
}

#allPlaylist {
	border: 1px solid #cecece;
	padding-top: 5px;
	padding-bottom: 5px;
}

.container-fluid{
	margin : 7px;
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

<!-- 아래 script는 youtube-search, video API 사용해서 original video 가져오기. 변경할 때 예원에게 말해주세요!!! -->
<script>
	var maxResults = "20";
	var idList = [ maxResults ]; //youtube Search 결과 저장
	var titleList = [ maxResults ];
	var dateList = [ maxResults ];
	var viewCount = [ maxResults ];
	var likeCount = [ maxResults ];
	var dislikeCount = [ maxResults ];
	var durationCount = [ maxResults ];
	var count = 0;

	function fnGetList(sGetToken) {
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

		//var key = "AIzaSyAAwiwQmW9kVJT5y-_no-A5lGJwk4B2QK8"; //AIzaSyCnS1z2Dk27-yex5Kbrs5XjF_DkRDhfM-c
		var accessToken = "${accessToken}";
		var sTargetUrl = "https://www.googleapis.com/youtube/v3/search?part=snippet&order="
				+ $getorder
				+ "&q="
				+ encodeURIComponent($getval) //encoding
				//+ "&key=" + key
				+ "&access_token="
				+ accessToken
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
											setList(i, this.id.videoId,
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
																	//+ "&key=" + key;
																	+ "&access_token="
																	+ accessToken;

															$.ajax({
																		type : "GET",
																		url : getVideo, //youtube-videos api
																		dataType : "jsonp",
																		success : function(jdata2) {
																			//console.log(jdata2);
																			setDetails(
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
							lastandnext(jdata.prevPageToken, " <-이전 ");
						}
						if (jdata.nextPageToken) {
							lastandnext(jdata.nextPageToken, " 다음-> ");
						}

					},

					error : function(xhr, textStatus) {
						console.log(xhr.responseText);
						alert("an error occured for searching");
						return;
					}
				});
	}

	function getView() { //페이지별로 video 정보가 다 가져와지면 이 함수를 통해 결과 list 출력
		for (var i = 0; i < maxResults; i++) {
			var id = idList[i];
			var thumbnail = '<img src="https://img.youtube.com/vi/' + id + '/0.jpg">';
			//var url = '<a href="https://youtu.be/' + id + '">';
			$("#get_view").append(
					//'<div class="video" onclick="viewVideo(\'' + id.toString() + '\')" >' 
					'<div class="video" onclick="viewVideo(\'' + id.toString()
							+ '\'' + ',\'' + titleList[i].toString() + '\''
							+ ',\'' + durationCount[i] + '\')" >' + thumbnail
							+ titleList[i] + '</p>'
							+ '<p class="info"> publised: <b>' + dateList[i]
							+ '</b> view: <b>' + viewCount[i]
							+ '</b> like: <b>' + likeCount[i]
							+ '</b> dislike: <b>' + dislikeCount[i]
							+ '</b> </p></div>');
		}
	}

	function lastandnext(token, direction) { // 검색결과 이전/다음 페이지 이동
		$("#nav_view").append(
				'<a href="javascript:fnGetList(\'' + token + '\');"> '
						+ direction + ' </a>');
	}

	function setList(i, id, title, date) { // search api사용할 때 데이터 저장
		idList[i] = id;
		titleList[i] = title;
		dateList[i] = date.substring(0, 10);
	}

	function setDetails(i, view, like, dislike, duration) { // videos api 사용할 때 디테일 데이터 저장 
		viewCount[i] = convertNotation(view);
		likeCount[i] = convertNotation(like);
		dislikeCount[i] = convertNotation(dislike);
		durationCount[i] = duration;
		count += 1;
		if (count == 20)
			getView();
	}

	function convertNotation(value) { //조회수 등 단위 변환
		var num = parseInt(value);

		if (num >= 1000000)
			return (parseInt(num / 1000000) + "m");
		else if (num >= 1000)
			return (parseInt(num / 1000) + "k");
		else
			return value;
	}
</script>

<body>
<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
<!-- 부트스트랩 3.x를 사용한다. -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

<script>
	$(function() { //페이지 처음 불러올때 playlist 띄우기
	 	getAllPlaylist();
	});

	function getAllPlaylist(){ //all playlist 출력
	  $.ajax({
	    type:'post',
	    url : 'http://localhost:8080/myapp/getAllPlaylist',
	    global : false,
	    async : true,
	    success : function(result) {
		    if(result.code == "ok"){
		    	$('#allPlaylist').empty();
			    values = result.allPlaylist; //order seq desc 로 가져온다. 
			    total = 0;
			    $.each(values, function( index, value ){ //여기서 index는 playlistID가 아님! 
					var html = '<div class = "playlistSeq card text-white bg-info mb-10" >' 
						+ '<div class="card-header" listID="' + value.playlistID + '" >' 
						+ (value.seq+1) + ' : ' + value.playlistName 
						+ '<a href="#" onclick="deletePlaylist(\'' + value.playlistID + '\')"> 삭제 </a></div>'
						+ '<div class="card-body"> body </div>'
						+ '</div>';
					$('#allPlaylist').append(html);
					total += 1;
				});
				document.getElementById("allPlaylist").setAttribute("total", total);
			}
		    else
			    alert('playlist 불러오기 실패! ')
	      
	    },error:function(json){
	 		alert('ajax 실패! ');
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

	function changeAllList(deletedID){ // playlist 추가, 삭제 뒤 재정렬
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
		      type: "POST",
		      url: "http://localhost:8080/myapp/changeItemsOrder",   // 서버단 메소드 url 
		      data : {changedList : idList},
		      dataType  : "json", 
		      success  : function(data) {
		  	  		getAllPlaylist(); 
		    	  
		      }, error:function(request,status,error){
		          //alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		    	  getAllPlaylist(); 
		       }
		    });
	}

	$(function() { // playlist 순서변경
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
	</script>
	
	<div class="playlist"> <!-- Playlist CRUD -->
		
		<h3>Playlist</h3>
		<div id="addPlaylist">
			<input type="text" id="playlistName" />
			<button onclick="createPlaylist()">생성</button>
		</div>
		
		<!-- playlist 출력 -->
		 <div class="container-fluid">
			<div class="row">
				<div id="allPlaylist" class="col-sm-8" >
					<!-- 각 카드 리스트 박스 추가되는 공간-->
				</div>
			</div>
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

	<script>
		// 각 video를 클릭했을 때 함수 parameter로 넘어오는 정보들
		var videoId;
		var videoTitle;
		var videoDuration;

		// player api 사용 변수 
		var tag;
		var firstScriptTag;
		var player;

		function viewVideo(id, title, duration) { // 선택한 비디오 아이디를 가지고 플레이어 띄우기
			videoId = id;
			videoTitle = title;
			videoDuration = duration;
			document.getElementById("player_info").innerHTML = '<h2> Title: '
					+ videoTitle + '</h2> <p> Duration: ' + videoDuration
					+ ' </p>';

			tag = document.createElement('script');

			tag.src = "https://www.youtube.com/iframe_api";
			firstScriptTag = document.getElementsByTagName('script')[0];
			firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

			//이미 다른 영상이 player로 띄워져 있을 때
			player.loadVideoById(videoId, 0, "large");

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
	</script>

	<div id="get_view"></div>

	<div id="nav_view"></div>


</body>
</html>

