/*
 * @project_name: yunzoukj_parent
 * @clazz_name: TeacherQueryVo.java
 * @description: TODO
 * @coder: github@toprhythm
 * @since: 2021/10/17 上午6:46
 * @version: 1.0.0
 */
package com.yunzoukj.yunzou.service.edu.entity.vo;

import lombok.Data;

import java.io.Serializable;

@Data
public class TeacherQueryVo implements Serializable {

    private static final long serialVersionUID = 1L;
    private String name;
    private Integer level;
    private String joinDateBegin;
    private String joinDateEnd;
}
