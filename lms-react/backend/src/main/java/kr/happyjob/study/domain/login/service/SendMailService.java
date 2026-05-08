package kr.happyjob.study.domain.login.service;

import javax.mail.MessagingException;

public interface SendMailService {
	public void sendEmail(String sendPerson,String subject, String htmlText) throws MessagingException;
	public void sendEmailAsync(String sendPerson,String subject, String htmlText);
	public String loadHTMLMailTemplate(String url);
}//end interface
