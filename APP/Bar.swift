//
//  Bar.swift
//  APP
//
//  Created by 段剀越 on 16/3/22.
//  Copyright © 2016年 段剀越. All rights reserved.
//对Raid5后数据序列化,记录字节数组和该字节数组的编号

import Foundation
class Bar: NSObject, NSCoding {
    var _array = [UInt8]()
    var No=0
    init(array:[UInt8]=[UInt8]()) {
        _array = array
    }
    required init(coder aDecoder: NSCoder) {
        var arrayLength:Int = 0
        var temp=[UInt8]()

        No=aDecoder.decodeInteger(forKey: "No")
        let buf = aDecoder.decodeBytes(forKey: "array"+"\(No)", returnedLength: &arrayLength)
            temp = Array(UnsafeBufferPointer(start: buf, count: arrayLength))
            _array=temp
       
    }
    func encode(with aCoder: NSCoder) {
            aCoder.encodeBytes( _array, length: _array.count, forKey: "array"+"\(No)" )
        aCoder.encode(No, forKey: "No")
    }
}
