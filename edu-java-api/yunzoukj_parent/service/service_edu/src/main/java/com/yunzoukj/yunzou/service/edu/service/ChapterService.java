package com.yunzoukj.yunzou.service.edu.service;

import com.yunzoukj.yunzou.service.edu.entity.Chapter;
import com.baomidou.mybatisplus.extension.service.IService;
import com.yunzoukj.yunzou.service.edu.entity.vo.ChapterVo;

import java.util.List;

/**
 * <p>
 * 课程 服务类
 * </p>
 *
 * @author topthyrhm
 * @since 2021-10-13
 */
public interface ChapterService extends IService<Chapter> {

    boolean removeChapterById(String id);

    List<ChapterVo> nestedList(String courseId);
}
