//
//  SaveInfo.swift
//  nnetwork
//
//  Created by 段剀越 on 16/5/13.
//  Copyright © 2016年 段剀越. All rights reserved.
//

import Foundation
class SaveInfo:NSObject
{
   
    var info=KuaiPanLaunchInfo()
     var documentsDirectory=""
    func saveData(_ info:KuaiPanLaunchInfo)
    {
        let data = NSMutableData()
        //申明一个归档处理对象
        let archiver = NSKeyedArchiver(forWritingWith: data)
        //将lists以对应Checklist关键字进行编码
        archiver.encode(info, forKey: "KuaiPanLaunchInfo")
        //编码结束
        archiver.finishEncoding()
        //数据写入
//        var paths = NSSearchPathForDirectoriesInDomains(
//            NSSearchPathDirectory.DocumentationDirectory,NSSearchPathDomainMask.UserDomainMask,true)
//        documentsDirectory = paths.first! as String
//        documentsDirectory=documentsDirectory.stringByAppendingString("KuaiPanLaunchInfo.plist")
        let path=NSHomeDirectory()+"/Documents/KuaiPanLaunchInfo.plist"
        data.write(toFile: path, atomically: true)
        print("write launch info:",path)
    }
    
    func loadData()->KuaiPanLaunchInfo
    {
        //获取本地数据文件地址
        let path = NSHomeDirectory()+"/Documents/KuaiPanLaunchInfo.plist"
        //声明文件管理器
        let defaultManager = FileManager()
        //通过文件地址判断数据文件是否存在
        if defaultManager.fileExists(atPath: path)
        {
            //读取文件数据
            let data = try? Data(contentsOf: URL(fileURLWithPath: path))
            //解码器
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data!)
            //通过归档时设置的关键字Checklist还原lists
            info = unarchiver.decodeObject(forKey: "KuaiPanLaunchInfo") as! KuaiPanLaunchInfo
            //结束解码
            unarchiver.finishDecoding()
            return info
        }else
        {return KuaiPanLaunchInfo()}
    }
}
