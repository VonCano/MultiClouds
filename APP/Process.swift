//
//  Process.swift
//  APP
//
//  Created by 段剀越 on 15/12/15.
//  Copyright © 2015年 段剀越. All rights reserved.
//

import UIKit
import Foundation
import CoreGraphics
//import AssetsLibrary

class Process: UIViewController,UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
    


    static var setKuaiPan=false
    var resultOfRaid5Encode=[[[UInt8]]]()
    
    var dataModel = DataModel()
    var plistName=[String]()
     var fileNum=0
    var imgData=NSMutableData()
    var diskNum = 0//被选中盘的个数
    var showDisk=[Int]()
    var flag = [Int](repeating: 0, count: 9) //记录那些盘被选中
    @IBOutlet weak var iv: UIImageView!
    @IBOutlet var diskSet: [UIButton]!
    var imageURL=URL(string:"")
    var localPath=""
    var finalSize=0 //补0之前，即做完AONT后文件大小
    var chunkSize=0
    var recordaddr=NSHomeDirectory()+"/Documents/record.txt"
    var placeHolderSize=0//补了几个零
    var fileType=""//是png还是jpg
    var resultOfAONT=NSData()
    var root = DKY_FileDir()
    var isDownLoad=false
    
    @IBAction func choosePic(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //初始化图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //指定图片控制器类型
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            //设置是否允许编辑
            //picker.allowsEditing = editSwitch.on
            //弹出控制器，显示界面
            self.present(picker, animated: true, completion: nil)
        }else{
            print("读取相册错误")
        }
 
       
    }
    //选择图片成功后代理
    func imagePickerController(_ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let type:String = (info[UIImagePickerControllerMediaType]as!String)
        //当选择的类型是图片
        if type=="public.image"
        {
            //获取选择的原图
            
//            var str = info[UIImagePickerControllerReferenceURL] as? String
            
            let img = info[UIImagePickerControllerOriginalImage]as?UIImage
            iv.image = img
            imgData = UIImageJPEGRepresentation(img!,1.0) as! NSMutableData
            print(imgData.length)
            picker.dismiss(animated:true, completion:nil)
            fileType="JPG"
        }
        
        
        
//        
//        
//        
//            //查看info对象
//            imageURL = info[UIImagePickerControllerReferenceURL] as! URL
//            //print(imageURL)
//           // var assetsLibrary =  ALAssetsLibrary()
//            
//            let imageName = URL(fileURLWithPath: imageURL!.path).lastPathComponent
//            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as String
//             localPath = documentDirectory + imageName
//            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//            print(localPath)
//            picker.dismiss(animated: true, completion: nil)
//            //获取选择的原图
//            //let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//            iv.image = image
//            var temp = UIImageJPEGRepresentation(image, 1.0)            //图片控制器退出
//            picker.dismiss(animated: true, completion: nil)
//          
           // imgCryptology(image,localPath)
    }

    
    
    func imgCryptology( _ image:UIImage, _ imagePath:String)
    {
        //把获取的照片转化为NSData
        //var imgData:NSData
        let index = imagePath.index(imagePath.endIndex, offsetBy: -3)
        let suffix = imagePath.substring(from: index)
        print("这是"+"\(suffix)"+"格式")
        fileType=suffix

        if suffix == "JPG"
        {
            var temp = UIImageJPEGRepresentation(image, 1.0)
            imgData = temp as! NSMutableData
        }
        else
        {
            var temp = UIImagePNGRepresentation(image)
            imgData = temp as! NSMutableData
        }
        print("imgData（原始数据）"+"\(imgData.length)")
      
    }
    @IBAction func uploadPic(_ sender: UIButton)
    {

         isDownLoad=false
        //self.performSegueWithIdentifier("system", sender: self)
        //return
        
//        print("imgData.length"+"\(imgData.length)")
//        diskNum=0
//        var recordOfDisk=[UInt8]()//记录下选择的网盘
//        var recordOfDiskData=NSData()
//        for i in 0..<flag.count
//        {
//            if flag[i] == 1
//            {
//                
//                recordOfDisk.append(UInt8(i))
//                print(recordOfDisk)
//                recordOfDiskData=NSData(bytes: &recordOfDisk, length: recordOfDisk.count)
//                print(recordOfDiskData)
//                
//                
//            }
//        }
//        recordOfDiskData.writeToFile(NSHomeDirectory()+"/Documents/record.plist", atomically: true)
        if imgData.length<=0
        {
            let alert = UIAlertController(title: "Alert", message: "必须选择文件才能上传！", preferredStyle: UIAlertControllerStyle.alert)
            //如果点击按钮有操作，删掉handler和nil，把下面注释符号去掉，in后面写代码
            alert.addAction(UIAlertAction(title: "好！", style: UIAlertActionStyle.destructive,handler : nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
//            var manager=NSFileManager.defaultManager()
//            var path=NSHomeDirectory()+"/Documents/record.plist"
//            if manager.fileExistsAtPath(path)
//            {
//                diskNum=0
//                var recordOfDiskData=NSData(contentsOfFile: path)!
//                let buffer = UnsafeBufferPointer<UInt8>(start:UnsafePointer<UInt8>( recordOfDiskData.bytes), count: recordOfDiskData.length)
//                var intData = [UInt8]()//读取用户之前选择的网盘
//                intData.reserveCapacity( recordOfDiskData.length)
//                for i in 0..<recordOfDiskData.length
//                {
//                    intData.append(UInt8(buffer[i]))
//                }
//                for i in intData
//                {
//                    showDisk.append(Int(i))
//                    diskNum+=1
//                }
//            }
//            showDisk=[Int]()
            if diskNum != 3
            {
                let alert = UIAlertController(title: "Alert", message: "必须选择3块网盘才能上传！", preferredStyle: UIAlertControllerStyle.alert)
            //如果点击按钮有操作，删掉handler和nil，把下面注释符号去掉，in后面写代码
                alert.addAction(UIAlertAction(title: "好！", style: UIAlertActionStyle.destructive,handler : nil))
           // alertController.delete(self)
            // alertContr
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                if Process.setKuaiPan==true//授权了快盘
                {
                    picHandler()
                }
                else
                {
                    if flag[0]==1//选了快盘
                    {
                        Process.setKuaiPan=true
                        //self.performSegueWithIdentifier("applyKuaiPan", sender: self)
                         let vc=self.storyboard?.instantiateViewController(withIdentifier: "kp") as! KuaiPanClientVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else
                    {
                        picHandler()
                    }
                }
                
            }
        }
    }
    func picHandler()
    {//self.performSegueWithIdentifier("system", sender: self)
        for i in 0 ..< 9
        {
            if flag[i] == 1
            {print(i)}
        }

        print("图片上传")
        var data=imgData.subdata(with: NSMakeRange(0,imgData.length))
        var anot = AONT()
        resultOfAONT=anot.encrypt(data as NSData,diskNum:diskNum)
        var splitfile=SplitFile()
        finalSize=resultOfAONT.length
        print("resultOfAONT:"+"\(resultOfAONT.length)")
        var resultOfSplit=splitfile.split(resultOfAONT,diskNum:diskNum)//第一个返回值是 [[[UInt8]]]，第二个是chunk_size
        chunkSize=resultOfSplit.1
        placeHolderSize=resultOfSplit.2
        var raid5 = Raid5()
        fileNum=resultOfSplit.0.count
        for i in 0 ... (resultOfSplit.0.endIndex-1)//resultOfSplit.0.endIndex个stripe
        {
            var temp = resultOfSplit.0[i]
            resultOfRaid5Encode.append(raid5.encode(temp, chunk_size: chunkSize))

        }
        var saveFile=SaveFile()
        saveFile.save(resultOfRaid5Encode,diskNo: getDisk())
        showDisk=[Int]()
        plistName=saveFile.getPlistName()
        var vc=self.storyboard?.instantiateViewController(withIdentifier: "l") as! ViewController
        //优先载入之前的文件结构
        dataModel.loadData()
        vc.setData(dataModel.file)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func downloadPic(_ sender: UIButton) {
        print("图片下载")
        isDownLoad=true
        var vc=self.storyboard?.instantiateViewController(withIdentifier: "l") as! ViewController
        dataModel.loadData()
        vc.setData(dataModel.file)
        
        self.navigationController?.pushViewController(vc, animated: true)
       
    }
    
    @IBAction func chooseDisk(_ sender: UIButton) {
        diskNum=0
       let a = self.diskSet.index(of: sender)!
        flag[a] ^= 1
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.diskSet[a].alpha = (self.flag[a] == 1 ) ? 1.0 : 0.20}) 
        for i in 0..<flag.count
        {
            if flag[i] == 1
            {
                diskNum += 1
            }
        }
    }
    func getDisk()->[Int]
    {
//        var manager=NSFileManager.defaultManager()
//        var path=NSHomeDirectory()+"/Documents/record.plist"
//        if manager.fileExistsAtPath(path)
//        {
//            diskNum=0
//            var recordOfDiskData=NSData(contentsOfFile: path)!
//            let buffer = UnsafeBufferPointer<UInt8>(start:UnsafePointer<UInt8>( recordOfDiskData.bytes), count: recordOfDiskData.length)
//            var intData = [UInt8]()//读取用户之前选择的网盘
//            intData.reserveCapacity( recordOfDiskData.length)
//            for i in 0..<recordOfDiskData.length
//            {
//                intData.append(UInt8(buffer[i]))
//            }
//            for i in intData
//            {
//                showDisk.append(Int(i))
//                diskNum+=1
//            }
//        }
//        else
//        {
            for i in 0..<flag.count
            {
                if flag[i] == 1
                {
                    showDisk.append(i)
                }
            }
//            var recordOfDisk=[UInt8]()//记录下选择的网盘
//            for i in showDisk
//            {
//                recordOfDisk.append(UInt8(i))
//            }
//            print(recordOfDisk)
//            var recordOfDiskData=NSData(bytes: &recordOfDisk, length: recordOfDisk.count)
//            print(recordOfDiskData)
//            recordOfDiskData.writeToFile(path, atomically: true)
//        }
        return showDisk
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(NSHomeDirectory())
        var root = DKY_FileDir()
        var isDownLoad=false
        
        var manager=FileManager.default
        var dataFilePath=DataModel()
       
        // Do any additional setup after loading the view.
        if manager.fileExists(atPath: dataModel.dataFilePath()) == false
        {
            print("没找到")
            var pic1 = DKY_FileDir()
            pic1.name="示例文件0"
            pic1.filePath.append("/"+pic1.name)
            pic1.createTime=getTime()
                pic1.metadata.name="示例文件1"
                pic1.metadata.size=123456
                pic1.metadata.ID="2120150457"
            
                pic1.metadata.chunk_size=512
                pic1.metadata.diskNo={
                ()->[Int] in
                var temp=[Int]()
                for i in 0..<flag.count
                {
                    if flag[i] == 1
                    {temp.append(i)}
                }
                return temp
                }()
                pic1.metadata.plistName=[String]()
                pic1.metadata.subFileNum=5
                pic1.metadata.fileType="jpg"
                pic1.metadata.placeHolderSize=101
            pic1.createTime=getTime()
            
            var rootOfPic = DKY_FileDir()
        
            rootOfPic.name="照片"
            rootOfPic.filePath.append("/"+rootOfPic.name)
            rootOfPic.celldata.add(pic1)
            rootOfPic.createTime=getTime()
            pic1.filePath.insert(String(rootOfPic.filePath)  , at: 0)
            root.celldata.add(rootOfPic)
       
            dataModel.saveData(root)
        }
        else
        {
            print("找到")
            dataModel.loadData()
        }
//        var path=NSHomeDirectory()+"/Documents/record.plist"
//        if manager.fileExistsAtPath(path)
//        {
//            var data=NSData(contentsOfFile: path)!
//            let buffer = UnsafeBufferPointer<UInt8>(start:UnsafePointer<UInt8>(data.bytes), count:data.length)
//            var intData = [UInt8]()//读取用户之前选择的网盘
//            intData.reserveCapacity(data.length)
//            for i in 0..<data.length
//            {
//                intData.append(UInt8(buffer[i]))
//            }
//            for i in intData
//            {
//                diskSet[Int(i)].alpha=1.0
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setDataRoot(_ ro: DKY_FileDir){
        self.root=ro
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func getTime()->String
    {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = " yyyy-MM-dd 'at' HH/mm/ss.sss"
        let strNowTime = timeFormatter.string(from: date) as String
        return strNowTime
    }
    

}
