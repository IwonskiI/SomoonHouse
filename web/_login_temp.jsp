<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page language="java" import="java.text.*,java.sql.*,java.util.Calendar,java.util.*" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <%
        //변수 정의
        int i;

        //신청폼으로 부터 받은 데이터 불러오기, 필요한 정보 정의
        String cur_form = request.getParameter("cur_form");
        String item_num = request.getParameter("item_num");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String building_type = request.getParameter("building_type");
        String area = request.getParameter("area");
        String due = request.getParameter("due");
        String budget = request.getParameter("budget");
        String reason = request.getParameter("reason");
        ArrayList<String> div2 = new ArrayList<String>();
        ArrayList<Integer> div_tmp = new ArrayList<Integer>();

        //session에 받아온 정보 임시 저장
        session.setAttribute("rf_inum", item_num);
        session.setAttribute("rf_bt", building_type);
        session.setAttribute("rf_area", area);
        session.setAttribute("rf_due", due);
        session.setAttribute("rf_budget", budget);
        session.setAttribute("rf_add", address);
        session.setAttribute("rf_name", name);
        session.setAttribute("rf_phone", phone);
        session.setAttribute("rf_reason", reason);
        session.setAttribute("cur_form", cur_form);

        //div2받아오기
        for (i = 0; i < 8; i++) {
            div2.add(request.getParameter("division2-" + i) + "");
            if (!div2.get(div2.size() - 1).equals("") && !div2.get(div2.size() - 1).equals("null")) {
                int div2_num = Integer.parseInt(div2.get(div2.size() - 1));
                div_tmp.add(div2_num);
            }
        }
        session.setAttribute("div_tmp",div_tmp);
    %>
    <script>
        location.href = "login.jsp";
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
    <!-- End Google Tag Manager -->
    <!-- 사용자 행동 정보 수집 코드 끝 - Meta, GA -->
</head>
<body>
</body>
</html>