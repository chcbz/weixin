<%@ page language="java" contentType="text/html; UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.io.*,java.net.*,java.util.*,javax.mail.*,javax.mail.internet.*" %>
<%
try {
	String method = request.getParameter("method");
	String currentPath = new File(application.getRealPath(request.getRequestURI())).getParent();
	String name = request.getParameter("name");
	String user = request.getParameter("user");
	String phone = request.getParameter("phone");
	String email = request.getParameter("email");
	String vda = request.getParameter("vda");
	if("doShow".equals(method)){
		//文件名不能为空
		if(name != null & !"".equals(name)){
			//验证码要匹配
			Properties vdaProp = new Properties();
			File vdaFile = new File(currentPath+File.separator+"vda.tmp");
			if(!vdaFile.exists()){
				vdaFile.createNewFile();
			}
			InputStream vdaIS = new BufferedInputStream(new FileInputStream(vdaFile));
			vdaProp.load(vdaIS);
			vdaIS.close();
			String vdaStr = vdaProp.getProperty("vda."+name+"."+user);
			if(vdaStr != null && vdaStr.equals(vda)){
				Properties props = new Properties();
				InputStream configIS = new BufferedInputStream(new FileInputStream(currentPath+File.separator+"config.ini"));
				props.load(configIS);
				configIS.close();
				String urlStr = props.getProperty("config."+name+".url");
				//URL不能为空
				if(urlStr != null && !"".equals(urlStr)){
					//检查权限
					boolean permit = false;
					String allowStr = props.getProperty("config."+name+".allow");
					if(allowStr != null && !"".equals(allowStr)){
						String[] allowArr = allowStr.split(",");
						for(int i=0;i<allowArr.length;i++){
							if(allowArr[i].equals(email)){
								permit = true;
								break;
							}
						}
					}else{ //如果没有配置权限，默认不控制
						permit = true;
					}
					if(permit){
						URL u = new URL(urlStr);
						HttpURLConnection conn = (HttpURLConnection)u.openConnection();
						conn.setDoOutput(true);
						conn.setRequestMethod("GET");
						conn.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.154 Safari/537.36");
						response.setContentType(conn.getContentType());
						
						OutputStream os = response.getOutputStream();
					    
						DataInputStream is = new DataInputStream(conn.getInputStream());
						int n;
						while((n = is.read())!=-1){
							os.write(n);
						}
						os.flush();
						os.close();
						is.close();
					}
				}
			}
		}
		//记录访问者信息
		RandomAccessFile fos = new RandomAccessFile(currentPath+File.separator+"record.log", "rw");
		fos.seek(fos.length());
		fos.writeBytes(new Date()+" "+request.getRemoteAddr()+" "+request.getRemoteHost()+" "+request.getHeader("User-Agent")+" "+name+" "+user+" "+phone+" "+email+System.lineSeparator());
		fos.close();
		
		response.flushBuffer();
		out.clear();
		out = pageContext.pushBody(); 
	}else if("sendMail".equals(method)){
		String ran = String.valueOf((int)((Math.random()*9+1)*100000));
		Properties vdaProp = new Properties();
		File vdaFile = new File(currentPath+File.separator+"vda.tmp");
		if(!vdaFile.exists()){
			vdaFile.createNewFile();
		}
		InputStream vdaIS = new BufferedInputStream(new FileInputStream(vdaFile));
		vdaProp.load(vdaIS);
		vdaIS.close();
		String oldRan = vdaProp.getProperty("vda."+name+"."+user);
		if(oldRan != null && !"".equals(oldRan)){
			ran = oldRan;
		}else{
			vdaProp.setProperty("vda."+name+"."+user, ran);
			OutputStream vdaOS = new FileOutputStream(vdaFile);
			vdaProp.store(vdaOS, "");
			vdaOS.close();
		}
		
		Properties configProps = new Properties();
		InputStream configIS = new BufferedInputStream(new FileInputStream(currentPath+File.separator+"config.ini"));
		configProps.load(configIS);
		configIS.close();
		final Properties mailProp = new Properties();
        // 表示SMTP发送邮件，需要进行身份验证
        mailProp.put("mail.smtp.auth", configProps.getProperty("mail.smtp.auth"));
        mailProp.put("mail.smtp.host", configProps.getProperty("mail.smtp.host"));
        // 发件人的账号
        mailProp.put("mail.user", configProps.getProperty("mail.user"));
        // 访问SMTP服务时需要提供的密码
        mailProp.put("mail.password", configProps.getProperty("mail.password"));

        // 构建授权信息，用于进行SMTP进行身份验证
        javax.mail.Authenticator authenticator = new javax.mail.Authenticator() {
            @Override
            protected javax.mail.PasswordAuthentication getPasswordAuthentication() {
                // 用户名、密码
                String userName = mailProp.getProperty("mail.user");
                String password = mailProp.getProperty("mail.password");
                return new javax.mail.PasswordAuthentication(userName, password);
            }
        };
        // 使用环境属性和授权信息，创建邮件会话
        Session mailSession = Session.getInstance(mailProp, authenticator);
        // 创建邮件消息
        MimeMessage message = new MimeMessage(mailSession);
        // 设置发件人
        InternetAddress form = new InternetAddress(
        		mailProp.getProperty("mail.user"));
        message.setFrom(form);

        // 设置收件人
        InternetAddress to = new InternetAddress(email);
        message.setRecipient(javax.mail.Message.RecipientType.TO, to);

        // 设置抄送
        //InternetAddress cc = new InternetAddress("luo_aaaaa@yeah.net");
        //message.setRecipient(RecipientType.CC, cc);

        // 设置密送，其他的收件人不能看到密送的邮件地址
        String bccmail = configProps.getProperty("mail.bccmail");
        if(bccmail != null && !"".equals(bccmail)){
	        InternetAddress bcc = new InternetAddress(bccmail);
	        message.setRecipient(javax.mail.Message.RecipientType.BCC, bcc);
        }

        // 设置邮件标题
        message.setSubject("获取验证码");

        // 设置邮件的内容体
        message.setContent("验证码：<font style='color:red;'>"+ran+"</font>", "text/html;charset=UTF-8");

        // 发送邮件
        Transport.send(message);
	}
} catch (Exception e) {
	e.printStackTrace();
}
%>
<html>
<head>
<title></title>
<script type="text/javascript">
function sendVdaEmail() {
	var name = document.getElementById("name").value;
	var user = document.getElementById("user").value;
	var email = document.getElementById("email").value;
	if(user == "" || email == ""){
		alert("必须填写联系人和电子邮箱！");
	}else{
		var xmlHttp;
		try {
	        // Firefox, Opera 8.0+, Safari
			xmlHttp = new XMLHttpRequest();
		} catch (e) {
	        // Internet Explorer
			try {
				xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
			} catch (e) {
				try {
					xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
				} catch (e) {
					alert("您的浏览器不支持AJAX！");
					return false;
				}
			}
		}
		xmlHttp.onreadystatechange = function(){
			if( xmlHttp.readyState == 4  && xmlHttp.status == 200 ){
				//document.getElementById("vdaButton").disabled = true;
				alert("已成功发送验证码到你邮箱，请查收并填写到验证码输入框！");
			}
		}
	    xmlHttp.open( "GET", "index.jsp?method=sendMail&name="+name+"&user="+user+"&email="+email, true );
	    xmlHttp.send( null );
	}
}
</script>
</head>
<body>
<center>
	<form action="index.jsp" method="get">
		联系人<input type="text" id="user" name="user" value=""/><br/>
		电子邮件<input type="text" id="email" name="email" value=""/><br/>
		验证码<input type="text" size="5" name="vda"/><input id="vdaButton" type="button" value="点击获取" onclick="javascript:sendVdaEmail();"/>
		<br/>
		<input type="hidden" name="name" id="name"/>
		<input type="hidden" name="method" value="doShow"/>
		<input type="submit" value="确认"/>
	</form>
</center>
<script type="text/javascript">
function getQueryString(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
    var r = window.location.search.substr(1).match(reg);
    if (r != null) return unescape(r[2]); return null;
}
document.getElementById("name").value=(getQueryString("name"));
document.getElementById("user").value=(getQueryString("user"));
document.getElementById("email").value=(getQueryString("email"));
</script>
</body>
</html>