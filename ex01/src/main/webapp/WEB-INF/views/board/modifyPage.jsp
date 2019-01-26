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
<script type="text/javascript" src="/resources/plugins/jQuery/jQuery-2.1.4.min.js"></script>
<title>Insert title here</title>
<script type="text/javascript">
$(document).ready(function(){
	
	var formObj=$("form[role='form']");
	
	console.log(formObj);
	
	$(".btn-warning").on("click", function(){
		self.location = "/board/listAll";
	});
	
	$(".btn-primary").on("click", function(){
		formObj.submit();
	});
	
	
});
</script>
</head>
<body>
<form role="form" method="post">
<div class="box-body">
	<div class="form-group">
		<label for="exampleInputEmail1">BNO</label>
		<input type="text" name='bno' class="form-control" value="${boardVO.bno }" readonly = "readonly">
	</div>
	
	<div class="form-group">
		<label for = "exmpleInputEmail1">Title</label>
		<input type="text" name = 'title' class="form-control" value="${boardVO.title }">
	</div>
	
	<div class="form-group">
		<label for = "exampleInputPassword1">Title</label>
		<textarea rows="3" class="form-control" name="content">${boardVO.content }</textarea>
	</div>
	
	<div class="form-group">
		<label for = "exmpleInputEmail1">Writer</label>
		<input type="text" name = 'writer' class="form-control" value="${boardVO.writer }">
	</div>
</div>
<!-- /.box-body -->
</form>

<div class="box-footer">
	<button type="submit" class="btn btn-primary">SAVE</button>
	<button type="submit" class="btn btn-warning">CANCEL</button>
</div>

</body>
<%@ include file="../include/footer.jsp"%>
</html>