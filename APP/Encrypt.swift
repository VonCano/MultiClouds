//
//  Encrypt.swift
//  APP
//
//  Created by 段剀越 on 16/3/10.
//  Copyright © 2016年 段剀越. All rights reserved.
//data是为加密的数据，是第一步

import Foundation
class Encrypt
{
    var selectedAlgorithm: SymmetricCryptorAlgorithm = .aes_128
    var pkcs7Padding = true
    var useEcbMode = true
    var cypherData: NSData?  //加密后的数据
    var decipherData:NSData?//解密后的数据
    var UInt8Data = [UInt8]()//UInt8Data是转化后的数组
    let key = SymmetricCryptor.randomStringOfLength(SymmetricCryptorAlgorithm.aes_128.requiredKeySize())
    
    func AES128Cypher(_ data:NSData)->NSData //->[UInt8]
    {
        //
        let cypher = SymmetricCryptor(algorithm: SymmetricCryptorAlgorithm.aes_128, options: {() -> Int in
            var options = 0
            options |= kCCOptionPKCS7Padding
            options |= kCCOptionECBMode
            return options}())//采用PKCS7填充，ECB模式
        do {
              cypherData = try cypher.crypt(data: data as Data, key: key) as NSData?//加密的原文有两种：String和NSData，次处是NSData类型
                print("加密成功!")
                print("cypherData（加密后大小）："+"\(cypherData?.length)")
//                //再把加密后数据转化为[UInt8]
//                let buffer = UnsafeBufferPointer<UInt8>(start:UnsafePointer<UInt8>(cypherData!.bytes), count:cypherData!.length)
//            
//            
//                UInt8Data.reserveCapacity(cypherData!.length)
//                for i in 0..<cypherData!.length
//                {
//                    UInt8Data.append(UInt8(buffer[i]))
//                }
//                print("转化为[UInt8]成功")
//                print("[UInt8](转化成字节数组后大小):"+"\(UInt8Data.count)")
           
            }
        catch var error as NSError
        {
            print("无法对原文加密. \(error). ")
        }
              return cypherData!
    }
    
    func AES128Decypher(_ data:NSData/*bytes:[UInt8]*/,key:String)->NSData
    {
        cypherData = NSData(data: data as Data) as NSData
        if cypherData == nil
        {
            print("没有加密文件需要解密")
//            var data:NSData?
            return cypherData!
        }
        
        let cypher = SymmetricCryptor(algorithm: SymmetricCryptorAlgorithm.aes_128, options: {() -> Int in
            var options = 0
            options |= kCCOptionPKCS7Padding
            options |= kCCOptionECBMode
            return options}())
        do {
                decipherData = try cypher.decrypt(cypherData! as Data, key: key) as NSData//如果密钥错误，decipherData就是nil
            if decipherData != nil
            {
                cypherData = nil
            }
            else
            {
                print("无法解密，密钥错误！加密后数据如下: \(cypherData)" )
            }
        }
        catch var error as NSError{
            print("无法对密文解密. \(error)")
        }
        return decipherData!
    }
    func getKey()->String
    {
        return key
    }
}
