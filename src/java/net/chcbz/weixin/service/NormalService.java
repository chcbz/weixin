package net.chcbz.weixin.service;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;

@Path("/normal")
public interface NormalService {
	@GET
	@Produces(MediaType.TEXT_PLAIN)
	public String signature(@QueryParam("echostr") String echostr);
	
	@POST
	@Consumes(MediaType.TEXT_XML)
	@Produces(MediaType.TEXT_XML)
	public String message(String msg);
}
