<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*,java.util.Calendar,java.security.SecureRandom" %>
<%@ page language="java" import="myPackage.*" %>
<%@ page import="com.sun.xml.internal.ws.developer.ValidationErrorHandler" %>
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script> 
<% request.setCharacterEncoding("UTF-8"); %>
<%String b_page = session.getAttribute("b_page")+"";%>
<!DOCTYPE html>
<html>
<head>
<style type="text/css">
	body{
	margin : 0px;
	}
</style>	
<title></title>
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
  <%!
  public String unicodeConvert(String str){
	  StringBuilder sb = new StringBuilder();
	  char ch;
	  int len = str.length();
	  for(int i = 0; i < len; i++){
		  ch = str.charAt(i);
		  if(ch == '\\' && str.charAt(i+1) == 'u'){
			  sb.append((char) Integer.parseInt(str.substring(i+2, i+6), 16));
			  i+=5;
		  }
		  sb.append(ch);
	  }
	  return sb.toString();
  }
  %>
	<ul class="navbar">
	</ul>
	<%!/*
	public class Password {
	  	// Define the BCrypt workload to use when generating password hashes. 10-31 is a valid value.
		private static int workload = 12;

		
		 * This method can be used to generate a string representing an account password
		 * suitable for storing in a database. It will be an OpenBSD-style crypt(3) formatted
		 * hash string of length=60
		 * The bcrypt workload is specified in the above static variable, a value from 10 to 31.
		 * A workload of 12 is a very reasonable safe default as of 2013.
		 * This automatically handles secure 128-bit salt generation and storage within the hash.
		 * @param password_plaintext The account's plaintext password as provided during account creation,
		 *			     or when changing an account's password.
		 * @return String - a string of length 60 that is the bcrypt hashed password in crypt(3) format.
		 
		public String hashPassword(String password_plaintext) {
			String salt = BCrypt.gensalt(workload);
			String hashed_password = BCrypt.hashpw(password_plaintext, salt);

			return(hashed_password);
		}*/
	%>
	<%
	Connection conn = DBUtil.getMySQLConnection();
	ResultSet rs = null;
	Statement stmt = null;
	String query = "select case when count(*)=0 then 1 else max(ID) + 1 end as num FROM USERS";
	stmt = conn.createStatement();
	rs = stmt.executeQuery(query);
	int num = 0;
	int error = 0;
	while(rs.next()){
		num = rs.getInt("num");
	}
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	String name = request.getParameter("name");
	String nickname = request.getParameter("nickname");
	String sns_id = request.getParameter("sns_id");
	String sns_type = request.getParameter("sns_type");
	String gender = request.getParameter("gender");
	String email = request.getParameter("email");
	String phone = request.getParameter("phone");
	String birthday = request.getParameter("birthday");
	String birthyear = request.getParameter("birthyear");
	String age = request.getParameter("age");
	
	//out.println(name);
	if(sns_id != "" && sns_id != null && !sns_id.equals("-1") && !sns_id.equals("null")){
		/*생일포맷수정*/
		age = age.replaceAll("-","");
		birthday = birthday.replaceAll("-","");
		phone = phone.replaceAll("-","");
		
		/*중복가입정보가 있는 지?*/
		String sql = "SELECT *, COUNT(*) AS exist FROM USERS WHERE SNS_ID = \'"+sns_id
		+"\' AND SNS_TYPE = \'"+sns_type+"\'";
		rs.close();stmt.close();
		stmt=conn.createStatement();
		rs=stmt.executeQuery(sql);
		String username = "";
		int exist = 0;
		int index = 0;
		while(rs.next()){
			exist = rs.getInt("exist");
			index = rs.getInt("ID");
			username = rs.getString("USERNAME");
		}
		if(exist != 0){
		%><script>alert("로그인되었습니다!")</script><%
		session.setAttribute("page", "");
		session.setAttribute("home_id", index);
		session.setAttribute("home_name", username);
		error++;

		Calendar cal = Calendar.getInstance();
		String year = Integer.toString(cal.get(Calendar.YEAR));
		String month = Integer.toString(cal.get(Calendar.MONTH)+1);
		String date = Integer.toString(cal.get(Calendar.DATE));
		String todayformat = year+"-"+month+"-"+date;
		java.sql.Date d = java.sql.Date.valueOf(todayformat);
		query = "UPDATE USERS SET MODIFY_DATE = ? WHERE ID = ?";
		PreparedStatement pstmt = null;
		pstmt = conn.prepareStatement(query);	
		pstmt.setDate(1, d);	
		pstmt.setInt(2, index);
		pstmt.executeUpdate();

		  if (b_page.equals("remodeling_form.jsp")){
			  session.setAttribute("b_page","");
			  String item_num = session.getAttribute("rf_inum")+"";
  			%><script>document.location.href="remodeling_form.jsp?item_num=<%=item_num%>"</script><%
		  }
		  else{
  			%><script>document.location.href="homepage.jsp"</script><%
		  }
		}
		else if(gender == "" || gender == null){
			gender = "NULL";
		}
	}
	else if(id == "" || id == null){%>
		<script>
		alert('아이디는 필수입력정보입니다.');
		history.back();	
		</script>
	<%
	error++;
	}
	else if(pw == "" || pw == null){%>
	<script>
	alert('비밀번호는 필수입력정보입니다.');
	history.back();	
	</script>
	<%
	error++;
	}
	else if(birthday.length()<8 || birthday.length()>8)
	{%>
		<script>
		alert('생일은 8자리 숫자로 입력해주세요 ex)19891028');
		alert("<%=birthday%>");
		history.back();
		</script>
	<%
	error++;
	}
	else{
		try{
			Integer.parseInt(birthday);
			birthyear = birthday.substring(0,4);
			birthday = birthday.substring(4);
		}
		catch(NumberFormatException e){
			%>
			<script>
			alert('생년월일은 숫자만 입력 가능합니다.');
			history.back();
			</script><%
			error++;
		}
	}
	
	if(error == 0){%>
		<script>
		if(confirm('위의 정보가 정확합니까?'))
		{
		</script>
			<%
/*   
+-------------+--------------+------+-----+---------+----------------+
| Field       | Type         | Null | Key | Default | Extra          |
+-------------+--------------+------+-----+---------+----------------+
| ID          | int(11)      | NO   | PRI | NULL    | auto_increment |
| SITE_ID     | varchar(20)  | YES  |     | NULL    |                |
| PW          | varchar(120) | YES  |     | NULL    |                |
| USERNAME    | varchar(50)  | YES  | MUL | NULL    |                |
| EMAIL       | varchar(50)  | YES  | MUL | NULL    |                |
| NICKNAME    | varchar(50)  | YES  |     | NULL    |                |
| SNS_ID      | varchar(255) | YES  | MUL | NULL    |                |
| SNS_TYPE    | varchar(10)  | YES  |     | NULL    |                |
| CREATE_DATE | datetime     | YES  |     | NULL    |                |
| MODIFY_DATE | datetime     | YES  |     | NULL    |                |
| BIRTHDAY    | varchar(9)   | YES  |     | NULL    |                |
| GENDER      | char(1)      | YES  |     | NULL    |                |
| POINT       | int(11)      | YES  |     | 0       |                |
| GRADE       | varchar(50)  | YES  |     | silver  |                |
+-------------+--------------+------+-----+---------+----------------+
14 rows in set (0.00 sec)
*/			
			PreparedStatement pstmt = null;
			String sql = "INSERT INTO USERS VALUES" + "(?,?,password(?),?,?,null,?,?,?,?,?,?,?,?,?,?,default,default, default, NULL)";
			/*현재날짜 받아오기*/
			Calendar cal = Calendar.getInstance();
			String year = Integer.toString(cal.get(Calendar.YEAR));
			
			
			String month = Integer.toString(cal.get(Calendar.MONTH)+1);
			String date = Integer.toString(cal.get(Calendar.DATE));
			String todayformat = year+"-"+month+"-"+date;
			Date d = Date.valueOf(todayformat);
			/*비밀번호 보안저장*/
			/*SecureRandom random = new SecureRandom();
			int salt_size = 60;
			String salt = "";
			for(int i=0;i<salt_size;i++){
				salt += random.nextInt(10);
			}
			String password = salt + pw;
			*/

			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			pstmt.setString(2, id);
			pstmt.setString(3, pw);
			pstmt.setString(4, name);
			pstmt.setString(5, email);
			pstmt.setString(6, phone);
			pstmt.setString(7, nickname);
			pstmt.setString(8, sns_id);
			pstmt.setString(9, sns_type);
			pstmt.setDate(10, d);
			pstmt.setDate(11, d);
			pstmt.setString(12, birthday);
			pstmt.setString(13, birthyear);
			pstmt.setString(14, age);
			pstmt.setString(15, gender);

			out.println(pstmt);
			try{
				pstmt.executeUpdate();
			}catch(SQLException e){
			%>
			<script>
			alert('신청에 실패했습니다.');
			history.back();
			</script>
			<%
			out.println(e);
			}
			//out.println(pstmt);
			pstmt.close();
			stmt.close();
			conn.close();
			rs.close();
			session.setAttribute("page", "");
			session.setAttribute("s_id", "");
			session.setAttribute("name", "");
			%><script>alert("로그인되었습니다!")</script><%
	  		session.setAttribute("page", "");
			session.setAttribute("home_id", num);
	  		session.setAttribute("home_name", name);
			%>
  			<% if (b_page.equals("remodeling_form.jsp")){
				  session.setAttribute("b_page","");
				String item_num = session.getAttribute("rf_inum")+"";
  			%><script>document.location.href="remodeling_form.jsp?item_num=<%=item_num%>"</script><%
			  }
  			else{
  			%><script>document.location.href="homepage.jsp"</script><%
			  }%>
			<script>
		}
		else{
			history.back();
		}
		</script>
	<%
	}%>
</body>
</html>