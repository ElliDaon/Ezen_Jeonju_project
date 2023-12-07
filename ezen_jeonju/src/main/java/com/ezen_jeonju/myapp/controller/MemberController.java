package com.ezen_jeonju.myapp.controller;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;



@Controller
@RequestMapping(value = "/member")
public class MemberController {
	

	@RequestMapping(value = "/memberLogin.do", method = RequestMethod.GET)
	public String memberLogin() {

		
		return "member/memberLogin";
	}
	
}

