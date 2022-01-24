/*
 * @project_name: yunzoukj_parent
 * @clazz_name: CommonMetaObjectHandler.java
 * @description: TODO
 * @coder: github@toprhythm
 * @since: 2021/10/17 上午7:08
 * @version: 1.0.0
 */
package com.yunzoukj.yunzou.service.base.handler;

import com.baomidou.mybatisplus.core.handlers.MetaObjectHandler;
import org.apache.ibatis.reflection.MetaObject;
import org.springframework.stereotype.Component;

import java.util.Date;

@Component
public class CommonMetaObjectHandler implements MetaObjectHandler {

    @Override
    public void insertFill(MetaObject metaObject) {
        this.setFieldValByName("gmtCreate", new Date(), metaObject);
        this.setFieldValByName("gmtModified", new Date(), metaObject);
    }
    @Override
    public void updateFill(MetaObject metaObject) {
        this.setFieldValByName("gmtModified", new Date(), metaObject);
    }
}
