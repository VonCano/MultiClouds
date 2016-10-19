//
//  MetadataManagement.swift
//  APP
//
//  Created by 段剀越 on 16/1/13.
//  Copyright © 2016年 段剀越. All rights reserved.
//元数据管理——元数据管理模块负责对元数 据进行管理,主要负责元数据加密散布、元数据解密下载、元数据移动和元数 据删除

import Foundation
class MetaData:NSObject
{
    var name : String = ""
    var size : Int
    var ID: String = ""
    var chunk_size : Int = 0
    var diskNo=[Int]() //网盘编号
    var createTime:String=""
    var plistName=[String]()//记录分片存储的文件名
    var subFileNum=0
    var placeHolderSize:Int
    var fileType=""
    //构造方法
    init(name:String="",size:Int,ID:String = "",chunk_size:Int,diskNo:[Int],createTime:String="",plistName:[String],subFileNum:Int,placeHolderSize:Int,fileType:String){
        self.name = name
        self.size = size
        self.ID = ID
        self.chunk_size = chunk_size
        self.diskNo = diskNo
        self.createTime=createTime
        self.plistName=plistName
        self.subFileNum=subFileNum
        self.placeHolderSize=placeHolderSize
        self.fileType=fileType
        super.init()
    }
    override convenience init(){
        self.init(name: "",size: 0,ID: "",chunk_size: 0,diskNo: [],plistName: [],subFileNum:0,placeHolderSize:0,fileType:"")
    }
     init(coder aDecoder:NSCoder!){
        
        self.name=aDecoder.decodeObject(forKey: "name") as! String
        self.size=aDecoder.decodeObject(forKey: "size") as! Int
        self.ID=aDecoder.decodeObject(forKey: "ID") as! String
        self.chunk_size=aDecoder.decodeObject(forKey: "chunk_size") as! Int
        self.diskNo=aDecoder.decodeObject(forKey: "diskNo") as! [Int]
        self.createTime=aDecoder.decodeObject(forKey: "createTime") as! String
        self.plistName=aDecoder.decodeObject(forKey: "plistName") as! [String]
        self.subFileNum=aDecoder.decodeObject(forKey: "subFileNum") as! Int
        self.placeHolderSize=aDecoder.decodeObject(forKey: "placeHolderSize") as! Int
        self.fileType=aDecoder.decodeObject(forKey: "fileType") as! String
    }
    
    //编码成object
    func encodeWithCoder(_ aCoder:NSCoder!){
        aCoder.encode(self.name,forKey:"name")
        aCoder.encode(self.size,forKey:"size")
        aCoder.encode(self.ID, forKey: "ID")
        aCoder.encode(self.chunk_size, forKey: "chunk_size")
        aCoder.encode(self.diskNo, forKey: "diskNo")
        aCoder.encode(self.createTime, forKey: "createTime")
        aCoder.encode(self.plistName, forKey: "plistName")
        aCoder.encode(self.subFileNum, forKey: "subFileNum")
        aCoder.encode(self.placeHolderSize, forKey: "placeHolderSize")
        aCoder.encode(self.fileType,forKey:"fileType")
    }
}
