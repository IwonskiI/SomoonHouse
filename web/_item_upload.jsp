<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*,java.util.Calendar,java.util.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest,com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page language="java" import="myPackage.DBUtil" %>
<%@ page language="java" import="myPackage.Link" %>
<%@ page language="java" import="myPackage.GetImage" %>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">
	<%
		String id = session.getAttribute("s_id")+"";
		String now = "_item_upload.jsp";
		String url = "";
		String roadAddrPart1 = "";
		String bdNm = "";
		String building = "";
		String title = "";
		String content = "";
		String company = "";
		String fee = "";
		String etc = "";
		String entX = "";
		String entY = "";
		String file1[] = new String[10];
		String price_area = "";
		String period = "";
		String part = "";
		String areasquare = "";
		request.setCharacterEncoding("UTF-8");
		String realFolder = "";
		String filename1 = "";
		int maxSize = 1024*1024*5;
		String encType = "UTF-8";
		String savefile = "img";
		ServletContext scontext = getServletContext();
		realFolder = scontext.getRealPath(savefile);

		Connection conn = DBUtil.getMySQLConnection();
		try{
			MultipartRequest multi=new MultipartRequest(request, realFolder, maxSize, encType, new DefaultFileRenamePolicy());
			url = multi.getParameter("url")+"";
			if(url.equals("")) url = "NULL";
			roadAddrPart1 = multi.getParameter("roadAddrPart1")+"";
			if(roadAddrPart1.equals("")) roadAddrPart1 = "NULL";
			bdNm = multi.getParameter("bdNm")+"";
			if(bdNm.equals("")) bdNm = "NULL";
			building = multi.getParameter("building")+"";
			if(building.equals("")) building = "NULL";
			title = multi.getParameter("title")+"";
			if(title.equals("")) title = "NULL";
			content = multi.getParameter("content")+"";
			if(content.equals("")) content = "NULL";
			company = multi.getParameter("company")+"";
			if(company.equals("")) company = "NULL";
			fee = multi.getParameter("fee")+"";
			if(fee.equals("")) fee = "NULL";
			etc = multi.getParameter("etc")+"";
			if(etc.equals("")) etc = "NULL";
			entX = multi.getParameter("entX")+"";
			if(entX.equals("")) entX = "NULL";
			entY = multi.getParameter("entY")+"";
			price_area = multi.getParameter("price_area")+"";
			if(price_area.equals("")) price_area = "NULL";
			period = multi.getParameter("period")+"";
			if(period.equals("")) period = "NULL";
			part = multi.getParameter("part")+"";
			if(part.equals("")) part = "NULL";
			areasquare = multi.getParameter("area")+"";
			if(areasquare.equals("")) areasquare = "NULL";
			Enumeration<?> files = multi.getFileNames();
			file1[0] = (String)files.nextElement();
			filename1 = multi.getFilesystemName(file1[0]);
		} catch(Exception e) {
			e.printStackTrace();
		}
		int error=0;
		if((title.equals("NULL") || filename1 == null) && url.equals("")){
	%><script>alert("제목,사진과 url중 하나를 입력해주시길 바랍니다"); window,history.back();</script><%
		error++;
	}
	else if(title.equals("NULL") || filename1 == null){
		Link MyLink = new Link(url);
		out.println("url: "+url);
		if(title.equals("NULL")){
			title = MyLink.getTitle();
			out.println("제목이없어요");
		}
		if(filename1 == null){
			file1 = MyLink.getImg();
			out.println("파일이없어요\n");
		}
	}
	if(filename1 != null)
		file1[0] = "img" + "/" + filename1;
	out.println("filename : " + file1[0] + "\n");
	//주소에서 지역 추출
	String keyword = "";
	String[] area = roadAddrPart1.split(" "); // area[0] 대구광역시 area[1]북구 ...
	PreparedStatement pstmt = null;
	String sql = "SELECT * FROM ROOT_AREA WHERE Area_name LIKE " + "\"%"+area[0]+"%\"";
	pstmt = conn.prepareStatement(sql);
	ResultSet rs = pstmt.executeQuery(sql);
	int rootareanum = -1;
	while(rs.next()){
		rootareanum = rs.getInt("Area_number");
	}
	if(rootareanum == -1){
		area = new String[2];
		area[1] = "recommend"; //out.println("지역을못찾겠어요ㅜㅜ");
	}
	sql = "SELECT * FROM SECOND_AREA WHERE Parent_Area = "+ rootareanum +" And Area_name LIKE " + "\""+area[1]+"\"";
	pstmt = conn.prepareStatement(sql);
	rs = pstmt.executeQuery(sql);
	int secondareanum = -1;
	while(rs.next()){
		secondareanum = rs.getInt("Area_number");
	}
	if(secondareanum == -1){
		out.println("행정구역을 못찾겠어요 ㅠㅠ");
	}
	pstmt = null;
	sql = "INSERT INTO REMODELING VALUES(Default, ?, ?, ?, ?, 0, ?, ?, ?, ?, ?, ?, ?, ?, ?, DEFAULT, ?, DEFAULT, ?, ?, 0, DEFAULT, ?)";

	//현재날짜 받아오기
	Calendar cal = Calendar.getInstance();
	String year = Integer.toString(cal.get(Calendar.YEAR));
	String month = Integer.toString(cal.get(Calendar.MONTH)+1);
	String date = Integer.toString(cal.get(Calendar.DATE));
	String todayformat = year+"-"+month+"-"+date;
	java.sql.Date d = java.sql.Date.valueOf(todayformat);

	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, "0");
	pstmt.setString(2, title);
	pstmt.setDate(3, d);
	pstmt.setString(4, company);
	pstmt.setString(5, fee);
	pstmt.setString(6, roadAddrPart1);
	pstmt.setString(7, bdNm);
	pstmt.setString(8, building);
	pstmt.setString(9, entX);
	pstmt.setString(10, entY);
	pstmt.setString(11, etc);
	pstmt.setString(12, content);
	pstmt.setString(13, url);
	pstmt.setString(14, period);
	pstmt.setInt(15, rootareanum);
	pstmt.setInt(16, secondareanum);
	pstmt.setInt(17, Integer.parseInt(areasquare));
	if(error == 0){
		pstmt.executeUpdate();
	}

	//사진 넣기
	sql = "SELECT MAX(Number) FROM REMODELING";
	pstmt = conn.prepareStatement(sql);
	rs = pstmt.executeQuery();
	int max = 0;
	while(rs.next()){
		max = rs.getInt("MAX(Number)");
	}
	int i;
	out.println("img[] size : "+ file1.length);
	for(i=0; i<file1.length; i++){
		out.println("img["+i+"] : "+file1[i]);
		if(file1[i] == null || file1[i].equals("null"))
			break;

		sql = "Insert into RMDL_IMG values(?, ?, ?)";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, max);
		pstmt.setInt(2, i);
		pstmt.setString(3, file1[i]);
		if(error == 0){
			pstmt.executeUpdate();
		}
	}
	pstmt.close();
	conn.close();
%>
	<script>
		alert('등록을 완료했습니다.');
		self.close();
	</script>
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