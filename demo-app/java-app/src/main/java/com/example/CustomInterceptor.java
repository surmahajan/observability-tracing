package com.example;

import io.opentracing.SpanContext;
import io.opentracing.Tracer;
import io.opentracing.propagation.TextMapExtractAdapter;
import io.opentracing.tag.Tags;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static io.opentracing.propagation.Format.Builtin.HTTP_HEADERS;

/**
 * @author lican
 * @date 2018/4/11
 */
@Component
public class CustomInterceptor extends HandlerInterceptorAdapter {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        Map<String, String> stringStringMap = new HashMap<String, String>();

        List<String> headers = Collections.list(request.getHeaderNames());
        headers.forEach(header -> {
            stringStringMap.put(header, request.getHeader(header));
        });

        Tracer.SpanBuilder spanBuilder = JaegerDemoAApplication.tracer.buildSpan(request.getRequestURI())
                .withTag(Tags.SPAN_KIND.getKey(), Tags.SPAN_KIND_SERVER);
//        if (request.getHeader("x-request-id") != null) {
            SpanContext extract = JaegerDemoAApplication.tracer.extract(HTTP_HEADERS, new TextMapExtractAdapter(stringStringMap));
            spanBuilder = spanBuilder.asChildOf(extract);
//        }
        spanBuilder.startActive(true);
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        super.postHandle(request, response, handler, modelAndView);
        JaegerDemoAApplication.tracer.scopeManager().active().close();
    }
}
