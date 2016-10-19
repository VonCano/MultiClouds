//
//  JsonFormat.swift
//  json
//
//  Created by 段剀越 on 16/4/7.
//  Copyright © 2016年 段剀越. All rights reserved.
//

import Foundation
class JsonFormat
{
    
}
open class RequestToken {
    open var oauth_token_secret:String = ""
    open var oauth_token : String = ""
    open var oauth_callback_confirmed:String = ""
}

open class AccessToken
{
    open var oauth_token_secret:String = ""
    open var oauth_token:String = ""
    open var user_id:String = ""
    open var charged_dir:String = ""
}

open class UserInfo
{
    open func getUserInfo(_ userData:AnyObject)
    {
       // [JsonProperty("quota_total")]
        var Total=userData.object(forKey: "quota_total") as! String
        //[JsonProperty("quota_used")]
        var Used=userData.object(forKey: "quota_used") as! String
    }
}

open class FileData
{
    open var name:String=""
    //public string rev;
    open var file_id:String=""
    //public string create_time;
    //public string modify_time;
    open var type:String=""
    //public string size;
}

open class KpUrl
{
    open var url:String=""
}
