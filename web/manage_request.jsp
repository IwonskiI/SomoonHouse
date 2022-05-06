<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*,java.util.*,java.security.*,java.math.BigInteger" %>
<%@ page language="java" import="myPackage.*" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=utf-8"); %>
<% session.setAttribute("page", "remodeling_form.jsp"); %>
<%

    //DB에 사용 할 객체들 정의
    Connection conn = DBUtil.getMySQLConnection();
    PreparedStatement pstmt = null;
    Statement stmt = null;
    String query = "";
    String sql = "";
    ResultSet rs = null;

//세션 생성 create session
    session.setAttribute("page", "remodeling_request.jsp"); // 현재 페이지 current page
//세션 가져오기 get session
    String now = session.getAttribute("page")+""; // 현재 페이지 current page
    String s_id = session.getAttribute("s_id")+"";// 현재 사용자 current user
    String name = session.getAttribute("name")+"";


    //변수설정
    String[] buildingType = {"아파트", "빌라", "주택", "원룸"};
    String[] assignedState = {"상담 대기", "부재중", "상담중", "미팅 예정", "계약진행중"};
    class Dates{
        String date;
        HashMap<String, HashMap<String, String>> applies;
        HashMap<String, HashMap<String, String>> details;

        void setDate(String date){
            this.date = date;
        }
        void setApplies(HashMap applies){
            this.applies = applies;
        }
        void setDetails(HashMap details){
            this.details = details;
        }

        String getDate(){
            return this.date;
        }
        HashMap getApplies(){
            return this.applies;
        }
        HashMap getDetails(){
            return this.details;
        }
    }



//신청내용들 받아오기
    String state = request.getParameter("state")+"";
    /*
    if(!s_id.equals("100"))
        query = "select * from REMODELING_APPLY where Number < 0";
    else
     */
    query = "select * from REMODELING_APPLY";



//특정상태에 대한 결과를 받아오는 탭일 경우

    if(!s_id.equals("100")){
        query += " where Number < 0";
    }
    else if(!state.equals("null") && !state.equals("NULL") && !state.equals("Null") && state != null && !state.contains("6")){
        query += " where State = " + state;
    }
    query += " order by State asc, Number desc";
    pstmt = conn.prepareStatement(query);

    rs = pstmt.executeQuery();

    LinkedList<HashMap<String, String>> itemlist = new LinkedList<HashMap<String, String>>();
    HashMap<String, LinkedList<HashMap<String, String>>> totalstatemap = new HashMap<String, LinkedList<HashMap<String, String>>>();

    LinkedList<Dates> datelist = new LinkedList<Dates>();

    while(rs.next()){
        HashMap<String, String> itemmap = new HashMap<String, String>();


        Dates date = new Dates();
        date.setDate(rs.getString("Apply_date"));

        HashMap<String, HashMap<String, String>> applies = new HashMap<String, HashMap<String, String>>();
        HashMap<String, HashMap<String, String>> details = new HashMap<String, HashMap<String, String>>();


        String item_number = rs.getString("Number")+"";
        String item_itemnum = rs.getString("Item_num")+"";
        //String agree = rs.getString("agree");
        String item_name = rs.getString("Name")+"";
        String item_phone = rs.getString("Phone")+"";
        String item_address = rs.getString("Address")+"";
        String item_building = rs.getString("Building_type")+"";
        String item_area = rs.getString("Area")+"";
        String item_due = rs.getString("Due")+"";
        String item_budget = rs.getString("Budget")+"";
        String item_consulting = rs.getString("Consulting")+"";
        String item_compare = rs.getString("compare")+"";
        String item_applydate = rs.getString("Apply_date")+"";
        String item_state = rs.getString("State")+"";
        String item_company = "";
        String item_title = "";
        String item_url = "";
        String item_calling = rs.getString("Calling")+"";
        String item_assigned_time = rs.getString("Assigned_time")+"";
        String item_remark = "";
        String item_reason = "";
        if(rs.getString("remark")!=null) {
            item_remark = rs.getString("remark") + "";
        }
        if(rs.getString("reason")!=null) {
            item_reason = rs.getString("reason") + "";
        }
        LinkedList statelist = new LinkedList<HashMap<String, String>>();

        //통합 신청일 경우(item number가 0임)
        if(item_itemnum.equals("0")){
            item_company = "";
            item_title = "통합 신청 버튼으로 신청한 사례";
            item_url = "#";
        }
        //블로그 신청일 경우
        else if(item_itemnum.equals("1")){
            item_company = "";
            item_title = "블로그를 통해 신청한 사례";
            item_url = "#";
        }
        // 일반 사례 신청일 경우
        else{
            //신청한 사례 원본 가져오기
            String query2 = "select * from REMODELING where Number = ?";
            pstmt = conn.prepareStatement(query2);
            pstmt.setString(1, item_itemnum);
            ResultSet rs2 = pstmt.executeQuery();
            while(rs2.next()){
                item_company = rs2.getString("Company");
                item_title = rs2.getString("Title");
                item_url = rs2.getString("URL");
            }
        }
        //빌딩타입 한글로 변경
        if(item_building != null && !item_building.equals("null")){
            String[] building_types = {"아파트", "빌라", "주택", "원룸"};
            item_building = building_types[Integer.parseInt(item_building)];
        }
        else {
            item_building = "정보없음";
        }
        //업체전달 완료일 경우
        if(!item_state.equals("0")){
            String status[] = {"신규(대기)", "신규(거절)", "진행중(상담예정)", "진행중(부재중)", "진행중(상담중)", "진행중(미팅예정)", "진행중(계약진행중)", "(계약완료)x", "완료(계약완료)", "중단(통화불가)", "중단(사유입력)", "상담취소"};
            String query2 = "select C.Name, A.State, A.refuse_reason from COMPANY C, ASSIGNED A where A.Company_num = C.Id and Apply_num = ?";

            pstmt = conn.prepareStatement(query2);
            pstmt.setString(1, item_number);
            ResultSet rs2 = pstmt.executeQuery();
            while(rs2.next()){
                HashMap<String, String> statemap = new HashMap<String, String>();
                statemap.put("reason", rs2.getString("refuse_reason"));
                statemap.put("name", rs2.getString("Name"));
                statemap.put("state", status[Integer.parseInt(rs2.getString("State"))]);
                statelist.add(statemap);
            }
        }

        itemmap.put("company", item_company);
        itemmap.put("title", item_title);
        itemmap.put("url", item_url);
        itemmap.put("number", item_number);
        itemmap.put("itemnum", item_itemnum);
        itemmap.put("name", item_name);
        itemmap.put("phone", item_phone);
        itemmap.put("address", item_address);
        itemmap.put("building", item_building);
        itemmap.put("area", item_area);
        itemmap.put("due", item_due);
        itemmap.put("budget", item_budget);
        itemmap.put("consulting", item_consulting);
        itemmap.put("compare", item_compare);
        itemmap.put("applydate", item_applydate);
        itemmap.put("state", item_state);
        itemmap.put("calling", item_calling);
        itemmap.put("assigned_time", item_assigned_time);
        itemmap.put("remark", item_remark);
        itemmap.put("reason", item_reason);

        totalstatemap.put(item_number.toString(), statelist);
        itemlist.add(itemmap);


        applies.put(item_number, itemmap);

        //details 값 넣기
        PreparedStatement pstmt2 = null;
        query = "select * from REMODELING_APPLY ra, REMODELING_APPLY_DIV2 rad, RMDL_DIV1 rd, RMDL_DIV2 rd2 where ra.Number = ? and ra.Number = rad.Apply_num And rad.Div2_num = rd2.Id and rd2.Parent_id = rd.Id";
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

    //신청별로 거절한회사/수락한회사/준적없는회사 받아오기
    HashMap<String, HashMap<String, String>> company_state = new HashMap<String, HashMap<String, String>>();
    for (int i = 0; i < itemlist.size(); i++) {
        HashMap<String, String> companymap = new HashMap<String, String>();
        query = "select * from ASSIGNED where Apply_num = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, itemlist.get(i).get("number"));
        rs = pstmt.executeQuery();
        String company_num = "";
        String status = "";
        while(rs.next()){
            company_num = rs.getString("Company_num");
            status = rs.getString("State");
            companymap.put(company_num, status);
        }
        company_state.put(itemlist.get(i).get("number"), companymap);
    }

//회사 받아오기
    query = "Select * from COMPANY where State = 1 OR Id = 47" ; //47은 게스트페이지
    pstmt = conn.prepareStatement(query);
    rs = pstmt.executeQuery();
    LinkedList<HashMap<String, String>> company = new LinkedList<HashMap<String, String>>();
    while(rs.next()){
        HashMap<String, String> mymap = new HashMap<String, String>();
        mymap.put("id", rs.getString("Id"));
        mymap.put("name", rs.getString("Name"));
        company.add(mymap);
    }
%>

<!DOCTYPE html>
<html>
<head>
    <link rel="SHORTCUT ICON" href="img/favicon.ico" />
    <link rel="stylesheet" type="text/css" href="https://pm.pstatic.net/css/webfont_v170623.css"/>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/manage_request.css"/>
    <script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
    <title>소문난집 - 신청 건 확인</title>
    <!-- 사용자 행동 정보 수집 코드 시작 - Meta, GA -->
    <!-- 모든 페이지에 하나씩만 포함되어 있어야 합니다. 위치는 </head> 바로 위로 통일 -->
    <!-- Meta Pixel Code -->
    <script>
        !function(f,b,e,v,n,t,s)
        {if(f.fbq)return;n=f.fbq=function(){n.callMethod?
            n.callMethod.apply(n,arguments):n.queue.push(arguments)};
            if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
            n.queue=[];t=b.createElement(e);t.async=!0;
            t.src=v;s=b.getElementsByTagName(e)[0];
            s.parentNode.insertBefore(t,s)}(window, document,'script',
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
        function gtag(){dataLayer.push(arguments);}
        gtag('js', new Date());
        gtag('config', 'G-PC15JG6KGN');
    </script>
    <!-- END Global site tag (gtag.js) - Google Analytics -->
    <!-- Google Tag Manager -->
    <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
            new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
        j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
        'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
    })(window,document,'script','dataLayer','GTM-TQFGN2T');</script>
    <!-- End Google Tag Manager -->
    <!-- 사용자 행동 정보 수집 코드 끝 - Meta, GA -->
</head>
<body>
<div id="container">
    <jsp:include page="/homepage_pc_header.jsp" flush="false" />
    <jsp:include page="/homepage_mob_header.jsp" flush="false" />
    <div class="tab">
        <a class="tab-item" href="_refresh_request.jsp?state=0">미배분</a>
        <a class="tab-item" href="_refresh_request.jsp?state=1">재배분필요</a>
        <a class="tab-item" href="_refresh_request.jsp?state=2">배분중</a>
        <a class="tab-item" href="_refresh_request.jsp?state=3">전체수락</a>
        <a class="tab-item" href="_refresh_request.jsp?state=4">고객취소</a>
        <a class="tab-item" href="_refresh_request.jsp?state=5">관리자삭제</a>
        <a class="tab-item" href="_refresh_request.jsp?state=6">전체보기</a>
    </div>
    <a class="refresh" href="_refresh_request.jsp">새로고침</a>
    <div id="content">
        <div id="sample"></div>
        <div style="width:100%;display:inline-block;border-radius:5px;">
            <div class="manage_container">
                <%
                    //Arraylist- itemlist에 있는 개수만큼 반복하기1
                    for (int idx = 0; idx < datelist.size(); idx++) {
                        for(String key : datelist.get(idx).applies.keySet()){
                            HashMap hm = datelist.get(idx).applies.get(key);
                            HashMap detail = datelist.get(idx).details.get(key);
                %>
                <div class="item" id='item<%out.println(hm.get("number"));%>' onclick="open_modal(this.id)">
                    <div class="item_header">
                        <div class="no">no.<%out.println(hm.get("number"));%></div>
                        <div class="state">
                            <%if(hm.get("state").equals("0")){%><div id="stt0"><% out.println("미배분");%></div><%}%>
                            <%if(hm.get("state").equals("1")){%><div id="stt1"><% out.println("재배분필요");%></div><%}%>
                            <%if(hm.get("state").equals("2")){%><div id="stt2"><% out.println("배분중");%></div><%}%>
                            <%if(hm.get("state").equals("3")){%><div id="stt3"><% out.println("전체수락");%></div><%}%>
                            <%if(hm.get("state").equals("4")){%><div id="stt3"><% out.println("고객취소");%></div><%}%>
                            <%if(hm.get("state").equals("5")){%><div id="stt3"><% out.println("관리자삭제");%></div><%}%>
                        </div>
                    </div>
                    <div class="item_wrapper">
                        <div class="info"><%out.println(hm.get("name"));%> <%out.println(hm.get("building"));%><%out.println(hm.get("area"));%>평</div>
                        <div class="info"><%out.println(hm.get("address"));%></div>
                        <div class="info"><span>전화번호</span> <%out.println(hm.get("phone"));%></div>
                        <div class="info"><span>신청날짜</span> <%out.println(hm.get("applydate"));%></div>
                        <div class="info">
                            <% if(hm.get("state").equals("2")){ %>
                            <div id="timer<%=hm.get("number")%>"></div>
                            <% } %>
                        </div>
                    </div>
                </div>
                <div class="modal_item" id='modal_item<%out.println(hm.get("number"));%>' style="display: none;"
                     onclick="modal_container_click()">
                    <div class="modal" onclick="modal_click()">
                        <div class="modal_content">
                            <div class="no">no.<%out.println(hm.get("number"));%></div>
                            <div class="item_wrapper">
                                <div class="modal_text">
                                    <div class="info"><span><%out.print(hm.get("company"));%></span><a href="<%out.println(hm.get("url"));%>"><%out.println(hm.get("title"));%></a></div>
                                    <div class="info"><span>이름</span> <%out.println(hm.get("name"));%></div>
                                    <div class="info phone"><span>전화번호</span> <%out.println(hm.get("phone"));%></div>
                                    <div class="info"><span>주소</span> <%out.println(hm.get("address"));%></div>
                                    <div class="info"><span>건물종류</span> <%out.println(hm.get("building"));%></div>
                                    <div class="info"><span>평수</span> <%out.println(hm.get("area"));%></div>
                                    <div class="info"><span>예정일</span> <%out.println(hm.get("due"));%></div>
                                    <div class="info"><span>상세시공</span>
                                        <table width="200px">
                                            <%
                                                String[] detail_key = {"창호/샷시", "발코니 확장", "도배", "바닥재", "주방", "욕실", "도어/문틀"};
                                                for(int d = 0; d < detail_key.length; d++){
                                                    if(detail.get(detail_key[d]) != null) {%>
                                            <tr><td><%=detail_key[d]%></td>
                                                <td><% out.println(detail.get(detail_key[d]));%></td></tr>
                                            <%}}%></table>
                                    </div>
                                    <div class="info"><span>예산</span> <%out.println(hm.get("budget"));%></div>
                                    <div class="info"><span>신청 이유</span> <%out.println(hm.get("reason"));%></div>
                                    <div class="info"><span>방문상담</span> <%if(hm.get("consulting").equals("1")) out.println("예"); else out.println("아니오");%></div>
                                    <div class="info"><span>비교견적</span> <%if(hm.get("compare").equals("1")) out.println("예"); else out.println("아니오");%></div>
                                    <div class="info"><span>신청날짜</span> <%out.println(hm.get("applydate"));%></div>
                                    <div class="info"><span>연락방식</span> <%if(hm.get("calling").equals("1")) out.println("업체의 전화를 기다리고 있습니다."); else out.println("고객님이 직접 전화하실 예정입니다.");%></div>
                                    <div class="info"><span>처리상태</span> <div class="state"><%if(hm.get("state").equals("0")){%><div id="stt0"><% out.println("미배분");%></div><%}%>
                                        <%if(hm.get("state").equals("1")){%><div id="stt1"><% out.println("재배분필요");%></div><%}%>
                                        <%if(hm.get("state").equals("2")){%><div id="stt2"><% out.println("배분중");%></div><%}%>
                                        <%if(hm.get("state").equals("3")){%><div id="stt3"><% out.println("전체수락");%></div><%}%>
                                        <%if(hm.get("state").equals("4")){%><div id="stt3"><% out.println("고객취소");%></div><%}%>
                                        <%if(hm.get("state").equals("5")){%><div id="stt3"><% out.println("관리자삭제");%></div><%}%> </div>
                                    </div>
                                    <div class="info">
                                        <%
                                            if(hm.get("state").equals("2")){ //배분중일 시 다운타이머 설정
                                        %>
                                        <div id="timer<%=hm.get("number")%>"></div>
                                        <%
                                            }
                                        %>
                                    </div>
                                    <div class="info">
                                        <textarea id="textarea<%out.print(hm.get("number"));%>">https://somoonhouse.com/customer_login.jsp?customer_num=<%out.print(hm.get("number"));%></textarea>
                                        <input class="copy_button" type="button" value="고객페이지 링크복사" onclick="myFunction('textarea<%out.print(hm.get("number"));%>')">
                                    </div>
                                </div>
                                <div class="modal_add">
                                    <table class="company_status">
                                        <%LinkedList<HashMap<String, String>> statelist = totalstatemap.get(hm.get("number"));
                                            for(HashMap<String, String> statemap : statelist){%>
                                        <tr>
                                            <td><%out.print(statemap.get("name"));%></td>
                                            <td><b><%out.print(statemap.get("state"));%></b></td>
                                            <% if(statemap.get("state").equals("신규(거절)") && !(statemap.get("reason")==null)){%>
                                            <td><span><b> -<%out.print(statemap.get("reason"));%></b></span></td>
                                            <%}%>
                                        </tr>
                                        <%}%>
                                    </table>
                                    <% if(hm.get("state").equals("0") || hm.get("state").equals("1")){%>
                                    <div class="toggle_area" id="toggle<%out.println(hm.get("number"));%>">
                                        <div id="toggle">▶</div>
                                        <div id="toggle_title">어느 회사로 넘길까요?</div>
                                    </div>
                                    <div class="form_container" id="company_form_container<%out.println(hm.get("number"));%>">
                                        <form action="_assign_company.jsp" class="assign_company"
                                              method="GET"
                                              target="_self">
                                            <input type="hidden" name="apply_num" value="<%out.print(hm.get("number"));%>">
                                            <%
                                                //상태에 따라 회사 표시 스타일 변경 -> 이미 수락한 회사는 회색(선택불가), 거절 당한 회사는 빨간색(선택가능)?
                                                for(HashMap<String, String> hm2 : company){
                                                    int find_state = 0;
                                                    for (int i = 0; i < company_state.get(hm.get("number")).size(); i++) { //상태가있나
                                                        if(company_state.get(hm.get("number")).containsKey(hm2.get("id"))){
                                                            //있
                                                            if(company_state.get(hm.get("number")).get(hm2.get("id")).equals("1")){ //거절(빨강)
                                                                find_state = 1; //거절
                                                            }
                                                            else{ //수락(회색)
                                                                find_state = 2; //수락
                                                            }
                                                            break;
                                                        }
                                                    }
                                                    if(find_state == 0) { //없(일반)
                                            %>
                                            <div><input type="checkbox" name="company" class="company_general" value="<%out.print(hm2.get("id"));%>" id="<%out.println(hm.get("number"));%>company<%out.print(hm2.get("id"));%>"><label for="<%out.println(hm.get("number"));%>company<%out.print(hm2.get("id"));%>" ><span></span><%out.print(hm2.get("name"));%></label></div>
                                            <%
                                            }
                                            else if (find_state == 1) { //거절
                                            %>
                                            <div><input type="checkbox" name="company" class="company_refused" value="<%out.print(hm2.get("id"));%>" id="<%out.println(hm.get("number"));%>company<%out.print(hm2.get("id"));%>"><label for="<%out.println(hm.get("number"));%>company<%out.print(hm2.get("id"));%>" ><span></span><%out.print(hm2.get("name"));%></label></div>
                                            <%
                                            }
                                            else {//수락
                                            %>
                                            <div><input type="checkbox" name="company" class="company_accepted" value="<%out.print(hm2.get("id"));%>" id="<%out.println(hm.get("number"));%>company<%out.print(hm2.get("id"));%>"><label for="<%out.println(hm.get("number"));%>company<%out.print(hm2.get("id"));%>" ><span></span><%out.print(hm2.get("name"));%></label></div>
                                            <%
                                                    }
                                                }
                                            %>
                                            <div>
                                                <textarea type="text" name="memo" class="remark" placeholder="기타 특이사항을 입력해주세요"><%if(!(hm.get("remark").equals(""))){out.print(hm.get("remark"));}%></textarea>
                                            </div>
                                            <div class="submit_btn">
                                                <input type="submit" value="넘기기">
                                            </div>
                                        </form>
                                        <div class="form_close_btn_container">
                                            <button class="form_close_btn" onclick="form_close()">넘기기 취소</button>
                                        </div>
                                    </div>
                                    <%}%>
                                </div>
                            </div>
                            <div class="result_info">
                                <%
                                    if(!state.equals("3") && !state.equals("4")){
                                        //전체 수락건이거나 고객 취소건이 아닌 이상 수락건으로 변경하는 버튼 달아주기
                                %>
                                <div class="manager_cancel half" id="cancel<%out.println(hm.get("number"));%>">
                                    <span>X</span>관리자삭제
                                </div>
                                <div class="manager_okay" id="okay<%out.println(hm.get("number"));%>">
                                    수락건으로
                                </div>
                                <%
                                }
                                else{
                                %>
                                <div class="manager_cancel full" id="cancel<%out.println(hm.get("number"));%>">
                                    <span>X</span>관리자삭제
                                </div>
                                <%
                                    }
                                %>
                            </div>
                            <div class="close_modal_btn">
                                <button class="close_modal" onclick="close_modal()">
                                    <img class="close_modal_img" src="https://somoonhouse.com/icon/x.png" />
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <%}}%>
            </div>
        </div>
    </div>
    <!------------ 내용물  --------------->

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
    var remem_modal_id;
    var form_id;
    $(".toggle_area").click(function(){
        var toggle_id = this.id.slice(6);
        form_id = "company_form_container" + toggle_id;
        var form_container = document.getElementById(form_id);
        form_container.style.display = 'flex';
    });
    const form_close = () =>{
        var form = document.getElementById(form_id);
        form.style.display = 'none';
    }
    const open_modal = (prop) =>{
        var id = prop.slice(4);
        var modal_id = "modal_item" + id;
        var this_modal = document.getElementById(modal_id);
        this_modal.style.display = 'flex';
        remem_modal_id = modal_id;
    }
    const close_modal = () => {
        var modal = document.getElementById(remem_modal_id);
        modal.style.display = 'none';
    }
    function myFunction(a) {
        var copyText = document.getElementById(a);
        copyText.select();
        copyText.setSelectionRange(0, 99999); /*For mobile devices*/
        document.execCommand("copy");
        alert("복사되었습니다");
    }
    var isIn = 0;
    function modal_container_click(){
        if(!isIn){
            close_modal();
        }
        isIn = 0;
    }
    function modal_click(){
        isIn = 1;
    }
</script>
<script>
    const countDownTimer = function (id, date){
        const _vvDate = new Date(date);
        const _vDate = _vvDate.setHours(_vvDate.getHours()+6);
        const _second = 1000;
        const _minute = _second * 60;
        const _hour = _minute * 60;
        const _day = _hour * 24;
        let timer;

        function showRemaining(){
            const now = new Date();
            const distDt = _vDate - now;

            if(distDt < 0){
                clearInterval(timer);
                document.getElementById(id).textContent = "배분시간종료";
                return;
            }

            const days = Math.floor(distDt / _day);
            const hours = Math.floor((distDt % _day) / _hour);
            const minutes = Math.floor((distDt % _hour) / _minute);
            const seconds = Math.floor((distDt % _minute) / _second);

            document.getElementById(id).textContent = days + '일 ';
            document.getElementById(id).textContent += hours + '시간 ';
            document.getElementById(id).textContent += minutes + '분 ';
            document.getElementById(id).textContent += seconds + '초 ';

        }

        timer = setInterval(() => showRemaining(), 1000);

    }


    <%
    for(HashMap<String, String> hm : itemlist){
        %>
    var str = "<%=hm.get("assigned_time")%>";
    var date = str.split("-"); //{2021}, {06}, {23 17:32:09.0}
    var time = (date[2].substring(date[2].indexOf(" ")+1, date[2].length)).split(":");
    date[2] = date[2].substring(0, date[2].indexOf(" "));
    countDownTimer("timer"+"<%=hm.get("number")%>", date[1]+"/"+date[2]+"/"+date[0]+" "+time[0]+":"+time[1]);
    //countDownTimer("timer"+"<%=hm.get("number")%>", '06/29/2021 00:00 AM');
    <%
}
%>
</script>
<script>
    window.onload = function(){
        /*
        if("<%=s_id%>" != "100" || "<%=s_id%>" == null){
                history.back();
            }
            */
    }
    $(".manager_cancel").click(function(){
        var req_id = $(this).attr("id");
        req_id = req_id.replace("cancel", "");
        location.href = "_delete_request.jsp?id="+req_id;
    });
    $(".manager_okay").click(function(){
        var req_id = $(this).attr("id");
        req_id = req_id.replace("okay", "");
        location.href = "_okay_request.jsp?id="+req_id;
    });
    /*
    function toggle_company(){
        if($(".assign_company").css("display") == "none"){
            $(".assign_company").css("display", "block");
            $(".assign_company").css("z-index", "10");
            $(".assign_company").css("position", "relative");
            $(".assign_company").css("background", "white");
            $(".assign_company").css("box-shadow", "1px 3px 3px 0px #00000045");
        }
        else{
            $(".assign_company").css("display", "none");
        }
    }
    $(".toggle_area").click(function(){
        toggle_company();
    })
     */
</script>
<script>
    $("document").ready(function(){
        if("<%=s_id%>" != "100"){
            alert("접근 권한이 없습니다!");
            location.href = "index.jsp";
        }
    })
</script>
</div>
</div>
</body>
</html>