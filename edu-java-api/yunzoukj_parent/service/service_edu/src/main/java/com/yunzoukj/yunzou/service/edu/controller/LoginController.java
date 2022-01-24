/*
 * @project_name: yunzoukj_parent
 * @clazz_name: LoginController.java
 * @description: TODO
 * @coder: github@toprhythm
 * @since: 2021/10/18 上午8:52
 * @version: 1.0.0
 */
package com.yunzoukj.yunzou.service.edu.controller;

import com.yunzoukj.yunzou.common.base.result.R;
import org.springframework.web.bind.annotation.*;

//@CrossOrigin // 允许跨域
@RestController // 返回json数据
@RequestMapping("/user") // 浏览器路径前缀
public class LoginController {

    @PostMapping("login")
    public R doLogin() {
        return R.ok().data("token", "admin");
    }

    /**
     * 获取用户信息
     * @return
     */
    @GetMapping("info")
    public R doInfo() {
        return R.ok()
                .data("name", "admin")
                .data("roles", "[admin]")
                .data("avatar", "https://oss.aliyuncs.com/aliyun_id_photo_bucket/default_handsome.jpg");
    }

    @PostMapping("logout")
    public R doLogout() {
        return R.ok();
    }

}
