<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MyPlaylist</title>
<style>
	.myPlaylist{
		width: 30%;
	}
</style>
</head>
<script 
  src="http://code.jquery.com/jquery-3.5.1.js"
  integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc="
  crossorigin="anonymous"></script>
<script>
	function getAllVideo(displayIdx, playlistID){ //해당 playlistID에 해당하는 비디오들을 가져온다
		$.ajax({
			type:'post',
		    url : 'http://localhost:8080/myapp/class/getOnePlaylist',
		    data : {id : playlistID},
		    success : function(result){
			    videos = result.allVideo;
			    $('#allVideo').empty();
			    
			    var lastIdx = $('#allVideo').attr('displayIdx');
			    $('.playlist:eq(' + lastIdx + ')').css("background-color", "unset");
			    
			    $.each(videos, function( index, value ){ 
				    var title = value.title;
			    	if (title.length > 40){
						title = title.substring(0, 50) + " ..."; 
					}
					
					var html = '<div class="video" onclick=openSavedVideo(this) '
					//+ ' playlistSeq="' + playlistSeq
					+ '" videoID="' + value.id 
					+ '" youtubeID="' + value.youtubeID 
					+ '" start_s="' + value.start_s
					+ '" end_s="' + value.end_s + '" tag="' + value.tag + '" > ' + (value.seq+1) + ". " + title
					+ '<a href="#" class="aDeleteVideo" onclick="deleteVideo(' displayIdx + ', '
						+ value.id + ')"> 삭제</a>'
					+ '</div>';

					$('#allVideo').append(html); 
				});
				
				$('#allVideo').attr('displayIdx', displayIdx);
				//if ($("#createVideoForm").css('display') === 'block') //video 추가할 Playlist 선택칸 보여주기
				$(".playlist:eq(" + displayIdx + ")").css("background-color", "lightgrey");
			}
		});
	}

	function deleteVideo(displayIdx, videoID){ // video 삭제
		//var playlistID = $(".video")[playlistSeq].getAttribute('listid');

		if (confirm("정말 삭제하시겠습니까?")){
			$.ajax({
				'type' : "post",
				'url' : "http://localhost:8080/myapp/deleteVideo",
				'data' : {	video : videoID,
							playlist : playlistID
					},
				success : function(data){
					changeAllVideo(playlistSeq, videoID); //삭제한 videoID도 넘겨줘야 함.
			
				}, error : function(err){
					alert("video 삭제 실패! : ", err.responseText);
				}

			});
		}

	}
</script>
<body>	
	<div class="nav">
		<button>내 컨텐츠</button>
		<button>LMS내 컨텐츠</button>
		<button>영상추가</button>
	</div>
	
	
	<div class="myPlaylist">
		<h2>MyPlaylist</h2>
		<c:forEach items="${playlist}" var="u" varStatus="status">
			<div class="playlist" playlistID="${u.playlistID}" onclick="getAllVideo(${status.index}, ${u.playlistID})">
				<p>${status.count}. ${u.playlistName} /총 ${u.totalVideo}개 영상</p>
			</div>
		</c:forEach>
	</div>
	
	<div id="selectedPlaylist"></div>
	<div id="allVideo"></div>
	

</body>
</html>