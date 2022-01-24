package com.yunzoukj.yunzou.service.sms.controller;

import com.netflix.client.ClientException;
import com.yunzoukj.yunzou.common.base.result.R;
import com.yunzoukj.yunzou.common.base.result.ResultCodeEnum;
import com.yunzoukj.yunzou.common.base.util.FormUtils;
import com.yunzoukj.yunzou.common.base.util.RandomUtils;
import com.yunzoukj.yunzou.service.base.exception.GuliException;
import com.yunzoukj.yunzou.service.sms.service.SmsService;
import io.swagger.annotations.Api;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.concurrent.TimeUnit;

@RestController
@RequestMapping("/api/sms")
@Api(description = "短信管理")
//@CrossOrigin //跨域
@Slf4j
public class ApiSmsController {
  
    @Autowired
    private SmsService smsService;
  
    @Autowired
    private RedisTemplate redisTemplate;

    @GetMapping("send/{mobile}")
    public R getCode(@PathVariable String mobile) throws ClientException {
        //校验手机号是否合法
        if(StringUtils.isEmpty(mobile) || !FormUtils.isMobile(mobile)) {
            log.error("请输入正确的手机号码 ");
            throw new GuliException(ResultCodeEnum.LOGIN_PHONE_ERROR);
        }
        //生成验证码
        String checkCode = RandomUtils.getFourBitRandom();
        // 组装params参数的map
        HashMap<String, Object> map = new HashMap<>();
        map.put("code", checkCode);
        //发送验证码
        smsService.send(mobile, map);
        //将验证码存入redis缓存
        redisTemplate.opsForValue().set(mobile, checkCode, 5, TimeUnit.MINUTES); //5, TimeUnit.MINUTES)就是5分钟
        return R.ok().message("短信发送成功");
    }
}