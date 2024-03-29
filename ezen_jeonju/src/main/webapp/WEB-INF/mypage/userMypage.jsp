<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>[EZEN-JEONJU]마이페이지</title>
<link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/images/favicon-32x32.png">
<link rel="stylesheet" href="../css/navbar.css">
<link rel="stylesheet" href="../css/userMypage.css">
<script src="http://code.jquery.com/jquery-3.1.0.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-cookie/1.4.1/jquery.cookie.min.js" integrity="sha512-3j3VU6WC5rPQB4Ld1jnLV7Kd5xr+cq9avvhwqzbH/taCRNURoeEpoPBK9pDyeukwSxwRPJ8fDgvYXd6SkaZ2TA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.2/css/all.min.css">
<!-- SweetAlert2 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/limonte-sweetalert2/7.2.0/sweetalert2.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/limonte-sweetalert2/7.2.0/sweetalert2.all.min.js"></script>
<style type="text/css">
.swal2-popup .swal2-content {
    font-weight: bold;
}
</style>
</head>
<body>
<script>
$(document).ready( function() {
	//가져올때 navbar.css도 같이 가져올 것
	$('#headers').load("../nav/nav.jsp");
	$('#footers').load("../nav/footer.jsp");

	$('#tab li').click(function(e){
		var el = $(e.target).closest('li');
		el.siblings('li').removeClass("on");
		el.addClass("on");
		var id_check = el.attr("id");
		if(id_check === 'tab1'){
			$('.con-sche').css('display','block');
			$('.con-rev').css('display','none');
			$('.con-like').css('display','none');
		}else if(id_check === 'tab2'){
			$('.con-sche').css('display','none');
			$('.con-rev').css('display','block');
			$('.con-like').css('display','none');
		}else if(id_check === 'tab3'){
			$('.con-sche').css('display','none');
			$('.con-rev').css('display','none');
			$('.con-like').css('display','block');
		}
		
	});
	
	scheList();
	
	$('#tab2').click(function(){
		reviewList();
	});
	
	$('#tab3').click(function(){
		likeList();
	});
});

var midx = ${sessionScope.midx};

/* --------------------------------리뷰-------------------------------*/
function reviewList(){
	$.ajax({
		type : "post",
		url : "${pageContext.request.contextPath}/mypage/reviewList.do",
		dataType : "json",
		data : {
				"midx" : midx
		},
		cache : false,
		success : function(data){
			reviewListPrint(data.reviewlist);
			$('#reviewCnt').html(data.pm.totalCount);
			reviewPaging(data.pm);
		},
		error : function(){
			alert("통신오류 실패");
		}		
	});
}
function reviewListPrint(data){
	var str = "<table class='rev-contb'>";
	$(data).each(function(){
		str = str + "<tr><td class='rev-conDTD' width='20%'>"
			+"<a href='${pageContext.request.contextPath}/contents/contentsArticle.do?cidx="+this.cidx+"'>"
			+"<div class='rev-conD'>"
			+"<img width='200px' src='${pageContext.request.contextPath}/thumbnailLoading.do?aidx="+this.aidx+"'>"
			+"<div class='rev-conT'>"+this.contentsSubject+"</div></div></a></td>"
			+"<td class='rev-contentsTD'><div class='rev-contents'><div class='rev-score'>";
		for(var i=0; i<this.reviewScore; i++){
			str = str + "<i class='rating__star fas fa-star'></i>";
		}
		str = str + "</div><div class='rev-date'>"+this.reviewWriteday+"</div>"
			+"<div class='rev-art'>"+this.reviewArticle+"</div></div></td>"
			+"<td class='revBtn' width='20%''><div class='rev-del'><button onclick='revDel("+this.ridx+")'><i class='fa fa-trash' aria-hidden='true'></i>&ensp;삭제</button></div></td></tr>";
	});
	str = str + "</table>";
	$('.revCon').html(str);
}
function reviewListPaging(page){
	$.ajax({
		type : "post",
		url : "${pageContext.request.contextPath}/mypage/reviewList.do?page="+page,
		dataType : "json",
		data : {
				"midx" : midx
		},
		cache : false,
		success : function(data){
			reviewListPrint(data.reviewlist);
			reviewPaging(data.pm);
		},
		error : function(){
			alert("통신오류 실패");
		}		
	});
}
function reviewPaging(data){
	var paging = "";
	var nowpage=data.rcri.page/5+1;
	if(data.prev == true){
		paging = paging + "<a class='pagePreview' href='javascript:reviewListPaging("+(data.startPage-1)+")'>이전</a>";
	}
	for(var i=data.startPage; i<=data.endPage; i++){
		if(i==nowpage){
			paging = paging + "<a class='pageNumber active' href='javascript:reviewListPaging("+i+")'>"+i+"</a>";	
		}else{
			paging = paging + "<a class='pageNumber' href='javascript:reviewListPaging("+i+")'>"+i+"</a>";
		}
	}
	if(data.next == true && data.endPage>0){
		paging = paging + "<a class='pageNext' href='javascript:reviewListPaging("+(data.endPage+1)+")'>다음</a>";
	}
	$('#revpaging').html(paging);
}

function revDel(ridx){
	swal({
		title: "",
		text: "리뷰를 삭제하시겠습니까?",
		type: "question",
		showCancelButton: true,
		confirmButtonText: "Yes",
		cancelButtonText: "Cancel"
	}). then ((result) => {
		/* alert(JSON.stringify(result)); */
		if(result.value){
			$.ajax({
				type : "post",
				url : "${pageContext.request.contextPath}/mypage/reviewDelete.do",
				dataType : "json",
				data : {
						"ridx" : ridx
				},
				cache : false,
				success : function(data){
					if(data.txt === "댓글을 삭제하였습니다."){
						swal(
							'',
							'<b style="font-weight:bold;">리뷰가 삭제되었습니다.</b>',
							'success'
						);
						reviewList();
					}else{
						alert(data.txt);
					}
				},
				error : function(){
					swal(
						'',
						'<b style="font-weight:bold;">통신오류 실패</b>',
						'error'
					);
				}
			});
		}
	});
}

/* --------------------------------좋아요-------------------------------*/
function likeList(){
	$.ajax({
		type : "post",
		url : "${pageContext.request.contextPath}/mypage/likeList.do",
		dataType : "json",
		data : {
				"midx" : midx
		},
		cache : false,
		success : function(data){
			likeListPrint(data.likelist);
			$('#likeCnt').html(data.pm.totalCount);
			likePaging(data.pm);
		},
		error : function(){
			alert("통신오류 실패");
		}		
	});
}
function likeListPaging(page){
	$.ajax({
		type : "post",
		url : "${pageContext.request.contextPath}/mypage/likeList.do?page="+page,
		dataType : "json",
		data : {
				"midx" : midx
		},
		cache : false,
		success : function(data){
			likeListPrint(data.likelist);
			likePaging(data.pm);
		},
		error : function(){
			alert("통신오류 실패");
		}		
	});
}
function likeListPrint(data){
	var liketxt = "";
	$(data).each(function(){
		liketxt = liketxt + "<div class='likeCon'><div class='likeImg'>"
				+"<img width='350px' height='210px' src='${pageContext.request.contextPath}/thumbnailLoading.do?aidx="+this.aidx+"'>"
				+"</div><div class='likeImgName'>"+this.contentsSubject+"</div>"
				+"<div class='likeCancel'><button onclick='likeDel("+this.clidx+")'><i class='fa fa-heart' aria-hidden='true'></i>&ensp;좋아요 취소</button></div></div>";
	});
	
	$('#likeList').html(liketxt);
}

function likePaging(data){
	var likepaging = "";
	var nowpage=data.mlcri.page/9+1;
	if(data.prev == true){
		likepaging = likepaging + "<a class='pagePreview' href='javascript:likeListPaging("+(data.startPage-1)+")'>이전</a>";
	}
	for(var i=data.startPage; i<=data.endPage; i++){
		if(i==nowpage){
			likepaging = likepaging + "<a class='pageNumber active' href='javascript:likeListPaging("+i+")'>"+i+"</a>";	
		}else{
			likepaging = likepaging + "<a class='pageNumber' href='javascript:likeListPaging("+i+")'>"+i+"</a>";
		}
	}
	if(data.next == true && data.endPage>0){
		likepaging = likepaging + "<a class='pageNext' href='javascript:likeListPaging("+(data.endPage+1)+")'>다음</a>";
	}
	$('#likePage').html(likepaging);
}

function likeDel(clidx){
/* 	if(!confirm('좋아요를 취소하시겠습니까?')){
        return false;
    } */
    swal({
		title: "",
		text: "좋아요를 취소하시겠습니까?",
		type: "question",
		showCancelButton: true,
		confirmButtonText: "Yes",
		cancelButtonText: "Cancel"
	}). then ((result) => {
		/* alert(JSON.stringify(result)); */
		if(result.value){
			$.ajax({
				type : "post",
				url : "${pageContext.request.contextPath}/mypage/likeDelete.do",
				dataType : "json",
				data : {
						"clidx" : clidx
				},
				cache : false,
				success : function(data){
					if(data.txt === "좋아요를 취소하였습니다."){
						swal(
							'',
							'<b style="font-weight:bold;">좋아요가 취소되었습니다.</b>',
							'success'
						);
						likeList();
					}else{
						alert(data.txt);
					}
				},
				error : function(){
					swal(
						'',
						'<b style="font-weight:bold;">통신오류 실패</b>',
						'error'
					);
				}		
			});
		}
	});
}

/*------------------------------스케줄-----------------------------*/
function scheList(){
	$.ajax({
		type : "post",
		url : "${pageContext.request.contextPath}/mypage/scheduleList.do",
		dataType : "json",
		data : {
				"midx" : midx
		},
		cache : false,
		success : function(data){
			scheListTable(data.scheList);
			$('#scheCnt').html(data.total);
		},
		error : function(){
			alert("통신오류 실패");
		}		
	});
}

function scheListTable(data){
	var txt = "<table class='scheTable'><thead><tr><th style='width:60%'>제목</th><th>기간</th><th>조회수</th></tr>"
			+"</thead><tbody>";
	$(data).each(function(){
		txt = txt + "<tr><td><a href='${pageContext.request.contextPath}/schedule/scheduleContents.do?sidx="+this.sidx+"'>"
			+ this.scheduleSubject+"</a></td>"
			+ "<td>"+this.scheduleStartDate+" ~ "+this.scheduleEndDate+"</td>"
			+ "<td>"+this.scheduleViewCount+"</td></tr>";
	});
	txt = txt + "</tbody></table>";
	$('.scheCon').html(txt);
}
</script>
<div id="headers"></div>

<div class="mypage">
<!-- 	<div class="mypage-head">
		<div class="head-title">마이페이지</div>
	</div> -->
	<div class="mypage-contents">
		<strong>${sessionScope.memberName}</strong>님의 전주여행
	</div>
	<div class="mypage-tabmenu">
		<ul class="tabStyle" id="tab">
			<li class="on" id="tab1">나의 여행일정</li>
			<li id="tab2">나의 리뷰</li>
			<li id="tab3">나의 좋아요</li>
		</ul>
	</div>
	<div class="tab-con innerwrap" id="tab_con">
		<div class="con-sche" style="display:block;">
			<div class="revHead">
				<div class="title">일정 목록</div>
				<div class="revCnt">총 <strong><div id="scheCnt" style="display:inline-block;"></div></strong>개</div>
			</div>
			<div class="scheList">
				<div class="scheCon">
					
				</div>
				<div class="paging" id="paging"></div>
			</div>
		</div>
		<div class="con-rev" style="display:none;">
			<div class="revHead">
				<div class="title">리뷰 목록</div>
				<div class="revCnt">총 <strong><div id="reviewCnt" style="display:inline-block;"></div></strong>개</div>
			</div>
			<div class="revList">
				<div class="revCon"></div>
				<div class="paging" id="revpaging"></div>
			</div>
		</div>
		<div class="con-like" style="display:none;">
			<div class="revHead">
				<div class="title">좋아요 목록</div>
				<div class="revCnt">총 <strong><div id="likeCnt" style="display:inline-block;"></div></strong>개</div>
			</div>
			<div class="likeList" id="likeList"></div>
			<div class="paging" id="likePage"></div>
		</div>
	</div>
</div>

<div id="footers"></div>
</body>
</html>