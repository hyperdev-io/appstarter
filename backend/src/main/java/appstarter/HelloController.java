package appstarter;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;

@RestController
public class HelloController {

    @RequestMapping("/api")
    public String index() {
        return "{\"greeting\": \"Greetings!\"}";
    }
}