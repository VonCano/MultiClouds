//
//  BarModel.swift
//  APP
//
//  Created by 段剀越 on 16/3/22.
//  Copyright © 2016年 段剀越. All rights reserved.
//

import Foundation
//
//  DataModel.swift
//  save2dArray
//
//  Created by 段剀越 on 16/3/22.
//  Copyright © 2016年 段剀越. All rights reserved.
//

import Foundation
class BarsModel: NSObject {
    
    
    var file=Bar()
    
    override init(){
        super.init()
        //        print("沙盒文件夹路径：\(documentsDirectory())")
        //print("数据文件路径：\(dataFilePath("0"))")
    }
    
    //保存数据
    func saveData(_ fileDir:Bar,str:String) {
        let data = NSMutableData()
        //申明一个归档处理对象
        let archiver = NSKeyedArchiver(forWritingWith: data)
        //将lists以对应Checklist关键字进行编码
        archiver.encode(fileDir, forKey: "root")
        //编码结束
        archiver.finishEncoding()
        //数据写入
        data.write(toFile: dataFilePath(str), atomically: true)
        //print(str)
    }
    
    //读取数据
    func loadData(_ str:String) {
        //获取本地数据文件地址
        let path = self.dataFilePath(str)
        //声明文件管理器
        let defaultManager = FileManager()
        //通过文件地址判断数据文件是否存在
        if defaultManager.fileExists(atPath: path) {
            //print("文件存在")
            //读取文件数据
            let data = try? Data(contentsOf: URL(fileURLWithPath: path))
            //解码器
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data!)
            //通过归档时设置的关键字Checklist还原lists
            file = unarchiver.decodeObject(forKey: "root") as! Bar
            //结束解码
            unarchiver.finishDecoding()
            
        }
    }
    
    //获取沙盒文件夹路径
    func documentsDirectory()->String {
        let paths = NSHomeDirectory()+"/Documents/"
//        NSSearchPathForDirectoriesInDomains(
//            NSSearchPathDirectory.DocumentationDirectory,NSSearchPathDomainMask.UserDomainMask,true)
//        var documentsDirectory:String = paths.first! as String
        //print(paths)
        return paths
    }
    
    //获取数据文件地址
    func dataFilePath (_ str:String)->String{
        //print(self.documentsDirectory().stringByAppendingString("\(str)"+".plist"))
        return self.documentsDirectory() + ("\(str)"+".plist")
    }
    //地址示例...NSHomeDirectory().../Documents/百度网盘/XXX.plist
}
