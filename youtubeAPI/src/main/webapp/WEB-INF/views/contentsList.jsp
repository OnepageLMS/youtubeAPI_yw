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
		width: 40%;
	}
	
	.content{
		border: 1px solid lightslategrey;
		margin: 3px;
	}
</style>
</head>
<script 
  src="http://code.jquery.com/jquery-3.5.1.js"
  integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc="
  crossorigin="anonymous"></script>
<script>
$(document).ready(function(){
	var allContents = JSON.parse('${allContents}');
	console.log(allContents);

	for(var i=0; i<allContents.length; i++){
		var week = allContents[i].week - 1;
		var day = allContents[i].day - 1;
		var date = new Date(allContents[i].startDate.time); //timestamp -> actural time
		var startDate = date.getFullYear() + "-" + (date.getMonth()+1) + "-" + date.getDate() + " " + date.getHours() + ":" + date.getMinutes();

		var content = $('.week:eq(' + week + ')').children('.day:eq(' + day+ ')');
		content.append("<div class='content' seq='" + allContents[i].daySeq + "'>" 
				+ '<h4 class="title">' +  (allContents[i].daySeq+1) + " " + allContents[i].title + '</h4>'
				+ '<p class="startDate">' + "시작일: " + startDate + '</p>'
			 	+ '<p class="published">' + "공개: " + allContents[i].published + '</p>'
				+ "</div>");
	}
});
	

</script>
<body>
	<div class="contents" classID="${classInfo.id}">
		<c:forEach var="i" begin="1" end="${classInfo.weeks}">
			<div class="week" week="${i}">
				<h3>${i}주차</h3>
				<c:forEach var="j" begin="1" end="${classInfo.days}">
					<div class="day" day="${j}">${j} 차시
						<a href="../addContent/${classInfo.id}/${i}/${j}">+내용추가</a>
					</div>
				</c:forEach>
			</div>
		</c:forEach>

	</div>
</body>
</html>