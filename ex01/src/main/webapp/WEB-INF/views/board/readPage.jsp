<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page session="false"%>
<%@ include file="../include/header.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript"
	src="/resources/plugins/jQuery/jQuery-2.1.4.min.js"></script>
<script>
	$(document).ready(function() {
		var formObj = $("form[role='form']");

		console.log(formObj);

		$(".btn-warning").on("click", function() {
			formObj.attr("action", "/board/modify");
			formObj.attr("method", "get");
			formObj.submit();
		});

		$(".btn-danger").on("click", function() {
			console.log("삭제");
			formObj.attr("action", "/board/remove");
			formObj.submit();
		});

		$(".btn-primary").on("click", function() {
			self.location = "/board/listAll";
		});
		
		$(".goListBtn").on("click", function(){
			formObj.attr("method", "get");
			formObj.attr("action","/board/listPage");
			formObj.submit();
		});
		
		$(".removeBtn").on("click", function(){
			formObj.attr("action","/board/removePage" );
			formObj.submit();
		});
		$(".modifyBtn").on("click",function(){
			formObj.attr("action","/board/modifyPage");
			formObj.attr("method", "get");
			formObj.submit();
		})
	});
</script>
<title>Insert title here</title>
</head>
<body>
	<form role="form" method="post">
		<input type='hidden' name='bno' value="${boardVO.bno }">
	</form>

	<div class="box-footer">
		<button type="submit" class="btn btn-warning modifyBtn">Modify</button>
		<button type="submit" class="btn btn-danger removeBtn">REMOVE</button>
		<button type="submit" class="btn btn-primary goListBtn">LIST
			ALL</button>
	</div>

	<div class="box-body">
		<div class="form-group">
			<label for="exampleInputEmail1">Title</label> <input type="text"
				name='title' class="form-control" value="${boardVO.title }"
				readonly="readonly">
		</div>
		<div class="form-group">
			<label for="exampleInputPassword1">Content</label>
			<textarea class="form-control" name="content" rows="3"
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
			type='hidden' name='perPageNum' value="${cri.perPageNum}">
	</form>


</body>
<%@ include file="../include/footer.jsp"%>
</html>