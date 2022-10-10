
<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*,java.util.Calendar,java.util.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest,com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page language="java" import="myPackage.DBUtil" %>
<%@ page language="java" import="myPackage.Link" %>
<%@ page language="java" import="myPackage.GetImage" %>
<%@ page import="myPackage.MessageSend3" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <%
        /*로그인된 세션 아이디(추후개발) 가져오기, 현재 페이지 저장
        String id = session.getAttribute("s_id")+"";
        String now = "_remodeling_form.jsp";*/

        //DB에 사용 할 객체들 정의
        Connection conn = DBUtil.getMySQLConnection();
        PreparedStatement pstmt = null;
        Statement stmt = null;
        String query = "";
        String sql = "";
        ResultSet rs = null;

        //처리에 에러정보가 있으면 롤백
        int error = 0;

        //배분중 상태인 신청들 중에서 6시간이 지난 신청 확인하기
        query = "select * from REMODELING_APPLY where State = 2 And Not Assigned_time BETWEEN DATE_ADD(NOW(), INTERVAL -6 HOUR ) AND NOW()";
        pstmt = conn.prepareStatement(query);
        rs = pstmt.executeQuery();

        LinkedList<String> not_valid_items = new LinkedList<String>();
        while(rs.next()){
            not_valid_items.add(rs.getString("Number"));
        }

        //6시간 지난 신청들의 배분 정보에서 상태(대기)가 일 시에 상태(거절)로 변경
        for (String number : not_valid_items){
            sql = "update ASSIGNED set State = 1 where State = 0 and Apply_num = " + number;
            pstmt = conn.prepareStatement(sql);
            pstmt.executeUpdate();
        }

        //거절되지 않은 건(수락건)이 4개이상일 시, 신청을 전체 수락 상태로 바꾸어주기
        for(String number : not_valid_items){
            query = "select count(*) from ASSIGNED where State != 1 and Apply_num = " + number;
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            while(rs.next()){
                int okay = rs.getInt("count(*)");
                if(okay >= 4){
                    sql = "update REMODELING_APPLY set State = 3 where Number = " + number;
                    pstmt = conn.prepareStatement(sql);
                    pstmt.executeUpdate();
                }
                else{
                    sql = "update REMODELING_APPLY set State = 1 where Number = " + number;
                    pstmt = conn.prepareStatement(sql);
                    pstmt.executeUpdate();

                    //모든 업체가 거절을 할 경우 문자메세지 전송
                    if(okay == 0){
                        ResultSet rs_msg;
                        String phone = "";
                        String msg_str = "";
                        int msg_send = 1;

                        query = "select * from REMODELING_APPLY where Number = " + number;
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
                            sql = "update REMODELING_APPLY set msg_send = true where Number = " + number;
                            pstmt = conn.prepareStatement(sql);
                            pstmt.executeUpdate();
                        }
                    }

                    //만약 모든 회사에 배분 되었고 수락한 회사가 4개이하라면 배분 테이블에 해당 신청건에 대해 거절한 열들을 다 지움
                    ResultSet rs2;

                    query = "select count(*) from ASSIGNED Where Apply_num = " + number;
                    pstmt = conn.prepareStatement(query);
                    rs2 = pstmt.executeQuery();
                    int assigned = 0;
                    while(rs2.next()){
                        assigned = rs2.getInt("count(*)");
                    }
                    query = "select count(*) from COMPANY where State = 1";
                    pstmt = conn.prepareStatement(query);
                    rs2 = pstmt.executeQuery();
                    int company = 0;
                    while(rs2.next()){
                        company = rs2.getInt("count(*)");
                    }

                    if(assigned >= company){ //원본
                        //if(assigned >= 4){ // 테스트
                        //거절인 행 다 지우기
                        sql = "delete from ASSIGNED where State = 1 and Number " + number;
                        pstmt = conn.prepareStatement(sql);
                        pstmt.executeUpdate();
                    }
                }
            }
        }

        //확인
        //out.println(pstmt);

        //DB객체 종료
        //stmt.close();
        pstmt.close();
        conn.close();

        String state = request.getParameter("state")+"";
        if(state.equals("null")) state = "";
        //out.print("manage_request.jsp?state="+state);
        response.sendRedirect("newTest" + state + ".jsp");

    %>
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
</body>
</html>