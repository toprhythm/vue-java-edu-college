package com.yunzoukj.yunzou.service.statistics.service;

import com.yunzoukj.yunzou.service.statistics.entity.Daily;
import com.baomidou.mybatisplus.extension.service.IService;
import org.springframework.stereotype.Service;

import java.util.Map;

/**
 * <p>
 * 网站统计日数据 服务类
 * </p>
 *
 * @author topthyrhm
 * @since 2021-11-18
 */
public interface DailyService extends IService<Daily> {

    void createStatisticsByDay(String day);

    Map<String, Map<String, Object>> getChartData(String begin, String end);
}
