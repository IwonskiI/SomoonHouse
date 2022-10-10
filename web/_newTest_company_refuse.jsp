<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page language="java" import="java.text.*,java.sql.*,java.util.*,java.security.*,java.math.BigInteger" %>
<%@ page language="java" import="myPackage.*" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=utf-8"); %>
<%
    //필요한 변수 선언
    int i, j;
    String mylog = "";

    //파라미터 가져오기
    //String param = request.getParameter("param");
    String apply_num = request.getParameter("applyNum") + "";
    String company_num = request.getParameter("companyNum") + "";
    String refuse_id = request.getParameter("refuseId") + "";
    String refuse_reason = request.getParameter("refuseReason") + "";
    //String apply_num = "1";
    //String company_num = "2";

    if (refuse_id.equals("1")) {
        refuse_reason = "고객 예산 부족";
    } else if (refuse_id.equals("2")) {
        refuse_reason = "공사 일정 마감";
    } else if (refuse_id.equals("3")) {
        refuse_reason = "해당 지역 불가";
    }

    //DB 관련 객체 선언
    Connection conn = DBUtil.getMySQLConnection();
    ResultSet rs = null;
    PreparedStatement pstmt = null;
    String query = "";
    String sql = "";

    //DB update
    query = "UPDATE ASSIGNED SET State = 1 , Refuse_id = ? , Refuse_reason = ? WHERE Apply_num = ? AND Company_num = ?";
    pstmt = conn.prepareStatement(query);
    pstmt.setString(1, refuse_id);
    pstmt.setString(2, refuse_reason);
    pstmt.setInt(3, Integer.parseInt(apply_num));
    pstmt.setInt(4, Integer.parseInt(company_num));


    pstmt.executeUpdate();


    //해당 거절건에 대하여 다른 업체들의 수락 상태를 확인하고 모든 업체가 거절했다면 메세지 전송

    //거절되지 않은 건(수락건)이 4개이상일 시, 신청을 전체 수락 상태로 바꾸어주기
    query = "select count(*) from ASSIGNED where State != 1 and Apply_num = " + apply_num;
    pstmt = conn.prepareStatement(query);
    rs = pstmt.executeQuery();
    while(rs.next()){
        int okay = rs.getInt("count(*)");
        //모든 업체가 거절을 할 경우 문자메세지 전송
        if(okay == 0){
            ResultSet rs_msg;
            String phone = "";
            String msg_str = "";
            int msg_send = 1;

            query = "select * from REMODELING_APPLY where Number = " + apply_num;
            pstmt = conn.prepareStatement(query);
            rs_msg = pstmt.executeQuery();
            while (rs_msg.next()){
                phone = rs_msg.getString("Phone");
                msg_send = rs_msg.getInt("msg_send");
            }
            if (msg_send == 0){
                MessageSend3 msg = new MessageSend3();
                msg_str = "[소문난집 매칭 결과 안내] 소문난집에는 종합 인테리어 업체 위주로 입점되어 있습니다. 시공 항목이나 시공 예산이 적을 경우, 업체 매칭이 어렵습니다. 재매칭을 원하신다면, 회신 부탁드립니다.";
                // 고객에게 문자 보내기
                msg.send(phone, msg_str, "lms");
                sql = "update REMODELING_APPLY set msg_send = true where Number = " + apply_num;
                pstmt = conn.prepareStatement(sql);
                pstmt.executeUpdate();
            }
        }
    }



    //pstmt.close();
%>
<!DOCTYPE html>
<html>
<head>
    <link rel="SHORTCUT ICON" href="https://somoonhouse.com/img/favicon.ico"/>
    <link rel="stylesheet" type="text/css" href="//cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/newindex.css"/>
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
    <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
            new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
        j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
        'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
    })(window,document,'script','dataLayer','GTM-TQFGN2T');</script>
    <!-- End Google Tag Manager -->
    <!-- 사용자 행동 정보 수집 코드 끝 - Meta, GA -->
</head>
<body>
<%

    if (pstmt != null) {
        pstmt.close();
        //rs.close();
        query = "";
        conn.close();
    }
%>
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script>
    alert('거절되었습니다.');
    location.href = "newTest0.jsp";
</script>
</body>
</html>