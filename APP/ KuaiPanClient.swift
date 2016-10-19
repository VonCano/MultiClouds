//
//  kuaipanclient.swift
//  nnetwork
//
//  Created by 段剀越 on 2016/4/24.
//  Copyright © 2016年 段剀越. All rights reserved.
//

import Foundation


open class KuaiPanClient//:NSObject,NSURLConnectionDataDelegate
{
    
    /// <summary>
    /// 参数
    /// </summary>
    //public var DiskID { get { return (int)Disk.Kuaipan; } }
    open var RootId:String
        {
        get
        {
            return ""
        }
    }
    open var HomeFolderPath:String=""
    open var MetaFolderPath:String=""
    fileprivate var UserAccount:String=""
    fileprivate var AppId=""//consumkey
    fileprivate var AppSecret=""//consymesecret
    static var token:Token?
    var urls=URLs()
    /// <summary>
    /// 构造函数
    /// </summary>
    /// <param name="app_id"></param>
    /// <param name="app_secret"></param>
    /// <param name="user_account"></param>
    
    init ( app_id:String, app_secret:String , user_account:String)
    {
        self.UserAccount = user_account;
        self.AppId = app_id;
        self.AppSecret = app_secret;
    }
    
    func  GetToken()->Token
    {
        return KuaiPanClient.token!
    }
    /// <summary>
    /// 获取临时的token
    /// </summary>
    /// <returns></returns>
    func requestToken()->Bool
    {
        
        let url = getUrl(urls.REQUESTTOKEN,args: nil,verify:"")
        print(url)
        var data:Data?
        //创建NSURL对象
        let myurl:URL! = URL(string: url)
        //创建请求对象
        let urlRequest:URLRequest = URLRequest(url: myurl)
        //响应对象
        var myresponse:URLResponse?
        var error:NSError?
        do{
            //发送请求
            
            data = try NSURLConnection.sendSynchronousRequest(urlRequest,
                returning: &myresponse)
            let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(str)

            
        }catch let error as NSError{
            //打印错误消息
            print(error.code)
            print(error.description)
        }
        //print ((myresponse as? NSHTTPURLResponse)!.statusCode)
        let json : AnyObject! = try? JSONSerialization
            .jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as AnyObject!
        
        //验证JSON对象可用性
        let oauth_token_secret  = json.object(forKey: "oauth_token_secret")! as! String
        let oauth_token  = json.object(forKey: "oauth_token")! as! String
        
        KuaiPanClient.token=Token(access_token: oauth_token, refresh_token: oauth_token_secret, expires: 1800)
            return true
        
    }
    //私用方法
    fileprivate func  getUrl( _ url:String, args:NSMutableDictionary?,verify:String)->String//SortedDictionary args
    {
        let o = OAuth1_0(consumer_key: self.AppId,consumer_secret: self.AppSecret);
        o.Url = url;
        o.Args = args;
        o.oauth_verifier=verify
        if (KuaiPanClient.token != nil)
        {
            print("token!=nil")
            o.oauth_token = KuaiPanClient.token!.accessToken
            o.oauth_token_secret = KuaiPanClient.token!.refreshToken
        }
        let str=o.getUrl()
        return str
    }
    //#endregion
    /// <summary>
    /// 生成获取Authorization code所用url
    /// </summary>
    /// <returns></returns>
    open func makeAuthorizationUrl()->String
    {
        if (requestToken()==true)
        {
            return "\(urls.AUTHORISE)"+"\(KuaiPanClient.token!.accessToken)"
        }
        else
        {
            return ""
        }
    }
    /// <summary>
    /// 获取token
    /// </summary>
    /// <param name="code"></param>
    /// <returns></returns>
    open func getAccessToken(_ code:String)->Bool
    {
        var url = getUrl(urls.ACCESSTOKEN, args: nil,verify:code)
        print(url)
        var data:Data?
        //创建NSURL对象
        let myurl:URL! = URL(string: url)
        //创建请求对象
        let urlRequest:URLRequest = URLRequest(url: myurl)
        //响应对象
        var myresponse:URLResponse?
        var error:NSError?

        do{
            //发送请求
            
            data = try NSURLConnection.sendSynchronousRequest(urlRequest,
                returning: &myresponse)
            //data=
            let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(str)
        }catch let error as NSError{
            //打印错误消息
            print(error.code)
            print(error.description)
        }
        let json : AnyObject! = try? JSONSerialization
            .jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as AnyObject!
        
        //验证JSON对象可用性
        let oauth_token_secret  = json.object(forKey: "oauth_token_secret")! as! String
        let oauth_token  = json.object(forKey: "oauth_token")! as! String
        let charged_dir = json.object(forKey: "charged_dir")! as! String
        let user_id = (json.object(forKey: "user_id")! as! NSNumber).intValue
        let expires_in = (json.object(forKey: "expires_in")! as! NSNumber).intValue
        KuaiPanClient.token=Token(access_token: oauth_token, refresh_token: oauth_token_secret, expires: expires_in)
        
        var kuaipanlaunchinfo=KuaiPanLaunchInfo(accessToken: oauth_token , refreshToken: oauth_token_secret, user_Id: user_id, charged_Dir: charged_dir)
        var save=SaveInfo()
        save.saveData(kuaipanlaunchinfo)
        return true

//        if (info == null) return false;
//        else
//        {
//            this.Token = new Token(info.oauth_token, info.oauth_token_secret, "-1");
//            if (this.Get_HomeAndMeta_Path("Meta"))
//            {
//                return true;
//            }
//            return false;
//        }
    }
    /// <summary>
    /// 更新token
    /// </summary>
    /// <param name="refToken"></param>
    /// <returns></returns>
//    public func GetRefreshToken(refToken:String)->Bool
//    {
//        //string[] arr = new string[2];
//        //arr=refToken.Split('/');
//        var arr=refToken.componentsSeparatedByString("/")
//        token =  Token(access_token: arr[0], refresh_token: arr[1], expires: "-1")
//        if (this.Get_HomeAndMeta_Path("Meta"))
//        {
//            return true;
//        }
//        return false;
//    }
    /// <summary>
    /// 获取用户信息
    /// </summary>
    /// <returns></returns>
    open func getUserInfo()->IperUserInfo?
    {
        var data:Data?
        //创建NSURL对象
    
        if (KuaiPanClient.token == nil)
        {return nil}
       // SortedDictionary<string, string> dt = new SortedDictionary<string, string>();
        let url = getUrl("http://openapi.kuaipan.cn/"+"1"+"/account_info", args: nil,verify: "")
        
        let myurl:URL! = URL(string: url)
        //创建请求对象
        let urlRequest:URLRequest = URLRequest(url: myurl)
        //响应对象
        var myresponse:URLResponse?
        var error:NSError?

        do{
            //发送请求
            
            data = try NSURLConnection.sendSynchronousRequest(urlRequest,
                returning: &myresponse)
            let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(str)
            if (myresponse as! HTTPURLResponse).statusCode != 200
            {
                return nil
            }
          
        }catch let error as NSError{
            //打印错误消息
            print(error.code)
            print(error.description)
        }
        let json : AnyObject! = try? JSONSerialization
            .jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as AnyObject!
        
        
        //验证JSON对象可用性
        let user_Name  = json.object(forKey: "user_name")! as! String
        
        let quota_Total = (json.object(forKey: "quota_total")! as! NSNumber).intValue
        
        let quota_Used = (json.object(forKey: "quota_used")! as! NSNumber).intValue
        print(user_Name)
        return  IperUserInfo(diskname: "user_Name", total: quota_Total, used: quota_Used);
    }
//    /// <summary>
//    /// 返回主目录路径
//    /// </summary>
//    /// <returns></returns>
//    public string Return_Home_Path()
//    {
//    return this.HomeFolderPath;
//    }
//    /// <summary>
//    /// 返回元数据文件夹的路径
//    /// </summary>
//    /// <returns></returns>
//    public string Return_Meta_Path()
//    {
//    return this.MetaFolderPath;
//    }
//    /// <summary>
//    /// 获取元数据文件夹的路径
//    /// </summary>
//    /// <param name="folder_name"></param>
//    /// <returns></returns>
//    public func Get_HomeAndMeta_Path(folder_name:String)->Bool
//    {
//        ErrType et = this.GetMeta(this.RootId + "/"+this.UserAccount+"/" + folder_name);
//        if (et == ErrType.NoErr)
//        {
//            this.HomeFolderPath = this.RootId + "/" + this.UserAccount;
//            this.MetaFolderPath = this.RootId + "/" + this.UserAccount + "/" + folder_name;
//            return true;
//        }
//        else if (et <= ErrType.FileOrPathErr)
//        {
//            et = this.CreateFolder(this.RootId+"/"+this.UserAccount, folder_name);
//            if (et == ErrType.NoErr)
//            {
//                this.HomeFolderPath = this.RootId + "/" + this.UserAccount;
//                this.MetaFolderPath = this.RootId + "/" + this.UserAccount + "/" + folder_name;
//                return true;
//            }
//            else return false;
//        }
//        else return false;
//    }
//    /// <summary>
//    /// 获取单个文件信息
//    /// </summary>
//    /// <param name="path"></param>
//    /// <returns></returns>
//    public func GetMeta(string path) throws // throws 来标明将会抛出异常,使用throw扔出异常
//    {
//        if (this.Token == null) return ErrType.Fault;
//        SortedDictionary<string, string> dt = null;
//        string root = "app_folder";
//        string url = this.GetUrl(string.Format(URLs.METADATA, URLs.Version, root, Make.UrlEncode(path.Trim('/'), "/")), dt);
//        HttpHelper hp = new HttpHelper(url, Method.GET);
//        HttpResponse Response = hp.Do();
//        ErrType et = this.HandleResponse(Response, Operation.Query);
//        return et;
//    }
//    /// <summary>
//    /// 新建文件夹
//    /// </summary>
//    /// <param name="parent_path"></param>
//    /// <param name="name"></param>
//    /// <returns></returns>
//    public ErrType CreateFolder(string parent_path, string name)
//    {
//    if (this.Token == null) return ErrType.Fault;
//    string Path=parent_path+"/"+name;
//    SortedDictionary<string, string> dt = new SortedDictionary<string, string>();
//    dt.Add("root", "app_folder");
//    dt.Add("path", Path);
//    string url = this.GetUrl(string.Format(URLs.CREATEFOLDER, URLs.Version), dt);
//    HttpHelper hp = new HttpHelper(url,Method.GET,0);
//    HttpResponse Response=hp.Do();
//    ErrType et = HandleResponse(Response, Operation.Mkdir);
//    return et;
//    }
//    /// <summary>
//    /// 删除文件
//    /// </summary>
//    /// <param name="parent_path"></param>
//    /// <param name="name"></param>
//    /// <returns></returns>
//    public ErrType Delete(string parent_path, string name)
//    {
//    if (this.Token == null) return ErrType.Fault;
//    string Path = parent_path + "/" + name;
//    SortedDictionary<string, string> dt = new SortedDictionary<string, string>();
//    dt.Add("root", "app_folder");
//    dt.Add("path", Path);
//    dt.Add("to_recycle", "True");
//    string url = this.GetUrl(string.Format(URLs.DELETE, URLs.Version), dt);
//    HttpHelper hp = new HttpHelper(url, Method.GET, 0);
//    HttpResponse Response = hp.Do();
//    ErrType et = HandleResponse(Response, Operation.Delete);
//    return et;
//    }
//    /// <summary>
//    /// 获取文件上传地址
//    /// </summary>
//    /// <returns></returns>
    open func  getUploadLocate()->String?
    {
        if (   KuaiPanClient.token == nil)
        {
            return nil
        }
        //SortedDictionary<string, string> dt = new SortedDictionary<string, string>();
        let dt=NSMutableDictionary()
        //dt.Add("source_ip", "");
        dt["source_ip"]=""
        let url = getUrl("http://api-content.dfs.kuaipan.cn/"+"1"+"/fileops/upload_locate",args: nil,verify: "")

        var data:Data?
        let myurl:URL! = URL(string: url)
        //创建请求对象
        let urlRequest:URLRequest = URLRequest(url: myurl)
        //响应对象
        var myresponse:URLResponse?
        var error:NSError?
        
        do{
            //发送请求
            
            data = try NSURLConnection.sendSynchronousRequest(urlRequest,
                returning: &myresponse)
            let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(str)
            if (myresponse as! HTTPURLResponse).statusCode != 200
            {
                return nil
            }
            
        }catch let error as NSError{
            //打印错误消息
            print(error.code)
            print(error.description)
        }
        let json : AnyObject! = try? JSONSerialization
            .jsonObject(with: data!, options:JSONSerialization.ReadingOptions.allowFragments) as AnyObject!
        let info=json.object(forKey: "url") as! String
        print("upload",info)
        return info
    }
//    /// <summary>
//    /// 快速上传
//    /// </summary>
//    /// <param name="parent_path"></param>
//    /// <param name="filename"></param>
//    /// <param name="data"></param>
//    /// <returns></returns>
    open func uploadFast( _ parent_path:String,  filename:String,uploadInfo:String)->String?
    {
        if (KuaiPanClient.token == nil)
        {
            return nil
        }
        let  path = parent_path+filename
        let dt=NSMutableDictionary()
        dt["root"] = "app_folder"
        dt["path"] = path
        dt["overwrite"] = "True"
        let uploadUrl = uploadInfo
        if (uploadUrl as NSString).length == 0
        {
            return nil
        }
        //var url = getUrl(string.Format(URLs.UPLOAD_FILE, URLs.Version, uploadUrl), dt);
        let url = getUrl(uploadUrl+"1"+"/fileops/upload_file", args: dt, verify: "")
        
//    MakeTable Form = new MakeTable();
//    Form.AddStreamFile("file", filename, data);
//    Form.PrepareFormData();
//    string ContentType = "multipart/form-data; boundary=" + Form.Boundary;
//    HttpHelper Hp = new HttpHelper(Url, Method.POST, 0, "", ContentType);
//    Hp.PostDataByte = Form.GetFormData();
//    HttpResponse Response = Hp.Do();
//    ErrType et = this.HandleResponse(Response, Operation.Upload);
        let fileUrl = URL(fileURLWithPath: "/Users/duankaiyue/Desktop/2016.png")
        let imageData = try! Data(contentsOf: fileUrl)
        var fileRead:InputStream?
        var length = 0
        var imgBin=[UInt8]()
        var fileBuf = [UInt8]() //读取缓冲区
        fileRead = InputStream(data: imageData)
        fileRead!.open()
        while (true)
        {
            length = fileRead!.read(&fileBuf, maxLength: fileBuf.count)//将数据读取到缓冲区filebuf
            if length>0
            {
                imgBin.append(contentsOf: fileBuf)
            }
            else
            {
                break
            }
        }
        
        var data:Data?
        let myurl:URL! = URL(string: url)
        //创建请求对象
       
        let request = NSMutableURLRequest(url: myurl!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 30.0)
        request.httpMethod = "POST"
        var host=uploadInfo.substring(from: (uploadInfo.range(of: "http://")?.upperBound)!)
        let Args=NSMutableDictionary()
        Args["Accept-Encoding"]="identity"
    Args["Host"]="p11.dfs.kuaipan.cn"//.substringToIndex(host.endIndex.advancedBy(-1))
        Args["Content-Type"]="multipart/form-data; boundary=----------ThIs_Is_tHe_bouNdaRY_$"
        //Args["boundary"]="ThIs_Is_tHe_bouNdaRY_$"
        Args["Connection"]="close"
        Args["User-Agent"]="Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13B5119e"
        //Args["Content-Length"]="\(imageData.length)"
        

        //request.addValue("1.1", forHTTPHeaderField: "HTTP")
        let sortedKeys = (Args.allKeys as! [String]).sorted(by: <)
        for key in sortedKeys
        {
            let value=Args[key]
//            str.appendContentsOf(value as! String)
//            str.appendContentsOf(":")
//            str.appendContentsOf(key as! String)
//            str.appendContentsOf("\r\n")
            request.addValue(value as! String, forHTTPHeaderField: key )
        }
//        request.addValue("multipart/form-data;boundary=----------ThIs_Is_tHe_bouNdaRY_$", forHTTPHeaderField:"Content-Type")
//        request.addValue(uploadInfo.substringFromIndex((uploadInfo.rangeOfString("http://")?.endIndex)!), forHTTPHeaderField: "Host")
        let body:NSMutableData = NSMutableData();
        //设置表单分隔符
        let boundary:NSString = "----------ThIs_Is_tHe_bouNdaRY_$";
//        var host="Host:"+uploadInfo+"\r\n"
//        var contentType = NSString(format: "multipart/form-data;boundary=%@", boundary)
 //       body.appendData(NSString(format: "\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!);
        
        
        //写入Info内容
        
        body.append(NSString(format: "--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!);
        //body.appendData(NSString(format: "Content-Disposition:form-data;name=\"%@\"\r\n\n","1.png").dataUsingEncoding(NSUTF8StringEncoding)!)
        
        //写入图片内容
        //body.appendData(host.dataUsingEncoding(NSUTF8StringEncoding)!)
        // body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
       
       /// body.appendData(NSString(format: "----------%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!);
        body.append(NSString(format: "Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", "file", "pic1.png").data(using: String.Encoding.utf8.rawValue)!);
        body.append("Content-Type:application/octet-stream\r\n\r\n".data(using: String.Encoding.utf8)!)
        
        
       //body.appendBytes(imgBin, length: imgBin.count)
        body.append(imageData)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        
        //写入尾部
        body.append(NSString(format: "--%@--\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!);
        request.httpBody = body as Data;
        //发送请求
        var urlResponse:URLResponse? = nil;
        var error:NSError?

        print("Request",request)
    
        do{
            //发送请求
            
            data = try NSURLConnection.sendSynchronousRequest(request as URLRequest,
                returning: &urlResponse)
            let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("str",str)
            if (urlResponse as! HTTPURLResponse).statusCode != 200
            {
                return nil
            }
            
        }catch let error as NSError{
            //打印错误消息
            print(error.code)
            print(error.description)
        }

       
        


//        let fileUrl = NSURL(fileURLWithPath: "/Users/duankaiyue/Desktop/2016.png")
//        var imageData = NSData(contentsOfURL:fileUrl)!
//        print(imageData.length)
//        do {
//            let opt = try HTTP.POST(url, parameters: ["filename": parent_path, "file": Upload(fileUrl: fileUrl)])
//            opt.start
//            {
//                response in
//                print("upload")
//                //let resp = Response(JSONDecoder(response.data))
//            }
//        } catch let error {
//            print("got an error creating the request: \(error)")
//        }
    return "done"
    
    }
//    /// <summary>
//    /// 强制上传
//    /// </summary>
//    /// <param name="parent_path"></param>
//    /// <param name="filename"></param>
//    /// <param name="data"></param>
//    /// <returns></returns>
//    public ErrType UploadForce(string parent_path, string filename, byte[] data)
//    {
//    if (this.Token == null) return ErrType.Fault;
//    string Path = parent_path + "/" + filename;
//    SortedDictionary<string, string> dt = new SortedDictionary<string, string>();
//    dt.Add("root", "app_folder");
//    dt.Add("path", Path);
//    dt.Add("overwrite", "True");
//    string UploadUrl = this.GetUploadLocate();
//    if (UploadUrl == null)
//    {
//    return ErrType.Fault;
//    }
//    string Url = this.GetUrl(string.Format(URLs.UPLOAD_FILE, URLs.Version, UploadUrl), dt);
//    MakeTable Form = new MakeTable();
//    Form.AddStreamFile("file", filename, data);
//    Form.PrepareFormData();
//    string ContentType = "multipart/form-data; boundary=" + Form.Boundary;
//    HttpHelper Hp = new HttpHelper(Url, Method.POST, 0, "", ContentType);
//    Hp.PostDataByte = Form.GetFormData();
//    HttpResponse Response = Hp.Do();
//    ErrType et = this.HandleResponse(Response, Operation.Upload);
//    return et;
//    }
//    /// <summary>
//    /// 下载文件
//    /// </summary>
//    /// <param name="parent_path"></param>
//    /// <param name="filename"></param>
//    /// <param name="sm"></param>
//    /// <returns></returns>
//    public ErrType DownLoad(string parent_path, string filename, out Stream sm)
//    {
//    if (this.Token == null) { sm = null; return ErrType.Fault; }
//    string Path = parent_path + "/" + filename;
//    SortedDictionary<string, string> dt = new SortedDictionary<string, string>();
//    dt.Add("root", "app_folder");
//    dt.Add("path", Path);
//    string Url = this.GetUrl(string.Format(URLs.DOWNLOAD_FILE, URLs.Version), dt);
//    HttpHelper Hp = new HttpHelper(Url,Method.GET,0);
//    HttpResponse Response = Hp.Download();
//    if (Response == null) { sm = null; return ErrType.Fault; }
//    else
//    {
//    sm = Response.DownloadStream;
//    ErrType et = HandleResponse(Response, Operation.Download);
//    return et;
//    }
//    }
//    public ErrType HandleResponse(HttpResponse response, Operation op)
//    {
//    //if (response == null) return ErrType.NoErr;
//    if (response == null) return ErrType.Fault;
//    ErrType ot;
//    int code = (int)response.StatusCode;
//    if (code == (int)HttpStatusCode.OK)
//    {
//    return ot = ErrType.NoErr;
//    }
//    int errno = (int)code;
//    switch (errno)
//    {
//    case 401: ot = ErrType.AuthoriseErr; break;
//    case 403:
//    if (op == Operation.Move || op == Operation.Mkdir)
//    ot = ErrType.FileExisted;
//    else
//    ot = ErrType.FileOrPathErr;
//    break;
//    case 404:
//    if (op == Operation.Query)
//    ot = ErrType.FileNotFound;
//    else
//    ot = ErrType.FileOrPathErr;
//    break;
//    case 405:
//    if (op == Operation.Upload)
//    ot = ErrType.PathNotExist;
//    else
//    ot = ErrType.FileOrPathErr;
//    break;
//    default: ot = ErrType.Fault; break;
//    }
//    return ot;
//    }
}
