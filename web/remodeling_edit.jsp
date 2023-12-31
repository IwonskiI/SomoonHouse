<%@ page import="java.net.URLEncoder" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page language="java" import="java.text.*,java.sql.*,java.util.Calendar,java.util.*" %>
<%@ page import="com.oreilly.servlet.MultipartRequest,com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page language="java" import="myPackage.DBUtil" %>
<%
	String num = request.getParameter("num")+"";
	
	Connection conn = DBUtil.getMySQLConnection();
	ResultSet rs = null;
	PreparedStatement pstmt = null;
	String query = "";
	query="SELECT * FROM REMODELING Where Number = ?";
	pstmt = conn.prepareStatement(query);
	pstmt.setString(1, num);
	rs=pstmt.executeQuery();
	String url = "";
	String addr = "";
	String company = "";
	String fee = "";
	String apart_name = "";
	String building = "";
	String etc = "";
	String title = "";
	String content = "";
	String Xpos = "";
	String Ypos = "";
	String price_area = "";
	String period = "";
	String part = "";
	String area = "";
	while(rs.next()){
		url = rs.getString("URL");
		addr = rs.getString("Address");
		apart_name = rs.getString("Apart_name");
	 	building = rs.getString("Building");
	 	title = rs.getString("Title");
	 	content = rs.getString("Content");
	 	company = rs.getString("Company");
	 	fee = rs.getString("Fee");
	 	etc = rs.getString("Etc");
	 	Xpos = rs.getString("Xpos");
	 	Ypos = rs.getString("Ypos");
	 	price_area = rs.getString("Price_area");
	 	period = rs.getString("Period");
	 	part = rs.getString("Part");
	 	area = rs.getString("Area");
	 	

	 	if(url == null || url.equals("") || url.equals("NULL"))
	 		url = "";
	 	if(addr == null || addr.equals("") || addr.equals("NULL"))
	 		addr = "";
	 	if(apart_name == null || apart_name.equals("") || apart_name.equals("NULL"))
	 		apart_name = "";
	 	if(building == null || building.equals("") || building.equals("NULL"))
	 		building = "";
	 	if(title == null || title.equals("") || title.equals("NULL"))
	 		title = "";
	 	if(content == null || content.equals("") || content.equals("NULL"))
	 		content = "";
	 	if(company == null || company.equals("") || company.equals("NULL"))
	 		company = "";
	 	if(fee == null || fee.equals("") || fee.equals("NULL"))
	 		fee = "";
	 	if(etc == null || etc.equals("") || etc.equals("NULL"))
	 		etc = "";
	 	if(Xpos == null || Xpos.equals("") || Xpos.equals("NULL"))
	 		Xpos = "";
	 	if(Ypos == null || Ypos.equals("") || Ypos.equals("NULL"))
	 		Ypos = "";
	 	if(price_area == null || price_area.equals("") || price_area.equals("NULL"))
	 		price_area = "";
	 	if(period == null || period.equals("") || period.equals("NULL"))
	 		period = "";
	 	if(part == null || part.equals("") || part.equals("NULL"))
	 		part = "";
	 	if(area == null || area.equals("") || area.equals("NULL"))
	 		area = "";
	}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script language="javascript">

function goPopup(){
	// 주소검색을 수행할 팝업 페이지를 호출합니다.
	// 호출된 페이지(jusopopup.jsp)에서 실제 주소검색URL(http://www.juso.go.kr/addrlink/addrCoordUrl.do)를 호출하게 됩니다.
	var pop = window.open("jusoPopup.jsp","pop","width=570,height=420, scrollbars=yes, resizable=yes"); 
}


function jusoCallBack(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn,detBdNmList,bdNm,bdKdcd,siNm,sggNm,emdNm,liNm,rn,udrtYn,buldMnnm,buldSlno,mtYn,lnbrMnnm,lnbrSlno,emdNo,entX,entY){
		// 팝업페이지에서 주소입력한 정보를 받아서, 현 페이지에 정보를 등록합니다.
		document.form.roadFullAddr.value = roadFullAddr;
		document.form.roadAddrPart1.value = roadAddrPart1;
		document.form.roadAddrPart2.value = roadAddrPart2;
		document.form.addrDetail.value = addrDetail;
		document.form.engAddr.value = engAddr;
		document.form.jibunAddr.value = jibunAddr;
		document.form.zipNo.value = zipNo;
		document.form.admCd.value = admCd;
		document.form.rnMgtSn.value = rnMgtSn;
		document.form.bdMgtSn.value = bdMgtSn;
		document.form.detBdNmList.value = detBdNmList;
		document.form.bdNm.value = bdNm;
		document.form.bdKdcd.value = bdKdcd;
		document.form.siNm.value = siNm;
		document.form.sggNm.value = sggNm;
		document.form.emdNm.value = emdNm;
		document.form.liNm.value = liNm;
		document.form.rn.value = rn;
		document.form.udrtYn.value = udrtYn;
		document.form.buldMnnm.value = buldMnnm;
		document.form.buldSlno.value = buldSlno;
		document.form.mtYn.value = mtYn;
		document.form.lnbrMnnm.value = lnbrMnnm;
		document.form.lnbrSlno.value = lnbrSlno;
		document.form.emdNo.value = emdNo;
		document.form.entX.value = entX;
		document.form.entY.value = entY;
		
}

</script>
<title>주소 입력 샘플</title>
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
<form name="form" id="form" method="post" enctype="multipart/form-data" action="_remodeling_edit.jsp?num=<%=num%>">
	<input type="button" onClick="goPopup();" value="주소찾기"/>
	<div id="list"></div>
	<div id="callBackDiv">
			<input type="file" name="filename1" size=40>
			<input type="hidden"  style="width:500px;" id="roadFullAddr"  name="roadFullAddr" />
			<input type="hidden"  style="width:500px;" id="addrDetail"  name="addrDetail" />
			<input type="hidden"  style="width:500px;" id="roadAddrPart2"  name="roadAddrPart2" />
			<input type="hidden"  style="width:500px;" id="engAddr"  name="engAddr" />
			<input type="hidden"  style="width:500px;" id="jibunAddr"  name="jibunAddr" />
			<input type="hidden"  style="width:500px;" id="zipNo"  name="zipNo" />
			<input type="hidden"  style="width:500px;" id="admCd"  name="admCd" />
			<input type="hidden"  style="width:500px;" id="rnMgtSn"  name="rnMgtSn" />
			<input type="hidden"  style="width:500px;" id="bdMgtSn"  name="bdMgtSn" />
			<input type="hidden"  style="width:500px;" id="detBdNmList"  name="detBdNmList" />
			<input type="hidden"  style="width:500px;" id="bdKdcd"  name="bdKdcd" />
			<input type="hidden"  style="width:500px;" id="siNm"  name="siNm" />
			<input type="hidden"  style="width:500px;" id="sggNm"  name="sggNm" />
			<input type="hidden"  style="width:500px;" id="emdNm"  name="emdNm" />
			<input type="hidden"  style="width:500px;" id="liNm"  name="liNm" />
			<input type="hidden"  style="width:500px;" id="rn"  name="rn" />
			<input type="hidden"  style="width:500px;" id="udrtYn"  name="udrtYn" />
			<input type="hidden"  style="width:500px;" id="buldMnnm"  name="buldMnnm" />
			<input type="hidden"  style="width:500px;" id="buldSlno"  name="buldSlno" />
			<input type="hidden"  style="width:500px;" id="mtYn"  name="mtYn" />
			<input type="hidden"  style="width:500px;" id="lnbrMnnm"  name="lnbrMnnm" />
			<input type="hidden"  style="width:500px;" id="lnbrSlno"  name="lnbrSlno" />
			<input type="hidden"  style="width:500px;" id="emdNo"  name="emdNo" />
			<input type="hidden"  style="width:500px;" id="entX"  name="entX" value = "<%=Xpos%>"/>
			<input type="hidden"  style="width:500px;" id="entY"  name="entY"  value = "<%=Ypos%>"/>
		<table>
			<tr><td>URL				</td><td><input type="text"  style="width:500px;" id="url"  name="url" value="<%=url %>" ></td></tr>
			<tr><td>도로명주소			</td><td><input type="text"  style="width:500px;" id="roadAddrPart1"  name="roadAddrPart1" value="<%=addr %>" ></td></tr>
			<tr><td>건물(아파트)명		</td><td><input type="text"  style="width:500px;" id="bdNm"  name="bdNm" value="<%=apart_name%>"></td></tr>
			<tr><td>동      	  		</td><td><input type="text"  style="width:500px;" id="building"  name="building" value="<%=building%>"></td></tr>
			<tr><td>글제목       			</td><td><input type="text"  style="width:500px;" id="title"  name="title" value="<%=title%>"></td></tr>
			<tr><td>글내용       			</td><td><input type="text"  style="width:500px;" id="content"  name="content" value="<%=content%>"></td></tr>
			<tr><td>시공사       			</td><td><input type="text"  style="width:500px;" id="company"  name="company" value="<%=company%>"></td></tr>
			<tr><td>시공비용       		</td><td><input type="text"  style="width:500px;" id="fee"  name="fee" value="<%=fee%>"></td></tr>
			<tr><td>기타사항       		</td><td><input type="text"  style="width:500px;" id="etc"  name="etc" value="<%=etc%>"></td></tr>
			<tr><td>평수      		</td><td><input type="text"  style="width:500px;" id="area"  value="<%=area%>" name="area" /></td></tr>
			<tr><td>시공기간       		</td><td><input type="text"  style="width:500px;" id="period" value="<%=period%>" name="period" /></td></tr>
			<tr><td>부분시공가능여부 		</td><td><input type="text"  style="width:500px;" id="part" value="<%=part%>" name="part" /></td></tr>
		</table>
		<div>※제목을 입력하지 않으면 등록한 URL의 제목으로 자동등록됩니다.</div>
		<input type="submit" value="등록">
	</div>
</form>
<script type = "text/javascript" src = "https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
</body>
</html>