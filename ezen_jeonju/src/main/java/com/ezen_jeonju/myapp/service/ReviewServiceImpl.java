package com.ezen_jeonju.myapp.service;

import java.util.ArrayList;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ezen_jeonju.myapp.domain.ReviewCriteria;
import com.ezen_jeonju.myapp.domain.ReviewListDTO;
import com.ezen_jeonju.myapp.domain.ReviewReportDTO;
import com.ezen_jeonju.myapp.domain.ReviewReportVo;
import com.ezen_jeonju.myapp.domain.ReviewVo;
import com.ezen_jeonju.myapp.persistance.ReviewService_Mapper;

@Service
public class ReviewServiceImpl implements ReviewService{
	
	public ReviewService_Mapper rsm;
	
	@Autowired
	public ReviewServiceImpl(SqlSession sqlSession) {
		this.rsm = sqlSession.getMapper(ReviewService_Mapper.class);
	}

	@Override
	public int reviewWrite(ReviewVo rv) {
		int value = rsm.reviewWrite(rv);
		return value;
	}

	@Override
	public ArrayList<ReviewListDTO> reviewList(ReviewCriteria rcri) {
		int value = (rcri.getPage()-1)*5;
		rcri.setPage(value);
		
		ArrayList<ReviewListDTO> list = rsm.reviewList(rcri);
		
		return list;
	}

	@Override
	public int reviewDel(int ridx) {
		int value = rsm.reviewDel(ridx);
		return value;
	}

	@Override
	public int reviewTotalCnt(int cidx) {
		int value = rsm.reviewTotalCnt(cidx);
		return value;
	}

	@Override
	public ReviewReportDTO reviewReport(int ridx) {
		ReviewReportDTO rrdto = new ReviewReportDTO();
		rrdto = rsm.reviewReport(ridx);
		return rrdto;
	}

	@Override
	public int reviewReportAction(ReviewReportVo rrv) {
		int value = rsm.reviewReportAction(rrv);
		System.out.println("rridx체크"+rrv.getRridx());
		rsm.insertNotification(rrv);
		return value;
	}

	@Override
	public int reviewReportCheck(ReviewReportVo rrv) {
		int value = rsm.reviewReportCheck(rrv);
		return value;
	}
	
	
	
}
