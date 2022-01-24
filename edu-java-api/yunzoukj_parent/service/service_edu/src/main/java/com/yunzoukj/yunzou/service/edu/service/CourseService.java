package com.yunzoukj.yunzou.service.edu.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.yunzoukj.yunzou.service.base.dto.CourseDto;
import com.yunzoukj.yunzou.service.edu.entity.Course;
import com.baomidou.mybatisplus.extension.service.IService;
import com.yunzoukj.yunzou.service.edu.entity.form.CourseInfoForm;
import com.yunzoukj.yunzou.service.edu.entity.vo.*;

import java.util.List;

/**
 * <p>
 * 课程 服务类
 * </p>
 *
 * @author topthyrhm
 * @since 2021-10-13
 */
public interface CourseService extends IService<Course> {

    String saveCourseInfo(CourseInfoForm courseInfoForm);

    CourseInfoForm getCourseInfoById(String id);

    void updateCourseInfoById(CourseInfoForm courseInfoForm);

    IPage<CourseVo> selectPage(Long page, Long limit, CourseQueryVo courseQueryVo);

    boolean removeCoverById(String id);

    boolean removeCourseById(String id);

    CoursePublishVo getCoursePublishVoById(String id);

    boolean publishCourseById(String id);

    List<Course> webSelectList(WebCourseQueryVo webCourseQueryVo);

    /**
     * 获取课程信息并更新浏览量
     * @param id
     * @return
     */
    WebCourseVo selectWebCourseVoById(String id);

    List<Course> selectHotCourse();

    CourseDto getCourseDtoById(String courseId);

    void updateBuyCountById(String id);
}
