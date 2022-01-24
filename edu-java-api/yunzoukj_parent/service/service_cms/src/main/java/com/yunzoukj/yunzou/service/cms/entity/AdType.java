package com.yunzoukj.yunzou.service.cms.entity;

import com.yunzoukj.yunzou.service.base.model.BaseEntity;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

/**
 * <p>
 * 推荐位
 * </p>
 *
 * @author topthyrhm
 * @since 2021-11-12
 */
@Data
@EqualsAndHashCode(callSuper = true)
@Accessors(chain = true)
@TableName("cms_ad_type")
@ApiModel(value="AdType对象", description="推荐位")
public class AdType extends BaseEntity {

    private static final long serialVersionUID=1L;

    @ApiModelProperty(value = "标题")
    private String title;


}
