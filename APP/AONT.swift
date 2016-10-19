//
//  ANOT.swift
//  APP
//
//  Created by 段剀越 on 16/3/16.
//  Copyright © 2016年 段剀越. All rights reserved.
//

import Foundation
class AONT{

    func encrypt(_ data:NSData,diskNum:Int)->NSData
    {
        //将文件MD5添加至文件末尾
        var anotData=NSMutableData(data: data as Data)
        anotData.append(data.MD5() as Data)
        //对添加过MD5的文件AES加密
        var encrypt = Encrypt()
        anotData = NSMutableData(data: encrypt.AES128Cypher(anotData) as Data)
        //计算加密后文件的MD5
        var newMD5=anotData.MD5()
        //MD5与密钥异或运算
        var keyData=(encrypt.getKey() as NSString).data(using: String.Encoding.utf8.rawValue)!
        //计算出Difference
        var difference={(key:Data,md5:Data)->NSData in
                            //NSData转化为数组
                            var buffer = UnsafeBufferPointer<UInt8>(start:(key as NSData).bytes.bindMemory(to: UInt8.self, capacity: key.count), count:key.count)
                            var keyArr = [UInt8]()//keyArr是转化后的数组
                            keyArr.reserveCapacity(key.count)
                            for i in 0..<key.count
                            {
                                keyArr.append(UInt8(buffer[i]))
                            }
                            buffer = UnsafeBufferPointer<UInt8>(start:(md5 as NSData).bytes.bindMemory(to: UInt8.self, capacity: md5.count), count:md5.count)
                            var MD5Arr = [UInt8]()//MD5Arr是转化后的数组
                            MD5Arr.reserveCapacity(md5.count)
                            for i in 0..<md5.count
                            {
                                MD5Arr.append(UInt8(buffer[i]))
                            }
                            var result=[UInt8](repeating: 0, count: md5.count)
                            var diffData:NSData?
                            if md5.count==key.count
                            {
                                for i in 0 ..< md5.count
                                {
                                    result[i] = MD5Arr[i] ^ keyArr[i]
                                }
                            }
                            diffData = NSData(bytes: result, length: result.count)
                            return diffData!
                        }(keyData,newMD5 as Data)
        anotData.append(difference as Data)
        
        return anotData
    }
    
    func decrypt(_ data:NSData)->NSData
    {
        var anotData=NSData()
        //MD5校验码长度是128bit，即16Bytes
        var difference = data.subdata(with: NSMakeRange(data.length-16,16))
        anotData = (data.subdata(with: NSMakeRange(0, data.length-16)) as NSData?)!
        var newMD5 = anotData.MD5()
        var key = {(diff:Data,md5:Data)->String in
            //NSData转化为数组
            var buffer = UnsafeBufferPointer<UInt8>(start:(diff as NSData).bytes.bindMemory(to: UInt8.self, capacity: diff.count), count:diff.count)
            var diffArr = [UInt8]()//keyArr是转化后的数组
           diffArr.reserveCapacity(diff.count)
            for i in 0 ..< diff.count
            {
                diffArr.append(UInt8(buffer[i]))
            }
            buffer = UnsafeBufferPointer<UInt8>(start:(md5 as NSData).bytes.bindMemory(to: UInt8.self, capacity: md5.count), count:md5.count)
            var MD5Arr = [UInt8]()//MD5Arr是转化后的数组
            MD5Arr.reserveCapacity(md5.count)
            for i in 0..<md5.count
            {
                MD5Arr.append(UInt8(buffer[i]))
            }
            var result=[UInt8](repeating: 0, count: md5.count)
            var keyData:Data?
            if md5.count==diff.count
            {
                for i in 0 ..< md5.count
                {
                    result[i] = MD5Arr[i] ^ diffArr[i]
                }
            }
           keyData = Data(bytes: UnsafePointer<UInt8>(result),count: result.count)
            var key = String(data: keyData!, encoding: String.Encoding.utf8)!
            return key
        }(difference,newMD5 as Data)
         var encrypt=Encrypt()
        anotData = encrypt.AES128Decypher(anotData,key:key)
        var checkMD5=anotData.subdata(with: NSMakeRange(anotData.length-16, 16))
        anotData=anotData.subdata(with: NSMakeRange(0,anotData.length-16)) as NSData
        if checkMD5==anotData.MD5() as Data
        {
            print("校验成功!")
            return anotData
        }
        else
        {
            print("校验失败!")
            var temp=NSData()
            return temp
        }
    }
}
