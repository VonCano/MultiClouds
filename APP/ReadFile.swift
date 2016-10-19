//
//  mergeFile.swift
//  APP
//
//  Created by 段剀越 on 2016/3/30.
//  Copyright © 2016年 段剀越. All rights reserved.
//

import Foundation
class ReadFile {
    func readFromPath(_ path:[String],chunkSize:Int,subFileNum:Int,diskNo:[Int])->[[[UInt8]]]
    {
        var result=[[[UInt8]]]()
        var barsModel=BarsModel()
        if subFileNum==1//文件小于MaxChunkSize*(disNum-1)
        {
            var file=[[UInt8]]()
            for str in path
            {
                barsModel.loadData(str)
                file.append(barsModel.file._array)
            }
            result.append(file)
            return result
        }
        else
        {
            var file=[[UInt8]]()
            var i=0
            for str in path
            {
                print(str)
                if str == path.last
                {
                    barsModel.loadData(str)
                    file.append(barsModel.file._array)
                    result.append(file)
                }
                else
                {
                    if i < diskNo.count
                    {
                        barsModel.loadData(str)
                        file.append(barsModel.file._array)
                        i += 1
                    }
                    else
                    {
                        result.append(file)
                        file=[[UInt8]]()
                        i=0
                        barsModel.loadData(str)
                        file.append(barsModel.file._array)
                        i += 1
                    }
                }
            }
            return result
        }
    }
    
    func read(_ filePath:[String],missDiskName:String,chunkSize:Int,diskNo:[Int],subFileNo:Int)->(Int,[[[UInt8]]])
    {
        var path=NSHomeDirectory()+"/Documents/"
        var manager=FileManager.default
        var No=diskNo
        var diskName:Dictionary<Int,String> = [0:"金山快盘",1:"百度云盘",2:"dropbox",3:"skydrive",4:"新浪微盘",5:"360云盘",6:"GoogleDrive",7:"网易网盘",8:"腾讯微云"];

        var barsModel=BarsModel()
        var file=[[UInt8]]()
        var result=[[[UInt8]]]()
        var missDiskNo = -1
        var missRow = -1


        if missDiskName=="OK"
        {
            result=readFromPath(filePath,chunkSize:chunkSize,subFileNum:subFileNo,diskNo:diskNo)
        }
        else
        {
            //查找丢失的行
            for (key,value) in  diskName
            {
                if value==missDiskName
                {
                    missDiskNo=key
                }
            }
            var temp=NSMutableArray()
            for i in diskNo//找到实际上丢失了哪一行，因为丢失的文件反映的是二维矩阵行的丢失
            {
                temp.add(i)
            }
            missRow=temp.index(of: missDiskNo)
            print("矩阵丢失了第",missRow,"行")
            if subFileNo==1
            {
                file=[[UInt8]]()
                var count=0
                for str in filePath
                {
                    if str.hasPrefix(missDiskName)
                    {
                        file.append([UInt8](repeating: 0, count: chunkSize))
                    }
                    else
                    {
                        barsModel.loadData(str)
                        file.append(barsModel.file._array)
                    }
                }
                result.append(file)
            }
            else
            {
                for sub in 0..<subFileNo//在每一个子文件中
                {
                    file=[[UInt8]]()
                    for i in 0..<diskNo.count
                    {
                        file.append([UInt8](repeating: 0, count: chunkSize))
                    }
                    for disk in diskNo//在每一个盘中
                    {

                            var rowNo=temp.index(of: disk)
                            if missRow==rowNo
                            {
                                //file.append([UInt8](count: chunkSize, repeatedValue: UInt8(0)))
                            }
                            else
                            {
                                var diff=diskName[disk]!+"/"+diskName[disk]!+"\(sub)"+"\(rowNo)"
                                for str in filePath//diskNo一次循环只能找到一条
                                {
                                    if str.hasPrefix(diff)//得到指定的无故障盘的文件路径
                                    {
                                       
                                        barsModel.loadData(str)
                                        var temp=barsModel.file._array
                                        file[rowNo]=temp
                                       
                                    }
                                }
                            }
                    }
                    result.append(file)
                }
            }
        }
        //print (result[0][missRow])
        return (missRow,result)
    }
}
