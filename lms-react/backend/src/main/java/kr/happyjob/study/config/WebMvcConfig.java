package kr.happyjob.study.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

@Configuration
public class WebMvcConfig extends WebMvcConfigurerAdapter {

    @Value("${fileUpload.rootPath}")
    private String cPath; // C:/FileRepository/

    @Value("${win.file.upload.path}")
    private String winZPath; // file:///Z:/LMSProject/

    @Value("${mac.file.upload.path}")
    private String macPath; // file:/Volumes/sharefolder/LMSProject/

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 현재 실행 중인 OS 확인
        String os = System.getProperty("os.name").toLowerCase();

        if (os.contains("win")) {
            // 1. 윈도우인 경우: C드라이브와 Z드라이브 동시 연결
            // /serverfile/** 요청 -> C:/FileRepository/ 연결
            registry.addResourceHandler("/serverfile/**")
                    .addResourceLocations("file:///" + cPath);

            // /lms/** 요청 -> Z:/LMSProject/ 연결
            registry.addResourceHandler("/lms/**")
                    .addResourceLocations(winZPath);
        } else {
            // 2. 맥북인 경우: 마운트된 네트워크 폴더 연결
            // 맥북 사용자는 /lms/** 요청 시 설정된 볼륨 경로를 바라봅니다.
            registry.addResourceHandler("/lms/**")
                    .addResourceLocations(macPath);

            // (참고) 맥북은 C드라이브가 없으므로 필요 시 맥용 로컬 경로를 추가 설정할 수 있습니다.
        }
    }
}