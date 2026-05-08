package kr.happyjob.study.domain.login.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.security.SecureRandom;

@Service
public class MailSendServiceImpl implements MailSendService {

	private static final SecureRandom RANDOM = new SecureRandom();
	private static final int AUTH_CODE_LENGTH = 6;

	@Autowired
	private SendMailService sendMailService;

	@Override
	public void sendEmail(String emailNum, String authNumId) throws Exception {
		String htmlText = buildAuthMailText(authNumId);
		sendMailService.sendEmail(emailNum, "HappyJob LMS 인증번호 안내", htmlText);
	}

	@Override
	public void sendEmailAsync(String emailNum, String authNumId) throws Exception {
		String htmlText = buildAuthMailText(authNumId);
		sendMailService.sendEmailAsync(emailNum, "HappyJob LMS 인증번호 안내", htmlText);
	}

	private String buildAuthMailText(String authNumId) {
		String htmlTemplate = sendMailService.loadHTMLMailTemplate("mailTemplate/authCode.html");

		if (htmlTemplate == null || htmlTemplate.trim().isEmpty()) {
			htmlTemplate =
					"<html><body><p>안녕하세요, HappyJob LMS입니다.</p>"
					+ "<p>인증번호는 <strong>{{AUTH_CODE}}</strong> 입니다.</p>"
					+ "<p>5분 이내에 입력해주세요.</p></body></html>";
		}

		return htmlTemplate.replace("{{AUTH_CODE}}", authNumId);
	}

	@Override
	public String RandomNum() {
		StringBuilder buffer = new StringBuilder(AUTH_CODE_LENGTH);

		for (int i = 0; i < AUTH_CODE_LENGTH; i++) {
			buffer.append(RANDOM.nextInt(10));
		}

		return buffer.toString();
	}
}
