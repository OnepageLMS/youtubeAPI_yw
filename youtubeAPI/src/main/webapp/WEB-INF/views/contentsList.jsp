<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>contentsList</title>
</head>
<body>
	<div class="contents">
		<c:forEach items="${classInfo}" var="u1" begin="0" end="${u.weeks}" varStatus="status">
			<div class="week" week="${status.index}">
				<h2>${status.index}</h2>
				<c:forEach var="u2" items="${classInfo}" begin="0" end="${u2.days}" varStatus=""/>
					<p class="day">${status2.index}</p>
				
			</div>
		</c:forEach>

	</div>
</body>
</html>