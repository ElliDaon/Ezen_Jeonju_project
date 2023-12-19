package com.ezen_jeonju.myapp.controller;

import java.util.ArrayList;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.ezen_jeonju.myapp.domain.NoticeVo;
import com.ezen_jeonju.myapp.service.NoticeService;
import com.ezen_jeonju.myapp.util.UploadFileUtiles;
import com.ezen_jeonju.myapp.domain.PageMaker;
import com.ezen_jeonju.myapp.domain.SearchCriteria;

@Controller
@RequestMapping(value = "/notice")
public class NoticeController {
	
	@Autowired
	NoticeService ns;
	
	@Autowired(required=false)
	private PageMaker pm;
	
	@Resource(name="uploadPath")
	String uploadPath;
	
	@RequestMapping(value = "/noticeWrite.do")
	public String noticeWrite() {
		return "notice/noticeWrite";
	}
	
	@RequestMapping(value = "/noticeWriteAction.do")
	public String noticeWriteAction(NoticeVo nv, HttpSession session) throws Exception{
		MultipartFile file = nv.getNoticeFileName();
		String uploadedFileName="";
		if(!file.getOriginalFilename().equals("")) {
			//업로드 시작
			uploadedFileName = UploadFileUtiles.uploadFile(uploadPath, file.getOriginalFilename(), file.getBytes());
		}
		System.out.println("uploadFileName: "+uploadedFileName);
		nv.setMidx(Integer.parseInt(session.getAttribute("midx").toString()));
		nv.setNoticeUploadedFileName(uploadedFileName);
		nv.setNoticeFilePath(uploadPath);
		
		ns.noticeWrite(nv);
		
		return "redirect:/notice/noticeList.do";
	}
	
	@RequestMapping(value = "/noticeList.do")
	public String noticeList(SearchCriteria scri, Model model, HttpSession session) {
		
		int totalCount = ns.noticeTotalCount(scri);
		pm.setScri(scri);
		pm.setTotalCount(totalCount);
		
		ArrayList<NoticeVo> nvlist = ns.noticeList(scri);
		model.addAttribute("nvlist",nvlist);
		model.addAttribute("pm", pm);
		
		// 검색어 입력 유지
		String keyword = (String)scri.getKeyword();
		if(keyword != null) {
			session.setAttribute("keyword", keyword);
		}
		
		// 카테고리 선택 유지
		String searchType = (String)scri.getSearchType();
		if(searchType != null) {
			session.setAttribute("searchType", searchType);
		}
		
		return "/notice/noticeList";
	}
	
	@RequestMapping(value = "/noticeContents.do")
	public String noticeContents(@RequestParam("nidx") int nidx, Model model) throws Exception {
		NoticeVo nv = ns.noticeContents(nidx);
		String hashtagList = nv.getNoticeHashtag();
		JSONParser parser = new JSONParser();
		JSONArray jsonArrayObj;
		jsonArrayObj = (JSONArray) parser.parse(hashtagList);
		
		model.addAttribute("nv", nv);
		model.addAttribute("hashtag", jsonArrayObj);
		return "/notice/noticeContents";
	}
	
	@RequestMapping(value="/noticeModify.do")
	public String noticeModify(@RequestParam("nidx") int nidx, Model model) throws Exception {		
		NoticeVo nv = ns.noticeContents(nidx);
		String hashtagList = nv.getNoticeHashtag();
		JSONParser parser = new JSONParser();
		JSONArray jsonArrayObj;
		jsonArrayObj = (JSONArray) parser.parse(hashtagList);
		
		model.addAttribute("nv", nv);
		model.addAttribute("hashtag", jsonArrayObj);
		return "/notice/noticeModify";
	}
	
	@RequestMapping(value="/noticeModifyAction.do")
	public String noticeModifyAction(NoticeVo nv) {		
		ns.noticeModify(nv);
		return "redirect:/notice/noticeContents.do?nidx="+nv.getNidx();
	}
	
	@RequestMapping(value="/noticeDeleteAction.do")
	public String noticeDeleteAction(@RequestParam("nidx") int nidx, @RequestParam("category") String category) {	
		ns.noticeDelete(nidx);
		return "redirect:/notice/noticeList.do";
		
	}	
}
