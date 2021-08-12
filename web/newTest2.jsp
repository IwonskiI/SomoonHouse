<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*,java.util.*,java.security.*,java.math.BigInteger" %>
<%@ page language="java" import="myPackage.*" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=utf-8"); %>
<%
    //필요한 변수 선언
    String mylog = "";

    //파라미터 가져오기
    //String param = request.getParameter("param");
    String s_id = session.getAttribute("s_id")+"";
    //String s_id = "35";

    //DB 관련 객체 선언
    Connection conn = DBUtil.getMySQLConnection();
    ResultSet rs = null;
    PreparedStatement pstmt = null;
    String query = "";
    String sql = "";

    //변수설정
    String[] buildingType = {"아파트", "빌라", "주택", "원룸"};
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

    //DB 가져오기
    query = "SELECT distinct Apply_date FROM ASSIGNED A, REMODELING_APPLY R";
    query += " WHERE A.Company_num = " + s_id;
    query += " And R.Number = A.Apply_num";
    query += " And A.State > 8"; // 탭에따라 이 쿼리 바꾸어주기
    pstmt = conn.prepareStatement(query);
    rs = pstmt.executeQuery();

    LinkedList<Dates> datelist = new LinkedList<Dates>();

    while(rs.next()) {

        Dates date = new Dates();
        date.setDate(rs.getString("Apply_date"));

        HashMap<String, HashMap<String, String>> applies = new HashMap<String, HashMap<String, String>>();
        HashMap<String, HashMap<String, String>> details = new HashMap<String, HashMap<String, String>>();


        query = "SELECT * FROM ASSIGNED A, REMODELING_APPLY R";
        query += " WHERE A.Company_num = " + s_id;
        query += " And R.Number = A.Apply_num";
        query += " And A.State > 8";
        query += " And Date(Apply_date) = '" + rs.getString("Apply_date") + "'";
        pstmt = conn.prepareStatement(query);
        ResultSet rs2 = pstmt.executeQuery();

        while (rs2.next()) {
            HashMap<String, String> temp = new HashMap<String, String>();
            if(rs2.getString("Item_num").equals("0")){
                temp.put("Title", "통합 신청 버튼으로 신청했습니다.");
                temp.put("URL", "#");
            }
            else{
                query = "select * from REMODELING where Number = " + rs2.getString("Item_num");
                pstmt = conn.prepareStatement(query);
                ResultSet rs3 = pstmt.executeQuery();
                while(rs3.next()){
                    temp.put("Title", rs3.getString("Title"));
                    temp.put("URL", rs3.getString("URL"));
                }
            }
            temp.put("Number", rs2.getString("R.Number"));
            temp.put("Item_num", rs2.getString("R.Item_num"));
            temp.put("Name", rs2.getString("R.Name"));
            temp.put("Phone", rs2.getString("R.Phone"));
            temp.put("Address", rs2.getString("R.Address"));
            if(rs2.getString("R.Building_type")!=null && !rs2.getString("R.Building_type").equals("null"))
                temp.put("Building_type", buildingType[Integer.parseInt(rs2.getString("R.Building_type"))]);
            else
                temp.put("Building_type", "정보없음");
            temp.put("Area", rs2.getString("R.Area"));
            temp.put("Due", rs2.getString("R.Due"));
            temp.put("Budget", rs2.getString("R.Budget"));
            temp.put("Consulting", rs2.getString("R.Consulting"));
            temp.put("Apply_date", rs2.getString("R.Apply_date"));
            temp.put("State", rs2.getString("R.State"));
            temp.put("Calling", rs2.getString("R.Calling"));
            temp.put("Pw", rs2.getString("R.Pw"));
            temp.put("Assigned_time", rs2.getString("R.Assigned_time"));
            temp.put("State", rs2.getString("A.State"));
            temp.put("Assigned_id", rs2.getString("A.Assigned_id"));
            temp.put("Memo", rs2.getString("A.Memo"));
            temp.put("Modify_date", rs2.getString("A.Modify_date"));
            applies.put(temp.get("Number"), temp);

            //details 값 넣기
            PreparedStatement pstmt2 = null;
            query = "select * from REMODELING_APPLY ra, REMODELING_APPLY_DIV2 rad, RMDL_DIV1 rd, RMDL_DIV2 rd2 where ra.Number = ? and ra.Number = rad.Apply_num And rad.Div2_num = rd2.Id and rd2.Parent_id = rd.Id";
            pstmt2 = conn.prepareStatement(query);
            pstmt2.setString(1, temp.get("Number"));
            ResultSet rs3 = pstmt2.executeQuery();
            HashMap<String, String> hm = new HashMap<String, String>();
            while (rs3.next()) {
                hm.put(rs3.getString("rd.Name"), rs3.getString("rd2.Name"));
            }
            details.put(temp.get("Number"), hm);
        }
        date.setApplies(applies);
        date.setDetails(details);

        datelist.add(date);
    }
%>
<!DOCTYPE html>
<html>
<head>
    <link rel="SHORTCUT ICON" href="https://somoonhouse.com/img/favicon.ico" />
    <link rel="stylesheet" type="text/css" href="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/newTest2.css"/>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
    <title>소문난집</title>
</head>
<body>
<%=mylog%>
<%
%>
<div class="body_container">
    <jsp:include page="/newTestHeader.jsp" flush="false" />
    <div class="body_main">
        <!--
        <div class="main_header">
            <div class="left_container">
                <div class="left_box">
                    <div class="img_container">
                        <img src="https://github.com/Yoonlang/web-programming/blob/master/html/assets/magnifying.png?raw=true" />
                    </div>
                    <div class="text_container">
                        <input class="text_input" type="text" placeholder="전화, 고객명, 주소" />
                    </div>
                </div>
            </div>
        </div>
        -->
        <div class="main_body_none">
            <div class="img_container">
                <img src="https://github.com/Yoonlang/web-programming/blob/master/html/assets/search2.png?raw=true" />
            </div>
            <div class="text_container">
                <span>중단된 공사가 없습니다.</span>
            </div>
        </div>
        <div class="main_body_yes">
            <%
                for (int i = 0; i < datelist.size(); i++) {
                    for(String key : datelist.get(i).applies.keySet()){
                        HashMap apply = datelist.get(i).applies.get(key);
            %>
            <div class="main_container">
                <div class="main_box">
                    <div class="left_box">
                        <div class="upper_container">
                            <div class="text_container">
                                <span><%=apply.get("Name")%> | <span class="sub_text"><%=apply.get("Address")%></span></span>
                            </div>
                        </div>
                        <div class="under_container">
                            <div class="under_box">
                                <span>계약 미성사 : 2021.05.18</span>
                            </div>
                        </div>
                    </div>
                    <div class="right_box">
                        <div class="img_container">
                            <img src="https://github.com/Yoonlang/web-programming/blob/master/html/assets/underDirection.png?raw=true" />
                        </div>
                    </div>
                </div>
            </div>
            <%
                    }
                }
            %>
        </div>
    </div>
    <jsp:include page="/newTestFooter.jsp" flush="false" />
</div>

<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script type="text/javascript" src="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>
<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-PC15JG6KGN"></script>
<script>
    //새 스크립트 작성
    //window.close();
    $('document').ready(function(){
        if('<%=datelist.size()%>' == '0'){
            $('.main_body_none').css('display', 'flex');
            $('.main_body_yes').css('display','none');
        }
        else{
            $('.main_body_none').css('display', 'none');
            $('.main_body_yes').css('display','flex');
        }
    })
</script>
</body>
</html>