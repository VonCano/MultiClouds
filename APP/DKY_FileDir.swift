//
//  DKY_FileDir.swift
//  APP
//
//  Created by 段剀越 on 16/3/20.
//  Copyright © 2016年 段剀越. All rights reserved.
//

import Foundation
class DKY_FileDir:NSObject
{
    var name : String = ""
    var celldata:NSMutableArray = []
    var filePath=NSMutableString()
    var createTime:String=""
    var metadata=MetaData()
    //构造方法
    init(name:String="",celldata:NSMutableArray=NSMutableArray(),filePath:NSMutableString = "",createTime:String="",metaData:MetaData=MetaData()){
        self.name = name
        self.celldata = celldata
        self.filePath = filePath
        self.createTime=createTime
        self.metadata=metaData
        super.init()
    }
    
    //从nsobject解析回来
    init(coder aDecoder:NSCoder!){
        self.name=aDecoder.decodeObject(forKey: "name") as! String
        self.celldata=aDecoder.decodeObject(forKey: "celldata") as! NSMutableArray
        self.filePath=aDecoder.decodeObject(forKey: "filePath") as! NSMutableString
        self.createTime=aDecoder.decodeObject(forKey: "createTime") as! String
        self.metadata=aDecoder.decodeObject(forKey: "metadata") as! MetaData
    }
    
    //编码成object
    func encodeWithCoder(_ aCoder:NSCoder!){
        aCoder.encode(name,forKey:"name")
        aCoder.encode(celldata,forKey:"celldata")
        aCoder.encode(filePath, forKey: "filePath")
        aCoder.encode(createTime, forKey: "createTime")
        aCoder.encode(metadata, forKey: "metadata")
    }
}
