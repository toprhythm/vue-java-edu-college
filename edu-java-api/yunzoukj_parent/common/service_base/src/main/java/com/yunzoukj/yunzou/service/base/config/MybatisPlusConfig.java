/*
 * @project_name: yunzoukj_parent
 * @clazz_name: MybatisPlusConfig.java
 * @description: TODO
 * @coder: github@toprhythm
 * @since: 2021/10/13 下午6:36
 * @version: 1.0.0
 */
package com.yunzoukj.yunzou.service.base.config;

import com.baomidou.mybatisplus.extension.plugins.PaginationInterceptor;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@EnableTransactionManagement
@Configuration
@MapperScan("com.yunzoukj.yunzou.service.*.mapper")
public class MybatisPlusConfig {

    /**
     * 分页插件
     */
    @Bean
    public PaginationInterceptor paginationInterceptor() {
        return new PaginationInterceptor();
    }

}