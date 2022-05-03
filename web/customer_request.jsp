<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page language="java" import="java.text.*,java.sql.*,java.util.*,java.security.*,java.math.BigInteger" %>
<%@ page language="java" import="myPackage.*" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=utf-8"); %>
<%
    /*현재 페이지 저장
    String now = "_remodeling_form.jsp";
    */

    //변수 설정
    String[] state = {"회사수락대기", "회사거절", "상담대기", "고객부재중", "상담중", "미팅 예정", "계약진행중", "(계약완료)X", "계약완료", "중단(고객 부재중)", "중단", "상담취소"};
    String[] building_types = {"아파트", "빌라", "주택", "원룸"};

//DB에 사용 할 객체들 정의
    Connection conn = DBUtil.getMySQLConnection();
    PreparedStatement pstmt = null;
    Statement stmt = null;
    String query = "";
    String sql = "";
    ResultSet rs = null;

//세션 생성 create session
    session.setAttribute("page", "company_request.jsp"); // 현재 페이지 current page
//세션 가져오기 get session
    String now = session.getAttribute("page") + ""; // 현재 페이지 current page
    String s_id = session.getAttribute("s_id") + "";// 현재 사용자 current user
    String name = session.getAttribute("name") + "";
    String apply_num = s_id.replaceAll("cu", "");

//업체별 신청내용 받아오기. 세션이 있을 경우. 세션이 없는경우는 현재 테스트를 위해 다 보이도록 해두었지만
////////**********추후에 세션이 없는 경우에는 접근 못하도록 수정 해야함 ***********/////////
    query = "select * from ASSIGNED";
//out.println("로그인된 아이디는 " + s_id);
    if (!s_id.equals("null") && !s_id.equals("NULL") && !s_id.equals("Null") && s_id != null && !s_id.equals("")) {
        query += " where Apply_num = " + apply_num;
    } else {
        query += " where Apply_num = -1";
    }
    pstmt = conn.prepareStatement(query);
    rs = pstmt.executeQuery();

    ArrayList<HashMap<String, String>> companylist = new ArrayList<HashMap<String, String>>();

    while (rs.next()) {

        HashMap<String, String> companymap = new HashMap<String, String>();
		String assign_id = rs.getString("Assigned_id");
		String company_num = rs.getString("Company_num");
        String state_eng = rs.getString("State");

        //회사 이름 가져오기
        query = "select * from COMPANY where Id = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, company_num);
        ResultSet rs1 = pstmt.executeQuery();

        String company_name = "";
        String company_address = "";
        String company_phone = "";
        String company_as_provide = "";
        String company_as_warranty = "";
        while (rs1.next()) {
            company_name = rs1.getString("Name");
            company_address = rs1.getString("Address");
            company_phone = rs1.getString("Phone");
            company_as_provide = rs1.getString("As_provide");
            company_as_warranty = rs1.getString("As_warranty");
        }

        //리뷰 여부 확인하기
        query = "select count(*),state,rate,text,submit_date from client_review where company_id = ? and assign_id = ? and state = 0";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, company_num);
        pstmt.setString(2 , assign_id);
        ResultSet rs2 = pstmt.executeQuery();
        String review0_cnt = "";
        String review0_state = "";
        String review0_rate = "";
        String review0_text = "";
        String review0_date = "";
        while (rs2.next()) {
            review0_state = rs2.getString("state");
            review0_rate = rs2.getString("rate");
            review0_text = rs2.getString("text");
            review0_date = rs2.getString("submit_date");
            review0_cnt = rs2.getString("count(*)");
        }

        //리뷰 여부 확인하기
        query = "select count(*),state,rate,text,submit_date from client_review where company_id = ? and assign_id = ? and state = 1";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, company_num);
        pstmt.setString(2 , assign_id);
        ResultSet rs3 = pstmt.executeQuery();
        String review1_cnt = "";
        String review1_state = "";
        String review1_rate = "";
        String review1_text = "";
        String review1_date = "";
        while (rs3.next()) {
            review1_state = rs3.getString("state");
            review1_rate = rs3.getString("rate");
            review1_text = rs3.getString("text");
            review1_date = rs3.getString("submit_date");
            review1_cnt = rs3.getString("count(*)");
        }


		companymap.put("assign_id", assign_id);
		companymap.put("name", company_name);
        companymap.put("as_provide", company_as_provide);
        companymap.put("as_warranty", company_as_warranty);
        companymap.put("address", company_address);
        companymap.put("phone", company_phone);
        companymap.put("state", state_eng);
        companymap.put("id", company_num);
        companymap.put("mid_cnt",review0_cnt);
        companymap.put("mid_rate",review0_rate);
        companymap.put("mid_text",review0_text);
        companymap.put("mid_date",review0_date);
        companymap.put("mid_state",review0_state);
        companymap.put("fin_cnt",review1_cnt);
        companymap.put("fin_state",review1_state);
        companymap.put("fin_rate",review1_rate);
        companymap.put("fin_date",review1_date);
        companymap.put("fin_text",review1_text);
        companylist.add(companymap);
    }


//신청정보 가져오기
    HashMap applymap = new HashMap<String, String>();

    query = "select * from REMODELING_APPLY where Number = ?";
    pstmt = conn.prepareStatement(query);
    pstmt.setString(1, apply_num);
    rs = pstmt.executeQuery();
    while (rs.next()) {
        String item_number = rs.getString("Number");
        String item_itemnum = rs.getString("Item_num");
        String item_name = rs.getString("Name");
        String item_phone = rs.getString("Phone");
        String item_address = rs.getString("Address");
        String item_building = rs.getString("Building_type") + "";
        String item_area = rs.getString("Area");
        String item_due = rs.getString("Due");
        String item_budget = rs.getString("Budget");
        String item_applydate = rs.getString("Apply_date");
        String item_calling = rs.getString("Calling");
        //String item_state = rs.getString("State");

        //빌딩타입 한글로 변경
        if (item_building != null && !item_building.equals("null")) {
            item_building = building_types[Integer.parseInt(item_building)];
        } else {
            item_building = "정보없음";
        }

        applymap.put("number", item_number);
        applymap.put("itemnum", item_itemnum);
        applymap.put("name", item_name);
        applymap.put("phone", item_phone);
        applymap.put("address", item_address);
        applymap.put("building", item_building);
        applymap.put("area", item_area);
        applymap.put("due", item_due);
        applymap.put("budget", item_budget);
        applymap.put("applydate", item_applydate);
        applymap.put("calling", item_calling);
        //applymap.put("state", item_state);
    }

    if (s_id.equals("null") || s_id.equals("NULL") || s_id.equals("Null") || s_id == null || s_id.equals("")) {
        applymap.put("consulting", -1);
        applymap.put("compare", -1);
    }
%>

<!DOCTYPE html>
<html>
<head>
    <link rel="SHORTCUT ICON" href="img/favicon.ico"/>
    <link rel="stylesheet" type="text/css" href="https://pm.pstatic.net/css/webfont_v170623.css"/>
    <link rel="stylesheet" type="text/css" href="slick-1.8.1/slick/slick.css"/>
    <link rel="stylesheet" type="text/css" href="slick-1.8.1/slick/slick-theme.css"/>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/customer_request.css"/>
    <script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/>
    <title>소문난집 - 내 신청 정보</title>
    <!-- 사용자 행동 정보 수집 코드 시작 - Meta, GA -->
    <!-- 모든 페이지에 하나씩만 포함되어 있어야 합니다. 위치는 </head> 바로 위로 통일 -->
    <!-- Meta Pixel Code -->
    <script>
        !function (f, b, e, v, n, t, s) {
            if (f.fbq) return;
            n = f.fbq = function () {
                n.callMethod ?
                    n.callMethod.apply(n, arguments) : n.queue.push(arguments)
            };
            if (!f._fbq) f._fbq = n;
            n.push = n;
            n.loaded = !0;
            n.version = '2.0';
            n.queue = [];
            t = b.createElement(e);
            t.async = !0;
            t.src = v;
            s = b.getElementsByTagName(e)[0];
            s.parentNode.insertBefore(t, s)
        }(window, document, 'script',
            'https://connect.facebook.net/en_US/fbevents.js');
        fbq('init', '483692416470707');
        fbq('track', 'PageView');
    </script>
    <noscript><img height="1" width="1" style="display:none"
                   src="https://www.facebook.com/tr?id=483692416470707&ev=PageView&noscript=1"
    /></noscript>
    <!-- End Meta Pixel Code -->
    <!-- Global site tag (gtag.js) - Google Analytics -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=G-PC15JG6KGN"></script>
    <script>
        window.dataLayer = window.dataLayer || [];

        function gtag() {
            dataLayer.push(arguments);
        }

        gtag('js', new Date());
        gtag('config', 'G-PC15JG6KGN');
    </script>
    <!-- END Global site tag (gtag.js) - Google Analytics -->
    <!-- Google Tag Manager -->
    <script>(function (w, d, s, l, i) {
        w[l] = w[l] || [];
        w[l].push({
            'gtm.start':
                new Date().getTime(), event: 'gtm.js'
        });
        var f = d.getElementsByTagName(s)[0],
            j = d.createElement(s), dl = l != 'dataLayer' ? '&l=' + l : '';
        j.async = true;
        j.src =
            'https://www.googletagmanager.com/gtm.js?id=' + i + dl;
        f.parentNode.insertBefore(j, f);
    })(window, document, 'script', 'dataLayer', 'GTM-TQFGN2T');</script>
    <!-- End Google Tag Manager -->
    <!-- 사용자 행동 정보 수집 코드 끝 - Meta, GA -->
</head>
<body>
<div id="container">
    <jsp:include page="/homepage_pc_header.jsp" flush="false"/>
    <jsp:include page="/homepage_mob_header.jsp" flush="false"/>
    <div></div>
    <div id="content">
        <div style="width:100%;display:inline-block;border-radius:5px;">
            <%
            %>
            <!------------ 내용물  --------------->
            <div>
                <%
                    //Arraylist- itemlist에 있는 개수만큼 반복하기
                    //for(HashMap<String, String> hm : applylist){
                %>
                <div class="item">
                    <div class="no">no.<%out.println(applymap.get("number"));%></div>
                    <div class="item_wrapper">
                        <div class="info"><span>이름</span> <%out.println(applymap.get("name"));%></div>
                        <div class="info"><span>전화번호</span> <%out.println(applymap.get("phone"));%></div>
                        <div class="info"><span>주소</span> <%out.println(applymap.get("address"));%></div>
                        <div class="info"><span>건물종류</span> <%out.println(applymap.get("building"));%></div>
                        <div class="info"><span>평수</span> <%out.println(applymap.get("area"));%></div>
                        <div class="info"><span>예정일</span> <%out.println(applymap.get("due"));%></div>
                        <div class="info"><span>예산</span> <%out.println(applymap.get("budget"));%></div>
                        <div class="info"><span>신청날짜</span> <%out.println(applymap.get("applydate"));%></div>
                        <div class="info"><span>처리상태</span>
                            <%
                                for (HashMap<String, String> hm : companylist) {
                                    if (hm.get("state").equals("0") || hm.get("state").equals("1"))
                                        continue;
                            %>
                            <div class="company" id="<%out.print(hm.get("id"));%>">
                                <div class="company_cont">
                                    <div class="state">
                                        <div><%out.print(hm.get("name"));%></div>
                                        <%
                                            if (hm.get("as_provide").equals("1")) {
                                        %>
                                        <div id="as">A/S <%out.print(hm.get("as_warranty"));%></div>
                                        <%
                                            }%>
                                        <div class="stt"><%=state[Integer.parseInt(hm.get("state"))]%>
                                        </div>
                                    </div>
                                    <div id="addr"><%=hm.get("address")%>
                                    </div>
                                    <div id="phone"><%=hm.get("phone")%>
                                    </div>
                                </div>
                                <div class="evaluate_box">
                                    <% if(false/*fin*/) {
                                        if(Integer.parseInt(hm.get("fin_cnt")) == 0){%>
                                    <div class="evaluate construct" id="eval_1<%out.print(hm.get("id"));%>"
                                         onclick="open_modal(this.id)">시공 평가
                                    </div>
                                    <%} else {%>
                                    <div class="evaluate fin" id="eval_1<%out.print(hm.get("id"));%>"
                                         onclick="open_modal_r(this.id)">평가 완료</div>
                                    <%}}%>
                                    <%if(Integer.parseInt(hm.get("mid_cnt")) == 0){%>
                                    <div class="evaluate consult" id="eval_0<%out.print(hm.get("id"));%>"
                                         onclick="open_modal(this.id)">상담 평가
                                    </div>
                                    <%} else {%>
                                    <div class="evaluate fin" id="eval_1<%out.print(hm.get("id"));%>"
                                         onclick="open_modal_r(this.id)">평가 완료</div>
                                    <%}%>
                                </div>
                            </div>
                            <%if((Integer.parseInt(hm.get("mid_cnt"))==0)||(Integer.parseInt(hm.get("fin_cnt"))==0)){%>
                            <div class="modal_item" id="modal_item<%out.print(hm.get("id"));%>" style="display: none;"
                                 onclick="modal_container_click()">
                                <div class="modal" onclick="modal_click()">
                                    <div class="modal_content">
                                        <form action="_customer_request.jsp" method="post"
                                              enctype="multipart/form-data">
                                            <div class="eval_content">
                                                <input type="hidden" name="assign" value="<%out.print(hm.get("assign_id"));%>">
                                                <input type="hidden" name="state"
                                                       id="eval_state<%out.print(hm.get("id"));%>">
                                                <input type="hidden" name="comp" value="<%out.print(hm.get("id"));%>">
                                                <input type="hidden" name="client"
                                                       value="<%out.print(applymap.get("number"));%>">
                                                <h2>업체 평가 하기</h2>
                                                <h3>별점</h3>
                                                <div class="eval stardiv">
                                                    <input type="radio" class="<%=hm.get("id")%> star" name="star"
                                                           id="<%=hm.get("id")%> star1" value="1"><label
                                                        for="<%=hm.get("id")%> star1"><span></span></label>
                                                    <input type="radio" class="<%=hm.get("id")%> star" name="star"
                                                           id="<%=hm.get("id")%> star2" value="2"><label
                                                        for="<%=hm.get("id")%> star2"><span></span></label>
                                                    <input type="radio" class="<%=hm.get("id")%> star" name="star"
                                                           id="<%=hm.get("id")%> star3" value="3"><label
                                                        for="<%=hm.get("id")%> star3"><span></span></label>
                                                    <input type="radio" class="<%=hm.get("id")%> star" name="star"
                                                           id="<%=hm.get("id")%> star4" value="4"><label
                                                        for="<%=hm.get("id")%> star4"><span></span></label>
                                                    <input type="radio" class="<%=hm.get("id")%> star" name="star"
                                                           id="<%=hm.get("id")%> star5" value="5"><label
                                                        for="<%=hm.get("id")%> star5"><span></span></label>
                                                    <input type="hidden" id="total_rate<%=hm.get("id")%>" name="rate">
                                                </div>
                                                <h3>평가하기</h3>
                                                <div class="eval text">
                                                    <textarea id="evaluate_info" name="text"></textarea>
                                                </div>
                                                <h3>사진 첨부하기</h3>
                                                <h4>사진은 최대 5장까지 첨부 가능합니다.</h4>
                                                <h6>사진을 다시 클릭하시면 삭제하실 수 있습니다.</h6>
                                                <div class="eval photo" id="<%=hm.get("id")%>">
                                                    <div id="imagePreview<%=hm.get("id")%>">
                                                        <input type="hidden" id="index<%=hm.get("id")%>" value="0">
                                                        <input type="hidden" id="cnt<%=hm.get("id")%>" value="0">
                                                        <label for="review_img<%=hm.get("id")%>0" id="img_label<%=hm.get("id")%>0"
                                                               class="add_photo"></label>
                                                        <input type="file" name="img0" id="review_img<%=hm.get("id")%>0"
                                                               class="review_photo" accept="image/*">
                                                    </div>
                                                </div>
                                                평가는 익명으로 업체에 전달되며<br>
                                                작성하신 리뷰는 수정이 불가능합니다.<br><br>

                                                <input class="eval" type="submit" value="등록">
                                            </div>
                                        </form>
                                        <div class="close_modal_btn">
                                            <button class="close_modal" onclick="close_modal()">
                                                <img class="close_modal_img" src="https://somoonhouse.com/icon/x.png"/>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%}%>

                            <%}%>
                        </div>
                        <!--<div id="request_cancel">상담취소하기</div>-->
                        <!-- div class="info">
                            <span>상담 전체 평가하기</span>
                            <textarea></textarea>
                        </div-->
                        <%// 처리상태 - 상담대기, 상담중, 상담완료, 통화 불가, 계약 대기중, 계약 성사, 계약 불발 %>

                    </div>
                </div>
            </div>
            <a href="_logout.jsp">로그아웃</a>
            <!------------ 내용물  --------------->
        </div>
    </div>
    <%
        //DB개체 정리
/*
pstmt.close();
rs.close();
query="";
conn.close();
*/
    %>
    <script>
        //별점주기
        $('.star').click(function () {
            var starClass = $(this).attr('class');
            var id = $(this).attr('id').slice(-100, -6);
            var num = $(this).attr('value');
            var numnum = parseInt(num);
            var rate = document.getElementById("total_rate" + id);
            var i;
            for (i = 1; i <= numnum; i++) {
                var mystar = $('label[for="' + starClass + i + '"]');
                mystar.css('background', 'url("css/img/onStar.png")');
                mystar.css('background-size', '20px 20px');
            }
            for (i = numnum + 1; i <= 5; i++) {
                var mystar = $('label[for="' + starClass + i + '"]');
                mystar.css('background', 'url("css/img/noStar.png")');
                mystar.css('background-size', '20px 20px');
            }
            rate.setAttribute("value", num);
        })
    </script>
    <script>
        //리뷰 모달창 컨트롤러
        var remem_modal_id;
        const open_modal = (prop) => {
            $('body').css("overflow", "hidden");
            var state_id = prop.slice(5);
            var id = state_id.slice(1);
            var state = state_id.slice(0, 1)
            var modal_id = "modal_item" + id;
            var this_modal = document.getElementById(modal_id);
            var button_state = document.getElementById("eval_state" + id);
            button_state.setAttribute("value", state);
            this_modal.style.display = 'flex';
            remem_modal_id = modal_id;
        }
        const close_modal = () => {
            $('body').css("overflow", "scroll");
            var modal = document.getElementById(remem_modal_id);
            modal.style.display = 'none';
        }
        var isIn = 0;

        function modal_container_click() {
            if (!isIn) {
                close_modal();
            }
            isIn = 0;
        }

        function modal_click() {
            isIn = 1;
        }
    </script>
    <script>
        //파일 업로드 관리(리뷰 사진 관리)
        var index = 0;
        var filecnt = 0;

        function readInputFile(e) {
            var sel_files = [];

            sel_files = [];

            var revimg_id = e.target.parentElement.parentElement.id;
            var files = e.target.files;
            var fileArr = Array.prototype.slice.call(files);
            var ind = document.getElementById("index"+revimg_id);
            var cnt = document.getElementById("cnt"+revimg_id);
            index = parseInt(ind.value);
            filecnt = parseInt(cnt.value);
            console.log(index, filecnt);

            fileArr.forEach(function (f) {
                if (!f.type.match("image/.*")) {
                    alert("이미지 확장자만 업로드 가능합니다.");
                    return;
                }
                if (filecnt < 5) {
                    sel_files.push(f);
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        var label = {};
                        label = document.getElementById('img_label' + revimg_id + index);
                        console.log(label);
                        label.remove();
                        var html = "<a id='img_id_" + index + "'><img class='img_prv' src='" + e.target.result + "' data-file='" + f.name + "'></a>";
                        $('#imagePreview'+revimg_id).append(html);
                        index++;
                        filecnt++;
                        ind.setAttribute("value", index);
                        cnt.setAttribute("value", filecnt);
                        if (filecnt < 5) {
                            var upload = "<label for='review_img" + revimg_id + index + "' id='img_label" + revimg_id + index + "' class='add_photo'></label> <input type='file' name='img" + index + "' id='review_img" + revimg_id + index + "' class='review_photo' accept='image/*'>";
                            $('#imagePreview'+revimg_id).append(upload);
                        }
                    };
                    reader.readAsDataURL(f);
                }
            })
            if (filecnt > 5) {
                alert("최대 5장까지 업로드 할 수 있습니다.");
            }
        }

        function img_del(e) {
            var delimg = e.target.parentNode;
            var id = delimg.parentElement.id.slice(12);
            var img_num = e.target.parentElement.id.slice(7);
            var img_input = document.getElementById("review_img" + id + img_num);
            var cnt = document.getElementById("cnt"+id);
            filecnt = parseInt(cnt.value);
            filecnt--;
            cnt.setAttribute("value", filecnt);
            console.log(img_num,cnt,filecnt);
            delimg.remove();
            img_input.remove();
            if (filecnt === 4) {
                var upload = "<label for='review_img" + id + index + "' id='img_label" + id + index + "' class='add_photo'></label> <input type='file' name='img" + index + "' id='review_img" + id + index + "' class='review_photo' accept='image/*'>";
                $('#imagePreview'+id).append(upload);
            }
        }

        $(document).on('change', "input[class='review_photo']", readInputFile);
        $(document).on('click', "img[class='img_prv']", img_del);
    </script>
    <script>
        $('#request_cancel').click(function () {
            location.href = "_customer_request_state.jsp?apply_num=" + "<%=applymap.get("number")%>";
        })
        $('.company_cont').click(function () {
            location.href = "https://somoonhouse.com/interior_info.jsp?id=" + $(this)[0].parentElement.id;
        })

        window.onload = function () {
            if ("<%=s_id%>" == "" || "<%=s_id%>" == "null") {
                alert("유효하지 않은 접근입니다!");
                history.back();
            }
        }
    </script>
</div>
</body>
</html>