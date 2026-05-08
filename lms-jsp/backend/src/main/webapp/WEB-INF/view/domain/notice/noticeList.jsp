<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:choose>
    <c:when test="${sessionScope.userType eq 'A'}">
        <c:set var="refreshUrl" value="${CTX_PATH}/admin/notices"/>
    </c:when>
    <c:when test="${sessionScope.userType eq 'I'}">
        <c:set var="refreshUrl" value="${CTX_PATH}/inst/notices"/>
    </c:when>
    <c:otherwise>
        <c:set var="refreshUrl" value="${CTX_PATH}/stu/notices"/>
    </c:otherwise>
</c:choose>

<html>
<head>
    <meta charset="UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>공지사항</title>
    <jsp:include page="/WEB-INF/view/common/common_include.jsp"/>
    <link rel="stylesheet" href="${CTX_PATH}/css/noticeList/noticeList.css"/>
</head>
<body>
<div id="wrap_area">
    <div id="container">
        <ul>
            <li class="lnb">
                <jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"/>
            </li>
            <li class="contents">
                <div class="content">
                    <jsp:include page="/WEB-INF/view/common/header.jsp">
                        <jsp:param name="menu1" value="커뮤니티"/>
                        <jsp:param name="menu2" value="공지사항"/>
                        <jsp:param name="refreshUrl" value="${refreshUrl}"/>
                    </jsp:include>

                    <p class="conTitle">
                        <span>공지사항</span>
                    </p>

                    <div class="container">
                        <!-- 검색 영역 -->
                        <div class="search-box">
                            <div class="search-row">
                                <select class="form-select" id="searchKey" style="width: 120px;">
                                    <option value="all">-- 전체 --</option>
                                    <option value="title">제목</option>
                                    <option value="content">내용</option>
                                </select>

                                <input type="text" class="form-input" id="searchWord" placeholder="검색어를 입력하세요"
                                       style="flex: 1; padding-left: 10px;">

                                <div class="search-buttons">
                                    <button type="button" class="btn btn-primary" onclick="fnSelectNoticeList(1)">🔍 검색</button>
                                    <c:if test="${sessionScope.userType eq 'A'}">
                                        <button class="btn btn-primary" onclick="fnToggleWrite()">신규 공지 작성</button>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <!-- Master-Detail 레이아웃 -->
                        <div class="master-detail-layout">
                            <!-- 좌측: 리스트 영역 -->
                            <div class="list-section">
                                <div class="table-container">
                                    <table>
                                        <thead>
                                        <tr>
                                            <th>번호</th>
                                            <th>제목</th>
                                            <th>작성자</th>
                                            <th id="orderDate" onclick="fnSetOrder()" style="cursor:pointer;">등록일 ▼</th>
                                            <th>조회수</th>
                                        </tr>
                                        </thead>
                                        <tbody id="noticeListBody"></tbody>
                                    </table>
                                </div>

                                <div class="bottom-container">
                                    <div class="paging_area" id="noticePagination"></div>
                                </div>
                            </div>

                            <!-- 우측: 상세/작성 영역 -->
                            <div class="detail-panel-wrapper">
                                <!-- 상세보기 영역 -->
                                <div id="noticeDetailArea" class="detail-section">
                                    <div class="detail-header">
                                        <h2>📢 공지사항 상세</h2>
                                        <button type="button" class="btn-close" onclick="fnCloseDetail()">✕</button>
                                    </div>

                                    <table class="info-table" style="background-color: transparent">
                                        <tr>
                                            <th>글번호</th>
                                            <td id="detailNoticeId" style="width: 35%;"></td>
                                            <th>등록일</th>
                                            <td id="detailDate" style="width: 35%;"></td>
                                        </tr>
                                        <tr>
                                            <th>작성자</th>
                                            <td id="detailUser"></td>
                                            <th>조회수</th>
                                            <td id="detailCount"></td>
                                        </tr>
                                    </table>

                                    <div class="detail-section-body">
                                        <label class="info-label">제목</label>
                                        <div id="detailTitle" class="detail-title-box"></div>
                                    </div>

                                    <div class="detail-section-body">
                                        <label class="info-label">내용</label>
                                        <div id="detailContent" class="detail-content-box"></div>
                                    </div>

                                    <div class="button-group" style="margin-top: 20px;">
                                        <c:if test="${sessionScope.userType eq 'A'}">
                                            <button type="button" class="btn-update" onclick="fnOpenUpdateNotice()">수정</button>
                                            <button type="button" class="btn-delete" onclick="fnDeleteNotice()">삭제</button>
                                        </c:if>
                                    </div>
                                </div>

                                <!-- 작성/수정 영역 -->
                                <div id="noticeWriteArea" class="detail-section">
                                    <div class="detail-header">
                                        <h2>📢 신규 공지사항 작성</h2>
                                        <button type="button" class="btn-close" onclick="fnCloseWrite()">✕</button>
                                    </div>

                                    <div class="detail-body">
                                        <form id="writeForm">
                                            <div class="detail-row">
                                                <label class="info-label" for="writeTitle">제목</label>
                                                <input type="text" id="writeTitle" class="form-input"
                                                       style="width:100%; padding-left: 10px; margin-bottom: 10px;"
                                                       placeholder="제목을 입력하세요.">
                                            </div>
                                            <div class="detail-row content-row">
                                                <label class="info-label" for="writeContent">내용</label>
                                                <textarea id="writeContent" class="val content-val"
                                                          style="width:100%; height:250px; border-radius: 8px; border: 1px solid #ddd; padding: 10px;"
                                                          placeholder="공지 내용을 상세히 입력하세요."></textarea>
                                            </div>
                                        </form>
                                    </div>

                                    <div class="button-group" style="margin-top: 20px;">
                                        <button type="button" class="btn-primary" onclick="fnSaveNotice()"
                                                style="background:#003366; color:#fff;">저장하기</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </li>
        </ul>
    </div>

    <script>
        $(function () {
            fnSelectNoticeList();

            // 검색창 엔터키
            $("#searchWord").on("keyup", function(event) {
                if (event.key === "Enter") {
                    fnSelectNoticeList(1);
                }
            });

            var pendingId = localStorage.getItem("pendingNoticeId");

            if (pendingId) {
                setTimeout(function() {
                    fnToggleDetail(parseInt(pendingId), null);

                    localStorage.removeItem("pendingNoticeId");
                }, 200);
            }
        });

        // 작성 폼 열기
        function fnToggleWrite() {
            if (!isAdmin()) return;

            // 모든 UI 초기화
            fnResetUI();

            // 입력값 초기화
            $("#noticeWriteArea").data("mode", "insert").removeData("noticeId");
            $("#noticeWriteArea h2").text("📢 신규 공지사항 작성");

            // Master-Detail 레이아웃 활성화
            $(".master-detail-layout").addClass("split-view");
            $("#noticeWriteArea").addClass("active");

            setTimeout(() => $("#writeTitle").focus(), 300);
        }

        // 작성 폼 닫기
        function fnCloseWrite() {
            // 레이아웃 초기화
            $(".master-detail-layout").removeClass("split-view");
            $("#noticeWriteArea").removeClass("active");

            // 입력 필드 초기화
            $("#writeTitle").val("");
            $("#writeContent").val("");
            $("#noticeWriteArea").removeData("mode");
            $("#noticeWriteArea").removeData("noticeId");
            $("#noticeWriteArea h2").text("📢 신규 공지사항 작성");
        }

        // 신규 공지사항 저장
        function fnSaveNotice() {
            var title = $("#writeTitle").val().trim();
            var content = $("#writeContent").val().trim();
            var mode = $("#noticeWriteArea").data("mode");
            var noticeId = $("#noticeWriteArea").data("noticeId");

            if (!title) {
                alert("제목을 입력해주세요.");
                $("#writeTitle").focus();
                return;
            }
            if (!content) {
                alert("내용을 입력해주세요.");
                $("#writeContent").focus();
                return;
            }

            if (!confirm(mode === "update" ? "공지사항을 수정하시겠습니까?" : "공지사항을 등록하시겠습니까?")) return;

            var url = (mode === "update") ? "/admin/notices/updateContent/list" : "/admin/notices/insertNotice/list";
            var param = { title: title, content: content };

            if (mode === "update") {
                param.noticeId = noticeId;
            }

            $.ajax({
                url: url,
                type: "POST",
                data: param,
                success: function (res) {
                    if (res.result === "success") {
                        alert(mode === "update" ? "성공적으로 수정되었습니다." : "성공적으로 등록되었습니다.");
                        fnCloseWrite();
                        fnSelectNoticeList(1);
                    } else {
                        alert("처리에 실패했습니다. 관리자 권한을 확인하세요.");
                    }
                },
                error: function (xhr) {
                    alert("서버 통신 중 오류가 발생했습니다.");
                }
            });
        }

        // 공지사항 목록 조회
        var orderType = "DESC";

        function fnSelectNoticeList(currentPage) {
            currentPage = currentPage || 1;

            var searchType = $("#searchKey").val();
            var sname = $("#searchWord").val();

            var param = {
                currentPage: currentPage,
                pageSize: 5,
                searchType: searchType,
                sname: sname,
                orderType: orderType
            };

            $.ajax({
                url: "/admin/notices/list",
                type: "GET",
                data: param,
                dataType: "json",
                success: function (data) {
                    fnRenderTable(data.notice, data.noticeCnt, data.currentPage, data.pageSize);
                    fnRenderPagination(data.noticeCnt, data.currentPage, data.pageSize);
                },
                error: function(xhr, status, error) {
                    console.error("데이터 로드 실패:", error);
                    alert("목록을 불러오는 중 오류가 발생했습니다.");
                }
            });
        }

        // 정렬 방식 변경
        function fnSetOrder() {
            orderType = (orderType === "DESC") ? "ASC" : "DESC";
            var icon = (orderType === "DESC") ? "▼" : "▲";
            $("#orderDate").html("등록일 " + icon);
            fnSelectNoticeList(1);
        }

        // 테이블 데이터 렌더링
        function fnRenderTable(list, totalCount, currentPage, pageSize) {
            var html = "";

            if (!list || list.length === 0) {
                html += "<tr><td colspan='5' style='text-align:center;'>데이터가 없습니다.</td></tr>";
            } else {
                list.forEach(function (item, index) {
                    var virtualNum = totalCount - ((currentPage - 1) * pageSize) - index;

                    var formattedDate = formatYYYYMMDD(item.reg_date);

                    html += "<tr class='notice-row' onclick='fnToggleDetail(" + item.notice_id + ", this)'>";
                    html += "  <td>" + virtualNum + "</td>";
                    html += "  <td class='notice-title'>" + (item.title || '제목 없음') + "</td>";
                    html += "  <td>" + (item.user || '-') + "</td>";
                    html += "  <td>" + formattedDate + "</td>";
                    html += "  <td>" + (item.view_count || 0) + "</td>";
                    html += "</tr>";
                });
            }
            $("#noticeListBody").html(html);
        }

        // 읽은 공지사항 ID 저장
        var viewedNotices = [];

        // 상세 데이터 가져오기
        function fnToggleDetail(noticeId, obj) {
            var alreadyViewed = viewedNotices.includes(noticeId);

            if (alreadyViewed) {
                fnFetchDetail(noticeId, obj);
            } else {
                $.ajax({
                    url: "/admin/notices/viewCount/list",
                    type: "POST",
                    data: {noticeId: noticeId},
                    success: function (res) {
                        if (res.result === "success") {
                            viewedNotices.push(noticeId);
                            fnFetchDetail(noticeId, obj);
                        }
                    }
                });
            }
        }

        function fnFetchDetail(noticeId, obj) {
            $.ajax({
                url: "/admin/notices/detail",
                type: "GET",
                data: {noticeId: noticeId},
                success: function (data) {
                    var notice = data.notice;
                    if (!notice) {
                        alert("존재하지 않는 게시글입니다.");
                        return;
                    }

                    // 모든 UI 초기화
                    fnResetUI();

                    // 데이터 매핑
                    $("#detailNoticeId").text(notice.notice_id);
                    $("#detailUser").text(notice.user || notice.loginID || '관리자');
                    $("#detailCount").text(notice.view_count || 0);
                    $("#detailTitle").text(notice.title);
                    $("#detailContent").html((notice.content || '').replace(/\n/g, '<br>'));

                    $("#detailDate").text(formatYYYYMMDD(notice.reg_date));

                    // 리스트 강조 및 레이아웃 활성화 조회수 갱신
                    if (obj) {
                        $(".notice-row").removeClass("active-row");
                        $(obj).addClass("active-row");
                        $(obj).find("td").last().text(notice.view_count);
                    }

                    // Master-Detail 레이아웃 활성화
                    $(".master-detail-layout").addClass("split-view");
                    $("#noticeDetailArea").addClass("active");
                },
                error: function() {
                    alert("상세 데이터를 가져오는 중 오류가 발생했습니다.");
                }
            });
        }

        function fnOpenUpdateNotice() {
            if (!isAdmin()) return;

            var noticeId = $("#detailNoticeId").text();
            var title = $("#detailTitle").text();
            var content = $("#detailContent").html().replace(/<br\s*[\/]?>/gi, "\n");

            $("#writeTitle").val(title);
            $("#writeContent").val(content);
            $("#noticeWriteArea").data("mode", "update");
            $("#noticeWriteArea").data("noticeId", noticeId);
            $("#noticeWriteArea h2").text("📝 공지사항 수정");

            $("#noticeDetailArea").removeClass("active");
            $("#noticeWriteArea").addClass("active");

            setTimeout(function() {
                $("#writeTitle").focus();
            }, 300);
        }

        // 공지 삭제
        function fnDeleteNotice() {
            if (!isAdmin()) return;

            var noticeId = $("#detailNoticeId").text();

            if (!noticeId) {
                alert("삭제할 대상을 찾을 수 없습니다.");
                return;
            }

            if (!confirm(noticeId + "번 공지사항을 정말로 삭제하시겠습니까?")) {
                return;
            }

            $.ajax({
                url: "/admin/notices/deleteNotice/list",
                type: "POST",
                data: {noticeId: noticeId},
                success: function (res) {
                    if (res.result === "success") {
                        alert("공지사항이 삭제되었습니다.");
                        fnCloseDetail();
                        fnSelectNoticeList(1);
                    } else {
                        alert("삭제에 실패했습니다. 관리자 권한을 확인하세요.");
                    }
                },
                error: function (xhr) {
                    if (xhr.status === 403) {
                        alert("삭제 권한이 없습니다.");
                    } else {
                        alert("서버와 통신 중 오류가 발생했습니다.");
                    }
                }
            });
        }

        // 페이지네이션 렌더링
        function fnRenderPagination(totalCount, currentPage, pageSize) {
            if (totalCount === 0) {
                $("#noticePagination").empty();
                return;
            }

            var totalPage = Math.ceil(totalCount / pageSize);
            var pageBlock = 5;
            var startPage = Math.floor((currentPage - 1) / pageBlock) * pageBlock + 1;
            var endPage = startPage + pageBlock - 1;

            if (endPage > totalPage) endPage = totalPage;

            var html = "";

            if (startPage > 1) {
                html += "<a onclick='fnSelectNoticeList(" + (startPage - 1) + ")'>&#9664; 이전</a>";
            }

            for (var i = startPage; i <= endPage; i++) {
                if (i === currentPage) {
                    html += "<span class='active'>" + i + "</span>";
                } else {
                    html += "<a onclick='fnSelectNoticeList(" + i + ")'>" + i + "</a>";
                }
            }

            if (endPage < totalPage) {
                html += "<a onclick='fnSelectNoticeList(" + (endPage + 1) + ")'>다음 &#9654;</a>";
            }

            $("#noticePagination").html(html);
        }

        function fnCloseDetail() {
            // 레이아웃 초기화
            $(".master-detail-layout").removeClass("split-view");
            $("#noticeDetailArea").removeClass("active");
            $(".notice-row").removeClass("active-row");
        }

        //공통 함수

        //권한 체크
        function isAdmin() {
            if ("${sessionScope.userType}" !== 'A') {
                alert("관리자만 접근 가능합니다.");
                return false;
            }
            return true;
        }

        //날짜 포맷팅
        function formatYYYYMMDD(dateStr) {
            if (!dateStr) return "-";

            var d = new Date(dateStr);
            // 날짜 객체가 유효하지 않을 경우 (NaN) 처리
            if (isNaN(d.getTime())) return "-";

            var year = d.getFullYear();
            var month = (d.getMonth() + 1);
            month = month < 10 ? '0' + month : month;
            var day = d.getDate();
            day = day < 10 ? '0' + day : day;

            return year + "-" + month + "-" + day;
        }

        //UI 초기화 통합
        function fnResetUI() {
            // 모든 패널 비활성화 및 레이아웃 리셋
            $(".master-detail-layout").removeClass("split-view");
            $("#noticeWriteArea, #noticeDetailArea").removeClass("active");
            $(".notice-row").removeClass("active-row");

            // 입력 필드 및 텍스트 초기화
            $("#writeTitle, #writeContent").val("");
            $("#detailNoticeId, #detailTitle, #detailContent, #detailDate, #detailUser, #detailCount").text("");

            // 모드 초기화
            $("#noticeWriteArea").removeData("mode").removeData("noticeId");
        }
    </script>
</div>
</body>
</html>
