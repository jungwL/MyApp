// 로컬 8080호스트에 flutter가 접근이 안돼 강제로 flutter 로컬 주소를 할당
package org.example.startapi.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.*;

@Configuration
public class WebConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**") //
                .allowedOrigins("http://localhost:60410/") // Flutter Web 디버깅 주소 (크롬에서 실행한 주소)
                .allowedMethods("GET", "POST", "PUT", "DELETE") // CRUD 요청 모두허용
                .allowedHeaders("*") //모든 HTTP Header 허용
                .allowCredentials(false); //쿠키, 세션정보 허용 여부
    }
}
