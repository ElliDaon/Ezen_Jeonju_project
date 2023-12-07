package com.ezen_jeonju.myapp.domain;

public class MemberVo {
	private int midx;
	private String memberId;
	private String memberPwd;
	private String memberName;
	private String memberPhone;
	private String memberGrade;
	private String memberSigninDate;
	
	public int getMidx() {
		return midx;
	}
	public void setMidx(int midx) {
		this.midx = midx;
	}
	public String getMemberId() {
		return memberId;
	}
	public void setMemberId(String memberId) {
		this.memberId = memberId;
	}
	public String getMemberPwd() {
		return memberPwd;
	}
	public void setMemberPwd(String memberPwd) {
		this.memberPwd = memberPwd;
	}
	public String getMemberName() {
		return memberName;
	}
	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}
	public String getMemberPhone() {
		return memberPhone;
	}
	public void setMemberPhone(String memberPhone) {
		this.memberPhone = memberPhone;
	}
	public String getMemberGrade() {
		return memberGrade;
	}
	public void setMemberGrade(String memberGrade) {
		this.memberGrade = memberGrade;
	}
	public String getMemberSigninDate() {
		return memberSigninDate;
	}
	public void setMemberSigninDate(String memberSigninDate) {
		this.memberSigninDate = memberSigninDate;
	}
}
