package com.yunzoukj.yunzou.service.edu.service;

import com.yunzoukj.yunzou.service.edu.entity.CourseCollect;
import com.baomidou.mybatisplus.extension.service.IService;
import com.yunzoukj.yunzou.service.edu.entity.vo.CourseCollectVo;

import java.util.List;

/**
 * <p>
 * 课程收藏 服务类
 * </p>
 *
 * @author topthyrhm
 * @since 2021-10-13
 */
public interface CourseCollectService extends IService<CourseCollect> {

    boolean isCollect(String courseId, String id);

    void saveCourseCollect(String courseId, String id);

    List<CourseCollectVo> selectListByMemberId(String id);

    boolean removeCourseCollect(String courseId, String id);
}
