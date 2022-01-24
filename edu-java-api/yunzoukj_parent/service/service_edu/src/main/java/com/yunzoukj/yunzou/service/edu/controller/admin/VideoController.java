package com.yunzoukj.yunzou.service.edu.controller.admin;


import com.yunzoukj.yunzou.common.base.exception.ExceptionUtils;
import com.yunzoukj.yunzou.common.base.result.R;
import com.yunzoukj.yunzou.common.base.result.ResultCodeEnum;
import com.yunzoukj.yunzou.service.base.exception.GuliException;
import com.yunzoukj.yunzou.service.edu.entity.Video;
import com.yunzoukj.yunzou.service.edu.feign.VodMediaService;
import com.yunzoukj.yunzou.service.edu.service.VideoService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * <p>
 * 课程视频 前端控制器
 * </p>
 *
 * @author topthyrhm
 * @since 2021-10-13
 */
//@CrossOrigin
@Api(description = "课时管理")
@RestController
@RequestMapping("/admin/edu/video")
@Slf4j
public class VideoController {
    @Autowired
    private VideoService videoService;
    @ApiOperation("新增课时")
    @PostMapping("save")
    public R save(
            @ApiParam(value="课时对象", required = true)
            @RequestBody Video video){
        boolean result = videoService.save(video);
        if (result) {
            return R.ok().message("保存成功");
        } else {
            return R.error().message("保存失败");
        }
    }
    @ApiOperation("根据id查询课时")
    @GetMapping("get/{id}")
    public R getById(
            @ApiParam(value="课时id", required = true)
            @PathVariable String id){
        Video video = videoService.getById(id);
        if (video != null) {
            return R.ok().data("item", video);
        } else {
            return R.error().message("数据不存在");
        }
    }
    @ApiOperation("根据id修改课时")
    @PutMapping("update")
    public R updateById(
            @ApiParam(value="课时对象", required = true)
            @RequestBody Video video){
        boolean result = videoService.updateById(video);
        if (result) {
            return R.ok().message("修改成功");
        } else {
            return R.error().message("数据不存在");
        }
    }


    @ApiOperation("根据ID删除课时")
    @DeleteMapping("remove/{id}")
    public R removeById(
            @ApiParam(value = "课时ID", required = true)
            @PathVariable String id){
        //删除视频：VOD //根据videoid找到aliyunvodid
        videoService.removeMediaVideoById(id);
        //在此处调用vod中的删除视频文件的接口
        boolean result = videoService.removeById(id);
        if (result) {
            return R.ok().message("删除成功");
        } else {
            return R.error().message("数据不存在");
        }
    }

}

