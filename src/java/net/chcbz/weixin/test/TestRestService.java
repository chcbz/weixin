package net.chcbz.weixin.test;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

public class TestRestService {
	private static void postMessage() throws Exception{
		URL url = new URL("http://localhost:8080/weixin/service/normal");
		HttpURLConnection conn = (HttpURLConnection)url.openConnection();
		conn.setRequestMethod("POST");
		conn.setDoInput(true);
		conn.setDoOutput(true);
		conn.setUseCaches(false);
		conn.setRequestProperty("Accept", "text/xml");
		conn.setRequestProperty("User-Agent", "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.64 Safari/537.11");
		conn.setRequestProperty("Content-Type", "text/xml");
		conn.setRequestProperty("Accept-Language", "zh-cn");
		conn.setRequestProperty("Connection", "Keep-Alive");
		conn.setRequestProperty("Charset", "UTF-8");
		
		conn.setConnectTimeout(50000);
		conn.setReadTimeout(50000);
		
		String xml = "<xml><ToUserName>toUser</ToUserName><FromUserName>fromUser</FromUserName><CreateTime>1348831860</CreateTime><MsgType>text</MsgType><Content><![CDATA[this is a test]]></Content><MsgId>1234567890123456</MsgId></xml>";
		
		OutputStream os = conn.getOutputStream();
		os.write(xml.toString().getBytes("UTF-8"));
		os.close();
		
		BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(),"UTF-8"));
		String line = "";
		while((line = br.readLine())!=null){
			System.out.println(line + "\n");
		}
		br.close();
	}
	
	public static void main(String[] args) throws Exception{
		postMessage();
	}
}
