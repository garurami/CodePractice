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
<title>Insert title here</title>
</head>
<body>
	<script type="text/javascript">
	$(document).ready(function(){
	
		$(".pageination li a").on("click", function(event){
			event.preventDefault();
			
			var targetPage = $(this).attr("href");
			
			var jobForm= $("#jobForm");
			jobForm.find("[name='page']").val(targetPage);
			jobForm.attr("action","/board/listPage").attr("method","get");
			jobForm.submit();
			
		});
	});
	</script>
	<form id="jobForm">
			<input type='hidden' name="page" value=${pageMaker.cri.perPageNum }>
			<input type='hidden' name="perPageNum"
				value=${pageMaker.cri.perPageNum }>
		</form>
	<table class="table table-bordered">
		<tr>
			<th style="width: 10px">BNO</th>
			<th>TITLE</th>
			<th>WRITER</th>
			<th>REGDATE</th>
			<th style="width: 40px">VIEWCNT</th>
		</tr>
		
		<c:forEach items="${list }" var="boardVO">
			<tr>
				<td>${boardVO.bno }
				<td><a
					href='/board/readPage${pageMaker.makeQuery(pageMaker.cri.page)}&bno=${boardVO.bno}'>${boardVO.title }</a>
				<td><fmt:formatDate pattern="yyyy-MM-dd HH:mm"
						value="${boardVO.regdate }" /></td>
				<td><span class="badge bg-red">${boardVO.viewcnt }</span></td>
			</tr>
		</c:forEach>
	</table>

	<div class="text-center">
		<ul class="pagination">
			<c:if test="${pageMaker.prev }">
				<li><a
					href="listPage${pageMaker.makeQuery(pageMaker.startPage - 1)}">&laquo;</a></li>
			</c:if>

			<c:forEach begin="${pageMaker.startPage }"
				end="${pageMaker.endPage }" var="idx">
				<li
					<c:out value="${pageMaker.cri.page == idx?'class = active':''}"/>>
					<a href="listPage${pageMaker.makeQuery(idx) }">${idx }</a>
				</li>
			</c:forEach>

			<c:if test="${pageMaker.next && pageMaker.endPage>0 }">
				<li><a
					href="listPage${pageMaker.makeQuery(pageMaker.endPage + 1) }">&raquo;</a>
				</li>
			</c:if>
		</ul>
	</div>

</body>
<%@ include file="../include/footer.jsp"%>
</html>