//
//  MergeFile.swift
//  APP
//
//  Created by 段剀越 on 16/5/22.
//  Copyright © 2016年 段剀越. All rights reserved.
//

import Foundation
class MergeFile
{
    func merge(_ source:[[[UInt8]]],placeHolderSize:Int)->Data
    {
        var result=Data()
         var withoutRearRow=[UInt8]()
        //先把所有子文件的最后一行删掉，构建新的数组用计算
        for subFile in source//对于每个子文件
        {
            for row in 0..<subFile.count-1//忽略最后一行
            {
                withoutRearRow.append(contentsOf: subFile[row])
            }
        }
        if placeHolderSize==0
        {
            result=Data(bytes: UnsafePointer<UInt8>(withoutRearRow), count: withoutRearRow.count)
        }
        else
        {
            //除掉补的0
            withoutRearRow.removeSubrange((withoutRearRow.indices.suffix(from: (withoutRearRow.count-placeHolderSize))))
            result=Data(bytes: UnsafePointer<UInt8>(withoutRearRow), count: withoutRearRow.count)
        }
        return result
    }
}
