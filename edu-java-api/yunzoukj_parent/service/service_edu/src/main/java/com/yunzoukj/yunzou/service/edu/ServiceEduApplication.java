package com.yunzoukj.yunzou.service.edu;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan({"com.yunzoukj.yunzou"})// 扩大扫描范围 yunzou.servive.*.*.java
@EnableDiscoveryClient
@EnableFeignClients
public class ServiceEduApplication {
  
    public static void main(String[] args) {
        SpringApplication.run(ServiceEduApplication.class, args);
    }
  
}