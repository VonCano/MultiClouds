//
//  Cut.swift
//  APP
//
//  Created by 段剀越 on 16/3/10.
//  Copyright © 2016年 段剀越. All rights reserved.
//

import Foundation
class Raid5{
    func encode(_ array:[[UInt8]],chunk_size:Int)->[[UInt8]]
    {
        var array = array
 
        array.append([UInt8](repeating: 0, count: chunk_size))
        let o = array.count-1
        for j in 0 ..< chunk_size
        {
            array[o][j]=array[0][j]
            for i in 1 ..< o
            {
                array[o][j] ^=  array[i][j]
            }
            //array[o][j]=temp
        }
        return array
    }
    
    func decode(_ array:[[UInt8]],chunk_size:Int,failureDiskNo:Int)->[[UInt8]]
    {
        var array = array
        //哪一行丢失，就置为0
        if failureDiskNo == array.count-1
        {
            return array
        }
        else
        {
           // array[failureDiskNo]=[UInt8](count: chunk_size, repeatedValue: UInt8(0))
            for j in 0 ..< chunk_size
            {
               
                for i in 0 ..< array.count
                {
                    if i != failureDiskNo
                    {
                        array[failureDiskNo][j] ^= array[i][j]
                    }
                }

            }
            return array
        }
    }
//    var row = 0,col = 0
//    func encode(array:[[UInt8]],chunk_size:Int,diskNum:Int)//nsdata to [UInt8]
//    {
//        var m = diskNum - 1 //二维矩阵列数
//        var n = {()->Int in //二维矩阵行数
//            if array.count % (m * chunk_size) == 0
//            {
//                return array.count / ( m * chunk_size)
//            }
//            else
//            {
//                return (array.count / ( m * chunk_size))+1
//            }
//            }()
//        var stripe = [[UInt8]]()
//        var check=[[UInt8]]()//存放校验和
//        if array.count % (m * chunk_size) == 0
//        {
//            for  i in  0...(n-1)
//            {
//                stripe.append(Array(array[i*m*chunk_size...m*chunk_size*(i+1)-1]))
//                //将一维数组 转化为 二维数组
//            }
//            for i in 0 ... (n-1)
//            {
//                check.append(Array())
//                for k in 0..<chunk_size
//                {
//                    var temp=stripe[i][k]
//                    for var j=k+chunk_size;j<m * chunk_size;j+=chunk_size
//                    {
//                        temp ^= stripe[i][j]
//                    }
//                    check[i].append(temp)
//                }
//            }
//        }
//        else
//        {
//            
//            for i in 0 ..< (n-1)
//                //可以凑成完整tripe的一维数组，转化成stripe
//            {
//                stripe.append(Array(array[i*m*chunk_size...m*chunk_size*(i+1)-1]))
//                
//            }
//            var residual = array.endIndex - (n-1)*m*chunk_size
//            //array.endIndex-1最后一个元素，(n-1)*m+1剩余元素第一个；结果是剩余元素个数
//            stripe.append(Array(array[(n-1)*m*chunk_size...array.endIndex-1]))
//            //添加剩余元素
//            for i in 0..<n-1
//                //先处理完整的stripe
//            {
//                check.append(Array())
//                //每处理一行stripe，就产生一个校验和数组
//                for k in 0..<chunk_size//k找到chunk_size内部对应元素
//                {
//                    var temp=stripe[i][k]
//                    for var j=k+chunk_size;j<m * chunk_size;j+=chunk_size//遍历每个chunk_size中的对应元素
//                    {
//                        
//                        temp ^= stripe[i][j]
//                    }
//                    check[i].append(temp)
//                }
//            }
//            check.append(Array())//处理多余的数据
//            for k in 0..<residual/m
//            {
//                var temp=stripe[n-1][k]
//                for var j=k+residual/m;j<residual;j+=residual/m
//                {
//                    
//                    temp ^= stripe[n-1][j]
//                }
//                check[n-1].append(temp)
//            }
//
//        }
//        print(check)
//    }
//    
//    func decode(array:[UInt8],chunk_size:Int,diskNum:Int,miss:Int)
//    {
//        if miss == -1
//        {
//            print("没有数据丢失")
//        }
//        else
//        {
//            
//        }
//    }
}
