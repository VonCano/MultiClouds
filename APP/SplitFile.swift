//
//  SplitFile.swift
//  APP
//
//  Created by 段剀越 on 16/3/15.
//  Copyright © 2016年 段剀越. All rights reserved.
//

import Foundation
class SplitFile {
    func split(_ data:NSData,diskNum:Int)->([[[UInt8]]],Int,Int)
    {
        
        var fileRead:InputStream?
        var max_chunk_size = 512*1024//512KB
        var chunk_size=0
        var filesize = data.length
        var stripe=[[UInt8]]()
        var length = 0
        var result = [[[UInt8]]]()//返回值
        var placeHolderSize=0
        
        if filesize <= (diskNum-1)*max_chunk_size //文件比较小
        {
            chunk_size=(filesize-1)/(diskNum-1)+1 //重新计算chunk_size
            var fileBuf = [UInt8](repeating: 0, count: chunk_size) //读取缓冲区
            fileRead = InputStream(data: data as Data)
            fileRead!.open()
            while (true)
            {
                length = fileRead!.read(&fileBuf, maxLength: fileBuf.count)//将数据读取到缓冲区filebuf
                if length>0 && length<chunk_size
                {
                    var temp=[UInt8](repeating: 0, count: chunk_size)
                    var i = 0
                    for elem in fileBuf[0..<length]
                    {
                        
                        temp[i]=elem
                        i += 1
                    }
                    for i in length ..< chunk_size
                    {
                        temp[i]=0
                    }
                    stripe.append(temp)
                    break
                }
                stripe.append(Array(fileBuf[0..<length]))
            }
            fileRead!.close()
            result.append(stripe)
            return (result,chunk_size,placeHolderSize)
        }
        else
        {
            chunk_size=max_chunk_size
            var fileBuf = [UInt8](repeating: 0, count: chunk_size) //读取缓冲区
            var piece=NSMutableData()
            //先将大文件分成max_chunk_size＊（diskNum－1）大小的小文件
            var pieceNum = (filesize-1)/(chunk_size*(diskNum-1))+1
            var arr=NSMutableArray()
            for i in 0 ... (pieceNum-1)
            {
                var remain = filesize % (chunk_size*(diskNum-1))//分成多个字文件后，无法分的大小
                if remain == 0//刚好分完没有残片
                {
                    piece = NSMutableData(data: data.subdata(with: NSMakeRange(i*(chunk_size*(diskNum-1)), (chunk_size*(diskNum-1)))) as Data )
                    arr.add(piece)
                }
                else
                {
                    if i*(chunk_size*(diskNum-1))+(chunk_size*(diskNum-1)) <= data.length
                    {
                        piece =  NSMutableData(data: data.subdata(with: NSMakeRange(i*(chunk_size*(diskNum-1)), (chunk_size*(diskNum-1)))) as Data )
                        arr.add(piece)
                    }
                    else
                    {
                        piece = NSMutableData(data: data.subdata(with: NSMakeRange(i*(chunk_size*(diskNum-1)), remain)) as Data)
                        //arr.addObject(piece!)
                         placeHolderSize=chunk_size*(diskNum-1) - remain
                        
                        var placeHolder=[UInt8]()
                        for i in 0 ..< placeHolderSize
                        {
                            placeHolder.append(0)
                        }
                        
                        var temp=Data(bytes: &placeHolder, count: placeHolderSize)
                        piece.append(temp)
                        arr.add(piece)
                    }
                }
                fileRead = InputStream(data: arr.object(at: i) as! Data)
                fileRead!.open()
                //读取每个小文件
                while (true)
                {
                    length = fileRead!.read(&fileBuf, maxLength: fileBuf.count)//将数据读取到缓冲区filebuf
                    if(length <= 0)
                    {//读取结束,跳出循环
                        break
                    }
                    stripe.append(Array(fileBuf[0..<length]))
                    //只添加读取的内容
                }
                result.append(stripe)
                stripe=[[UInt8]]()
                fileRead!.close()
            }
            return (result,chunk_size,placeHolderSize)
        }
    }
}
