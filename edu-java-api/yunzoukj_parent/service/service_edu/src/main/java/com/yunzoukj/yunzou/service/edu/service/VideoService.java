package com.yunzoukj.yunzou.service.edu.service;


import com.yunzoukj.yunzou.service.edu.entity.Video;
import com.baomidou.mybatisplus.extension.service.IService;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * <p>
 * 课程视频 服务类
 * </p>
 *
 * @author topthyrhm
 * @since 2021-10-13
 */
@Service
public interface VideoService extends IService<Video> {
    void removeMediaVideoById(String id);

    void removeMediaVideoByChapterId(String chapterId);

    void removeMediaVideoByCourseId(String courseId);
}
