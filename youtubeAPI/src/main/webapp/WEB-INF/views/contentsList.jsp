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
$(document).ready(function(){
	var allContents = JSON.parse('${allContents}'); //class에 해당하는 모든 contents 가져오기
	console.log(allContents);

	for(var i=0; i<allContents.length; i++){
		var week = allContents[i].week - 1;
		var day = allContents[i].day - 1;
		var date = new Date(allContents[i].startDate.time); //timestamp -> actural time
		var startDate = date.getFullYear() + "-" + (date.getMonth()+1) + "-" + date.getDate() + " " + date.getHours() + ":" + date.getMinutes();

		var content = $('.week:eq(' + week + ')').children('.day:eq(' + day+ ')'); //한번에 contents를 가져왔기 때문에, 각 content를 해당 주차별 차시 순서에 맞게 나타나도록  
		var onclickDetail = "location.href='../contentDetail/" + allContents[i].id + "'";
		
		content.append("<div class='content' seq='" + allContents[i].daySeq + "' onclick=" + onclickDetail + " style='cursor: pointer;'>"
						+ '<p class="title"> <b>' +  (allContents[i].daySeq+1) + " " + allContents[i].title 
							+ '</b><a href="../editContent/' + allContents[i].id + '"> 수정</a>'
							+ '<a href="javascript:deleteCheck(' + allContents[i].classID +","+ allContents[i].id + ')"> 삭제</a>'
						+ '</p>'
						+ '<p class="startDate">' + "시작일: " + startDate + '</p>'
					 	+ '<p class="published">' + "공개: " + allContents[i].published + '</p>'
					+ "</div>");
	}
});

function deleteCheck(classID, id){
	var a = confirm("정말 삭제하시겠습니까?");
	if (a)
		location.href = '../deleteContent/' + classID + "/" + id;
}
	

</script>
<body>
	<div class="contents" classID="${classInfo.id}">
		<c:forEach var="i" begin="1" end="${classInfo.weeks}">
			<div class="week" week="${i}">
				<h3>${i}주차</h3>
				<c:forEach var="j" begin="1" end="${classInfo.days}">
					<div class="day" day="${j}">${j} 차시
						<a href="../addContent/${classInfo.id}/${i}/${j}">+페이지추가</a>
					</div>
				</c:forEach>
			</div>
		</c:forEach>

	</div>
</body>
</html>