package com.ezen_jeonju.myapp.controller;

import java.util.ArrayList;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.ezen_jeonju.myapp.domain.ContentsVo;
import com.ezen_jeonju.myapp.service.ContentsService;
import com.ezen_jeonju.myapp.util.UploadFileUtiles;

@Controller
@RequestMapping(value = "/contents")
public class ContentsController {
	
	@Autowired
	ContentsService cs;
	
	/*
	 * @Resource(name="uploadPath") String uploadPath;
	 */
	@RequestMapping(value = "/contentsWrite.do")
	public String contentsWrite() {

		
		return "contents/contentsWrite";
	}
	
	@RequestMapping(value = "/contentsWriteAction.do")
	public String contentsWriteAction(ContentsVo cv, HttpSession session) throws Exception{
	//	MultipartFile file = cv.getNoticeFileName();
	//	String uploadedFileName="";
	//	if(!file.getOriginalFilename().equals("")) {
			//업로드 시작
	//		uploadedFileName = UploadFileUtiles.uploadFile(uploadPath, file.getOriginalFilename(), file.getBytes());
	//	}
	//	System.out.println("uploadFileName: "+uploadedFileName);
		cv.setMidx(Integer.parseInt(session.getAttribute("midx").toString()));
	//	cv.setNoticeUploadedFileName(uploadedFileName);
	//	cv.setNoticeFilePath(uploadPath);
		
		cs.contentsWrite(cv);
		
		return "redirect:/index.jsp";
	}
	
	@RequestMapping(value = "/sightsList.do")
	public String sightsList(Model model) {
		ArrayList<ContentsVo> cvlist = cs.sightsList();
		model.addAttribute("cvlist",cvlist);
		return "/contents/sigthsList";
	}
	
	@RequestMapping(value = "/foodList.do")
	public String foodList(Model model) {
		ArrayList<ContentsVo> cvlist = cs.foodList();
		model.addAttribute("cvlist",cvlist);
		return "/contents/foodList";
	}
	
	@RequestMapping(value = "/contentsArticle.do")
	public String contentsArticle(@RequestParam("cidx") String cidx, Model model) {
		int cidx_i = Integer.parseInt(cidx);
		ContentsVo cv = cs.contentsArticle(cidx_i);
		model.addAttribute("cv", cv);
		return "/contents/contentsArticle";
	}
}