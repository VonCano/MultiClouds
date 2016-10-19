//
//  Token.swift
//  json
//
//  Created by 段剀越 on 16/4/7.
//  Copyright © 2016年 段剀越. All rights reserved.
//

import Foundation
public enum Disk { case kanbox;case dbank; case kuaipan;case baidu;case vdisk;case chinaEnd;case foreignStart;case skyDrive;case dropBox;case googleDrive;case box;case foreignEnd;case localDisk1;case localDisk2;case localDisk3;case localDisk4;case localDisk5;case system };
class Token
{
    var accessToken:String=""
    var refreshToken=""
    var expires=0
    init ( access_token:String , refresh_token:String ,  expires:Int)
    {
        self.accessToken = access_token;
        self.refreshToken = refresh_token;
        self.expires = expires;
    }
}

open class IperUserInfo
{
        open var diskName=""
        open var total=0
        open var used=0
        init( diskname:String , total:Int , used:Int)
        {
            self.diskName = diskname;
            self.total = total;
            self.used = used;
        }
}
