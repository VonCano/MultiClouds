 //
//  DataModel.swift
//  APP
//
//  Created by 段剀越 on 16/3/20.
//  Copyright © 2016年 段剀越. All rights reserved.
//

import Foundation
class DataModel: NSObject {
    
   var file=DKY_FileDir()
    
    override init(){
        super.init()
//        print("沙盒文件夹路径：\(documentsDirectory())")
//        print("数据文件路径：\(dataFilePath())")
    }
    
    //保存数据
    func saveData(_ fileDir:DKY_FileDir) {
        let data = NSMutableData()
        //申明一个归档处理对象
        let archiver = NSKeyedArchiver(forWritingWith: data)
        //将lists以对应Checklist关键字进行编码
        archiver.encode(fileDir, forKey: "root")
        //编码结束
        archiver.finishEncoding()
        //数据写入
        data.write(toFile: dataFilePath(), atomically: true)
        
    }
    
    //读取数据
    func loadData() {
        //获取本地数据文件地址
        let path = self.dataFilePath()
        //声明文件管理器
        let defaultManager = FileManager()
        //通过文件地址判断数据文件是否存在
        if defaultManager.fileExists(atPath: path) {
            //读取文件数据
            let data = try? Data(contentsOf: URL(fileURLWithPath: path))
            //解码器
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data!)
            //通过归档时设置的关键字Checklist还原lists
            file = unarchiver.decodeObject(forKey: "root") as! DKY_FileDir
            //结束解码
            unarchiver.finishDecoding()
            
        }
    }
    
    //获取沙盒文件夹路径
    func documentsDirectory()->String {
        let paths = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentationDirectory,FileManager.SearchPathDomainMask.userDomainMask,true)
        let documentsDirectory:String = paths.first! as String
        return documentsDirectory
    }
    
    //获取数据文件地址
    func dataFilePath ()->String{
        return self.documentsDirectory() + "fileDir.plist"
    }
}
