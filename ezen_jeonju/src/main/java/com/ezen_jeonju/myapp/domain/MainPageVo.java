package com.ezen_jeonju.myapp.domain;

public class MainPageVo extends AttachFileVo{
	private int mpidx;
	private int midx;
	private int aidx;
	private int mainPageSequence;
	private String mainPageSubject;
	private String mainPageLink;
	private String mainWriteday;
	private String mainPageYN;
	
	
	
	public int getAidx() {
		return aidx;
	}
	public void setAidx(int aidx) {
		this.aidx = aidx;
	}
	public String getMainPageYN() {
		return mainPageYN;
	}
	public void setMainPageYN(String mainPageYN) {
		this.mainPageYN = mainPageYN;
	}
	
	public int getMpidx() {
		return mpidx;
	}
	public void setMpidx(int mpidx) {
		this.mpidx = mpidx;
	}
	public int getMidx() {
		return midx;
	}
	public void setMidx(int midx) {
		this.midx = midx;
	}
	public int getMainPageSequence() {
		return mainPageSequence;
	}
	public void setMainPageSequence(int mainPageSequence) {
		this.mainPageSequence = mainPageSequence;
	}
	public String getMainPageSubject() {
		return mainPageSubject;
	}
	public void setMainPageSubject(String mainPageSubject) {
		this.mainPageSubject = mainPageSubject;
	}
	public String getMainPageLink() {
		return mainPageLink;
	}
	public void setMainPageLink(String mainPageLink) {
		this.mainPageLink = mainPageLink;
	}
	public String getMainWriteday() {
		return mainWriteday;
	}
	public void setMainWriteday(String mainWriteday) {
		this.mainWriteday = mainWriteday;
	}
	public int getSidx() {
		return aidx;
	}
	public void setSidx(int sidx) {
		this.aidx = sidx;
	}
}
