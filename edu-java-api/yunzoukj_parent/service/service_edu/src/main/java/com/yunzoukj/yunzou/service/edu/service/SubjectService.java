package com.yunzoukj.yunzou.service.edu.service;

import com.yunzoukj.yunzou.service.edu.entity.Subject;
import com.baomidou.mybatisplus.extension.service.IService;
import com.yunzoukj.yunzou.service.edu.entity.vo.SubjectVo;

import java.io.InputStream;
import java.util.List;

/**
 * <p>
 * 课程科目 服务类
 * </p>
 *
 * @author topthyrhm
 * @since 2021-10-13
 */
public interface SubjectService extends IService<Subject> {
    void batchImport(InputStream inputStream);

    List<SubjectVo> nestedList();
}
