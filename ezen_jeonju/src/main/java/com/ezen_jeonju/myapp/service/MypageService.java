package com.ezen_jeonju.myapp.service;

import java.util.ArrayList;

import com.ezen_jeonju.myapp.domain.MypageLikeCriteria;
import com.ezen_jeonju.myapp.domain.MypageReviewDTO;
import com.ezen_jeonju.myapp.domain.ReviewCriteria;
import com.ezen_jeonju.myapp.domain.ScheduleRootVo;

public interface MypageService {
	
	//mypage 리뷰리스트
	public ArrayList<MypageReviewDTO> reviewList(ReviewCriteria rcri);
	//mypage 리뷰삭제
	public int reviewDelete(int ridx);
	//mypage 리뷰 총 갯수
	public int reviewTotalCnt(int midx);
	//mypage 좋아요리스트
	public ArrayList<MypageLikeCriteria> likeList(MypageLikeCriteria mlcri);
	//mypage 좋아요 총 갯수
	public int likeTotalCnt(int midx);
	//mypage 좋아요 삭제
	public int likeDelete(int clidx);
	//mypage 여행일정 리스트
	public ArrayList<ScheduleRootVo> scheduleList(int midx); 
	//mypage 여행일정 총 갯수
	public int scheculeTotalCnt(int midx);
}
