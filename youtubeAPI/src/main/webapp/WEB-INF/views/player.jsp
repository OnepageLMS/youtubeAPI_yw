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

.playlistSeq {
	background-color: #cecece;
	padding: 10px;
	margin: 5px;
}

.container-fluid {
	margin: 7px;
	width: 500px;
	float: right;
}
/* 이동 타켓 */
.card-placeholder {
	border: 1px dashed grey;
	margin: 0 1em 1em 0;
	height: 50px;
	margin-left: auto;
	margin-right: auto;
	background-color: #E8E8E8;
}
/* 마우스 포인터을 손가락으로 변경 */
.card:not(.no-move) .card-header {
	cursor: pointer;
}

.card {
	border-radius: 5px;
}

.card-header {
	border-bottom: 1px solid;
	margin: 0px -10px;
	padding: 5px 10px;
	padding-top: 0px;
}

.card-body {
	font-size: 13.5px;
}


/* modal사용 안할시에 지울것 */ 
/* .modal-header {
	background: #F7941E;
	color: #fff;
}

.required:after {
	content: "*";
	color: red;
} */

#popup_bg{
	position: fixed;
	top: 0;
	left: 0;
	background-color: rgba(0,0,0,0.7);
	width: 100%;
	height: 100%;
}

#popup_main_div{
	postion: fixed;
	width: 400px;
	height: 500px;
	border: 2px solid black;
	border-radius: 5px;
	background-color: white;
	left: 50%;
	float: center;
	margin-right: 90px;
	margin-top: 70px;
	top: 50%;
}

#close_popup_div{
	position: absolute;
	width: 25px;
	height: 25px;
	border-radius: 25px;
	border: 2px solid black;
	text-align: center;
	right: 5px;
	top: 5px;
}

/* playlist 구간 끝 */
</style>

</head>
<script src="https://code.jquery.com/jquery-3.5.1.js"
	integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc="
	crossorigin="anonymous"></script>

<link href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css"
	rel="stylesheet" type="text/css" />
<!-- jquery for drag&drop list order -->
<link rel="stylesheet"
	href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<link rel="stylesheet"
	href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<!-- fontawesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

<body>
	<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
	<script
		src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-beta1/dist/js/bootstrap.bundle.min.js"
		integrity="sha384-ygbV9kiqUc6oa4msXn9868pTtWMgiQaeYH7/t7LECLbyPA2x65Kgf80OJFdroafW"
		crossorigin="anonymous"></script>
	
	<script>
		function stopDefaultAction(e) { e.stopPropagation(); }
	</script>
	

	<!-- playlist CRUD -->
	<script>
	var email = "yewon.lee@onepage.edu";
		$(function() { //페이지 처음 불러올때 playlist 띄우기
			getAllMyPlaylist(email);
		});

		function togglePlaylist(index) {
			//if (e.target !== e.currentTarget) return;
			event.stopPropagation();
			var element = $(".card-body")[index], 
			style = window.getComputedStyle(element),
			display = style.getPropertyValue('display');

			if(display == "block"){
				$(".card-body")[index].setAttribute('style', 'display: none');
			}
			else{
				$(".card-body")[index].setAttribute('style', 'display: block');
			}

			var div = $(".card-header:eq(" + index + ")").find(".caret-icon");
			console.log("check for true??", div);

			if(div.hasClass("fa-caret-right")){
				div.addClass("fa-caret-down").removeClass("fa-caret-right");
			} else {
				div.addClass("fa-caret-right").removeClass("fa-caret-down");
			}
		}
	
		function getAllMyPlaylist(email) { //all playlist 출력
			console.log("check here", email);
			$
					.ajax({
						type : 'post',
						url : '${pageContext.request.contextPath}/playlist/getAllMyPlaylist',
						data : {email : email},
						async : false,
						success : function(result) {
								playlists = result.allMyPlaylist; //order seq desc 로 가져온다.

								$('#allMyPlaylist').empty();

								if (playlists == null)
									$('#allMyPlaylist').append('저장된 playlist가 없습니다.');

								else{
								$.each(
										playlists,
										function(index, value) { //여기서 index는 playlistID가 아님! 
											var playlistID = value.playlistID;
											var num = index;

											var hr = Math.floor(value.totalVideoLength / 3600);
											var min = Math.floor(value.totalVideoLength % 3600 / 60); 
											var sec = value.totalVideoLength % 3600 % 60;
											if(sec % 1 !=0){ 	// 소수점 있을시에는 2자리까지만 표기 하도록. 
												sec = parseFloat(sec).toFixed(2);
											}											

											var html = '<div class = "playlistSeq card text-white bg-info mb-10" >'
													+ '<div class="card-header" listID="' + playlistID + '"playlistName="' + value.playlistName + '"onclick="togglePlaylist(\'' + num + '\')" >'
													+ '<input type="checkbox" value="' + playlistID + '" class="selectPlaylists custom-control-input" style="margin:2px 4px; display:none;" onclick="stopDefaultAction(event);">'
													+ '<i class="caret-icon fa fa-caret-right fa-lg" style="margin:5px;"></i>'
													+ (index + 1)
													+ ' : '
													+ value.playlistName
													+ '  ('
													+ value.totalVideo
													+ '개: '
													+ hr + '시간 ' + min + '분 ' + sec + '초 )'
													+ '<a href="#" class="aUpdatePlaylist" onclick="updatePlaylist(\''
													+ playlistID
													+ '\')" style="display:none;"> 수정 </a>'
													+ '<a href="#" class="aDeletePlaylist" onclick="deletePlaylist(\''
													+ playlistID
													+ '\')" style="display:none;"> 삭제 </a></div>'
													+ '<div class="card-body"></div>'
													+ '</div>';

											$('#allMyPlaylist').append(html);
											getAllVideo(index);

										});
									if ($("#createVideoForm").css('display') === 'block') //video 추가할 Playlist 선택칸 보여주기
									$(".selectPlaylists").css("display",
											"inline");
								}
					}, error : function(json) {
						console.log("ajax로 youtube api 부르기 실패 ");
					}
			});
		}
		
		function getAllPlaylist() { //all playlist 출력
			$
					.ajax({
						type : 'post',
						url : '${pageContext.request.contextPath}/playlist/getAllPlaylist',
						async : false,
						success : function(result) {
							if (result.code == "ok") {
								$('#allPlaylist').empty();
								playlists = result.allPlaylist; //order seq desc 로 가져온다.

								$.each(
												playlists,
												function(index, value) { //여기서 index는 playlistID가 아님! 
													var playlistID = value.playlistID;
													var num = index;

													var hr = Math.floor(value.totalVideoLength / 3600);
													var min = Math.floor(value.totalVideoLength % 3600 / 60); 
													var sec = value.totalVideoLength % 3600 % 60;
													if(sec % 1 !=0){ 	// 소수점 있을시에는 2자리까지만 표기 하도록. 
														sec = parseFloat(sec).toFixed(2);
													}													

													var html = '<div class = "playlistSeq card text-white bg-info mb-10" >'
															+ '<div class="card-header" listID="' + playlistID + '"playlistName="' + value.playlistName + '"onclick="togglePlaylist(\'' + num + '\')" >'
															+ '<input type="checkbox" value="' + playlistID + '" class="selectPlaylists custom-control-input" style="margin:2px 4px; display:none;" onclick="stopDefaultAction(event);">'
															
															+ '<i class="fa fa-caret-right fa-lg" style="margin:5px;"></i>'
															+ (index + 1)
															+ ' : '
															+ value.playlistName
															+ '  ('
															+ value.totalVideo
															+ '개: '
															+ hr + '시간 ' + min + '분 ' + sec + '초 )'
															+ '<a href="#" class="aUpdatePlaylist" onclick="updatePlaylist(\''
															+ playlistID
															+ '\')" style="display:none;"> 수정 </a>'
															+ '<a href="#" class="aDeletePlaylist" onclick="deletePlaylist(\''
															+ playlistID
															+ '\')" style="display:none;"> 삭제 </a></div>'
															+ '<div class="card-body"></div>'
															+ '</div>';

													$('#allPlaylist').append(
															html);
													getAllVideo(index);

												});
								if ($("#createVideoForm").css('display') === 'block') //video 추가할 Playlist 선택칸 보여주기
									$(".selectPlaylists").css("display",
											"inline");
							} else
								alert('playlist 불러오기 실패! ');

						},
						error : function(json) {
							console.log("ajax로 youtube api 부르기 실패 ");
						}
					});
		}

		// 진행중 (2021/08/16) 
		function createPlaylist() { //playlist 추가
			/* var popup = window.open('addPlaylistPopup') */
			//var playlistName = $("#playlistName").val();
			//var creatorEmail = "yewon.lee@onepage.edu"; //나중에 사용자 로그인 정보 가져오기!
			//var url = "${pageContext.request.contextPath}/playlist/addPlaylistPopup" + creatorEmail;
			//var popOption = "width=500, height=600";

			//var popup = window.open(url, "addPlaylistPopup", popOption);
			
			$.ajax({
				'type' : "post",
				'url' : '${pageContext.request.contextPath}/playlist/addPlaylist',
				'data' : {
					name : playlistName,
					creator : creatorEmail,
				},
				success : function(data) {
					getAllMyPlaylist(email);
				},
				error : function(err) {
					alert("playlist 추가 실패! : ", err.responseText);
				}

			}); 
		}

		/* function deletePlaylist(id) { // playlist 삭제
			if (confirm("playlist에 속한 비디오들까지 삭제됩니다. 정말 삭제하시겠습니까? ")) {
				$.ajax({
					'type' : "post",
					'url' : "${pageContext.request.contextPath}/playlist/deletePlaylist",
					'data' : {
						id : id
					},
					success : function(data) {
						changeAllList(id); // 삭제된 playlistID를 넘겨줘야한다. 

					},
					error : function(err) {
						alert("playlist 삭제 실패! : ", err.responseText);
					}
				});
			}
		} */

		/* function changeAllList(deletedID) { // playlist 추가, 삭제 뒤 전체 list order 재정렬
			var idList = new Array();

			$(".card-header").each(function(index) {
				var playlistID = $(this).attr('listID'); // listID(playlistID)의 value값 가져오기
				if (deletedID != null) { // 이 함수가 playlist 삭제 뒤에 실행됐을 땐 삭제된 playlistID	 제외하고 재정렬
					if (deletedID != playlistID)
						idList.push(playlistID);
				} else
					idList.push(playlistID);
			});

			$.ajax({
				type : "post",
				url : "${pageContext.request.contextPath}/playlist/changePlaylistOrder", //새로 바뀐 순서대로 db update
				data : {
					changedList : idList
				},
				dataType : "json",
				success : function(data) {
					getAllMyPlaylist(email);
				},
				error : function(request, status, error) {
					//alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
					getAllMyPlaylist(email);
				}
			});
		} */

		/* $(function() { // playlist drag&drop으로 순서변경
			$("#allPlaylist").sortable({
				connectWith : "#allPlaylist", // 드래그 앤 드롭 단위 css 선택자
				handle : ".card-header", // 움직이는 css 선택자
				cancel : ".no-move", // 움직이지 못하는 css 선택자
				placeholder : "card-placeholder", // 이동하려는 location에 추가 되는 클래스

				stop : function(e, ui) { // 이동 완료 후, 새로운 순서로 db update
					changeAllList();
				}
			});
			$("#allPlaylist .card").disableSelection(); //해당 클래스 하위의 텍스트는 변경x

		}); */

		function updatePlaylist(playlistID) { //선택한 playlist 이름, 포함된 video들 순서 바꾸기

		}

		function getAllVideo(playlistSeq) { //해당 playlistID에 해당하는 비디오들을 가져온다
			var playlistID = $(".card-header:eq(" + playlistSeq + ")").attr('listID');
		
			$(".card-body:eq(" + playlistSeq + ")").attr('style', 'display: none');

			$.ajax({
				type : 'post',
				url : '${pageContext.request.contextPath}/video/getOnePlaylistVideos',
				data : {
					id : playlistID
				},
				success : function(result) {
					videos = result.allVideo;
					$('.card-body:eq(' + playlistSeq + ')').empty();
							$.each(
									videos,
									function(index, value) {
										var title = value.title;
										if (title.length > 40) {
											title = title.substring(0,
													40)
													+ " ...";
										}
										

										if(value.newTitle == null){
											//console.log(value.newTitle);
											value.newTitle = title;
											console.log(value.newTitle);
										}

										var html2 = '<div class="videos"'
												+ ' playlistSeq="'
												+ playlistSeq
												+ '" videoID="'
												+ value.id
												+ '" youtubeID="'
												+ value.youtubeID
												+ '" title="'
												+ value.title
												+ '" newTitle="'
												+ value.newTitle
												+ '" start_s="'
												+ value.start_s
												+ '" end_s="'
												+ value.end_s
												+ '" maxLength="'
												+ value.maxLength														
												+ '" tag="'
												+ value.tag
												+ '" > '
												+ (value.seq+1)
												+ ". "
												+ value.newTitle
												+ '<a href="#" class="aDeleteVideo" onclick="deleteVideo('
												+ playlistSeq
												+ ','
												+ value.id
												+ ')" style="display:none;"> 삭제</a>'
												+ '</div>';

										$(
											'.card-body:eq('
													+ playlistSeq
													+ ')').append(
											html2);
									});

							if ($("#createVideoForm").css('display') === 'block') //video 추가할 Playlist 선택칸 보여주기
								$(".selectPlaylists").css("display", "inline");
						}
					});
		}

		function createVideo() { // video 저장 		
			event.preventDefault(); // avoid to execute the actual submit of the form.

			var checkBoxArr = []; //새로운 영상이 추가될 playlist들 저장
			$('input:checkbox:checked').each(function(i) {
				checkBoxArr.push($(this).val());
			});
			var title = $("#inputYoutubeTitle").val();
			var newName = $("#newName").val();
			var start_s = $("#start_s").val();
			var end_s = $("#end_s").val();
			var youtubeID = $("#inputYoutubeID").val();
			var maxLength = $("#maxLength").val();
			var duration = $('#duration').val();
			var tag = $("#tag").val();
			var newTitle;
			
			if(newName != title){
				newTitle = newName;
			}
			
			$.ajax({
				'type' : "POST", 
				'url' : "${pageContext.request.contextPath}/video/addVideo",
				'data' : {
					playlistArr : checkBoxArr,
					title : title,
					newTitle : newTitle,
					start_s : start_s,
					end_s : end_s,
					youtubeID : youtubeID,
					maxLength : maxLength,
					duration : duration,
					tag : tag
				},
				success : function(data) {
					console.log("ajax video저장 완료!");
					for (var i = 0; i < checkBoxArr.length; i++) {
						getAllVideo(checkBoxArr[i]);
					}
				},
				error : function(error) {
					getAlMyPlaylist();
					console.log("ajax video저장 실패!" + error);
				}
			});

			confirmSearch();
			return false;
		}

		// tag로 playlist 및 영상 찾기:
		var playlistSearch = null;

		function searchPlaylist() {
			console.log(playlistSearch);

			if (playlistSearch != null) {
				playlistSearch.forEach(function(element) {
					//$("[tag*='"+ element + "']").css("background-color", "#d9edf7;"); 
					$("[playlistname*='" + element + "']").css(
							"background-color", "#d9edf7;");
				});
			}

			playlistSearch = $("#playlistSearch").val();
			playlistSearch = playlistSearch.replace(/ /g, '').split(",");

			playlistSearch.forEach(function(element) {
				//$("[tag*='"+ element + "']").css("background-color", "yellow");
				$("[playlistname*='" + element + "']").css("background-color",
						"green");
			});
		}
	</script>


	<div class="container-fluid playlist">
		<!-- Playlist CRUD -->
		<h3>Playlist </h3>


		<div id="addPlaylist">
			<button onclick="createPlaylist()" style="width: 200px;">생 성</button>
		</div>
		<!-- div id="addPlaylist">
			<input type="text" id="playlistName" placeholder="플레이리스트 이름"/>
			<button onclick="createPlaylist()">생성</button>
		</div> -->
		
		<div>
			<input type="text" id="playlistSearch" placeholder="플레이리스트 이름" />
			<button onclick="searchPlaylist()">찾기</button>
		</div>
		<div id="allMyPlaylist" class="">
			<!-- 각 카드 리스트 박스 추가되는 공간-->
		</div>
	</div>

	<!-- <div id="player_info"></div> -->
	<br>
	<div id="title"></div>
	<div>
		<textarea id="newName" name="newName" cols="78" rows="2"> </textarea>
	</div>
	<div id="player"></div>

	<!-- (jw) 영상 구간 설정 부분  -->
	<br>
	<form id="createVideoForm" onsubmit="return validation(event)"
		style="display: none">
		<input type="hidden" name="youtubeID" id="inputYoutubeID"> 
		<input type="hidden" name="start_s" id="start_s"> 
		<input type="hidden" name="end_s" id="end_s"> 
		<input type="hidden" name="title" id="inputYoutubeTitle">
		<input type="hidden" name="maxLength" id="maxLength"> 
		<input type="hidden" name="duration" id="duration">

		<br>
		<button onclick="getCurrentPlayTime1()" type="button">start time</button>
		: <input type="text" id="start_hh" maxlength="2" size="2"> 시 
		<input type="text" id="start_mm" maxlength="2" size="2"> 분 
		<input type="text" id="start_ss" maxlength="5" size="5"> 초
		<button onclick="seekTo1()" type="button">위치이동</button>
		<span id=warning1 style="color: red;"></span> <br>

		<button onclick="getCurrentPlayTime2()" type="button">end time</button>
		: <input type="text" id="end_hh" max="" maxlength="2" size="2">
		시 <input type="text" id="end_mm" max="" maxlength="2" size="2">
		분 <input type="text" id="end_ss" maxlength="5" size="5"> 초
		<button onclick="seekTo2()" type="button">위치이동</button>
		<span id=warning2 style="color: red;"></span> <br>

		tag: <input type="text" id="tag" name="tag">
		<!-- 아래는 기존 playlist에서 video를 수정할 때 사용 -->
		<!--  <input type="hidden" name="playlistID" id="inputPlaylistID"> -->
		<input type="hidden" name="videoID" id="inputVideoID">
		<button type="submit" class="submitBtn">추가</button>
		<!-- id="btn-submit" disabled="disabled" -->
	</form>

	<!-- Youtube video player -->
	<script>
		/*  각 video를 클릭했을 때 함수 parameter로 넘어오는 정보들 */
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
		var youtubeID;

		window.onload = function() {
			videoId = "${id}";
			videoTitle = "${title}";
			videoDuration = "${duration}";
			selectVideo(videoId, videoTitle, videoDuration);
			showForm();
		}

		function showYoutubePlayer(id, title) {
			$('html, body').animate({
				scrollTop : 0
			}, 'slow'); //화면 상단으로 이동

			videoId = id;
			videoTitle = title;

			console.log(videoTitle);
			//document.getElementById("newTitle").innerHTML = '<h3 class="videoTitle">' + videoTitle + '</h3>';
			$('#newName').val(videoTitle);

			//아래는 youtube-API 공식 문서에서 iframe 사용방법으로 나온 코드.
			tag = document.createElement('script');
			tag.src = "https://www.youtube.com/iframe_api";
			firstScriptTag = document.getElementsByTagName('script')[0];
			firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
		}

		function selectVideo(id, title, duration) { // 유튜브 검색결과에서 영상 아이디를 가지고 플레이어 띄우기
			$('.videos').css({ 
				'fontWeight' : 'normal'
			});
			$('input:checkbox').prop("checked", false); //youtube 검색결과에서 비디오 선택하면 playlist 체크된것 다 초기화 
			$('.submitBtn').html('추가');
			document.getElementById("inputVideoID").value = -1; //updateVideo()가 아닌 createVideo()가 실행되도록 초기화!

			showYoutubePlayer(id, title);

			//console.log("check duration", duration); // 직접찍어본 결과 희한하게 영상에 따라 총 영상 길이가 보통 1초가 다 긴데, 어떤건 정확하게 영상 길이만큼 나온다. 

			var regex = /PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?/;
			var regex_result = regex.exec(duration); //Can be anything like PT2M23S / PT2M / PT28S / PT5H22M31S / PT3H/ PT1H6M /PT1H6S
			var hours = parseInt(regex_result[1] || 0);
			var minutes = parseInt(regex_result[2] || 0);
			var seconds = parseInt(regex_result[3] || 0);

			/* if(seconds != "00") {
				seconds = parseInt(seconds) - 1;  // 어떤건 1초 적게 나올 수 있음 이게 영상 마다 정의된 총 길이시간이 1초가 더해지기도 안더해지기도 해서 . 
			}	  */

			document.getElementById("end_hh").value = hours;
			document.getElementById("end_mm").value = minutes;
			document.getElementById("end_ss").value = seconds;

			var total_seconds = hours * 60 * 60 + minutes * 60 + seconds;

			// for validty check: 
			limit = parseInt(total_seconds);
			document.getElementById("maxLength").value = limit;

			// 클릭한 영상의 videoId form에다가 지정. 
			document.getElementById("inputYoutubeID").value = id;
			document.getElementById("inputYoutubeTitle").value = videoTitle;

			//이미 다른 영상이 player로 띄워져 있을 때 새로운 id로 띄우기
			//player.loadVideoById(videoId, 0, "large");

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
					'onStateChange' : onPlayerStateChange
				}
			});
		}
		// 4. The API will call this function when the video player is ready.
		function onPlayerReady() {
			//player.playVideo();

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

		// (jw) player가 끝시간을 넘지 못하게 만들기 : 일단 임의로 시작 시간으로 되돌리기 했는데, 하영이거에서 마지막 재생 위치에서 부터 다시 재생되게 하면 될듯. 
		function onPlayerStateChange(state) {
			if (player.getCurrentTime() >= end_s) {

				player.pauseVideo();
				//player.seekTo(start_s);
				player.loadVideoById({
					'videoId' : youtubeID,
					'startSeconds' : start_s,
					'endSeconds' : end_s
				});
			}
		}

		// (jw) 여기서 부터 구간 설정 자바스크립트 

		// 영상 검색과 함께 영상 구간 설정을 위한 form (원래 숨겨있던 것) 보여주기:
		function showForm() {
			var saveForm = document.getElementById("createVideoForm");
			saveForm.style.display = "block";

			$(".selectPlaylists").css("display", "inline"); //영상 추가할 기존 playlist 중 선택
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

			document.getElementById("start_ss").value = parseFloat(s)
					.toFixed(2);
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
			start_time = start_hh * 3600.00 + start_mm * 60.00 + start_ss
					* 1.00;
			$('#start_s').val(start_time);
			var end_hh = $('#end_hh').val();
			var end_mm = $('#end_mm').val();
			var end_ss = $('#end_ss').val();

			end_time = end_hh * 3600.00 + end_mm * 60.00 + end_ss * 1.00;
			$('#end_s').val(end_time);

			console.log(limit);
			//console.log(end_time - start_time);
			$('#duration').val(end_time - start_time);

			if (start_time > end_time) {
				document.getElementById("warning1").innerHTML = "start time cannot exceed end time";
				document.getElementById("start_ss").focus();
				return false;
			}
			if (end_time > limit) {
				//console.log(end_time,"  ", limit);
				document.getElementById("warning2").innerHTML = "Please insert again";
				document.getElementById("end_ss").focus();
				return false;
			} else {
				/* if ($('#inputVideoID').val() > -1)
					return updateVideo(event); */
				return createVideo(event);
			}
		}
		function confirmSearch(){
			var result = confirm("선택하신 영상이 추가되었습니다.\n영상 추가를 더 원하신다면 확인 버튼을 눌러주세요. ");

			if(result){
				window.history.back();
			}
			else {
				window.location.href = 'main';
			}
		}
	</script>

	<div id="get_view"></div>

	<div id="nav_view"></div>


</body>
</html>

