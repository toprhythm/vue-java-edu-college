package com.yunzoukj.yunzou.service.statistics.feign.fallback;

import com.yunzoukj.yunzou.common.base.result.R;
import com.yunzoukj.yunzou.service.statistics.feign.UcenterMemberService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class UcenterMemberServiceFallBack implements UcenterMemberService {
    @Override
    public R countRegisterNum(String day) {
        //错误日志
        log.error("熔断器被执行");
        return R.ok().data("registerNum", 0);
    }
}