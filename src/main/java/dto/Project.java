package dto;

import java.sql.Date;

public class Project {

	private int p_idx; //프로젝트 고유 번호 (pk)
	private String m_id; //해당 프로젝트의 창작자 아이디(member의 fk)
	private String p_title; //프로젝트 이름
	private String p_content; //프로젝트 내용
	private String p_filename; //프로젝트 썸네일 이미지 파일명
	private int p_target; //목표 금액
	private int p_current; //현재 금액
	private String p_end; //펀딩 마감일
	private Date p_upload_date; //등록일
	private String category;
	
	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	private int p_percent; //달성률

	public int getP_idx() {
		return p_idx;
	}

	public void setP_idx(int p_idx) {
		this.p_idx = p_idx;
	}

	public String getM_id() {
		return m_id;
	}

	public void setM_id(String m_id) {
		this.m_id = m_id;
	}

	public String getP_title() {
		return p_title;
	}

	public void setP_title(String p_title) {
		this.p_title = p_title;
	}

	public String getP_content() {
		return p_content;
	}

	public void setP_content(String p_content) {
		this.p_content = p_content;
	}

	public String getP_filename() {
		return p_filename;
	}

	public void setP_filename(String p_filename) {
		this.p_filename = p_filename;
	}

	public int getP_target() {
		return p_target;
	}

	public void setP_target(int p_target) {
		this.p_target = p_target;
	}

	public int getP_current() {
		return p_current;
	}

	public void setP_current(int p_current) {
		this.p_current = p_current;
	}

	public String getP_end() {
		return p_end;
	}

	public void setP_end(String p_end) {
		this.p_end = p_end;
	}

	public Date getP_upload_date() {
		return p_upload_date;
	}

	public void setP_upload_date(Date p_upload_date) {
		this.p_upload_date = p_upload_date;
	}

	public int getP_percent() {
		return p_percent;
	}

	public void setP_percent(int p_percent) {
		this.p_percent = p_percent;
	}
	
	public Project(String p_title,int p_target) {
		this.p_title =p_title;
		this.p_target =p_target;
	}

	public int getPercent() {
		if(this.p_target == 0 )return 0;
		return (int) (((double) this.p_current/this.p_target)*100);
	}
	
}
