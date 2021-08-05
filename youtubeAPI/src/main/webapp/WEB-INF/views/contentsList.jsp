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
</style>
</head>
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