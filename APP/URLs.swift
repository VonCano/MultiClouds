//
//  URLs.swift
//  json
//
//  Created by 段剀越 on 16/4/7.
//  Copyright © 2016年 段剀越. All rights reserved.
//

import Foundation
class URLs
{
    open let Version = 1;
    // 获取未授权的Request Token
    open let REQUESTTOKEN = "https://openapi.kuaipan.cn/open/requestToken";
    // 请求用户授权Token
    open let AUTHORISE = "https://www.kuaipan.cn/api.php?ac=open&op=authorise&oauth_token=";
    // 获取授权过的Access Token
    open let ACCESSTOKEN = "https://openapi.kuaipan.cn/open/accessToken";
    // 获取用户信息
    open let ACCOUNTINFO = "http://openapi.kuaipan.cn/{0}/account_info";
    // 获取文件(夹)信息
    open let METADATA = "http://openapi.kuaipan.cn/{0}/metadata/{1}/{2}";
    // 获取文件分享链接
    open let SHARES = "http://openapi.kuaipan.cn/{0}/shares/{1}/{2}";
    // 创建文件(夹)
    open let CREATEFOLDER = "http://openapi.kuaipan.cn/{0}/fileops/create_folder";
    // 删除文件(夹)
    open let DELETE = "http://openapi.kuaipan.cn/{0}/fileops/delete";
    // 移动文件(夹)
    open let MOVE = "http://openapi.kuaipan.cn/{0}/fileops/move";
    // 复制文件(夹)
    open let COPY = "http://openapi.kuaipan.cn/{0}/fileops/copy";
    // 获取文件上传地址
    open let UPLOAD_LOCATE = "http://api-content.dfs.kuaipan.cn/{0}/fileops/upload_locate";
    // 获取文件上传地址
    open let UPLOAD_FILE = "{1}/{0}/fileops/upload_file";
    // 下载文件
    open let DOWNLOAD_FILE = "http://api-content.dfs.kuaipan.cn/{0}/fileops/download_file";
}
