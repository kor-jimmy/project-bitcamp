package com.aeho.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class LoginController {

	@GetMapping("/loginCustom")
	public void login() {
		
	}
	
	@GetMapping("/loginError")
	public void loginError() {
		
	}
	
}
