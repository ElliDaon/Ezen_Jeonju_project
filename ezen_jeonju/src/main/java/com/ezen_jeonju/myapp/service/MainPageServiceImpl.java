package com.ezen_jeonju.myapp.service;

import java.util.ArrayList;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ezen_jeonju.myapp.domain.ContentsVo;
import com.ezen_jeonju.myapp.domain.MainPageVo;
import com.ezen_jeonju.myapp.domain.NoticeVo;
import com.ezen_jeonju.myapp.persistance.AttachFileService_Mapper;
import com.ezen_jeonju.myapp.persistance.MainPageService_Mapper;

@Service
public class MainPageServiceImpl implements MainPageService{
	
	public MainPageService_Mapper mpsm;
	public AttachFileService_Mapper asm;
	
	@Autowired
	public MainPageServiceImpl(SqlSession sqlSession) {
		this.mpsm = sqlSession.getMapper(MainPageService_Mapper.class);
	}
	
	
	@Override
	public int mainPageVannerRegister(MainPageVo mpv) {
		int value=mpsm.mainPageVannerRegister(mpv);
		return value;
	}


	@Override
	public ArrayList<MainPageVo> mainPageVannerView() {
		ArrayList<MainPageVo> mpv = mpsm.mainPageVannerView();
		return mpv;
	}


	@Override
	public ArrayList<ContentsVo> mainPageSecondView() {
		ArrayList<ContentsVo> cv = mpsm.mainPageSecondView();
		return cv;
	}

	@Override
	public ArrayList<ContentsVo> mainPageThirdView() {
		ArrayList<ContentsVo> cvtop3 = mpsm.mainPageThirdView();
		return cvtop3;
	}

	@Override
	public ArrayList<NoticeVo> mainPageNoticeView() {
		ArrayList<NoticeVo> nv = mpsm.mainPageNoticeView();
		return nv;
	}






}
