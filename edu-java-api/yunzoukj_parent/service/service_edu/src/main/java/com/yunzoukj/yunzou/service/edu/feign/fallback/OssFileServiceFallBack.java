package com.yunzoukj.yunzou.service.edu.feign.fallback;

import com.yunzoukj.yunzou.common.base.result.R;
import com.yunzoukj.yunzou.service.edu.feign.OssFileService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class OssFileServiceFallBack implements OssFileService {
    @Override
    public R test() {
        log.info("熔断保护");
        return R.error();
    }

    @Override
    public R removeFile(String url) {
        log.info("熔断保护");
        return R.error();
    }
}
