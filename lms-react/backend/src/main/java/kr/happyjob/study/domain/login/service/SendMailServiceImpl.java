package kr.happyjob.study.domain.login.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.core.io.ClassPathResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.apache.log4j.LogManager;
import org.apache.log4j.Logger;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import java.nio.file.Files;
import java.util.concurrent.Executor;

@Service
public class SendMailServiceImpl implements SendMailService {
	private final Logger logger = LogManager.getLogger(this.getClass());

	@Autowired
	private JavaMailSender mailSender;

	@Autowired
	@Qualifier("mailTaskExecutor")
	private Executor mailTaskExecutor;
	/**
	 * 이메일 보내기
	 * @param sendPerson 보낼 사람
	 * @param subject 제목
	 * @param htmlText 보낼 html 문서
	 * @throws MessagingException
	 */
	public void sendEmail(String sendPerson,String subject, String htmlText) throws MessagingException {
		MimeMessage message=mailSender.createMimeMessage();
		MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

		helper.setTo(sendPerson);
		helper.setSubject(subject);
		helper.setText(htmlText, true);

		mailSender.send(message);

	}//end sendEmail

	@Override
	public void sendEmailAsync(String sendPerson, String subject, String htmlText) {
		mailTaskExecutor.execute(() -> {
			try {
				logger.info("메일 발송 시작: " + sendPerson);
				sendEmail(sendPerson, subject, htmlText);
				logger.info("메일 발송 성공: " + sendPerson);
			} catch (Exception e) {
				logger.error("메일 발송 실패: " + sendPerson, e);
			}
		});
	}



	/**
	 * url을 넣으면, 해당 파일의 html을 가져온다.
	 * @param url
	 * @return htmlStr
	 * @throws Exception
	 */
	public String loadHTMLMailTemplate(String url){
		ClassPathResource resource = new ClassPathResource(url);
		String loadHTMLstr="";

		try{
			loadHTMLstr=new String(Files.readAllBytes(resource.getFile().toPath()),"UTF-8");
		}catch(Exception e){
			e.printStackTrace();
		}//end try~catch

		return loadHTMLstr;
	}//end loadHTMLTemplate
}//end class
