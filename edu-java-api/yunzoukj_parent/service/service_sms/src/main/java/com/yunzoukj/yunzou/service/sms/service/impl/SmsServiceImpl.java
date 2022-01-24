package com.yunzoukj.yunzou.service.sms.service.impl;

import com.cloopen.rest.sdk.BodyType;
import com.cloopen.rest.sdk.CCPRestSmsSDK;
import com.yunzoukj.yunzou.service.sms.service.SmsService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

/*
 * @author: toprhythm
 * @since: 2021/11/13 上午10:36
 */
@Service
@Slf4j
public class SmsServiceImpl  implements SmsService {
    @Value(value = "${rckj.accountSId}")
    private String ACCOUNTS_ID;
    @Value(value = "${rckj.accountToken}")
    private String ACCOUNTTOKEN;
    @Value(value = "${rckj.appId}")
    private String APPID;
    @Value(value = "${rckj.serverIp}")
    private String serverIp;
    @Value(value = "${rckj.serverPort}")
    private String serverPort;

    @Override
    public void send(String mobile,Map<String,Object> params) {

        CCPRestSmsSDK ccpRestSmsSDK=new CCPRestSmsSDK();
        ccpRestSmsSDK.setAccount(ACCOUNTS_ID,ACCOUNTTOKEN);
        ccpRestSmsSDK.setAppId(APPID);
        ccpRestSmsSDK.setBodyType(BodyType.Type_JSON);
        ccpRestSmsSDK.init(serverIp,serverPort);
        String[] datas={(String) params.get("code"),"2"};
        HashMap<String, Object> result = ccpRestSmsSDK.sendTemplateSMS(mobile, "1", datas);
        System.out.println("SDKTestGetSubAccounts result=" + result);
        if("000000".equals(result.get("statusCode"))){
            //正常返回输出data包体信息（map）
            HashMap<String,Object> data = (HashMap<String, Object>) result.get("data");
            Set<String> keySet = data.keySet();
            for(String key:keySet){
                Object object = data.get(key);
                System.out.println(key +" = "+object);
                log.error(key +" = "+object);
            }
        }else{
            //异常返回输出错误码和错误信息
            System.out.println("错误码=" + result.get("statusCode") +" 错误信息= "+result.get("statusMsg"));
            log.error("错误码=" + result.get("statusCode") +" 错误信息= "+result.get("statusMsg"));
        }
    }

    @Override
    public void do111() {
        System.out.println("do111");
        log.error("error: do111");
    }
}
