package com.yunzoukj.yunzou.service.sms.service;

import com.cloopen.rest.sdk.BodyType;
import com.cloopen.rest.sdk.CCPRestSmsSDK;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.HashMap;
import java.util.Set;

/*
 * @author: toprhythm
 * @since: 2021/11/13 上午10:38
 */
@SpringBootTest
public class SendSmsTest {

    @Autowired
    private SmsService smsService;

    @Test
    public void sendSmsTest(){

        HashMap<String, Object> map = new HashMap<>();
        map.put("code", "6565");

        smsService.send("18974017944", map);

        /**测试成功，控制台打印：
         * SDKTestGetSubAccounts result={data={templateSMS={dateCreated=20211113114511, smsMessageSid=cf34a2b6bb8c4dd5890cdc3eb8a2641a}}, statusCode=000000}
         * templateSMS = {dateCreated=20211113114511, smsMessageSid=cf34a2b6bb8c4dd5890cdc3eb8a2641a}
         */

        // 注入并调用ioc对象执行do111方法成功
        //smsService.do111();

    }

    @Test
    void contextLoads() {

        //生产环境请求地址：app.cloopen.com
        String serverIp = "app.cloopen.com";
        //请求端口
        String serverPort = "8883";
        //主账号,登陆云通讯网站后,可在控制台首页看到开发者主账号ACCOUNT SID和主账号令牌AUTH TOKEN
        String accountSId = "8aaf07087ce03b67017d16f1fabf0bde";
        String accountToken = "8c922862617142d695ef0833610660f9";
        //请使用管理控制台中已创建应用的APPID
        String appId = "8aaf07087ce03b67017d16f1fbe00be4";
        CCPRestSmsSDK sdk = new CCPRestSmsSDK();
        sdk.init(serverIp, serverPort);
        sdk.setAccount(accountSId, accountToken);
        sdk.setAppId(appId);
        sdk.setBodyType(BodyType.Type_JSON);
        String to = "18974017944";
        String templateId= "1";
        //String[] datas = {"变量1(4位验证码)","变量2(请于x分钟内正确输入)","变量3"};
        String[] datas = {"9939","2","变量3"};
        String subAppend="1234";  //可选 扩展码，四位数字 0~9999
        String reqId="fadfafas";  //可选 第三方自定义消息id，最大支持32位英文数字，同账号下同一自然天内不允许重复
        //HashMap<String, Object> result = sdk.sendTemplateSMS(to,templateId,datas);
        HashMap<String, Object> result = sdk.sendTemplateSMS(to,templateId,datas,subAppend,reqId);
        if("000000".equals(result.get("statusCode"))){
            //正常返回输出data包体信息（map）
            HashMap<String,Object> data = (HashMap<String, Object>) result.get("data");
            Set<String> keySet = data.keySet();
            for(String key:keySet){
                Object object = data.get(key);
                System.out.println(key +" = "+object);
            }
        }else{
            //异常返回输出错误码和错误信息
            System.out.println("错误码=" + result.get("statusCode") +" 错误信息= "+result.get("statusMsg"));
        }

    }

}
