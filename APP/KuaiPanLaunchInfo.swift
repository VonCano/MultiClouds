//
//  Bars.swift
//  nnetwork
//
//  Created by 段剀越 on 16/5/12.
//  Copyright © 2016年 段剀越. All rights reserved.
//

import Foundation
class KuaiPanLaunchInfo:NSObject, NSCoding{
   
    var accessToken=""  //oauth_token
    var refreshToken="" //oauth_token_secret
    var user_Id=0
    var charged_Dir=""
    
    init(accessToken:String,refreshToken:String,user_Id:NSInteger,charged_Dir:String)
    {
        self.accessToken=accessToken
        self.refreshToken=refreshToken
        self.user_Id=user_Id
        self.charged_Dir=charged_Dir
    }
    
    override convenience init(){
        self.init(accessToken: "",refreshToken:"",user_Id:0,charged_Dir:"")
    }
     //从nsobject解析回来
    required init(coder aDecoder: NSCoder) {

        accessToken=aDecoder.decodeObject(forKey: "accessToken") as! String
        refreshToken=aDecoder.decodeObject(forKey: "refreshToken") as! String
        user_Id=aDecoder.decodeObject(forKey: "user_Id") as! NSInteger
        charged_Dir=aDecoder.decodeObject(forKey: "charged_Dir") as! String
        
    }
     //编码成object
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(accessToken,forKey:"accessToken")
        aCoder.encode(refreshToken,forKey:"refreshToken")
        aCoder.encode(user_Id,forKey:"user_Id")
        aCoder.encode(charged_Dir,forKey:"charged_Dir")
    }
    
}
