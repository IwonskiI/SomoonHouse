<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="com.google.gson.*"%>

<html>
  <head>
    <title>네이버로그인</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
  	<link rel="stylesheet" type="text/css" href="https://pm.pstatic.net/css/webfont_v170623.css"/>
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
  <body style="width:100%;">
  <div style="display:block;text-align:center;width:100%;">
  </div>
  <%
    String clientId = "G8MVoxXfGciyZW5dF4p1";//애플리케이션 클라이언트 아이디값";
    String clientSecret = "bqjKbGP1j4";//애플리케이션 클라이언트 시크릿값";
    String code = request.getParameter("code");
    String state = request.getParameter("state");
    String redirectURI = URLEncoder.encode("https://somoonhouse.com/callback.jsp", "UTF-8");
    String apiURL;
    apiURL = "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code&";
    apiURL += "client_id=" + clientId;
    apiURL += "&client_secret=" + clientSecret;
    apiURL += "&redirect_uri=" + redirectURI;
    apiURL += "&code=" + code;
    apiURL += "&state=" + state;
    String access_token = "";
    String refresh_token = "";
    String auth = "";
  %><script>console.log("<%=code%>")</script><%
    //System.out.println("apiURL="+apiURL);
    try {
      String str = "";
      URL url = new URL(apiURL);
      HttpURLConnection con = (HttpURLConnection)url.openConnection();
      con.setRequestMethod("GET");
      int responseCode = con.getResponseCode();
      BufferedReader br;
      //System.out.print("responseCode="+responseCode);
      if(responseCode==200) { // 정상 호출
        br = new BufferedReader(new InputStreamReader(con.getInputStream()));
      } else {  // 에러 발생
        br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
      }
      String inputLine;
      StringBuffer res = new StringBuffer();
      while ((inputLine = br.readLine()) != null) {
        res.append(inputLine);
      }
      br.close();
      if(responseCode==200) {
        //out.println(res.toString());
        str = res.toString();
        /*접근토큰정보 파싱*/
        JsonParser jsonParser = new JsonParser();
        JsonObject object = (JsonObject) jsonParser.parse(str);
        access_token = object.get("access_token").getAsString();
        refresh_token = object.get("refresh_token").getAsString();
        String token_type = object.get("token_type").getAsString();
        //String expire_in = object.get("expire_in").getAsString();
        auth = "Bearer "+access_token;
  %><script>console.log(`<%=auth%>`)</script><%
      }
    }catch (Exception e) {
      System.out.println(e);
    }

    try{
      response.setHeader("Pragma", "No-cache");
      response.addHeader("Authorization", auth);
      //out.println(auth);
      String str="";
      String profile_url;
      profile_url = "https://openapi.naver.com/v1/nid/me";

      URL url = new URL(profile_url);
      HttpURLConnection con = (HttpURLConnection)url.openConnection();
      con.setRequestMethod("GET");
      con.setRequestProperty("Authorization", auth);
      int responseCode = con.getResponseCode();
      BufferedReader br;
      //System.out.print("responseCode="+responseCode);

      if(responseCode==200){
        br = new BufferedReader(new InputStreamReader(con.getInputStream()));
      } else {  // 에러 발생
        br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
      }
      String inputLine;
      StringBuffer res = new StringBuffer();
      while ((inputLine = br.readLine()) != null) {
        res.append(inputLine);
      }
      br.close();
      //out.println(res.toString());
      if(responseCode==200) {
        str = res.toString();
  %><script>console.log(`<%=str%>`)</script><%
        /*사용자프로필정보 파싱*/
        JsonParser jsonParser2 = new JsonParser();
        JsonObject respon = (JsonObject) jsonParser2.parse(str);
        JsonObject prof = (JsonObject)respon.get("response");
        String id = prof.get("id").getAsString();
        String birthday = prof.get("birthday").getAsString();
        String birthyear = prof.get("birthyear").getAsString();
        String age = prof.get("age").getAsString();
        String gender = prof.get("gender").getAsString();
        String email = prof.get("email").getAsString();
        String name = prof.get("name").getAsString();
        String mobile = prof.get("mobile").getAsString();
  %><script>console.log("<%=respon%>")</script><%
        //out.println(name);
  %>
  <script>
    var s = encodeURI("_"+"signup.jsp"+"?sns_id=<%=id%>&gender=<%=gender%>&email=<%=email%>&phone=<%=mobile%>&name=<%=name%>&age=<%=age%>&birthday=<%=birthday%>&birthyear=<%=birthyear%>&sns_type=naver");
    document.location.href = s;
  </script>
  <%
      }
    } catch(Exception e){
      System.out.println(e);
    }
  %>
  </body>
</html>