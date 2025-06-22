<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>게시글 작성</title>
<link rel="stylesheet" href="./../css/boardViewFrame.css">
<link rel="icon" href="../img/favicon.ico" type="image/x-icon">
</head>
<body>

	<h2>** 게시글 작성 **</h2>

	<form action="boardInsert.jsp" method="post">
		<div class="menu">
			<p>
				<span style="cursor: pointer;"
					onclick="location.href='boardTitleListPaging.jsp'">[ 목록 ]</span>
			</p>
		</div>
		<table>
			<tr>
				<td class="label">제목</td>
				<td><input type="text" name="title" class="input" required></td>
			</tr>
			<tr>
				<td class="label">작성자</td>
				<td><input type="text" name="writer" class="input" required></td>
			</tr>
			<tr>
				<td rowspan="2" class="label image-cell"><img
					src="../img/side.jpg" alt="Side Image"></td>
				<td><textarea name="content" class="input full" required></textarea></td>
			</tr>
		</table>
		<div class="buttons">
			<button type="submit">등록</button>
			<button type="reset">다시쓰기</button>
		</div>
	</form>

</body>
</html>
