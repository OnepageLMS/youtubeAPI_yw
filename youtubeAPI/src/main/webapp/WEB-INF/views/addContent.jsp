<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>addContent</title>
<style>
	.selectContent{
		border: 1px solid lightgrey;
		padding: 10px;
		text-align: center;
		width: 60%;
	}
	.setTime{
		width: 50px;
	}
</style>
<script 
  src="http://code.jquery.com/jquery-3.5.1.js"
  integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc="
  crossorigin="anonymous"></script>
<script>
	$(document).ready(function(){

		//아래부분 마감일 설정때 나오도록...?
		var timezoneOffset = new Date().getTimezoneOffset() * 60000;
		var date = new Date(Date.now() - timezoneOffset).toISOString().split("T")[0]; //set local timezone
		endDate.min = date;
		//endDate.value = date;
		startDate.min = date;
		startDate.value = date;
		
	    $("#addContent").submit(function(){ //when submit the form, check the validation
	          
	        var date = $('#startDate').val().split("-");
	        var hour = $('.start_h').val();
	        var min = $('.start_m').val();
	        var startDate = new Date(date[0], date[1]-1, date[2], hour, min, 00);

	        if ($('#endDate').val() == null){
				alert("마감일을 설정해주세요!");
				$('#endDate').focus();
		    }

	        var e_date = $('#endDate').val().split("-");
	        var e_hour = $('.end_h').val();
	        var e_min = $('.end_m').val();
	        var endDate = new Date(e_date[0], e_date[1]-1, e_date[2], e_hour, e_min, 00);

	        if(startDate.getTime() >= endDate.getTime()) {
	            alert("컨텐츠 마감일보다 게시일이 빨라야 합니다.");
		        $('#startDate').focus();
	            return false;
	        }

	        if ($('input[name=title]').val() == null){
				alert("제목을 입력해주세요!");
				$('input[name=title]').focus();
				return false;
		    }
		        
	        else{
				$('input[name=endDate]').val(endDate);
				$('input[name=startDate]').val(startDate);
		    }
	    }); 
	}); // end ready()

	function getCurrentTime(){
		var timezoneOffset = new Date().getTimezoneOffset() * 60000;
		var date = new Date(Date.now() - timezoneOffset).toISOString().split("T")[0]; //set local timezone
		startDate.value = date;
		
		var hour = new Date().getHours();
		var min = new Date().getMinutes();
		$('.start_h').val(hour);
		$('.start_m').val(min);
		console.log(hour, min);
	}

	function addCancel(id) {
		var a = confirm("등록을 취소하시겠습니까?");
		if (a)
			location.href = '${pageContext.request.contextPath}/class/contentList/' + id;
	}

	function popupOpen(){
		if ($('#inputPlaylistID').val() >= 0){
			console.log($('#inputPlaylistID').val());
			if('이미 선택한 Playlist가 있습니다. 새로 바꾸시겠습니까?'){
				//$('#playlistThubmnail').empty();
			}
			else {
				return false;
			}
		}
		
		var myEmail = "yewon.lee@onepage.edu"; //이부분 나중에 로그인 구현하면 로그인한 정보 가져오기
		var url = "${pageContext.request.contextPath}/playlist/myPlaylist/" + myEmail;
		var popOption = "width=500, height=600";
		var p = window.open(url, "myPlaylist", popOption);
		p.focus();
	}

</script>
</head>

<body>
	
	
	<form id="addContent" action="../../../addContentOK" method="post">
		<input type="hidden" name="classID" value="${content.classID}"/>
		<input type="hidden" name="day" value="${content.day}"/>
		
		<div class="selectContent">
			<div id="selectedContent">
				<div id="playlistThubmnail"></div>
				<p id="playlistTitle">Playlist를 선택해주세요 </p>
			</div>
			<button type="button" id="selectPlaylistBtn" onclick="popupOpen();">playlist가져오기</button>
			<input type="hidden" name="playlistID" id="inputPlaylistID">
			<input type="hidden" name="thumbnailID" id="inputThumbnailID" value="${vo.thumbnailID}">
		</div>
		
		<div class="inputTitle">
			<label for="title">제목: </label>
			<input type="text" name="title">
		</div>
		
		<div class="inputDescription">
			<label for="description">설명: </label>
			<textarea name="description" cols="50" rows="10"></textarea>
		</div>
		
		<div class="setEndDate">
			<label for="endDate"> 마감일: </label>
			<input type="hidden" name="endDate">
			<input type="date" id="endDate"> 
			<input type="number" class="setTime end_h" value="0" min="0" max="23"> 시
			<input type="number" class="setTime end_m" value="0" min="0" max="59"> 분
		</div>
		
		<div class="setStartDate">
			<label for="startDate">공개일: </label>
			<input type="hidden" name="startDate">
			<input type="date" id="startDate">
			<input type="number" class="setTime start_h" value="0" min="0" max="23"> 시
			<input type="number" class="setTime start_m" value="0" min="0" max="59"> 분
			<button type="button" onclick="location.href='javascript:getCurrentTime()'">지금</button>
		</div>
		
	</form>
	
	<button onclick="location.href='javascript:addCancel(${content.classID})'">취소</button>
	<button type="submit" form="addContent">저장</button>

</body>
</html>