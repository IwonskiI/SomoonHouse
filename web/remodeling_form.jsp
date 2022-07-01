<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page language="java" import="java.text.*,java.sql.*,java.util.*,java.security.*,java.math.BigInteger" %>
<%@ page language="java" import="myPackage.*" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=utf-8"); %>
<% session.setAttribute("page", "remodeling_form.jsp"); %>
<%
    Connection conn = DBUtil.getMySQLConnection();
    ResultSet rs = null;
    PreparedStatement pstmt = null;
    String query = "";
%>
<%
    // 세션 생성 create session
    session.setAttribute("page", "remodeling_form.jsp"); // 현재 페이지 current page
// 세션 가져오기 get session
    String now = session.getAttribute("page") + ""; // 현재 페이지 current page
    String s_id = session.getAttribute("s_id") + "";// 현재 사용자 current user
    String name = session.getAttribute("name") + "";
    String home_id = "0";
    if (session.getAttribute("home_id") != null) {home_id = session.getAttribute("home_id")+"";}

//DB개체들 가져오기
    conn = DBUtil.getMySQLConnection();
    rs = null;
    pstmt = null;
    query = "";

//변수정의
    int i = 0;
    int j = 0;
    String item_num = request.getParameter("item_num") + ""; //사례번호 가져오기
    ArrayList<String> resident = new ArrayList<String>();
    HashMap<Integer, String> division1 = new HashMap<Integer, String>();
    HashMap<Integer, HashMap<Integer, String>> division2 = new HashMap<Integer, HashMap<Integer, String>>();

//resident type 가져오기
    query = "select * from RESIDENT order by Id";
    pstmt = conn.prepareStatement(query);
    rs = pstmt.executeQuery();

    while (rs.next()) {
        resident.add(rs.getString("Name"));
    }

    query = "select * from RMDL_DIV1 order by Id";
    pstmt = conn.prepareStatement(query);
    rs = pstmt.executeQuery();
    while (rs.next()) {
        division1.put(rs.getInt("Id"), rs.getString("Name"));
    }

    for (i = 1; i <= division1.size(); i++) {
        query = "select * from RMDL_DIV2 where Parent_Id = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, i);
        rs = pstmt.executeQuery();
        HashMap<Integer, String> hm = new HashMap<Integer, String>();
        while (rs.next()) {
            hm.put(rs.getInt("Id"), rs.getString("Name"));
        }
        division2.put(i, hm);
    }

    query = "select * from USERS where ID = ?";
    pstmt = conn.prepareStatement(query);
    pstmt.setInt(1, Integer.valueOf(home_id));
    rs = pstmt.executeQuery();
    HashMap<String, String> user = new HashMap<String, String>();
    while (rs.next()) {
        user.put("name", rs.getString("USERNAME"));
        user.put("phone", rs.getString("PHONE"));
    }

%>
<!DOCTYPE html>
<html>
<head>
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
    <link rel="SHORTCUT ICON" href="img/favicon.ico"/>
    <link rel="stylesheet" type="text/css" href="https://pm.pstatic.net/css/webfont_v170623.css"/>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/remodeling_form.css"/>
    <script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/>
    <title>소문난집 - 리모델링 견적받기</title>
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
<jsp:include page="/homepage_pc_header.jsp" flush="false"/>
<jsp:include page="/homepage_mob_header.jsp" flush="false"/>
<!--div id="banner">
</div-->
<div id="container">
    <!------------ 내용물  --------------->
    <form action="_remodeling_form.jsp" method="post" onSubmit="return formChk();">
        <input type="hidden" name="item_num" value="<%=item_num%>">
        <div class="form_mini" id="form1" style="display:block;">
            <!-- 건물 유형 선택 -->
            <div class="form_title">어떤 건물을 인테리어 하실건가요?</div>
            <div class="form_content center">
                <% for (i = 0; i < resident.size(); i++) {
                %>
                <input type="radio" name="building_type" value="<%=i%>" id="resident<%=i%>" class="block">
                <label for="resident<%=i%>">
                    <img src="https://somoonhouse.com/otherimg/estimate/resident_<%=i+1%>.png">
                    <div class="_txt"><%=resident.get(i)%>
                    </div>
                </label>
                <%
                    }%>
            </div>
        </div>
        <div class="form_mini" id="form2">
            <!-- 평수 -->
            <div class="form_title">평수(공급면적)을 입력해 주세요.</div>
            <div class="form_content">
                <input type="number" id="area" name="area" pattern="\d*" class="block" onchange="area_cal(this)">평
            </div>
        </div>
        <div class="form_mini" id="form3">
            <!-- 시공예정일 -->
            <div class="form_title">공사 예정일이 언제인가요?</div>
            <div class="form_content block">
                <input type="radio" name="due" value="1개월 이내" id="due1" class="block"><label for="due1">1개월 이내</label>
                <input type="radio" name="due" value="2개월 이내" id="due2" class="block"><label for="due2">2개월 이내 </label>
                <input type="radio" name="due" value="2개월 이후" id="due3" class="block"><label for="due3">2개월 이후</label>
            </div>
        </div>
        <div class="form_mini" id="form4">
            <!-- 시공 대분류 -->
            <div class="form_title">원하는 시공을 모두 골라주세요.</div>
            <div class="form_content block">
                <input type="checkbox" id="division1_all" class="block">
                <label for="division1_all">
                    <!-- <img src="otherimg/estimate/division<%=i%>.jpg"> -->
                    전체 선택
                </label>
                <%
                    for (i = 1; i <= division1.size(); i++) {
                %>
                <input type="checkbox" name="division1" id="division1_<%=i%>" class="block" value="<%=i%>">
                <label for="division1_<%=i%>">
                    <!-- <img src="otherimg/estimate/division<%=i%>.jpg"> -->
                    <%=division1.get(i)%>
                </label>
                <%
                    }
                %>
            </div>
        </div>
        <div class="form_mini" id="form5">
            <!-- 시공 소분류 -->
            <div class="form_title"></div>
            <div class="form_content">
                <%
                    for (i = 1; i <= division1.size(); i++) {
                %>
                <div id="division2_<%=i%>">
                    <div class="mini_title"><%=division1.get(i)%>
                    </div>
                    <div class="block">
                        <%
                            HashMap<Integer, String> hm = division2.get(i);
                            for (Integer key : hm.keySet()) {
                        %>
                        <input type="radio" name="division2-<%=i%>" id="division2-<%=key%>" class="block"
                               value="<%=key%>">
                        <label for="division2-<%=key%>"><%
                            out.println(hm.get(key));
                        %></label><%
                        }%>
                    </div>
                </div>
                <%
                    }
                %>
            </div>
        </div>
        <div class="form_mini" id="form6">
            <!-- 인테리어 예산 -->
            <div class="form_title">인테리어 예산을 알려주세요.</div>
            <div class="form_content">
                <input type="radio" name="budget" id="below1000" class="block" value="1천만원 이하">
                <label for="below1000">1천만원 이하</label>
                <input type="radio" name="budget" id="below2000" class="block" value="2천만원 이하">
                <label for="below2000">2천만원 이하</label>
                <input type="radio" name="budget" id="below3000" class="block" value="3천만원 이하">
                <label for="below3000">3천만원 이하</label>
                <input type="radio" name="budget" id="below4000" class="block" value="4천만원 이하">
                <label for="below4000">4천만원 이하</label>
                <input type="radio" name="budget" id="below5000" class="block" value="5천만원 이하">
                <label for="below5000">5천만원 이하</label>
                <input type="radio" name="budget" id="below6000" class="block" value="6천만원 이하">
                <label for="below6000">6천만원 이하</label>
                <input type="radio" name="budget" id="below8000" class="block" value="8천만원 이하">
                <label for="below8000">8천만원 이하</label>
                <input type="radio" name="budget" id="below10000" class="block" value="1억원 이하">
                <label for="below10000">1억원 이하</label>
                <input type="radio" name="budget" id="above10000" class="block" value="1억원 이상">
                <label for="above10000">1억원 이상</label>
                <input type="radio" name="budget" id="undefined" class="block" value="미정(상담 후 결정)">
                <label for="undefined">미정</label>
            </div>
            <div class="warning_cost" id="warning" style="display:none;">
                <div class="warning_title">
                    <img src="https://somoonhouse.com/otherimg/assets/warning.png">
                    <span>예상 금액 범위 안내</span>
                </div>
                <div class="warning_content">
                    <span>●</span>
                    <span>해당 평수는 최소 <span class="cal_val" id="cal_val1"></span>만원 ~ <span class="cal_val" id="cal_val2"></span>만원 정도 예상 해 주셔야 합니다.</span>
                    <span>●</span>
                    <span>하자 없는 시공을 추구하므로 예산이 적을 경우 업체 매칭이 어려울 수 있습니다.</span>
                    <span class="write_red">●</span>
                    <span class="write_red">단, 제시된 예상 견적 금액은 현장 상황이나, 원하시는 자재에 따라 실제 공사 금액과 차이가 있을 수 있습니다.</span>
                </div>
            </div>
        </div>
        <div class="form_mini" id="form7">
            <!-- 인테리어 지역주소 -->
            <div class="form_title">시공하시는 곳의 주소를 알려주세요.</div>
            <div class="form_content">
                <input type="text" name="address" class="block">
            </div>
        </div>
        <!--div class="form_mini" id="form8">
        < 상담방식(방문/영상/필요없음) >
            <div class="form_title">원하는 상담방식을 골라주세요.</div>
            <div class="form_content block">
                <input type="radio" name="consulting" id="consulting_no"  class="block" value="0">
                <label for="consulting_no"  class="will">전화상담</label>
                <input type="radio" name="consulting" id="visit" value="1" class="block">
                <label for="visit" class="please">방문상담</label>
                <input type="radio" name="consulting" id="video"  value="2" class="block">
                <label for="video"  class="will">영상상담</label>
            </div>
            <div class="notice">
                <p>
                *영상상담이란? 고객님이 현장에서 영상통화를 통해 업체와 편리하게 상담하는 서비스입니다.<br>
                현장을 보여주고, 이를 통해 비대면으로 상세견적을 받아보실 수 있어요.
                </p>
            </div>
        </div>
        <div class="form_mini" id="form9">
        < 연락방식(주세요/걸게요) >
            <div class="form_title">원하는 연락방식을 골라주세요.</div>
            <div class="form_content">
                <input type="radio" name="call" id="callplease" value="1" class="block">
                <label for="callplease" class="please">전화주세요</label>
                <input type="radio" name="call" id="callwill"  value="0" class="block">
                <label for="callwill"  class="will">전화 걸게요</label>
            </div>
        </div-->
        <div class="form_mini" id="form8">
            <!-- 이름, 연락처정보 + 개인정보동의 -->
            <div class="form_title">상담을 위해 정보를 입력해주세요.</div>
            <div class="form_content">
                <div class="item"><span class="nametag">성함</span><input type="text" name="name" class="block"
                    <%if(user.get("name")!=null){%> value="<%=user.get("name")%>"<%}%>
                ></div>
                <div class="item"><span class="nametag">휴대폰</span><input type="number" name="phone" class="block"
                    <%if(user.get("phone")!=null){%> value="<%=user.get("phone")%>"<%}%>
                ></div>
                <div class="item"><span class="nametag">신청 이유(선택 사항)</span><input type="text" name="reason" class="block"></div>
                <!-- div class="item"><span class="nametag">휴대폰</span><input type="text" class="cert_input" name="phone"><input type="button" class="cert_btn" id="cert_start" value="인증"></div>
                <div class="item"><span class="nametag">인증번호</span><input type="text" class="cert_input" name="certificate_num"><input type="button" class="cert_btn" id="cert_ok" value="확인"></div-->
                <input type="checkbox" name="agree" class="block"> 개인정보 활용동의
                <a href="personal.html" target="_blank">전문보기</a>
            </div>
        </div>
        <div class="form_mini" id="form9">
            <!-- 중단사유 입력 -->
            <div class="form_title">중단 사유를 입력해주세요.</div>
            <div class="form_content" style="text-align: left">
                <input type="radio" name="reason_id" value="1"> 신청 과정이 너무 번거로움 <br><br>
                <input type="radio" name="reason_id" value="2"> 아직 구체적인 계획이 없음 <br><br>
                <input type="radio" name="reason_id" value="3">
                <input type="text" name="stop_reason" id="stop_reason" class="block" placeholder="기타(직접입력)">
            </div>
        </div>

        <div class="estimate_navigator" id="navigator1">
            <div class="not" id="notstart" style="display: none">다음</div>
            <div class="start" id="yesstart">다음</div>
            <%--				 style="display: none"--%>
        </div>
        <div class="estimate_navigator" id="navigator2" style="display:none;">
            <div class="prev">뒤로</div>
            <div class="next" id="yesnext">다음</div>
            <%--				 style="display: none"--%>
            <div class="not" id="notnext" style="display: none">다음</div>
            <input type="button" class="next" id="save" value="신청서 저장하기" onclick="return saveform(this.form);">
            <div class="reset">
                <div>업체 더 둘러보기</div>
            </div>
        </div>
        <div class="estimate_navigator" id="navigator3" style="display:none;">
            <div class="prev">뒤로</div>
            <input type="submit" id="yesfinish" value="완료">
            <%--			style="display: none">--%>
            <div class="not" id="notfinish" style="display: none">완료</div>
            <input type="button" class="next" id="save" value="신청서 저장하기" onclick="return saveform(this.form);">
            <div class="reset">
                <div>업체 더 둘러보기</div>
            </div>
        </div>
        <div class="estimate_navigator" id="navigator4" style="display:none;">
            <div class="prev" id="stop_quit">뒤로</div>
            <input type="button" class="start" id="yesquit" value="업체 더 둘러보기" onclick="return quitRsn(this.form);">
            <%--				   style="display: none">--%>
            <div class="not" id="notquit" style="display: none">업체 더 둘러보기</div>
            <input type="hidden" id="home_id" value="<%=home_id%>">
        </div>
    </form>
</div>
<footer>
    <div>
        소문난집에서는 업체의 추천, 업체와의 소통에 도움은 드릴 수 있으나 A/S, 공사와 관련된 일체의 책임은 시공 업체에 있습니다.<br>
        업체 별로 A/S기간과 범위의 차이가 있으니 이를 꼭 확인하시고 계약하시기 바랍니다.
    </div>
</footer>
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

    var quit_num = 0;

    function check_all(){
        var chck_lst = "";
        $("input[name=division1]:checked").each(function() {
            var tmpVal = $(this).val();
            console.log(tmpVal);
            chck_lst += tmpVal
        });
        if(chck_lst.indexOf("1")!==-1 && chck_lst.indexOf("3")!==-1 && chck_lst.indexOf("4")!==-1 && chck_lst.indexOf("5")!==-1 && chck_lst.indexOf("6")!==-1){
            $('#warning').css('display', 'inline-block');
        }
        else{
            $('#warning').css('display', 'none');
        }
    }

    $(document).ready(function() {
        $("#division1_all").click(function() {
            if($("#division1_all").is(":checked")){
                $("input[name=division1]").prop("checked", true);
            }
            else{
                $("input[name=division1]").prop("checked", false);
            }
        });

        $("input[name=division1]").click(function() {
            var total = $("input[name=division1]").length;
            var checked = $("input[name=division1]:checked").length;

            if(total != checked){
                $("#division1_all").prop("checked", false);
            }
            else{
                $("#division1_all").prop("checked", true);
            }
        });
    });

    $('document').ready(function () {
        function nowform() {
            var num;
            $('.form_mini').each(function () {
                if ($(this).css('display') == "block") {
                    num = $(this).attr('id');
                }
            });
            num = num.replaceAll('form', '');
            num = parseInt(num);
            return num;
        }

        function form_vaild() {
            //지금이 몇번째 폼인지 알아오기
            var num = nowform();
            //그안에 모든 input에 대해 차있는지 확인해보기
            var ischecked = 1;
            $('#form' + num + ' input.block').each(function () {
                if ($(this).attr('type') == 'radio') {
                    //라디오항목일 경우 - name이 같은 항목에 대해 체크된 값이 있는지 없는지 확인해본다
                    var name = $(this).attr('name');
                    if ($(':radio[name=' + name + ']:checked').length < 1) {
                        ischecked = 0;
                    }
                } else if ($(this).attr('type') == 'checkbox') {
                    //체크박스항목일 경우 - name이 같은 항목에 대해 체크된 값이 있는지 없는지 확인해본다
                    var name = $(this).attr('name');
                    if ($(':checkbox[name=' + name + ']:checked').length < 1) {
                        ischecked = 0;
                    }
                } else if ($(this).attr('type') == 'number' || $(this).attr('type') == 'text') {
                    if (!$(this).val()) {
                        ischecked = 0;
                    }
                }
            });
            if (ischecked == 1) {
                turnon();
                return true;
            } else {
                turnoff();
                return false;
            }
            alert(ischecked);
        }

        function turnon() {
            if ($('#yesstart').css('display') == 'none') {
                $('#notstart').css('display', 'none');
                $('#yesstart').css('display', 'inline-block');
            }
            if ($('#yesnext').css('display') == 'none') {
                $('#notnext').css('display', 'none');
                $('#yesnext').css('display', 'inline-block');
            }
            if ($('#yesfinish').css('display') == 'none') {
                $('#notfinish').css('display', 'none');
                $('#yesfinish').css('display', 'inline-block');
            }
            if ($('#yesquit').css('display') == 'none') {
                $('#notquit').css('display', 'none');
                $('#yesquit').css('display', 'inline-block');
            }
        }

        function turnoff() {
            if ($('#notstart').css('display') == 'none') {
                $('#yesstart').css('display', 'none');
                $('#notstart').css('display', 'inline-block');
            }
            if ($('#notnext').css('display') == 'none') {
                $('#yesnext').css('display', 'none');
                $('#notnext').css('display', 'inline-block');
            }
            if ($('#notfinish').css('display') == 'none') {
                $('#yesfinish').css('display', 'none');
                $('#notfinish').css('display', 'inline-block');
            }
            if ($('#notquit').css('display') == 'none') {
                $('#yesquit').css('display', 'none');
                $('#notquit').css('display', 'inline-block');
            }
        }

        $('.form_mini input').on("propertychange change keyup paste input", function () {
            //form_vaild();
        })
        //시작
        $('.start#yesstart').click(function () {
            $('#form1').css('display', 'none');
            $('#form2').css('display', 'block');

            $(this).parent().css('display', 'none');
            $('#navigator2').css('display', 'block');
            //$('#yesnext').css('display', 'none');
            //$('#notnext').css('display', 'inline-block');

            //form_vaild();
        })

        //다음 폼
        $('.next').click(function () {
            var elem;
            var num;

            $('.form_mini').each(function () {
                if ($(this).css('display') == 'block') {
                    num = $(this).attr('id').replace(/form/g, '');
                    num = parseInt(num);
                    num += 1;
                    elem = $(this);
                }
            })
            if (num == 5)
                partly();
            else if (num == 6)
                check_all();
            else if (num == 8) {
                $(this).parent().css('display', 'none');
                $('#navigator3').css('display', 'block');
            }
            elem.css('display', 'none');
            $('#form' + num).css('display', 'block');
            //$('#yesnext').css('display', 'none');
            //$('#notnext').css('display', 'inline-block');
            //form_vaild();

        })

        //이전 폼
        $('.prev').click(function () {
            var elem;
            var num;

            $('.form_mini').each(function () {
                if ($(this).css('display') == 'block') {
                    num = $(this).attr('id').replace(/form/g, '');
                    num = parseInt(num);
                    num -= 1;
                    elem = $(this);
                }
            })
            if (num == 5)
                partly();
            else if (num == 6)
                check_all();
            else if (num == 7) {
                $(this).parent().css('display', 'none');
                $('#navigator2').css('display', 'block');
            } else if (num == 1) {
                $(this).parent().css('display', 'none');
                $('#navigator1').css('display', 'block');
            }
            elem.css('display', 'none');
            $('#form' + num).css('display', 'block');
            //form_vaild($('#form'+num+' input'));
        })

        //중단
        $('.reset').click(function () {
            $('.form_mini').each(function () {
                if ($(this).css('display') == 'block') {
                    quit_num = $(this).attr('id').replace(/form/g, '');
                    quit_num = parseInt(quit_num);
                    $(this).css('display', 'none');
                }
            })
            $('#form9').css('display', 'block');

            $(this).parent().css('display', 'none');
            $('#navigator4').css('display', 'block');

            //form_vaild()
        })
        $('#stop_quit').off().on('click', function () {
            $(this).parent().css('display', 'none');
            if (quit_num == 1) {
                $('#navigator1').css('display', 'block');
            }
            else if (quit_num == 8) {
                $('#navigator3').css('display', 'block');
            }
            else{
                if (quit_num == 5)
                    partly();
                $('#navigator2').css('display', 'block');
            }
            $('#form9').css('display', 'none');
            $('#form' + quit_num).css('display', 'block');
        })
        $('#save').off()

        function partly() {
            var num;
            $('#form4 input').each(function () {
                num = $(this).attr('id');
                num = num.replaceAll('division1_', '');
                num = parseInt(num);
                if ($(this).is(':checked')) {
                    $('#division2_' + num).css('display', 'block');
                    $('#division2_' + num + ' input').each(function () {
                        $(this).attr('class', 'block');
                    })
                } else {
                    $('#division2_' + num).css('display', 'none');
                    $('#division2_' + num + ' input').each(function () {
                        $(this).attr('class', 'none');
                    })
                }
            })
        }
    })

    function formChk() {
        //return confirm("");
    }

    function quitRsn(frm) {
        //입력오류 확인

        var id = $("input:radio[name='reason_id']:checked").val();
        var reason = document.getElementById("stop_reason").value;

        if (id == null) {
            alert('중단 사유를 선택해주세요!');
        } else if (id === '3' && reason === "") {
            alert('기타 사유를 입력해주세요!');
            document.getElementById("stop_reason").focus();
        } else {
            frm.action = '_remodeling_form_stop.jsp';
            frm.submit();
        }
        return true;
    }

    function saveform(frm) {
        var home_id = document.getElementById("home_id").value
        if(home_id === "0"){
            alert("견적서 저장은 로그인이 필요한 서비스 입니다.");
            location.href='login.jsp'
        }
        else {
            frm.action = '_remodeling_form_save.jsp';
            frm.submit();
            return true;
        }
    }

    function area_cal(val){
        var area = val.value;
        var value = 110;

        document.getElementById("cal_val1").innerHTML = area * value;
        document.getElementById("cal_val2").innerText = area * value + 500;

    }


</script>
</body>
</html>