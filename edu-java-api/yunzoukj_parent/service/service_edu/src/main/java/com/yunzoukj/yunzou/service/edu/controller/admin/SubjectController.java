package com.yunzoukj.yunzou.service.edu.controller.admin;


import com.yunzoukj.yunzou.common.base.exception.ExceptionUtils;
import com.yunzoukj.yunzou.common.base.result.R;
import com.yunzoukj.yunzou.common.base.result.ResultCodeEnum;
import com.yunzoukj.yunzou.service.base.exception.GuliException;
import com.yunzoukj.yunzou.service.edu.entity.vo.SubjectVo;
import com.yunzoukj.yunzou.service.edu.service.SubjectService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.InputStream;
import java.util.List;

/**
 * <p>
 * 课程科目 前端控制器
 * </p>
 *
 * @author topthyrhm
 * @since 2021-10-13
 */
//@CrossOrigin // 允许跨域
@Slf4j
@Api(description = "课程分类管理")
@RestController
@RequestMapping("/admin/edu/subject")
public class SubjectController {

    @Autowired
    private SubjectService subjectService;
    @ApiOperation(value = "Excel批量导入课程类别数据")
    @PostMapping("import")
    public R batchImport(
            @ApiParam(value = "Excel文件", required = true)
            @RequestParam("file") MultipartFile file) {
        try {
            InputStream inputStream = file.getInputStream();
            subjectService.batchImport(inputStream);
            return R.ok().message("批量导入成功");
        } catch (Exception e) {
            log.error(ExceptionUtils.getMessage(e));
            throw new GuliException(ResultCodeEnum.EXCEL_DATA_IMPORT_ERROR);
        }
    }

    @ApiOperation(value = "嵌套数据列表")
    @GetMapping("nested-list")
    public R nestedList(){
        List<SubjectVo> subjectVoList = subjectService.nestedList();
        return R.ok().data("items", subjectVoList);
    }

}

