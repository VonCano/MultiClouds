//
//  SaveFile.swift
//  APP
//
//  Created by 段剀越 on 16/3/22.
//  Copyright © 2016年 段剀越. All rights reserved.
//

import Foundation
class SaveFile
{
    var plistName=[String]()
    func save(_ source:[[[UInt8]]],diskNo:[Int])
    {
       
        
        var tempPath=[String]()
        var diskName:Dictionary<Int,String> = [0:"金山快盘",1:"百度云盘",2:"dropbox",3:"skydrive",4:"新浪微盘",5:"360云盘",6:"GoogleDrive",7:"网易网盘",8:"腾讯微云"];  // 声明一个网盘字典  键: 网盘编号  值:网盘名
        var subFileNum=source.count
        var manager=FileManager.default
        var value=NSMutableArray ()
        for i in diskNo
        {
             value.add(diskName[i]!)
        }
        var storePath=NSHomeDirectory()+"/Documents/"
        //创建网盘本地模拟盘
        for i in  value
        {
            //tempPath.append(i)
            if manager.fileExists(atPath: storePath+(i as! String))==false
            {
                do {
                try manager.createDirectory(atPath: storePath+(i as! String), withIntermediateDirectories: false, attributes: nil)
                }
                catch let error as NSError
                {
                    print("creating directory failed: "+"\(error)")
                }
            }
        }
        //地址示例...NSHomeDirectory().../Documents/百度网盘/
        //存储文件
        var barsModel=BarsModel()
        for i in 0 ... (source.endIndex-1)//选择子文件
        {
            for j in 0..<diskNo.count//对于每一行
            {
                var bars=Bar(array: source[i][j])
                barsModel.saveData(bars,str:value.object(at: j) as! String+"/"+(value.object(at: j) as! String) as! String+"\(i)"+"\(j)"+getTime())
                    //地址示例...NSHomeDirectory().../Documents/百度网盘/
                plistName.append(value.object(at: j) as! String+"/"+(value.object(at: j) as! String)+"\(i)"+"\(j)"+getTime())
            }
        }
    
    }
    func getTime()->String
    {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = " yyyy-MM-dd 'at' HH:mm:ss.sss"
        let strNowTime = timeFormatter.string(from: date) as String
        return strNowTime
    }
    
    func getPlistName()->[String]
    {
        return plistName
    }
}
