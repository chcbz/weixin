package net.chcbz.weixin.vo;

public class User {
	private String name;
	private String workPhone;
	private String cellPhone;
	private String email;
	private Integer age;
	private Long sid;
	
	public User(Long sid, String name, Integer age){
		this.sid = sid;
		this.name = name;
		this.age = age;
	}
	
	public Integer getAge() {
		return age;
	}
	public void setAge(Integer age) {
		this.age = age;
	}
	public Long getSid() {
		return sid;
	}
	public void setSid(Long sid) {
		this.sid = sid;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getWorkPhone() {
		return workPhone;
	}
	public void setWorkPhone(String workPhone) {
		this.workPhone = workPhone;
	}
	public String getCellPhone() {
		return cellPhone;
	}
	public void setCellPhone(String cellPhone) {
		this.cellPhone = cellPhone;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
}
