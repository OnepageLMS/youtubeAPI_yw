<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>find youtube video</title>
</head>
<body>

	<form action="search">
		검색창 <input type="text" name="keyword"
			placeholder="For example: tom brady" /> <input type="submit"
			name="submit" />
	</form>

	<h2>검색 결과</h2>
	<div class="resultlist">
		<table>
			<tr>
				<td>title</td>
				<td>description</td>
				<td>URL</td>
				<td>publishDate</td>
			</tr>
			<c:forEach var="v" items="${videos}">
				<tr>
					<td>${v.title}</td>
					<td>${v.description}</td>
					<td>${v.url}</td>
					<td>${v.publishDate}</td>
				</tr>
			</c:forEach>
		</table>

	</div>

</body>
</html>