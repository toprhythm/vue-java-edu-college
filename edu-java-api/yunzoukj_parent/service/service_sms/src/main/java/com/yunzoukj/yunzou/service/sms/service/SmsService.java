package com.yunzoukj.yunzou.service.sms.service;

import java.util.Map;

/*
 * @author: toprhythm
 * @since: 2021/11/13 上午10:35
 */
public interface SmsService {
    void send(String mobile , Map<String,Object> param);

    void do111();
}
