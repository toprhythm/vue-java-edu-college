package com.yunzoukj.yunzou.service.trade.mapper;

import com.yunzoukj.yunzou.service.trade.entity.PayLog;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

/**
 * <p>
 * 支付日志表 Mapper 接口
 * </p>
 *
 * @author topthyrhm
 * @since 2021-11-16
 */
@Repository
public interface PayLogMapper extends BaseMapper<PayLog> {

}
