<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page language="java" import="java.text.*,java.sql.*,java.util.*,java.security.*,java.math.BigInteger" %>
<%@ page language="java" import="java.text.*,java.sql.*,java.util.Calendar,java.util.*" %>
<%@ page language="java" import="myPackage.DBUtil" %>
<%@ page language="java" import="myPackage.*" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=utf-8"); %>
<%

    //DB에 사용 할 객체들 정의
    Connection conn = DBUtil.getMySQLConnection();
    PreparedStatement pstmt = null;
    Statement stmt = null;
    String query = "";
    String sql = "";
    ResultSet rs = null;

    class Dates {
        String date;
        HashMap<String, HashMap<String, String>> applies;
        HashMap<String, HashMap<String, String>> details;

        void setDate(String date) {
            this.date = date;
        }

        void setApplies(HashMap applies) {
            this.applies = applies;
        }

        void setDetails(HashMap details) {
            this.details = details;
        }

        String getDate() {
            return this.date;
        }

        HashMap getApplies() {
            return this.applies;
        }

        HashMap getDetails() {
            return this.details;
        }
    }

//세션 생성 create session
    session.setAttribute("page", "remodeling_request.jsp"); // 현재 페이지 current page
//세션 가져오기 get session
    String now = session.getAttribute("page") + ""; // 현재 페이지 current page
    String s_id = session.getAttribute("s_id") + "";// 현재 사용자 current user
    String name = session.getAttribute("name") + "";
    String home_id = session.getAttribute("home_id") + "";// 현재 사용자 current user
    String home_name = session.getAttribute("home_name") + "";

    String type = "";
//정보 받아오기
    query = "select * from USERS where ID = ?";
    pstmt = conn.prepareStatement(query);
    pstmt.setInt(1, Integer.valueOf(home_id));
    rs = pstmt.executeQuery();
    HashMap<String, String> user = new HashMap<String, String>();
    while (rs.next()) {
        user.put("name", rs.getString("USERNAME"));
        user.put("email", rs.getString("EMAIL"));
        user.put("phone", rs.getString("PHONE"));
        user.put("grade", rs.getString("GRADE"));
        type = rs.getString("SNS_TYPE");
        //SNS타입 한글로 변경
        if (type.equals("naver")) {
            type = "네이버";
        } else if (type.equals("kakao")) {
            type = "카카오";
        } else if (type.equals("google")) {
            type = "구글";
        } else {
            type = "정보없음";
        }
        user.put("type", type);
    }

//저장건 불러오기
    query = "select * from REMODELING_APPLY_TEMP where C_id = ?";
    pstmt = conn.prepareStatement(query);
    pstmt.setInt(1, Integer.valueOf(home_id));
    rs = pstmt.executeQuery();

    LinkedList<Dates> datelist = new LinkedList<Dates>();

    while (rs.next()) {
        HashMap<String, String> itemmap = new HashMap<String, String>();


        Dates date = new Dates();
        date.setDate(rs.getString("Apply_date"));

        HashMap<String, HashMap<String, String>> applies = new HashMap<String, HashMap<String, String>>();
        HashMap<String, HashMap<String, String>> details = new HashMap<String, HashMap<String, String>>();


        String item_number = "";
        String item_itemnum = "";
        String item_name = "";
        String item_phone = "";
        String item_address = "";
        String item_building = "";
        String item_area = "";
        String item_due = "";
        String item_budget = "";
        String item_applydate = "";
        String item_reason = "";

        if (rs.getString("Number") != null) {
            item_number = rs.getString("Number") + "";
        }
        if (rs.getString("Item_num") != null) {
            item_itemnum = rs.getString("Item_num") + "";
        }
        if (rs.getString("Name") != null) {
            item_name = rs.getString("Name") + "";
        }
        if (rs.getString("Phone") != null) {
            item_phone = rs.getString("Phone") + "";
        }
        if (rs.getString("Address") != null) {
            item_address = rs.getString("Address") + "";
        }
        if (rs.getString("Area") != null) {
            item_area = rs.getString("Area") + "";
        }
        if (rs.getString("Due") != null) {
            item_due = rs.getString("Due") + "";
        }
        if (rs.getString("Budget") != null) {
            item_budget = rs.getString("Budget") + "";
        }
        if (rs.getString("Apply_date") != null) {
            item_applydate = rs.getString("Apply_date") + "";
        }
        if (rs.getString("reason") != null) {
            item_reason = rs.getString("reason") + "";
        }

        //빌딩타입 한글로 변경
        item_building = rs.getString("Building_type") + "";
        if (item_building != null && !item_building.equals("null")) {
            String[] building_types = {"아파트", "빌라", "주택", "원룸"};
            item_building = building_types[Integer.parseInt(item_building)];
        } else {
            item_building = "정보없음";
        }

        itemmap.put("number", item_number);
        itemmap.put("itemnum", item_itemnum);
        itemmap.put("name", item_name);
        itemmap.put("phone", item_phone);
        itemmap.put("address", item_address);
        itemmap.put("building", item_building);
        itemmap.put("area", item_area);
        itemmap.put("due", item_due);
        itemmap.put("budget", item_budget);
        itemmap.put("applydate", item_applydate);
        itemmap.put("reason", item_reason);

        applies.put(item_number, itemmap);

        //details 값 넣기
        PreparedStatement pstmt2 = null;
        query = "select * from REMODELING_APPLY_TEMP ra, REMODELING_APPLY_DIV2_TEMP rad, RMDL_DIV1 rd, RMDL_DIV2 rd2 where ra.Number = ? and ra.Number = rad.Apply_num And rad.Div2_num = rd2.Id and rd2.Parent_id = rd.Id";
        pstmt2 = conn.prepareStatement(query);
        pstmt2.setString(1, item_number);
        ResultSet rs3 = pstmt2.executeQuery();
        HashMap<String, String> dhm = new HashMap<String, String>();
        while (rs3.next()) {
            dhm.put(rs3.getString("rd.Name"), rs3.getString("rd2.Name"));
        }
        details.put(item_number, dhm);

        date.setApplies(applies);
        date.setDetails(details);

        datelist.add(date);
    }

    //시공 정보 불러오기
    query = "select * from RMDL_DIV1";
    pstmt = conn.prepareStatement(query);
    rs = pstmt.executeQuery();
    LinkedList<HashMap<String, String>> rmdl1 = new LinkedList<HashMap<String, String>>();
    while (rs.next()) {
        HashMap<String, String> item = new HashMap<String, String>();
        item.put("id", rs.getString("Id"));
        item.put("name", rs.getString("Name"));
        item.put("flag","0");
        rmdl1.add(item);
    }

    query = "select * from RMDL_DIV2";
    pstmt = conn.prepareStatement(query);
    rs = pstmt.executeQuery();
    LinkedList<HashMap<String, String>> rmdl2 = new LinkedList<HashMap<String, String>>();
    while (rs.next()) {
        HashMap<String, String> item = new HashMap<String, String>();
        item.put("id", rs.getString("Id"));
        item.put("pid", rs.getString("Parent_id"));
        item.put("name", rs.getString("Name"));
        rmdl2.add(item);
    }

%>
<!DOCTYPE html>
<html>
<head>
    <link rel="SHORTCUT ICON" href="https://somoonhouse.com/img/favicon.ico"/>
    <link rel="stylesheet" type="text/css" href="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/mypage.css"/>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/>
    <title>소문난집</title>
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
<jsp:include page="/homepage_pc_header.jsp" flush="false"/>
<jsp:include page="/homepage_mob_header.jsp" flush="false"/>
<div class="container">
    <div class="body_container">
        <div class="content">
            <form>
            <div class="head">
                <h1>내 정보</h1>
            </div>
            <div class="info_main">
                <div class="info_content">
                    <div class="info_content_title">성함</div>
                    <div class="info_content_info"><%out.println(user.get("name"));%></div>
                </div>
                <div class="info_content">
                    <div class="info_content_title">전화번호</div>
                    <%if(user.get("phone")!=null){%>
                    <div class="info_content_info info_mod" style="display: flex"><%out.println(user.get("phone"));%></div>
                    <%} else {%>
                    <div class="info_content_info info_mod" style="display: flex">전화번호가 등록되어 있지 않습니다.</div>
                    <%}%>
                    <input type="text" class="info_input" name="phone" value="<%=user.get("phone")%>" style="display: none">
                </div>
                <div class="info_content">
                    <div class="info_content_title">이메일</div>
                    <div class="info_content_info info_mod" style="display: flex"><%out.println(user.get("email"));%></div>
                    <input type="text" class="info_input" name="email" value="<%=user.get("email")%>" style="display: none">
                </div>
                <div class="info_content">
                    <div class="info_content_title">등급</div>
                    <div class="info_content_info"><%out.println(user.get("grade"));%></div>
                </div>
                <div class="info_content">
                    <div class="info_content_title">연동 SNS</div>
                    <div class="info_content_info"><%out.println(user.get("type"));%></div>
                </div>
            </div>
            <input type="button" class="info_btn" id="modify_btn" value="개인 정보 수정" style="display: none">
            <input type="button" class="info_btn" id="cancel_btn" value="취소하기" style="display: none">
            <input type="submit" class="info_btn" id="submit_btn" value="수정하기" style="display: none">
            </form>
        </div>
        <div class="content">
            <div class="head">
                <h1>내 상담 신청 확인</h1>
            </div>
            <div class="contract_main">
                <%
                    if (datelist.size() == 0) {
                %>
                <div class="no_contract"> 저장된 신청서가 없습니다!</div>
                <%
                } else {
                    //Arraylist- itemlist에 있는 개수만큼 반복하기1
                    for (int idx = 0; idx < datelist.size(); idx++) {
                        for (String key : datelist.get(idx).applies.keySet()) {
                            HashMap hm = datelist.get(idx).applies.get(key);
                            HashMap detail = datelist.get(idx).details.get(key);
                %>
                <div class="contract" id='item<%out.println(hm.get("number"));%>' onclick="open_modal(this.id)">
                    <div class="item_header">
                        <div class="no">No.<%out.println(idx+1);%></div>
                        <% if (!hm.get("name").equals("")) {%>
                        <div class="info"><span>신청자명</span> <%out.println(hm.get("name"));%></div>
                        <%}%>
                    </div>
                    <div class="item_wrapper">
                        <div class="item_wrapper2">
                            <div class="info"><span>건물정보</span> <%out.println(hm.get("building"));%><%
                                out.println(hm.get("area"));
                                if (!(hm.get("area").equals(""))) {
                            %>
                                <div style="display: inline">평</div>
                                <%}%></div>
                            <div class="info"><span>주소</span> <%out.println(hm.get("address"));%></div>
                        </div>
                        <div class="item_wrapper2">
                            <div class="info"><span>전화번호</span> <%out.println(hm.get("phone"));%></div>
                            <div class="info"><span>최종 수정 날짜</span> <%out.println(hm.get("applydate"));%></div>
                        </div>
                    </div>
                </div>
                <div class="modal_item" id='modal_item<%out.println(hm.get("number"));%>' style="display: none;"
                     onclick="modal_container_click()">
                    <div class="modal" onclick="modal_click()">
                        <div class="modal_content">
                            <div class="modal_header">
                                <div class="no">No.<%out.println(idx+1);%></div>
                                <div class="info"><span>최종 수정 날짜</span>
                                    <div id="applydate"><%out.println(hm.get("applydate"));%></div>
                                </div>
                            </div>
                            <div class="item_wrapper">
                                <div class="modal_text">
                                    <form>
                                        <%
                                            String[] building_types = {"아파트", "빌라", "주택", "원룸"};
                                            String[] due_type = {"1개월 이내", "2개월 이내", "2개월 이후"};
                                            String[] bud_type = {"1천만원 이하", "2천만원 이하", "3천만원 이하", "4천만원 이하", "5천만원 이하", "6천만원 이하", "7천만원 이하", "8천만원 이하", "1억원 이하", "1억원 이상", "미정(상담 후 결정)"};
                                        %>
                                        <input type="hidden" name="number" id="delnum" value="<%=hm.get("number")%>">
                                        <input type="hidden" name="item_num" id="delnum" value="<%=hm.get("itemnum")%>">
                                        <div class="info privacy"><span>이름</span><span>전화번호</span>
                                            <input type="text" id="name" name="name" class="text"
                                            <%if(hm.get("name").equals("")){%> value="<%out.println(user.get("name"));%>"<%}else{%> value="<%out.println(hm.get("name"));%>"<%}%>>
                                            <input type="text" id="phone" name="phone" class="text"
                                            <%if(hm.get("phone").equals("")){%> value="<%out.println(user.get("phone"));%>"<%}else{%> value="<%out.println(hm.get("phone"));%>"<%}%>>
                                        </div>
                                        <div class="info"><span>주소</span><input type="text" id="address" name="address" class="text" placeholder="정확한 주소를 입력해주세요." value="<%out.println(hm.get("address"));%>">
                                        </div>
                                        <div class="info house">
                                            <span>건물종류</span><span>평수</span><span>예정일</span>
                                            <select name="building_type">
                                                <option value="" selected>--선택하세요--</option>
                                                <% for (int i = 0; i < building_types.length; i++) { %>
                                                <option value ="<%=i%>" <%if(hm.get("building") == building_types[i]){%>selected<%}%>><%=building_types[i]%><%}%>
                                            </select>
                                            <div><input type="text" id="area" name="area" class="text" value="<%out.println(hm.get("area"));%>" placeholder="ex)34">평</div>
                                            <select name="due">
                                                <option value="" selected>--선택하세요--</option>
                                                <% for (int i = 0; i < due_type.length; i++) { %>
                                                <option value="<%=due_type[i]%>" <%if(hm.get("due").equals(due_type[i])){%>selected<%}%>><%=due_type[i]%></option><%}%>
                                            </select>
                                        </div>
                                        <div class="info details"><span>상세시공</span>
                                            <div class="detail_box">
                                                <%for(int r1 =0; r1 < rmdl1.size(); r1++){ HashMap<String, String> rmdls1 = rmdl1.get(r1);%>
                                                <span class="detail">
                                                    <input type="checkbox" id="<%=hm.get("number")%>rmdlin<%=r1%>" name="division1"  onclick="toggle_selbox(this)" value="<%=rmdls1.get("id")%>" <%for(int r1c =0; r1c < rmdl1.size(); r1c++){if (detail.get(rmdl1.get(r1c).get("name")) != null && Objects.equals(rmdl1.get(r1c).get("name"), rmdls1.get("name"))){%>checked<%break;}}%>><%=rmdls1.get("name")%>
                                                    <select id="<%=hm.get("number")%>rmdlsel<%=r1%>" name="division2-<%=r1%>" hidden>
                                                        <option value="" selected>--선택하세요--</option>
                                                        <%for(int r2 = 0; r2 < rmdl2.size(); r2++){HashMap<String, String> rmdls2 = rmdl2.get(r2); if(Objects.equals(rmdls2.get("pid"), rmdls1.get("id"))){%>
                                                        <option value="<%=rmdls2.get("id")%>" <%for(int r2c = 0; r2c < rmdl1.size(); r2c++){if(rmdls2.get("name").equals(detail.get(rmdl1.get(r2c).get("name"))) && rmdls2.get("pid").equals(rmdl1.get(r2c).get("id"))){%>selected<%break;}}%>><%=rmdls2.get("name")%></option><%}}%>
                                                    </select>
                                                </span>
                                                <%}%>
                                            </div>
                                        </div>
                                        <div class="info">
                                            <span>예산</span>
                                            <select name="budget">
                                                <option value="" selected>--선택하세요--</option>
                                                <% for (int i = 0; i < bud_type.length; i++) { %>
                                                <option value="<%=bud_type[i]%>" <%if(hm.get("budget").equals(bud_type[i])){%>selected<%}%>><%=bud_type[i]%><%}%>
                                            </select>
                                        </div>
                                        <div class="info"><span>신청 이유 (선택사항)</span><textarea id="reason" name="reason" class="text"><%out.println(hm.get("reason"));%></textarea>
                                        </div>
                                        <div class="info"><span>개인정보 활용 동의</span>
                                            <input type="checkbox" name="agree" id="agree"><a href="personal.html" target="_blank">전문보기</a>
                                        </div>
                                        <div class="button_container">
                                            <input type="button" value="삭제하기" onclick="return delform(this.form);">
                                            <input type="button" value="수정하기" onclick="return saveform(this.form);">
                                            <input type="button" value="등록하기" onclick="return submitform(this.form);">
                                        </div>
                                    </form>
                                </div>
                            </div>
                            <div class="close_modal_btn">
                                <button class="close_modal" onclick="close_modal()">
                                    <img class="close_modal_img" src="https://somoonhouse.com/icon/x.png"/>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <%
                            }
                        }
                    }
                %>
            </div>
        </div>
    </div>
</div>
<jsp:include page="/newTestFooter.jsp" flush="false"/>
</body>
<script>

    var det = document.getElementsByName("division1")
    for(var i=0; i<det.length; i++){
        if(det[i].checked == true){
            var inputid = det[i].id.slice(-1)
            var inputnum = det[i].id.slice(-100,-7)
            const selectElem = document.getElementById(inputnum+'rmdlsel'+inputid);
            selectElem.hidden = false
        }
    }

    function toggle_selbox(checkbox) {
        var id = checkbox.id.slice(-1)
        var num = checkbox.id.slice(-100,-7)
        const select_elem = document.getElementById(num+'rmdlsel'+id);
        select_elem.hidden = checkbox.checked ? false : true;
    }
    var remem_modal_id;
    var form_id;
    const form_close = () => {
        var form = document.getElementById(form_id);
        form.style.display = 'none';
    }
    const open_modal = (prop) => {
        $('body').css("overflow", "hidden");
        var id = prop.slice(4);
        var modal_id = "modal_item" + id;
        var this_modal = document.getElementById(modal_id);
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

    function saveform(frm) {
        frm.action = '_remodeling_save_update.jsp';
        frm.submit();
        return true;
    }

    function delform(frm) {
        frm.action = '_remodeling_save_del.jsp';
        frm.submit();
        return true;
    }

    function submitform(frm) {
        frm.action = '_remodeling_save_submit.jsp';
        frm.submit();
        return true;
    }
</script>
</html>