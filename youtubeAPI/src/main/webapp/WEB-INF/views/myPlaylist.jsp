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
		width: 250px;
		float: left;
		border: 2px solid lightgrey;
		padding: 5px;
	}
	
	.selectedPlaylist{
		display: flex;
		float: right;
		width: 75%;
		background-color: #F0F0F0;
		min-height: 700px; /*responsive로 할때 수정하기*/
		padding: 5px;
	}
	
	.playlist {
		margin: 5px;
	}
	
	.playlist:hover{
		background-color: lightgrey;
		cursor: pointer;
	}
	
	.playlist > p{
		display: inline;
	}
	
	.playlistPic {
		width: 300px;
	}
	
	#playlistInfo {
		display: inline;
		margin: 5px;
		width: 30%;
	}
	
	#allVideo {
		display: inline;
		margin: 5px;
		width: 70%;
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
	
	.video{
		
	}
	
	.video:hover {
		background-color: lightgrey;
	}

	.videoIndex {
		display: inline;
		float: left;
		width: 20px;
		background-color: lightgrey;
		height: 80px;
	}
	
	.videoIndex > p{
		display: inline;
	}
	
	.videoContent:hover{
		cursor: pointer;
	}
	
	.thumbnailBox{
		display: inline-grid;
	}
	
	.duration{
		text-align: center;
		margin: 3px;
	}
	
	.videoPic {
		width: 120px;
		height: 70px;
		padding: 5px;
	}
	
	.titles {
		display: inline;
		float: right;
		width: 75%;
	}
	
	.videoNewTitle{
		font-size: 16px;
		margin: 3px 0;
		font-weight: bold;
	}
	
	.videoOriTitle {
		font-size: 13px;
		margin: 0;
	}
	
	.tag {
		font-size: 13px;
		color: #0033CC;
	}
	
	.aDeleteVideo{ /*button*/

		
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
	function convertTime(timestamp){ //timestamp형식을 사용자에게 보여주기
		var date = new Date(timestamp- 540*60*1000); //GMT로 돼서 강제로 바꿔주기.. 이렇게 안하면 db설정을 바꿔야하는데 우리는 불가함.
		var dd_mm_yyyy = date.toLocaleDateString();
		var yyyy_mm_dd = dd_mm_yyyy.replace(/(\d+)\/(\d+)\/(\d+)/g, "$3-$2-$1");
		/*
		var d = new Date(timestamp), // Convert the passed timestamp to milliseconds
	        yyyy = d.getFullYear(),
	        mm = ('0' + (d.getMonth() + 1)).slice(-2),  // Months are zero based. Add leading 0.
	        dd = ('0' + d.getDate()).slice(-2),         // Add leading 0.
	        hh = d.getHours(),
	        h = hh,
	        min = ('0' + d.getMinutes()).slice(-2),     // Add leading 0.
	        ampm = 'AM',
	        time;
            
        if (hh > 12) {
            h = hh - 12;
            ampm = 'PM';
        } else if (hh === 12) {
            h = 12;
            ampm = 'PM';
        } else if (hh == 0) {
            h = 12;
        }
        
        // ie: 2013-02-18, 8:35 AM  
        time = yyyy + '년' + mm + '월' + dd + '일' + h + ':' + min + ' ' + ampm;
            */
        return yyyy_mm_dd;
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
	
	function getPlaylistInfo(playlistID, displayIdx){ //선택한 playlistInfo 가져오기
		$.ajax({
			type : 'post',
			url : '${pageContext.request.contextPath}/playlist/getPlaylistInfo',
			data : {playlistID : playlistID},
			datatype : 'json',
			success : function(result){
				var lastIdx = $('#playlistInfo').attr('displayIdx'); //새로운 결과 출력 위해 이전 저장된 정보 비우기
			    $('.playlist:eq(' + lastIdx + ')').css("background-color", "unset");
			    $(".playlist:eq(" + displayIdx + ")").css("background-color", "lightgrey"); //클릭한 playlist 표시
			    $('#playlistInfo').empty(); 

			    $('.selectedPlaylist').attr('playlistID', playlistID); //혹시 나중에 사용할 일 있지 않을까?
			    
			    var thumbnail = '<img src="https://img.youtube.com/vi/' + result.thumbnailID + '/0.jpg" class="playlistPic">'
			    				+ '<button id="playAllVideo" onclick="">playlist 전체재생</button>';
			    $('#playlistInfo').append(thumbnail);
			    
				var name = '<div class="playlistName">'
								+ '<p id="displayPlaylistName" style="display:inline";>' + result.playlistName + '</p>'
								+ '<input type="text" id="inputPlaylistName" style="display:none;">'
								+ '<button onclick="showEditPlaylistName()" style="display:inline;">수정</button>'
								+ '<div class="editPlaylistNameButtons"></div>'
						+ '</div>';
			    $('#playlistInfo').append(name); //중간영역
			    
				var modDate = convertTime(result.modDate);
				var totalVideoLength = convertTotalLength(result.totalVideoLength);
				var description = result.description;
				if (result.description == null)
					description = "설명 없음";

				var info = '<div class="info">' 
								+ '<div>'
									+ '<p class="totalInfo"> 총 영상 <b>' + result.totalVideo + '개</b></p>'
									+ '<p class="totalInfo"> 총 재생시간 <b>' + totalVideoLength + '</b></p>'
								+ '</div>'
								+ '<p> 업데이트 <b>' + modDate + '</b> </p>'
								+ '<div class="description">'
									+ '<p id="displayDescription">' + description + '</p>'
									+ '<input type="text" id="inputDescription" style="display:none";>'
									+ '<button onclick="showEditDescription()">수정</button>'
									+ '<div class="editDescriptionButtons"></div>'
								+ '</div>'
							+ '</div>';
							
				$('#playlistInfo').append(info);
			    $('#playlistInfo').attr('displayIdx', displayIdx); //현재 오른쪽에 가져와진 playlistID 저장

				getAllVideo(playlistID); //먼저 playlist info 먼저 셋팅하고 videolist 가져오기
			}
		});
		
	}

	function getAllVideo(playlistID){ //해당 playlistID에 해당하는 비디오들을 가져온다
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

			    	var thumbnail = '<img src="https://img.youtube.com/vi/' + value.youtubeID + '/0.jpg" class="inline videoPic">';

			    	if (value.tag != null && value.tag.length > 0){
				    	var tags = value.tag.replace(', ', ' #');
			    		tags = '#'+ tags;
			    	}
			    	else 
				    	var tags = ' ';

			    	var address = "'../../video/watch/" + value.playlistID + '/' + value.id + "'";
			    	
			    	if (index == 0){
				    	var forButton = 'location.href=' + address + '';
						$("#playAllVideo").attr("onclick", forButton);
					} 
					
					var html = '<div class="video" videoID="' + value.id + '">'
									+ '<div class="videoIndex">  <p>' + (value.seq+1) + '</p></div>'
									+ '<div class="videoContent" onclick="location.href=' + address + '" videoID="' + value.id + '" youtubeID="' + value.youtubeID + '" >'
										+ '<div class="thumbnailBox">' 
											+ thumbnail 
											+ '<p class="duration" > 재생시간 ' + convertTotalLength(value.duration) + '</p>'
										+ '</div>'
										+ '<div class="titles">'
											+ '<p class="tag" class="inline">' + tags + '</p>'
											+ '<p class="videoNewTitle">' + newTitle + '</p>'
											+ '<p class="videoOriTitle">' + title + '</p>'
										+ '</div>'
									+'</div>'
									+ '<button href="#" class="aDeleteVideo" onclick="deleteVideo(' + value.id + ')"> 삭제</button>'
								+ '</div>'
								+ '<div class="videoLine"></div>';

					$('#allVideo').append(html); 
				});
			}
		});
	}

	function changeAllVideo(deletedID){ // video 추가, 삭제, 순서변경 뒤 해당 playlist의 전체 video order 재정렬
		var playlistID = $('.selectedPlaylist').attr('playlistID');
		var idList = new Array();
	
		$('.video').each(function(){
			var tmp = $(this)[0];
			var tmp_videoID = tmp.getAttribute('videoID');

			if (deletedID != null){ // 이 함수가 playlist 삭제 뒤에 실행됐을 땐 삭제된 playlistID	 제외하고 재정렬 (db에서 삭제하는것보다 list가 더 빨리 불러와져서 이렇게 해줘야함)
				if (deletedID != tmp_videoID)
					idList.push(tmp_videoID);
			}
			else
				idList.push(tmp_videoID);
		});
		
		$.ajax({
		      type: "post",
		      url: "${pageContext.request.contextPath}/video/changeVideosOrder", //새로 바뀐 순서대로 db update
		      data : { changedList : idList },
		      dataType  : "json", 
		      success  : function(data) {
		  	  		getAllVideo(playlistID); //새로 정렬한 뒤 video 새로 불러와서 출력하기
		    	  
		      }, error:function(request,status,error){
			      console.log("error");
		    	  //getAllVideo(playlistSeq); 
		       }
		    });
	}

	function deleteVideo(videoID){ // video 삭제
		var playlistID = $('.selectedPlaylist').attr('playlistID');
		changeAllVideo(videoID);
		console.log("deleteVideo: " + videoID + ":" + playlistID);

		if (confirm("정말 삭제하시겠습니까?")){
			$.ajax({
				'type' : "post",
				'url' : "${pageContext.request.contextPath}/video/deleteVideo",
				'data' : {	videoID : videoID,
							playlistID : playlistID
					},
				success : function(data){
					changeAllVideo(videoID); //삭제한 videoID 넘겨줘야 함.
			
				}, error : function(err){
					alert("video 삭제 실패! : ", err.responseText);
				}

			});
		}
	}

	function savePlaylistName(){ //playlist name 수정
		var playlistID = $('.selectedPlaylist').attr('playlistID');
		var name = $("#inputPlaylistName").val();

		$.ajax({
			'type' : 'post',
			'url' : '${pageContext.request.contextPath}/playlist/updatePlaylistName',
			'data' :{
					'playlistID' : playlistID,
					'name' : name
				},
			success :function(data){
				$("#displayPlaylistName").text(data);
				hideEditPlaylistName();
			}
		});
	}

	function showEditPlaylistName(){
		$("#displayPlaylistName").css("display", "none");
		$(".playlistName").children('button').css("display", "none");
		
		var value = $("#displayPlaylistName").text();
		
		$("#inputPlaylistName").val(value);
		$("#inputPlaylistName").css("display", "inline");
		
		var buttons = '<button onclick="hideEditPlaylistName()">취소</button>' 
						+ '<button onclick="savePlaylistName();">확인</button>';
		$(".editPlaylistNameButtons").append(buttons);
	}

	function hideEditPlaylistName(){
		$(".editPlaylistNameButtons").empty(); 
		$("#inputPlaylistName").css("display", "none");
		
		$("#displayPlaylistName").css("display", "inline");
		$(".playlistName").children('button').css("display", "inline");
	}

	function saveDescription(){ //description 수정
		var playlistID = $('.selectedPlaylist').attr('playlistID');
		var description = $("#inputDescription").val();

		$.ajax({
			'type' : 'post',
			'url' : '${pageContext.request.contextPath}/playlist/updatePlaylistDesciption',
			'data' :{
					'playlistID' : playlistID,
					'description' : description
				},
			success :function(data){
				$("#displayDescription").text(data);
				hideEditDescription();
			}
		});
		
	}

	function hideEditDescription(){
		$(".editDescriptionButtons").empty();
		$("#inputDescription").css("display", "none");
		
		$("#displayDescription").css("display", "block");
		$(".description").children('button').css("display", "block");
	}

	function showEditDescription(){ //playlist설명 수정
		$("#displayDescription").css("display", "none");
		$(".description").children('button').css("display", "none");

		var value = $("#displayDescription").text();
		if (value != "설명 없음")
			$("#inputDescription").val(value);

		$("#inputDescription").css("display", "block");
		
		var buttons = '<button onclick="hideEditDescription()">취소</button>' 
						+ '<button onclick="saveDescription();">확인</button>';
		$(".editDescriptionButtons").append(buttons);
		
	}

	function selectOK(){
		var playlistID = $('input:radio[name="check"]:checked').val();
		
		if(playlistID){
			$('#inputPlaylistID', opener.document).val(playlistID); //부모페이지에 선택한 playlistID 설정
			$('#playlistTitle', opener.document).text(playlistID + "번 playlist 선택됨");
			
			if (confirm('playlist가 선택되었습니다. 현재 창을 닫으시겠습니까?')){
				self.close();
			}
		}
		else {
			alert('playlist를 선택해주세요');
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
				<!-- playlist 검색 구현하기 -->
				<input type="text" name="search" placeholder="playlist 검색">
				<button type="button">검색</button>
				
			 	<c:forEach items="${playlist}" var="u" varStatus="status">
					<div class="playlist" onclick="getPlaylistInfo(${u.playlistID}, ${status.index});">
						<input type="radio" name="check" value="${u.playlistID}" />
						<p class="playlistSeq">${status.count}. </p>
						<p class="selectPlaylistName">${u.playlistName}
						<p class="totalVideo">${u.totalVideo}</p>개 영상
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