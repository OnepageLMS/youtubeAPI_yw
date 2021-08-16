<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>contentDetail</title>
<style>
	.content{
		padding: 10px;
		width: 50%;
	}
	
	.selectContent{
		padding: 5px;
		border: 2px solid lightgrey;
		width: 60%;
	}
</style>
</head>
<script 
  src="http://code.jquery.com/jquery-3.5.1.js"
  integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc="
  crossorigin="anonymous"></script>
 <script>
 $(document).ready(function(){
		displayDates('${vo.startDate}', '.startDate');
		displayDates('${vo.endDate}', '.endDate');
 });

 function displayDates(fulldate, name){
	 var monthToNumber = {'Jan':'01', 'Fab':'02', 'Mar':'03', 'Apr':'04', 'May':'05', 'Jun':'06', 
				'Jul':'07', 'Aug':'08', 'Sep':'09', 'Oct':'10', 'Nov':'11', 'Dec':'12'};
		
	 var end = fulldate.split(' ');
	 var day = end[5] + "-" + monthToNumber[end[1]] + "-" + end[2];
	 var end2 = end[3].split(':');
	 var time = end2[0] + ":" + end2[1];
	 $(name).append('<p>' + day + " " + time + '</p>');
}

 </script>
<body>
	<div class="content">
		<div class="selectContent">
			<div id="selectedContent">
				<p>playlist 총 재생시간 및 각 비디오시간 출력!</p>
				<p>${vo.playlistID}번 playlist 정보 여기에</p>
			</div>
		</div>
		
		<div class="title">
			<p>제목: ${vo.title}</p>
		</div>
		
		<div class="description">
			<p>설명</p>
			<p>${vo.description}</p>
		</div>
		
		<div class="endDate">
			<p>마감일</p>
		</div>
		
		<div class="startDate"> 
			<p>공개일</p>
		</div>
	</div>
</body>
</html>