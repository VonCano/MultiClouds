//
//  extensionMD5.swift
//  APP
//
//  Created by 段剀越 on 16/3/16.
//  Copyright © 2016年 段剀越. All rights reserved.
//

import Foundation
//extension String {
//    var md5 : String{
//        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
//        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
//        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
//        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen);
//        
//        CC_MD5(str!, strLen, result);
//        
//        let hash = NSMutableString();
//        for i in 0 ..< digestLen {
//            hash.appendFormat("%02x", result[i]);
//        }
//        result.destroy();
//        
//        return String(format: hash as String)
//    }
//}


extension String {
    var md5 : String{
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen);
        
        CC_MD5(str!, strLen, result);
        
        let hash = NSMutableString();
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i]);
        }
        result.deinitialize();
        
        return String(format: hash as String)
    }
}
extension Int {
    func hexedString() -> String {
        return String(format:"%02x", self)
    }
}

extension NSData {
    func hexString() -> String {
        var string = String()
//        for i in UnsafeBufferPointer<UInt8>(start: UnsafeMutablePointer<UInt8>(bytes), count: length)
         for i in UnsafeBufferPointer<UInt8>(start: bytes.assumingMemoryBound(to: UInt8.self), count: length){
            string += Int(i).hexedString()
        }
        return string
    }
    
    func MD5() -> NSData {
        var result = Data(count: Int(CC_MD5_DIGEST_LENGTH))
         _ = result.withUnsafeMutableBytes({mutableBytes in CC_MD5(bytes, CC_LONG(length), mutableBytes)})
//        CC_MD5(bytes, CC_LONG(length), UnsafeMutablePointer<UInt8>(result.mutableBytes))
        return NSData(data: result)
    }

    
    func SHA1() -> NSData {
        var result = Data(count:Int(CC_SHA1_DIGEST_LENGTH))
        _ = result.withUnsafeMutableBytes({mutableBytes in CC_SHA1(bytes, CC_LONG(length), mutableBytes)})
//        CC_SHA1(bytes, CC_LONG(length), UnsafeMutablePointer<UInt8>(result.mutableBytes))
        return NSData(data: result)
    }
}
