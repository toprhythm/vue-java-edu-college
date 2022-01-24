package com.yunzoukj.yunzou.service.trade.feign;

import com.yunzoukj.yunzou.common.base.result.R;
import com.yunzoukj.yunzou.service.base.dto.CourseDto;
import com.yunzoukj.yunzou.service.trade.feign.fallback.EduCourseServiceFallBack;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@Service
@FeignClient(value = "service-edu", fallback = EduCourseServiceFallBack.class)
public interface EduCourseService {
    @GetMapping(value = "/api/edu/course/inner/get-course-dto/{courseId}")
    CourseDto getCourseDtoById(@PathVariable(value = "courseId") String courseId);
    @GetMapping("/api/edu/course/inner/update-buy-count/{id}")
    R updateBuyCountById(@PathVariable("id") String id);
}