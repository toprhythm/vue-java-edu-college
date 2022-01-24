package com.yunzoukj.yunzou.service.ucenter.service;

import com.yunzoukj.yunzou.service.base.dto.MemberDto;
import com.yunzoukj.yunzou.service.ucenter.entity.Member;
import com.baomidou.mybatisplus.extension.service.IService;
import com.yunzoukj.yunzou.service.ucenter.entity.vo.LoginVo;
import com.yunzoukj.yunzou.service.ucenter.entity.vo.RegisterVo;

/**
 * <p>
 * 会员表 服务类
 * </p>
 *
 * @author topthyrhm
 * @since 2021-11-13
 */
public interface MemberService extends IService<Member> {

    void register(RegisterVo registerVo);

    String login(LoginVo loginVo);

    MemberDto getMemberDtoByMemberId(String memberId);

    Integer countRegisterNum(String day);
}
