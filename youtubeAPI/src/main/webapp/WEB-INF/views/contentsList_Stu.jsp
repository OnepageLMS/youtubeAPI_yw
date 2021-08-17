<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>contentsList</title>
<style>
	.contents{
		padding: 10px;
	}
	
	.week{
		border: 2px solid lightslategrey;
		padding: 5px;
		margin: 5px;
		width: 50%;
	}
	
	.content{
		border: 1px solid lightslategrey;
		margin: 3px;
		padding-left: 5px;
	}
	
	.title {
		font-size: 16px;
	}
	
	a{
		text-decoration: none;
	}
	
	
		
</style>
</head>
<script 
  src="http://code.jquery.com/jquery-3.5.1.js"
  integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc="
  crossorigin="anonymous"></script>
<script>
	var playlistcheck;
	var playlist;
	var total_runningtime;
	$(document).ready(function(){
		
		var allContents = JSON.parse('${allContents}');
		var weekContents = JSON.parse('${weekContents}');
		playlistcheck = JSON.parse('${playlistCheck}'); //progress bar를 위해
		playlist = JSON.parse('${playlist}'); //total 시간을 위해
		total_runningtime = 0;
		
		var classInfo = document.getElementsByClassName( 'contents' )[0].getAttribute( 'classID' );
		
		console.log("classID는 다음과 같습니다. " + classInfo);
		console.log("length : " +weekContents.length );
		var week;
		
	 		for(var i=0; i<weekContents.length; i++){
	 			console.log("youtubeID : " +weekContents[i].thumbnailID + " / playlistID : " + weekContents[i].playlistID + " week " +  weekContents[i].week + " day " +  weekContents[i].day + " / title : " + weekContents[i].title );
				var thumbnail = '<img src="https://img.youtube.com/vi/' + weekContents[i].thumbnailID + '/1.jpg">';
					week = weekContents[i].week -1 ;
				var day = weekContents[i].day - 1;
				var date = new Date(weekContents[i].startDate.time); //timestamp -> actural time
				
				var result_date = convertTotalLength(date);
				
				var startDate = date.getFullYear() + "-" + (date.getMonth()+1) + "-" + date.getDate() + " " + date.getHours() + ":" + date.getMinutes();
				
				var onclickDetail = "location.href='../contentDetail/" + weekContents[i].playlistID + "/" +weekContents[i].id + "/" +classInfo+  "'";
				
				//var content = $('.week:eq(' + week + ')').children('.day:eq(' + day+ ')');
				var content = $('.day:eq(' + day + ')');
				//if(i>0){
					if(i==0 || weekContents[i-1].playlistID != weekContents[i].playlistID){ //강의리스트에서는 플레이리스트의 첫번째 영상 썸네일만 보이도록
					content.append("<div  class='content' seq='" + weekContents[i].daySeq + "' onclick=" + onclickDetail + " style='cursor: pointer;'>"
							+ '<p class="title"> <b>' +  (weekContents[i].daySeq+1) + " " + weekContents[i].title + '</b>' + '</p>'
							+ '<p class="startDate">' + "시작일: " + startDate + '</p>'
						+ thumbnail + "youtubeID : " +weekContents[i].thumbnailID +  " week " +  weekContents[i].week 
						+ " day " + weekContents[i].day +  " seq " + weekContents[i].seq 
						+ " playlistID " + weekContents[i].playlistID +  " id " + weekContents[i].id + "<div id='myProgress'><div id='myBar'></div></div> </div>");
					}
				//}
				
				//$("#weekContents").append(thumbnail +'<div> ' + weekContents[j].newTitle + '</div>');
				//이제 클릭했을 때 해당하는 플레이리스트가 띄워지도록!
				//클릭했을 때 ajax를 통해서 playlistID를 넘겨주기 (x) -> 페이지 이동이 일어나야하는데
				//깃헙머지
			}
	 		
	 		
	 		for(var j=0; j<playlist.length; j++){
	 			total_runningtime += parseInt(playlist[j].duration);
	 		}
	 		
	});
	
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
	
	function toggle(e){
		var idx = $(e).attr('week');
		console.log("idx : " + idx);
		$(e).on("click", function(){
			$('.week:eq(' + (idx-1) + ')').toggle("1000", "linear");
		});
	}
	
</script>
<body>	
	<div class="contents" classID="${classInfo.id}">
		
			
				<c:forEach var="j" begin="1" end="${classInfo.days}">
					<div class="day" day="${j}">${j} 차시
						
					</div>
				</c:forEach>
		

	</div>
</body>
</html>