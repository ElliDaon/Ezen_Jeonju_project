package com.ezen_jeonju.myapp.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ezen_jeonju.myapp.domain.PageMaker;
import com.ezen_jeonju.myapp.domain.ScheduleCriteria;
import com.ezen_jeonju.myapp.domain.ScheduleRootVo;
import com.ezen_jeonju.myapp.domain.TourCourseVo;
import com.ezen_jeonju.myapp.service.ScheduleService;

@Controller
@RequestMapping(value = "/schedule")
public class ScheduleController {
	
	@Autowired
	ScheduleService ss;
	
	//Controller에서 script했을시 문자깨지는거 방지 메소드
	private String escapeJavaScript(String input) {
	    StringBuilder result = new StringBuilder();
	    for (char c : input.toCharArray()) {
	        if (c <= 0x7F) {
	            result.append(c);
	        } else {
	            result.append(String.format("\\u%04x", (int) c));
	        }
	    }
	    return result.toString();
	}
	
	@RequestMapping(value = "/scheduleWrite.do")
	public String scheduleWrite(HttpServletResponse response,HttpServletRequest request) throws IOException {
		HttpSession session = request.getSession();
		PrintWriter out = response.getWriter();
		if (session.getAttribute("midx") == null) {
	        String contextPath = request.getContextPath();
	        String alertMessage = "로그인 이후 이용바랍니다.";
	        String alertScript = "alert('" + escapeJavaScript(alertMessage) + "');location.href='" + contextPath + "/member/memberLogin.do';";
	        out.println("<script>" + alertScript + "</script>");
	        return null;
	    }
	    
	    return "schedule/scheduleWrite";
	}
	
	@RequestMapping(value="/searchMapPopup.do")
	public String searchMamPopup() {
		
		return "schedule/searchMapPopup";
	}
	
	@RequestMapping(value = "/scheduleWriteAction.do")
	public String scheduleWriteAction(ScheduleRootVo sv ,HttpSession session,
			@RequestParam("Array") String rootValue,
			@RequestParam("scheduleSubject") String scheduleSubject,
			@RequestParam("scheduleStartDate") String scheduleStartDate,
			@RequestParam("scheduleEndDate") String scheduleEndDate,
			@RequestParam("scheduleShareYN") String scheduleShareYN
			) 
	{
		sv.setMidx(((Integer)session.getAttribute("midx")).intValue());
		sv.setScheduleEndDate(scheduleEndDate);
		sv.setScheduleStartDate(scheduleStartDate);
		sv.setScheduleShareYN(scheduleShareYN);
		sv.setScheduleSubject(scheduleSubject);
		
		JSONParser parser = new JSONParser();
		
		JSONArray jsonArray = null;
	    try {
			jsonArray = (JSONArray) parser.parse(rootValue);
		} catch (ParseException e) {
			e.printStackTrace();
		}
	    ArrayList<TourCourseVo> list = new ArrayList<>();

	    for(int i=0; i<jsonArray.size(); i++){
			JSONObject insertData = (JSONObject) jsonArray.get(i);
			TourCourseVo tv = new TourCourseVo();
			String tourCourseDate = (String)insertData.get("tourCourseDate");
			String tourCourseTime = (String)insertData.get("tourCourseTime");
			String tourCoursePlace = (String)insertData.get("tourCoursePlace");
			String tourCourseLatitude = (String)insertData.get("tourCourseLatitude");
			String tourCourseLongitude = (String)insertData.get("tourCourseLongitude");
			String tourCourseNDate = (String)insertData.get("tourCourseNDate");
			
			tv.setTourCourseDate(tourCourseDate);
			tv.setTourCourseTime(tourCourseTime);
			tv.setTourCoursePlace(tourCoursePlace);
			tv.setTourCourseLatitude(tourCourseLatitude);
			tv.setTourCourseLongitude(tourCourseLongitude);
			tv.setTourCourseNDate(tourCourseNDate);
			
			list.add(tv);
	    }

		ss.scheduleWrite(sv,list);
		
		return "redirect:/schedule/scheduleList.do";
	}

	
	@RequestMapping(value = "/scheduleList.do")
	public String scheduleList(ScheduleCriteria sscri, Model model) {
		
		int totalCount = ss.scheduleTotalCount();
		PageMaker pm = new PageMaker();
		pm.setSscri(sscri);
		pm.setTotalCount(totalCount);
		ArrayList<ScheduleRootVo> list = ss.scheduleList(sscri);
		
		model.addAttribute("list",list);
		model.addAttribute("pm", pm);
		return "schedule/scheduleList";
	}
    @RequestMapping(value="/scheduleContents.do")
    public String boardContents(@RequestParam("sidx") int sidx, Model model,HttpServletResponse response) throws IOException{
    	ScheduleRootVo sv = ss.scheduleContents(sidx);
    	ArrayList<TourCourseVo> tlist = ss.tourCourseNDate(sidx);
    	
    	model.addAttribute("tlist",tlist);
    	model.addAttribute("sv",sv);
    	model.addAttribute("sidx", sidx);
    	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");	
    	
      	String scheduleStartDate = "";
    	String scheduleEndDate = "";
    	scheduleStartDate = sv.getScheduleStartDate();
    	scheduleEndDate = sv.getScheduleEndDate();
    	
    	LocalDate startDate = LocalDate.parse(scheduleStartDate, formatter);
    	LocalDate endDate = LocalDate.parse(scheduleEndDate, formatter);

    	long differenceInDays = endDate.toEpochDay() - startDate.toEpochDay() +1;
    	int totalCnt = (int) differenceInDays;
    	
    	ArrayList<LocalDate> dateList = new ArrayList<>();

    	for (LocalDate currentDate = startDate; !currentDate.isAfter(endDate); currentDate = currentDate.plusDays(1)) {
    	    dateList.add(currentDate);
    	}
    	model.addAttribute("dateList",dateList);
    	
    	
    	return "/schedule/scheduleContents";
    	
    }
    
    @ResponseBody
    @RequestMapping(value="/getTourCourse.do")
    public JSONArray getTourCourse(@RequestParam("sidx") int sidx) {
    	ArrayList<TourCourseVo> tlist = ss.tourCourseContents(sidx);
    	JSONArray array = new JSONArray();

    	for(int i=0; i<tlist.size(); i++) {
    		JSONObject alist = new JSONObject();
    		alist.put("tourCourseDate", tlist.get(i).getTourCourseDate());
    		alist.put("tourCourseTime", tlist.get(i).getTourCourseTime());
    		alist.put("tourCoursePlace", tlist.get(i).getTourCoursePlace());
    		alist.put("tourCourseLongitude",tlist.get(i).getTourCourseLongitude());
    		alist.put("tourCourseLatitude",tlist.get(i).getTourCourseLatitude());
    		alist.put("tourCourseNDate",tlist.get(i).getTourCourseNDate());
    				
    		array.add(alist);
    	}
        JSONObject result = new JSONObject();
        result.put("tourCourses", array);
    	return array;
    }
	
    @ResponseBody
    @RequestMapping(value="/getTourCourseNDate.do")
    public JSONArray getTourCourseNDate(TourCourseVo tv) {
    	
    	ArrayList<TourCourseVo> tlist = ss.tourCourseNDateContents(tv);
    	
    	JSONArray array = new JSONArray();

    	for(int i=0; i<tlist.size(); i++) {
    		JSONObject alist = new JSONObject();
    		alist.put("tourCourseDate", tlist.get(i).getTourCourseDate());
    		alist.put("tourCourseTime", tlist.get(i).getTourCourseTime());
    		alist.put("tourCoursePlace", tlist.get(i).getTourCoursePlace());
    		alist.put("tourCourseLongitude",tlist.get(i).getTourCourseLongitude());
    		alist.put("tourCourseLatitude",tlist.get(i).getTourCourseLatitude());
    		alist.put("tourCourseNDate",tlist.get(i).getTourCourseNDate());
    				
    		array.add(alist);
    	}
        JSONObject result = new JSONObject();
        result.put("tourCourses", array);
    	return array;
    }
	@RequestMapping(value = "/scheduleDelete.do")
	public String scheduleDelete(@RequestParam("sidx") int sidx,HttpServletResponse response,HttpServletRequest request) throws IOException {
		
		HttpSession session = request.getSession();
		PrintWriter out = response.getWriter();
		int value = ss.scheduleDelete(sidx);
		ScheduleRootVo sv = ss.scheduleContents(sidx);
		
		if(value == 1) {
			return "redirect:/schedule/scheduleList.do";
		}
	
		return "";
	}

}