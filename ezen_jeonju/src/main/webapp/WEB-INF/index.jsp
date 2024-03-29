<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>[EZEN-JEONJU]</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/mainhome.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@300;400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="http://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>
    <link rel="stylesheet" href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
    <link rel="icon" type="image/png" sizes="32x32" href="${pageContext.request.contextPath}/images/favicon-32x32.png">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <script type="text/javascript" src="http://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>
    <script src="https://apis.google.com/js/api.js"></script>
<style type="text/css">
.notification ul li{
	width: 100%;
	left: 0px;
}
</style>
</head>

<body>
<script src="${pageContext.request.contextPath}/js/nav-bar.js"></script>
<script>
$(document).ready(function(){
	notifCheck();
	
	$('#noticeBtn').click(function(){
		var cssD = $('#notification').css("display");
		if(cssD == 'block'){
			$('#notification').css("display","none");
		}else{
			$('#notification').css("display","block");
			notificationList();
			
		}
	});
});
function notifCheck(){
	$.ajax({
        type: "post",
        url: "${pageContext.request.contextPath}/notification/notificationCheck.do",
        dataType: "json",
        cache: false,
        success: function (data) {
        	if(data.value){
        		if(data.value > 0){
        			var txt = "<span class='note-num'>"+data.value+"</span>"
        			$('#note-num').html(txt);
        		}
        	}else{
    			$('#note-num').html("<span></span>");
    		}
        },
        error: function () {
            alert("통신 오류 실패");
        }
    });
}

function notificationList(){
	$.ajax({
        type: "post",
        url: "${pageContext.request.contextPath}/notification/notificationList.do",
        dataType: "json",
        cache: false,
        success: function (data) {
        	if(data.ntlist && data.ntlist.length > 0){
        		notificationPrint(data.ntlist);
        	}else{
        		$('.notifList').html("<div class='noneNotif'>일주일 이내 알림이 없습니다.</div>");
        	}
        	notifCheck();
        },
        error: function () {
            alert("통신 오류 실패");
        }
    });
}

function notificationPrint(data){
	var txt = "<ul>";
	$(data).each(function(){
		if(this.notificationCategory === 'report'){
			txt = txt + "<li><Strong>"+this.contentsSubject+"</Strong>에 작성한 댓글 '"+this.reviewArticle
				+ "'이 "+this.reviewReportReason+"의 사유로 <Strong>신고</Strong>되었습니다.</li>";
		}else{
			txt = txt + "<li><Strong>"+this.contentsSubject+"</Strong>에 작성한 댓글 '"+this.reviewArticle
			+ "'이 "+this.reviewReportReason+"의 사유로 <span>삭제</span>되었습니다.</li>";
		}
	});
	txt= txt+"</ul>"
	$('.notifList').html(txt);
}

</script>
<header class="navigation" id="navigation">
    <nav class="nav-bar">
        <h1>
            <a href="/">
                <img src="${pageContext.request.contextPath}/images/logo.png">
            </a>
        </h1>
        <div class="menu-wrap">
            <ul class="menu-element">
                <li class="dep">
                    <a href="#none">전주에가면</a>
                    <div class="dep-inner" style="display: none;">
                        <div class="inner-sub-title">
                            <p class="large-text">전주에가면</p>
                        </div>
						<ul class="depth-2">
							<li><a href="<%=request.getContextPath()%>/contents/sight/contentsList.do">명소</a></li>
							<li><a href="<%=request.getContextPath()%>/contents/food/contentsList.do">음식</a></li>
							<li><a href="<%=request.getContextPath()%>/contents/youtube.do?page=1">영상</a></li>
						</ul>
                    </div>
                </li>
                <li class="dep">
                    <a href="#none">여행일정</a>
                    <div class="dep-inner" style="display: none;">
                        <div class="inner-sub-title">
                            <p class="large-text">여행일정</p>
                        </div>
                        <ul class="depth-2">
                            <li><a href="<%=request.getContextPath()%>/schedule/scheduleList.do">여행공유</a></li>
                        </ul>
                    </div>
                </li>
                <li class="dep">
                    <a href="#none">공지사항</a>
                    <div class="dep-inner" style="display: none;">
                        <div class="inner-sub-title">
                            <p class="large-text">공지사항</p>
                        </div>
                        <ul class="depth-2">
                            <li><a href="<%=request.getContextPath()%>/notice/noticeList.do">공지사항</a></li>
                        </ul>
                    </div>
                </li>
            </ul>
        </div>
        <div class="my-menu-element">
            <div class="login-element">
                <%
                String memberGradeValue = (String) session.getAttribute("memberGrade");		
                if(session.getAttribute("midx")==null){%>
                <a class="login" href="${pageContext.request.contextPath}/member/memberLogin.do">로그인</a>
                <%} else{ 
                	if(!"관리자".equals(memberGradeValue)){%>
		                <div id="note-num"><span></span></div>
		                <div class="noticeImg"><button id="noticeBtn"><img src="/images/notification.png"></button></div>
		                <div id="notification" class="notification" style="display:none;">
		                	<div class="notifList"></div>
		                </div>
		          	<%}%>
                <a href="${pageContext.request.contextPath}/member/memberLogout.do">로그아웃</a>
                <%} 
    			if ("관리자".equals(memberGradeValue)) {%>
                <a href="${pageContext.request.contextPath}/mypage/userMypage.do">관리페이지</a>
                <%} else{ %>
                <a href="${pageContext.request.contextPath}/mypage/userMypage.do">마이페이지</a>
                <%} %>
            </div>
        </div>
        <div class="menu-hamburger" onclick="toggleMenu()">
            <i class="xi-bars"></i>
        </div>
    </nav>
        <div class="menu-hamburger-area" id="menu-hamburger-area" style="display: none;">
            <div class="login-box">
                <%if(session.getAttribute("midx")==null){%>
                <a href="<%=request.getContextPath()%>/member/memberLogin.do">로그인</a>
                <%} else{ %>
                <a href="<%=request.getContextPath()%>/member/memberLogout.do">로그아웃</a>
                <%} 
    			if ("관리자".equals(memberGradeValue)) {%>
                <a href="${pageContext.request.contextPath}/mypage/userMypage.do">관리페이지</a>
                <%} else{ %>
                <a href="${pageContext.request.contextPath}/mypage/userMypage.do">마이페이지</a>
                <%} %>
            </div>
            <div class="menu-hamburger-list">
                <div class="menu-list-wrap">
                    <div class="menu-title" onclick="toggleSubMenu('submenu-title-1')">
                        <p>전주에가면</p>
                    </div>
                    <ul class="submenu-title-1" style="display: none;">
                        <li><a href="<%=request.getContextPath()%>/contents/sight/contentsList.do">명소</a></li>
                        <li><a href="<%=request.getContextPath()%>/contents/food/contentsList.do">음식</a></li>
                        <li><a href="<%=request.getContextPath()%>/contents/youtube.do?page=1">영상</a></li>
                    </ul>
                </div>
                <div class="menu-list-wrap">
                    <div class="menu-title" onclick="toggleSubMenu('submenu-title-2')">
                        <p>여행일정</p>
                    </div>
                    <ul class="submenu-title-2" style="display: none;">
                        <li><a href="<%=request.getContextPath()%>/schedule/scheduleList.do">여행공유</a></li>
                    </ul>
                </div>  
                <div class="menu-list-wrap">
                    <div class="menu-title" onclick="toggleSubMenu('submenu-title-3')">
                        <p>공지사항</p>
                    </div>
                    <ul class="submenu-title-3" style="display: none;">
                        <li><a href="<%=request.getContextPath()%>/notice/noticeList.do">공지사항</a></li>
                    </ul>
                </div>
            </div>
        </div>
</header>
<div id="main-contents" class="main-contents">
    <section class="first-visual">
        <div class="first-visual-list">
    		<c:forEach var="mpv" items="${mpvlist}">
            	<div><a href="${mpv.mainPageLink}"><img class="first-visual-img" src="${pageContext.request.contextPath}/imageLoading.do?aidx=${mpv.aidx}" /></a></div>
            </c:forEach>
        </div>
        <div class="first-text">
            <div class="first-text-list">
            	<c:forEach var="mpv" items="${mpvlist}">
                	<div><a href="${mpv.mainPageLink}"><p class="slide-txt">${mpv.mainPageSubject}</p></a></div>
                </c:forEach>
            </div>
            <div class="first-control">
                <div class="page">
                    <span class="first-current-num"></span>
                    <span>/</span>
                    <span class="first-total-num"/></span>
                </div>  
                <div class="btn-area">
                    <button class="btn-prev" type="button">
                        <i class="xi-angle-left-thin"></i>
                    </button>
                    <button id="btn-pause" type="button">
                        <i class="xi-pause"></i>
                    </button>
                    <button id="btn-play" type="button">
                        <i class="xi-play"></i>
                    </button>
                    <button class="btn-next" type="button">
                        <i class="xi-angle-right-thin"></i>
                    </button>    
                </div>
            </div>
            <%
			if ("관리자".equals(memberGradeValue)) {
			%>
            <div class="admin-click">
                <div><a class="btn-more" href="<%=request.getContextPath()%>/main/vannerRegisterList.do"><span>배너등록 +</span></a></div>
            </div>
            <%
			}
			%>
        </div>
    </section>
    <section class="second-visual">
        <div class="title-section">
            <h2>
                <span class="title1">지금 전주는</span>
                <span class="title2">어디가 좋을까?</span>
            </h2>
        </div>
        <div class="second-visual-list">
        	<c:forEach var="cv" items="${cvlist}">
	            <div><a href="<%=request.getContextPath()%>/contents/contentsArticle.do?cidx=${cv.cidx}"><div class="thumbnail"><img class="thumbnail-img" src="${pageContext.request.contextPath}/thumbnailLoading.do?aidx=${cv.aidx}" /></div><p class="slide-txt">${cv.contentsSubject}</p></a></div>
      		</c:forEach>
        </div>
    </section>

    <section class="third-visual">
        <div class="inner">
            <div class="title-section">
                <h2>
                    <span class="title1">전주 인기 여행 TOP3</span>
                    <span class="title2">조회수 높은 게시글을 알려드립니다.</span>
                </h2>
            </div>
            <div class="hot3-list">
            	<c:forEach var="cv" items="${cvtop3list}">
	                <div class="hot-item">  
	                    <a href="<%=request.getContextPath()%>/contents/contentsArticle.do?cidx=${cv.cidx}">
	                        <div class="box-wrap">
	                            <div class="box-img">
	                                <img src="${pageContext.request.contextPath}/thumbnailLoading.do?aidx=${cv.aidx}" />
	                            </div>
	                        </div>
	                        <p class="tit">${cv.contentsSubject}</p>
	                    </a>
	                </div>
                </c:forEach>
            </div>
        </div>
    </section>
    <section class="exhibition">
        <div class="inner">
            <div class="title-wrap">
                <div class="sub-title">
                    <span>공연</span>
                    <span>전시</span>
                    <span>축제</span>
                    <span>행사</span>
                    <a href="<%=request.getContextPath()%>/notice/noticeList.do"><span>더 보기 +</span></a>
                </div>
            </div>
            <div class="exhibition-list">
            	<c:forEach var="nv" items="${nvlist}">
             	   <a href="<%=request.getContextPath()%>/notice/noticeContents.do?nidx=${nv.nidx}"><div><img src="${pageContext.request.contextPath}/thumbnailLoading.do?aidx=${nv.aidx}" /><p class="slide-txt">${nv.noticeSubject}</p></div></a>
                </c:forEach>
            </div>
        </div>
    </section>
    <section class="video" style="background-image: url(images/1920480.jpg);">
        <div class="inner">
            <div class="title-section">
                <span class="title1">전주를 더 보고 싶다면?</span>
            </div>
            <div class="sns-list">
                <a href="https://www.youtube.com/channel/UCYRRFXJKbiAF7H6rP-BiHog" class="youtube-icon" target="_blank">
                    <i class="xi-youtube-play"></i>
                </a>
                <a href="https://blog.naver.com/jeonju_city" class="naver-icon" target="_blank">
                    <i class="xi-naver"></i>
                </a>
                <a href="https://www.instagram.com/visitjeonju_official/" class="instagram-icon" target="_blank">
                    <i class="xi-instagram"></i>
                </a>
                <a href="https://www.facebook.com/jeonju.kr" class="facebook-icon" target="_blank">
                    <i class="xi-facebook"></i>
                </a>
            </div>
            <div class="video-more">
                <div><a class="video-btn-more" href="<%=request.getContextPath()%>/contents/youtube.do?page=1"><span >영상 더 보러 가기 +</span></a></div>
            </div>
            <ul class="video-list">
            </ul>           
        </div>
    </section>
</div>
<footer>
    <a href="#main-contents" class="top-view"></a>
    <div class="inner">
	    <div class="footer-text">
	    	<p>
	    		(99999) 전라북도 전주시 이젠 개발자가 되고 싶어 대표전화 : 000)999-0000
	    	</p>
		   	<p>
			   	Copyright Ezen-Developer Team All rights  reserved
		   	</p>
    	</div>
   	</div>
</footer>
</body>
</html>
<script src="${pageContext.request.contextPath}/js/mainhome.js"></script>
<script src="${pageContext.request.contextPath}/js/mainhomeYout.js"></script>