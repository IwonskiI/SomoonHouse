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
    String company_name = "";
    String stock = "";

    //파라미터 가져오기
    //String param = request.getParameter("param");
    String s_id = session.getAttribute("s_id")+"";

    //DB 관련 객체 선언
    Connection conn = DBUtil.getMySQLConnection();
    ResultSet rs = null;
    PreparedStatement pstmt = null;
    String query = "";
    String sql = "";

    //DB 가져오기
    //회사이름
    query = "select * from COMPANY where id = " + s_id;
    pstmt = conn.prepareStatement(query);
    rs = pstmt.executeQuery();
    while(rs.next()){
        company_name = rs.getString("Name");
    }
    //이용중인 상품
    LinkedHashMap<String,HashMap<String,String>> company_coupon_now = new LinkedHashMap<String,HashMap<String,String>>();
    query = "select * from ISSUED_COUPON I, COUPON C where I.Coupon_id = C.Id and I.Company_id = " + s_id + " and (Expiration_date >= CURDATE() and I.Stock > 0) order by Expiration_date asc";
    pstmt = conn.prepareStatement(query);
    rs = pstmt.executeQuery();
    while(rs.next()) {
        // 쿠폰이름, 남은 건수, 발급 일자, 유효 기간
        HashMap<String, String> hm = new HashMap<String, String>();
        hm.put("name", rs.getString("C.Name"));
        hm.put("stock", rs.getString("I.Stock"));
        hm.put("quantity", rs.getString("C.Quantity"));
        hm.put("origin", rs.getString("C.Origin"));
        hm.put("extra", rs.getString("C.Extra"));
        hm.put("issued_date", rs.getString("I.Issued_date"));
        hm.put("expiration_date", rs.getString("Expiration_date"));
        company_coupon_now.put(rs.getString("I.Id"), hm);
    }

    //이용끝난
    LinkedHashMap<String,HashMap<String,String>> company_coupon_old = new LinkedHashMap<String,HashMap<String,String>>();
    query = "select * from ISSUED_COUPON I, COUPON C where I.Coupon_id = C.Id and I.Company_id = " + s_id + " and (Expiration_date < CURDATE() or I.Stock = 0) order by Expiration_date asc";
    pstmt = conn.prepareStatement(query);
    rs = pstmt.executeQuery();
    while(rs.next()) {
        // 쿠폰이름, 남은 건수, 발급 일자, 유효 기간
        HashMap<String, String> hm = new HashMap<String, String>();
        hm.put("name", rs.getString("C.Name"));
        hm.put("stock", rs.getString("I.Stock"));
        hm.put("quantity", rs.getString("C.Quantity"));
        hm.put("origin", rs.getString("C.Origin"));
        hm.put("extra", rs.getString("C.Extra"));
        hm.put("issued_date", rs.getString("I.Issued_date"));
        hm.put("expiration_date", rs.getString("Expiration_date"));
        company_coupon_old.put(rs.getString("I.Id"), hm);
    }
    //전체 잔여
    query = "SELECT SUM(Stock) FROM ISSUED_COUPON where Company_id = " + s_id
            + " and Expiration_date >= CURDATE()"
            + " group by Company_id";
    pstmt = conn.prepareStatement(query);
    rs = pstmt.executeQuery();
    stock = "0";
    while(rs.next()){
        stock = rs.getString("SUM(Stock)");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <link rel="SHORTCUT ICON" href="https://somoonhouse.com/img/favicon.ico" />
    <link rel="stylesheet" type="text/css" href="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/newTestPartnerOld.css"/>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
    <title>소문난집 - 내 쿠폰 관리</title>
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
<%=mylog%>
<%
%>
<div class="body_container">
    <jsp:include page="/newTestHeader.jsp" flush="false" />
    <div class="body_main">
        <div class="main_header">
            <span><%=company_name%>님</span>
        </div>
        <div class="main_container">
            <div class="sub_text"><span>총 잔여 건수</span></div>
            <div class="goods_container">
                <span class="left_item"><%=stock%>건</span>
            </div>
            <div class="sub_text"><span>이용중인 상품</span></div>
            <%for(String key : company_coupon_now.keySet()){
                HashMap coupon = company_coupon_now.get(key);
             %>
            <div class="goods_container">
                <div class="text_area">
                    <span class="upper_text"><%=coupon.get("name")%></span>
                </div>
                <div class="text_area">
                    <span class="mid_text">기간 <span class="mid_date_text"><%=coupon.get("issued_date")%> ~ <%=coupon.get("expiration_date")%></span></span>
                </div>
                <div class="text_area">
                    <span class="lower_text">잔여 <%=coupon.get("stock")%> / 전체 <%=coupon.get("quantity")%></span>
                </div>
            </div>
            <%}%>
            <div class="sub_text"><span>이용 끝난 상품</span></div>
            <%for(String key : company_coupon_old.keySet()){
                HashMap coupon = company_coupon_old.get(key);
            %>
            <div class="goods_container">
                <div class="text_area">
                    <span class="upper_text"><%=coupon.get("name")%>
                        <%if(coupon.get("origin")!=null && !coupon.get("origin").equals("null")) {
                            int origin = Integer.parseInt((String) coupon.get("origin"));
                            int extra = Integer.parseInt((String) coupon.get("extra"));
                            int total = origin + extra;
                            out.print("(" + total + "건)");
                        }
                        %>
                    </span>
                </div>
                <div class="text_area">
                    <span class="mid_text">기간 <span class="mid_date_text"><%=coupon.get("issued_date")%> ~ <%=coupon.get("expiration_date")%></span></span>
                </div>
                <div class="text_area">
                    <span class="lower_text">배분 <%=coupon.get("stock")%>건 / <%=coupon.get("quantity")%>건</span>
                </div>
            </div>
            <%}%>
        </div>
    </div>
    <jsp:include page="/newTestFooter.jsp" flush="false" />
</div>

<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script>
</script>
</body>
</html>