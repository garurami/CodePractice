<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="/resources/plugins/jQuery/jQuery-2.1.4.min.js"></script>
<title>Insert title here</title>
<script type="text/javascript">
console.log("왜");
</script>
</head>
<body>
	<h4>${exeception.getMessage() }</h4>

	<ul>
		<c:forEach items="${exeception.getStackTrace() }" var="stack">
			<li>${stack.toString() }</li>
		</c:forEach>
	</ul>
</body>
</html>