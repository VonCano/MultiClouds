//
//  SymmetricCryptor.swift
//  APP
//
//  Created by 段剀越 on 16/3/8.
//  Copyright © 2016年 段剀越. All rights reserved.
//

import Foundation

private let kSymmetricCryptorRandomStringGeneratorCharset: [Character] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".characters.map({$0})
enum SymmetricCryptorAlgorithm {
    case aes_128    // AES, 128 bits key
    case aes_256    // AES, 256 bits key
    
    func ccAlgorithm() -> CCAlgorithm {
        switch (self) {
        case .aes_128: return CCAlgorithm(kCCAlgorithmAES)
        case .aes_256: return CCAlgorithm(kCCAlgorithmAES)
        }
    }
    func requiredIVSize(_ options: CCOptions) -> Int {
        // if kCCOptionECBMode is specified, no IV is needed.
        if options & CCOptions(kCCOptionECBMode) != 0 { return 0 }
        switch (self) {
        case .aes_128: return kCCBlockSizeAES128
        case .aes_256: return kCCBlockSizeAES128 // AES256 still requires 256 bits IV
        }
    }
    func requiredKeySize() -> Int {
        switch (self) {
        case .aes_128: return kCCKeySizeAES128
        case .aes_256: return kCCKeySizeAES256
        }
    }
    func requiredBlockSize() -> Int {
        switch (self) {
        case .aes_128: return kCCBlockSizeAES128
        case .aes_256: return kCCBlockSizeAES128 // AES256 still requires 128 bits IV
        }
    }
}
enum SymmetricCryptorError: Error {
    case missingIV
    case cryptOperationFailed
    case wrongInputData
    case unknownError
}
class SymmetricCryptor: NSObject {
    // properties
    var algorithm: SymmetricCryptorAlgorithm    // Algorithm
    var options: CCOptions                      // Options (i.e: kCCOptionECBMode + kCCOptionPKCS7Padding)
    var iv: Data?                             // Initialization Vector
    
    init(algorithm: SymmetricCryptorAlgorithm, options: Int) {
        self.algorithm = algorithm
        self.options = CCOptions(options)
    }
    convenience init(algorithm: SymmetricCryptorAlgorithm, options: Int, iv: String, encoding: String.Encoding = String.Encoding.utf8) {
        self.init(algorithm: algorithm, options: options)
        self.iv = iv.data(using: encoding)
    }
    func crypt(string: String, key: String) throws -> Data {
        do {
            if let data = string.data(using: String.Encoding.utf8) {
                return try self.cryptoOperation(data, key: key, operation: CCOperation(kCCEncrypt))
            } else { throw SymmetricCryptorError.wrongInputData }
        } catch {
            throw(error)
        }
    }
    
    func crypt(data: Data, key: String) throws -> Data {
        do {
            return try self.cryptoOperation(data, key: key, operation: CCOperation(kCCEncrypt))
        } catch {
            throw(error)
        }
    }
    func decrypt(_ data: Data, key: String) throws -> Data  {
        do {
            return try self.cryptoOperation(data, key: key, operation: CCOperation(kCCDecrypt))
        } catch {
            throw(error)
        }
    }
    internal func cryptoOperation(_ inputData: Data, key: String, operation: CCOperation) throws -> Data {
        // Validation checks.
        if iv == nil && (self.options & CCOptions(kCCOptionECBMode) == 0) {
            throw(SymmetricCryptorError.missingIV)
        }
        
        // Prepare data parameters
        let keyData: Data! = key.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        let keyBytes = keyData.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> UnsafePointer<UInt8> in
            return bytes
        }
        //let keyBytes         = keyData.bytes.bindMemory(to: Void.self, capacity: keyData.count)
        let keyLength        = size_t(algorithm.requiredKeySize())
        let dataLength       = Int(inputData.count)
        let dataBytes        = inputData.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> UnsafePointer<UInt8> in
            return bytes
        }
        var bufferData       = Data(count: Int(dataLength) + algorithm.requiredBlockSize())
        let bufferPointer    = bufferData.withUnsafeMutableBytes { (bytes: UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8> in
            return bytes
        }
        let bufferLength     = size_t(bufferData.count)
        let ivBuffer: UnsafePointer<UInt8>? = (iv == nil) ? nil : iv!.withUnsafeBytes({ (bytes: UnsafePointer<UInt8>) -> UnsafePointer<UInt8> in
            return bytes
        })
        var bytesDecrypted   = Int(0)
        // Perform operation
        let cryptStatus = CCCrypt(
            operation,                  // Operation
            algorithm.ccAlgorithm(),    // Algorithm
            options,                    // Options
            keyBytes,                   // key data
            keyLength,                  // key length
            ivBuffer,                   // IV buffer
            dataBytes,                  // input data
            dataLength,                 // input length
            bufferPointer,              // output buffer
            bufferLength,               // output buffer length
            &bytesDecrypted)            // output bytes decrypted real length
        if Int32(cryptStatus) == Int32(kCCSuccess) {
            bufferData.count = bytesDecrypted // Adjust buffer size to real bytes
            return bufferData as Data
        } else {
            print("Error in crypto operation: \(cryptStatus)")
            throw(SymmetricCryptorError.cryptOperationFailed)
        }
    }
    // MARK: - Random methods
    
    class func randomDataOfLength(_ length: Int) -> Data? {
        var mutableData = Data(count: length)
        let bytes = mutableData.withUnsafeMutableBytes { (bytes: UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8> in
            return bytes
        }
        let status = SecRandomCopyBytes(kSecRandomDefault, length, bytes)
        return status == 0 ? mutableData as Data : nil
    }
    class func randomStringOfLength(_ length:Int) -> String {
        var string = ""
        for _ in (1...length) {
            string.append(kSymmetricCryptorRandomStringGeneratorCharset[Int(arc4random_uniform(UInt32(kSymmetricCryptorRandomStringGeneratorCharset.count) - 1))])
        }
        return string
    }
    
    func setRandomIV() {
        let length = self.algorithm.requiredIVSize(self.options)
        self.iv = SymmetricCryptor.randomDataOfLength(length)
    }
}

