<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page session="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="../include/header.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<script type="text/javascript">
	$(document).ready(function() {
		var formObj = $("form[role='form']");

		console.log(formObj);

		$(".modifyBtn").on("click", function() {
			formObj.attr("action", "/board/modifyPage");
			formObj.attr("method", "get");
			formObj.submit();
		});
		$(".removeBtn").on("click", function() {
			formObj.attr("action", "/board/removePage");
			formObj.submit();
		});
		$(".btn-primary").on("click", function() {
			self.location = "/board/listAll";
		});
		$(".goListBtn").on("click", function(){
			formObj.attr("method","get");
			formObj.attr("action", "/board/listPage");
			formObj.submit();
		});
	});
</script>
<body>

	<div class="box-footer">
		<button type="submit" class="btn btn-wrning modifyBtn">Modify</button>
		<button type="submit" class="btn btn-danger removeBtn">REMOVE</button>
		<button type="submit" class="btn btn-primary goListBtn">LIST ALL</button>
	</div>

	<form role="form" method="post">
		<input type='hidden' name='bno' value="${boardVO.bno }">
	</form>

	<div class="box-body">
		<div class="form-group">
			<label for="exampleInputEmail1">Title</label> <input type="text"
				name='title' class="form-control" value="${boardVO.title }"
				readonly="readonly">
		</div>
		<div class="form-group">
			<label for="exampleInputPassword1">Content</label>
			<textarea name="content" class="form-control" rows="3"
				readonly="readonly">${boardVO.content }</textarea>
		</div>
		<div class="form-group">
			<label for="exampleInputEmail1">Writer</label> <input type="text"
				name="writer" class="form-control" value="${boardVO.writer }"
				readonly="readonly">
		</div>
	</div>
	<!-- /.box-body -->

	<form role="form" action="modifyPage" method="post">

		<input type='hidden' name='bno' value="${boardVO.bno }"> <input
			type='hidden' name='page' value="${cri.page }"> <input
			type='hidden' name='perPageNum' value="${cri.perPageNum }">
	</form>
	<%@ include file="../include/footer.jsp"%>
</body>
</html>