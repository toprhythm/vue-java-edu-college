package com.yunzoukj.yunzou.service.oss.service;

import java.io.InputStream;

public interface FileService {
    /**
     * 文件上传至阿里云
     */
    String upload(InputStream inputStream, String module, String originalFilename);

    /**
     * 阿里云oss文件删除
     * @param url 文件的url地址
     */
    void removeFile(String url);
}