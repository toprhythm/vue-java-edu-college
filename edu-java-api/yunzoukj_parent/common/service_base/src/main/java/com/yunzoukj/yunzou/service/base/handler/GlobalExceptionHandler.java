/*
 * @project_name: yunzoukj_parent
 * @clazz_name: GlobalExceptionHandler.java
 * @description: TODO
 * @coder: github@toprhythm
 * @since: 2021/10/17 上午7:23
 * @version: 1.0.0
 */
package com.yunzoukj.yunzou.service.base.handler;

import com.yunzoukj.yunzou.common.base.exception.ExceptionUtils;
import com.yunzoukj.yunzou.common.base.result.R;
import com.yunzoukj.yunzou.common.base.result.ResultCodeEnum;
import com.yunzoukj.yunzou.service.base.exception.GuliException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.jdbc.BadSqlGrammarException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

@Slf4j
@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(Exception.class)
    @ResponseBody
    public R error(Exception e){
        // e.printStackTrace();
        log.error(ExceptionUtils.getMessage(e));
        return R.error();
    }


    // sql语法错误
    @ExceptionHandler(BadSqlGrammarException.class)
    @ResponseBody
    public R error(BadSqlGrammarException e){
        // e.printStackTrace();
        //log.error(e.getMessage());
        log.error(ExceptionUtils.getMessage(e));
        return R.setResult(ResultCodeEnum.BAD_SQL_GRAMMAR);
    }


    // 传过来错误的json数据
    @ExceptionHandler(HttpMessageNotReadableException.class)
    @ResponseBody
    public R error(HttpMessageNotReadableException e){

        // e.printStackTrace();
        log.error(ExceptionUtils.getMessage(e));
        return R.setResult(ResultCodeEnum.JSON_PARSE_ERROR);
    }

    // 传过来错误的json数据
    @ExceptionHandler(GuliException.class)
    @ResponseBody
    public R error(GuliException e){
        log.error(ExceptionUtils.getMessage(e));
        return R.error().message(e.getMessage()).code(e.getCode());
    }
}