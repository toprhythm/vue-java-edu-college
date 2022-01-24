package com.yunzoukj.yunzou.service.ucenter.mapper;

import com.yunzoukj.yunzou.service.ucenter.entity.Member;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.springframework.stereotype.Repository;

/**
 * <p>
 * 会员表 Mapper 接口
 * </p>
 *
 * @author topthyrhm
 * @since 2021-11-13
 */
@Repository
public interface MemberMapper extends BaseMapper<Member> {

    Integer selectRegisterNumByDay(String day);

}
