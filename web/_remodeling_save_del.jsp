<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page language="java" import="java.sql.*" %>

<%@ page language="java" import="myPackage.DBUtil" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="content-type" content="text/html; charset=UTF-8">
  <%
    //변수 정의
    int i;

	/*로그인된 세션 아이디(추후개발) 가져오기, 현재 페이지 저장
	String id = session.getAttribute("s_id")+"";*/

    //DB에 사용 할 객체들 정의
    Connection conn = DBUtil.getMySQLConnection();
    PreparedStatement pstmt = null;
    Statement stmt = null;
    String query = "";
    String sql = "";
    ResultSet rs = null;

    //처리에 에러정보가 있으면 롤백
    int error = 0;

    //신청폼으로 부터 받은 데이터 불러오기, 필요한 정보 정의
    String item_num = request.getParameter("number");
    int i_num = Integer.parseInt(item_num);

    //업데이트하기
    sql = "DELETE FROM REMODELING_APPLY_TEMP WHERE Number = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, i_num);
    pstmt.executeUpdate();

    sql = "DELETE FROM REMODELING_APPLY_DIV2_TEMP WHERE Apply_num = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setInt(1, i_num);
    pstmt.executeUpdate();

    //DB객체 종료
    pstmt.close();
    conn.close();
  %>
  <script>
    alert('견적 삭제 완료!🙂');
    location.href = "mypage.jsp";
  </script>
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
  <title></title>
  <!-- End Google Tag Manager -->
  <!-- 사용자 행동 정보 수집 코드 끝 - Meta, GA -->
</head>
<body>
</body>
</html>