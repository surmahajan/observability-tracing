package com.example;

import io.jaegertracing.Tracer;
import io.jaegertracing.reporters.RemoteReporter;
import io.jaegertracing.samplers.ConstSampler;
import io.jaegertracing.senders.UdpSender;
import io.opentracing.SpanContext;
import io.opentracing.propagation.TextMapInjectAdapter;
import io.opentracing.tag.Tags;
import io.opentracing.util.AutoFinishScope;
import io.opentracing.util.AutoFinishScopeManager;
import okhttp3.OkHttpClient;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.http.ResponseEntity;
import org.springframework.util.concurrent.ListenableFuture;
import org.springframework.util.concurrent.ListenableFutureCallback;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.AsyncRestTemplate;
import org.springframework.web.client.RestTemplate;

import javax.annotation.PostConstruct;
import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;

import static io.opentracing.propagation.Format.Builtin.HTTP_HEADERS;

/**
 * @author lican
 */
@RestController
@RequestMapping("a")
@SpringBootApplication
public class JaegerDemoAApplication {

    public static Tracer tracer;

    public static Tracer mockMysqlTracer;

    public static Tracer trialTracer;

    private static final String AGENT_HOST = System.getenv("JAEGER_AGENT_HOST");

    public static OkHttpClient client = new OkHttpClient();

    @Bean
    public RestTemplate getRestTemplate() {
        return new RestTemplate();
    }

    @PostConstruct
    public void init() {
        tracer = new Tracer.Builder("jaeger-demo-a")
                .withReporter(new RemoteReporter.Builder()
                        .withSender(new UdpSender(AGENT_HOST, 6831, 0))
                        .build())
                .withSampler(new ConstSampler(true))
                .withScopeManager(new AutoFinishScopeManager())
                .build();
        trialTracer = new Tracer.Builder("jaeger-trial")
                .withReporter(new RemoteReporter.Builder()
                        .withSender(new UdpSender(AGENT_HOST, 6831, 0))
                        .build())
                .withSampler(new ConstSampler(true))
                .build();
    }

    public static void main(String[] args) {
        SpringApplication.run(JaegerDemoAApplication.class, args);
    }

    @GetMapping("hello")
    public Object hello() throws IOException, InterruptedException {
        HashMap<String, String> map = new HashMap<>();

        SpanContext context = tracer.activeSpan().context();
        tracer.inject(context, HTTP_HEADERS, new TextMapInjectAdapter(map));
//        tracer.buildSpan("okhttp").asChildOf(tracer.activeSpan())
//                .startActive(true);
//        for (Map.Entry<String, String> entry : map.entrySet()) {
//            builder.header(entry.getKey(), entry.getValue());
//        }
//        Request request = builder.build();
//        try (Response response = client.newCall(request).execute()) {
//        } finally {
//            tracer.scopeManager().active().close();
//        }

        trialTracer.buildSpan("trial-span")
                .asChildOf(tracer.activeSpan())
                .withTag(Tags.DB_TYPE.getKey(), "trial")
                .startActive(true);
        trialTracer.scopeManager().active().close();
        return Collections.singletonMap("hello", "a");
    }

    @GetMapping("rt")
    public Object restTemplate() {
        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<String> forEntity = restTemplate.getForEntity("https://www.baidu.com", String.class);
        return forEntity.getBody();
    }

}
