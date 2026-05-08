package kr.happyjob.study.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;
import org.springframework.web.client.RestTemplate;

import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.concurrent.Executor;
import org.springframework.http.converter.HttpMessageConverter;

@Configuration
@EnableAsync
public class RestClientConfig {

    @Bean
    public RestTemplate restTemplate() {
        RestTemplate rt = new RestTemplate();
        // String 응답 UTF-8로 강제
        List<HttpMessageConverter<?>> list = rt.getMessageConverters();
        list.removeIf(c -> c instanceof StringHttpMessageConverter);
        list.add(0, new StringHttpMessageConverter(StandardCharsets.UTF_8));
        return rt;
    }

    @Bean(name = "mailTaskExecutor")
    public Executor mailTaskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(2);
        executor.setMaxPoolSize(5);
        executor.setQueueCapacity(50);
        executor.setThreadNamePrefix("mail-");
        executor.initialize();
        return executor;
    }
}   
