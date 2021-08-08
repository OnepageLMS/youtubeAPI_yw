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
		width: 20%;
		float: left;
		border: 2px solid lightgrey;
		padding: 5px;
	}
	
	.selectedPlaylist{
		display: flex;
		float: right;
		width: 70%;
	}
	
	.playlist {
		margin: 5px;
	}
	
	.playlist > p{
		display: inline;
	}
	
	#playlistInfo {
		display: inline;
		margin: 10px;
		width: 40%;
	}
	
	#allVideo {
		display: inline;
		margin: 10px;
		width: 60%;
	}
</style>
</head>
<script 
  src="http://code.jquery.com/jquery-3.5.1.js"
  integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc="
  crossorigin="anonymous"></script>
<script>
	function getPlaylistInfo(playlistID, displayIdx){ //선택한 playlistInfo 가져오기
		
	}

	function getAllVideo(playlistID, displayIdx){ //해당 playlistID에 해당하는 비디오들을 가져온다
		$.ajax({
			type:'post',
		    url : 'http://localhost:8080/myapp/class/getOnePlaylist',
		    data : {id : playlistID},
		    success : function(result){
			    videos = result.allVideo;
			    
			    var lastIdx = $('#playlistInfo').attr('displayIdx'); //새로운 결과 출력 위해 이전 저장된 정보 비우기
			    $('.playlist:eq(' + lastIdx + ')').css("background-color", "unset");
			    $('#playlistInfo').empty(); 
			    $('#allVideo').empty();

			    //var name = '<h3>' + playlistName + '</h3>';
			    //$('#playlistInfo').append(name); //중간영역
			    $('#playlistInfo').attr('displayIdx', displayIdx); //현재 오른쪽에 가져와진 playlistID 저장
			        
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
					+ '<a href="#" class="aDeleteVideo" onclick="deleteVideo(' + displayIdx + ', '
						+ value.id + ')"> 삭제</a>'
					+ '</div>';

					$('#allVideo').append(html); 
				});
				
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

	function close_window(){ //playlist 선택완료하면 window 닫기
		self.close();
	}

	function selectOK(){
		var playlistID = $('input:radio[name="check"]:checked').val();
		
		if(playlistID){
			$('#inputPlaylistID', opener.document).val(playlistID); //부모페이지에 선택한 playlistID 설정
			$('#playlistTitle', opener.document).text(playlistID + "번 playlist 선택됨");
			
			if (confirm('창을 닫으시겠습니까?')){
				close_window();
			}
		}
		else {
			alert('playlist를 선택해주세요!');
			return false;
		}
			
	}
</script>
<body>	
	<div class="nav">
		<button>내 컨텐츠</button>
		<button>LMS내 컨텐츠</button>
		<button>영상추가</button>
	</div>
	
	<h2>MyPlaylist</h2>
	<div class="myPlaylist">
		<c:choose>
			<c:when test = "${empty playlist}">
			 	저장된 playlist가 없습니다. 새로 만들어주세요.
			</c:when>
			<c:when test = "${!empty playlist}">
			 	<c:forEach items="${playlist}" var="u" varStatus="status">
					<div class="playlist" onclick="getPlaylistInfo(${u.playlistID}, ${status.index}); getAllVideo(${u.playlistID}, ${status.index})">
						<input type="radio" name="check" value="${u.playlistID}" />
						<p>${status.count}. ${u.playlistName} /총 ${u.totalVideo}개 영상</p>
					</div>
				</c:forEach>
				<button class="selectOK" onclick="selectOK()">선택완료</button>
			</c:when>
		</c:choose>
		
	</div>
	
	<div class="selectedPlaylist">
		<div id="playlistInfo"></div>
		<div id="allVideo"></div>
	</div>
	
	

</body>
</html>