package com.yunzoukj.yunzou.service.statistics.task;

import com.yunzoukj.yunzou.service.statistics.service.DailyService;
import lombok.extern.slf4j.Slf4j;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/*
 * @author: toprhythm
 * @since: 2021/11/18 下午1:56
 */
@Slf4j
@Component
public class DailyStatisticsTask {

    @Autowired
    private DailyService dailyService;
    /**
     * 测试
     */
    @Scheduled(cron="0/3 * * * * *") // 每隔3秒执行一次
    public void task1() {
        log.info("task1 执行");
    }
    /**
     * 每天凌晨1点执行定时任务
     */
    @Scheduled(cron = "0 0 1 * * ?") //注意只支持6位表达式
    //@Scheduled(cron = "02 03 14 * * ?") //每天14点03分02秒执行
    public void taskGenarateStatisticsData() {
        //获取上一天的日期
        String day = new DateTime().minusDays(1).toString("yyyy-MM-dd");
        dailyService.createStatisticsByDay(day);
        log.info("前一天的日期：{} , taskGenarateStatisticsData 统计完毕", day);
    }

}
