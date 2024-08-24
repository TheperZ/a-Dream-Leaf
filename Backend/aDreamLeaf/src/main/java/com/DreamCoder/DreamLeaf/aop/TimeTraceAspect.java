package com.DreamCoder.DreamLeaf.aop;

import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;
import org.springframework.util.StopWatch;

@Slf4j
@Component
@Aspect
public class TimeTraceAspect {


    @Pointcut("@annotation(com.DreamCoder.DreamLeaf.aop.TimeTrace))")
    private void timeTracePointCut() {

    }

    @Around("timeTracePointCut()")
    public Object traceTime(ProceedingJoinPoint joinPoint) throws Throwable {
        StopWatch stopWatch = new StopWatch();

        try {
            stopWatch.start();
            return joinPoint.proceed(); // 실제 타겟 호출
        } finally {
            stopWatch.stop();
            log.debug("{} - Total time = {}s",
                    joinPoint.getSignature().toShortString(),
                    stopWatch.getTotalTimeSeconds());
        }
    }

}
