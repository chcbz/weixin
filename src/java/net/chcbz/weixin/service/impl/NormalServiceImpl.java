package net.chcbz.weixin.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import net.chcbz.weixin.service.NormalService;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service("signatureServiceImpl")  
public class NormalServiceImpl implements NormalService {
	
	final Logger logger = LoggerFactory.getLogger(NormalServiceImpl.class);
	private String toUserName = "";
	private String fromUserName = "";
	private List<Map<String,String>> articleList = new ArrayList<Map<String,String>>();

	public String signature(String echostr) {
		return echostr;
	}

	public String message(String msg) {
		String returnValue = "";
		try {
			Document xml = DocumentHelper.parseText(msg);
			Element root = xml.getRootElement();
			toUserName = root.element("ToUserName").getText();
			fromUserName = root.element("FromUserName").getText();
//			String createTime = root.element("CreateTime").getText();
			String msgType = root.element("MsgType").getText();
//			String msgId = root.element("MsgId").getText();
			
			if("text".equals(msgType)){
				String content = root.element("MsgType").getText();
				if("声音".equals(content)){
					
				}else{
					returnValue = generateReturnMessage();
				}
				
			}
		} catch (DocumentException e) {
			logger.error("net.chcbz.weixin.service.impl.NormalServiceImpl", e);
		}
		return returnValue;
	}

	private String generateReturnMessage(){
		Document document = DocumentHelper.createDocument();
		Element root = document.addElement("xml");
		root.addElement("ToUserName").addText(fromUserName);
		root.addElement("FromUserName").addText(toUserName);
		root.addElement("CreateTime").addText(String.valueOf(new Date().getTime()));
		root.addElement("MsgType").addText("news");
		root.addElement("ArticleCount").addText(String.valueOf(articleList.size()));
		Element articles = root.addElement("Articles");
		for(int i=0;i<articleList.size();i++){
			Map<String,String> article = articleList.get(i);
			Element item = articles.addElement("item");
			item.addElement("Title").addText(article.get("title"));
			item.addElement("Description").addText(article.get("description"));
			item.addElement("PicUrl").addText(article.get("picUrl"));
			item.addElement("Url").addText(article.get("url"));
		}
		return document.asXML();
	}

	public List<Map<String, String>> getArticleList() {
		return articleList;
	}

	public void setArticleList(List<Map<String, String>> articleList) {
		this.articleList = articleList;
	}
}
