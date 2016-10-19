//
//  OAuth1_0.swift
//  json
//
//  Created by 段剀越 on 16/4/8.
//  Copyright © 2016年 段剀越. All rights reserved.
//

import Foundation
class OAuth1_0
{
    open var Url=""
    open var Args:NSMutableDictionary?
    var signatureFirst=false
    open var callback=""
    open var oauth_token=""
    open var oauth_token_secret=""
    open var oauth_verifier=""
    
    fileprivate var consumer_key:String?
    fileprivate var consumer_secret:String?
    fileprivate var _signature = ""
    fileprivate var _timeStamp = ""
    fileprivate var _nonce = ""
    
    init( consumer_key:String, consumer_secret:String)
    {
        Args = nil
        self.consumer_key = consumer_key;
        self.consumer_secret = consumer_secret;
        _timeStamp = self.getTimeStamp()
        _nonce = self.getOAuthNonce()

    }
    open func getUrl()->String
    {
        if oauth_token_secret.isEmpty
        {
            print("no oauth_token_secret")
        }
        else
        {
            print(oauth_token_secret)
        }
        //假如没有oauth_token的话，密钥为consumer_secret+"&"
        var str=consumer_secret!+"&"
        str.append( oauth_token_secret.isEmpty ? "" : oauth_token_secret)
        _signature = getSignature(getSignatureString(), key: str )
        var para=paramToString(true)
        if signatureFirst==true
        {
            let start=para.range(of: "oauth_signature")?.lowerBound
            let substr=para.substring(from: start!)
            let end=substr.range(of: "&")?.upperBound
            let aim=substr.substring(to: end!)
            para=para.replacingOccurrences(of: aim, with:"")
            let s:NSMutableString=NSMutableString(string: para)
            s.insert(aim, at: 1 )
            return Url+(s as String)
        }
        else
        {
            return Url+para
        }
    }
    
    func  AddAuthParam()-> NSMutableDictionary
    {
        if (Args == nil)
        {
            Args = NSMutableDictionary()
        }
        Args!["oauth_consumer_key"] = consumer_key
        Args!["oauth_nonce"] = _nonce
        Args!["oauth_signature_method"] = "HMAC-SHA1"
        Args!["oauth_timestamp"] = _timeStamp
        Args!["oauth_version"] = "1.0"
        if (!callback.isEmpty)
        {
            Args!["oauth_callback"] = callback
        }
        if (!_signature.isEmpty)
        {
            Args!["oauth_signature"] = _signature
        }
        if (!oauth_token.isEmpty)
        {
            Args!["oauth_token"] = oauth_token
        }
        if (!oauth_verifier.isEmpty)
        {
            Args!["oauth_verifier"] = oauth_verifier
        }
        return Args!
    }
    
    func urlEncode(_ value:String)->String
    {
        return urlEncode(value, other:"")
    }
    
    fileprivate func paramToString( _ isEncode:Bool)->String
    {
        var para = ""
        AddAuthParam()
//        if signatureFirst==true
//        {
//            para.appendContentsOf("?"+"\(urlEncode("oauth_signature"))"+"="+"\(urlEncode(Args!["oauth_signature"] as! String))")//快盘最后一步获取accessToken时，signature是第一个参数，其他按字典顺序
//            Args!["oauth_signature"]=nil
//            signatureFirst=false
//        }
        
        let sortedKeys = (Args!.allKeys as! [String]).sorted(by: <)
        for key in sortedKeys
        {
            let value=Args![key]
            if (isEncode)
            {
//                if (para.rangeOfString("signature") != nil && key.rangeOfString("oauth_signature") != nil)
//                {
//                    continue
//                }
                para.append("&" + "\(urlEncode(key ))" + "=" + "\(urlEncode(value as! String))")
            }
            else
            {
                para.append("\(key)"+"\(value)")
            }
        }
        para.remove(at: para.startIndex)
        para.insert("?",at:para.startIndex)
        return para
    }
    
    fileprivate func getSignatureString()->String
    {
        var paramString = paramToString(true)
        paramString=paramString.substring(from: paramString.characters.index(paramString.startIndex, offsetBy: 1))
        var method=""
        if Url.range(of: "upload_file") != nil
        {
            method = "POST"
        }
        else
        {
            method = "GET"
        }
        let str="\(method)"+"&"+"\(urlEncode(Url))"+"&"+"\(urlEncode(paramString))"
        print(str)
        return str
    }
    
    open func  getTimeStamp()->String
    {
        let date = Date()
        let timeInterval = Int(date.timeIntervalSince1970)
        let str="\(timeInterval)"
        return str
    }
    
    open func  getOAuthNonce()->String
    {
        let uuid = UUID().uuidString
        let filter=uuid.replacingOccurrences(of: "-", with: "") as NSString
        let str=filter.substring(with: NSMakeRange(0, 32))
        return str.lowercased()
    }
    
    //hmac-sha1 加密,自带base64编码，替换特殊字符
    open func getSignature( _ sigstr:String,  key:String)->String
    {
        //print(sigstr,"sigstr")
        //print(key,"key")
        var hmacStr = sigstr.hmac(.sha1, key: key)
        //print(hmacStr,"hmacstr")
        return hmacStr
    }
    
    func dec2hex(_ num:UInt8) -> String {
        return String(format: "%X", num)
    }
    
    func urlEncode(_ str:String, other:String)->String//例如urlencode(".-_~+*")=".-_~%20%2B%2A"
    {
        var sb=""
        var strSpecial = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.~"+"\(other)"
        for character in str.characters
        {
            if strSpecial.characters.contains(character)
            {
                sb.append(character)
            }
            else
            {
                var temp="\(character)"
                for codeUnit in temp.utf8
                {
                    sb.append("%" + dec2hex(codeUnit) )
                }
            }
        }
        return sb
    }
}
