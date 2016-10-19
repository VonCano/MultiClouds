//
//  ViewController.swift
//  APP
//
//  Created by 段剀越 on 15/12/12.
//  Copyright © 2015年 段剀越. All rights reserved.
//

import UIKit


class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate
{
    var oneData:AnyObject?
    var click=false
    var dirCount=0
    var fileCount=0
    let longPress=UILongPressGestureRecognizer()
    var indexRow=0
    
    var dataModel = DataModel()
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var diskTableView: UITableView!
    @IBAction func save(_ sender
        : UIButton) {
            fileCount += 1
            var vc : ViewController
            var process=Process()
            var newFile=DKY_FileDir()
            newFile.name="Pic"+"\(fileDirObject.celldata.count)"
            newFile.filePath.append("/"+newFile.name)
            fileDirObject.celldata.add(newFile)
            newFile.filePath.insert( String(fileDirObject.filePath), at: 0)
            newFile.createTime=getTime()
            for vc in (self.navigationController?.viewControllers)!{
                if vc.isKind(of: Process.self){
                    
                    newFile.metadata.name=(vc as! Process).localPath
                    newFile.metadata.ID="2120150457"
                    newFile.metadata.size = (vc as! Process).finalSize //补0之前，即做完AONT后文件大小
                    newFile.metadata.chunk_size=(vc as! Process).chunkSize
                    newFile.metadata.diskNo=(vc as! Process).getDisk()
                    (vc as! Process).showDisk=[Int]()
                    newFile.metadata.createTime=getTime()
                    newFile.metadata.plistName=(vc as! Process).plistName
                    (vc as! Process).plistName=[String]()
                    newFile.metadata.subFileNum=newFile.metadata.plistName.count/3
                    (vc as! Process).fileNum=0
                    newFile.metadata.placeHolderSize=(vc as! Process).placeHolderSize
                    (vc as! Process).placeHolderSize=0
                    newFile.metadata.fileType=(vc as! Process).fileType
                    (vc as! Process).fileType=""
                    //(vc as! Process).imgData=NSMutableData()
                    print("subFile",newFile.metadata.subFileNum)
                }
            }
            

                            diskTableView.reloadData()
            print("当前有:"+"\(fileDirObject.celldata.count)")
            print("newfile path:"+"\(newFile.filePath)")
            click=true
            sender.isEnabled=false
            
            
            //find  root in Process
            for vc in (self.navigationController?.viewControllers)!{
                if vc.isKind(of: Process.self){
                    
                    dataModel.saveData((vc as! Process).dataModel.file)
                }
            }
            
            
    }
    
    @IBAction func createDir(_ sender: UIButton)
    {
        dirCount += 1
        var pic1 = DKY_FileDir()
        pic1.name="示例文件"
        pic1.filePath.append("/"+pic1.name)
        
        
        var newDir=DKY_FileDir()
        newDir.name="新建目录"+"\(dirCount)"
        newDir.filePath.append("/"+newDir.name)
        newDir.celldata.add(pic1)
        

        fileDirObject.celldata.add(newDir)
        newDir.filePath.insert( String(fileDirObject.filePath), at: 0)
        pic1.filePath.insert(String(newDir.filePath)  , at: 0)
        diskTableView.reloadData()
        
        print("当前有:"+"\(fileDirObject.celldata.count)")
        print("newDir path:"+"\(newDir.filePath)")
        
        var vc : ViewController
        for vc in (self.navigationController?.viewControllers)!{
            if vc.isKind(of: Process.self){
                
                dataModel.saveData((vc as! Process).dataModel.file)
            }
        }


    }
    var celldata:NSMutableArray=["快盘","微盘","SkyDrive", []]
    var cellimg=["kuaipan","vdisk","skydrive"]
    var fileDirObject=DKY_FileDir()

    @IBAction func downLoad(_ sender: UIButton)
    {
        var missDiskName=getFileInfo(oneData!)
        if oneData==nil
        {
            let downLoadAlert = UIAlertController(title: "Alert", message: "必须选择文件才能下载！", preferredStyle: UIAlertControllerStyle.alert)
            //如果点击按钮有操作，删掉handler和nil，把下面注释符号去掉，in后面写代码
            downLoadAlert.addAction(UIAlertAction(title: "好！", style: UIAlertActionStyle.destructive,handler : nil))
            self.present(downLoadAlert, animated: true, completion: nil)
            
        }
        else
        {
            var missDisk=getFileInfo(oneData!)
            print("故障盘",missDisk)//检查有无故障
            
            var read=ReadFile()
            var result=read.read(oneData!.metadata.plistName, missDiskName: missDisk, chunkSize: oneData!.metadata.chunk_size, diskNo: oneData!.metadata.diskNo, subFileNo: oneData!.metadata.subFileNum)
            var raid5=Raid5()
            var mergeFile=MergeFile()
            var aont=AONT()
            var resultOfRaid5=[[[UInt8]]]()
            var resultOfMerge=Data()
            var originalImg=Data()
            print("failureNo",result.0)
            if result.0 == -1
            {
                for i in result.1
                {
                    resultOfRaid5.append(raid5.decode(i, chunk_size: oneData!.metadata.chunk_size, failureDiskNo: i.count-1))
                }
            }
            else
            {
                for i in result.1
                {
                    resultOfRaid5.append(raid5.decode(i, chunk_size: oneData!.metadata.chunk_size, failureDiskNo: result.0))
                }
            }
            resultOfMerge=mergeFile.merge(resultOfRaid5,  placeHolderSize: oneData!.metadata.placeHolderSize)
            originalImg = aont.decrypt(resultOfMerge as NSData) as Data
             try? originalImg.write(to: URL(fileURLWithPath: NSHomeDirectory()+"/Documents/"+getTime()+"."+oneData!.metadata.fileType), options: [.atomic])

        }

    }
    
    func testRaid5(_ resultOfRaid5:[[[UInt8]]],missRow:Int)->Bool
    {
        var chunk=0
        var myflag=0
        var originalValue=[[[UInt8]]]()
        for vc in (self.navigationController?.viewControllers)!{
            if vc.isKind(of: Process.self){
                originalValue = (vc as! Process).resultOfRaid5Encode
                print( (vc as! Process).resultOfRaid5Encode.count)
                chunk =  (vc as! Process).chunkSize
            }
        }
        print("originalValue.count:"+"\(originalValue.count)")
        print("result.count:"+"\(resultOfRaid5.count)")
        var count=0
        if originalValue.count == resultOfRaid5.count//子文件数目相同
        {
            for i in 0 ... (originalValue.endIndex-1)//遍历每个字文件
            {
                var temp1 = originalValue[originalValue.endIndex-1]//原始一个子文件
                var temp2 = resultOfRaid5[originalValue.endIndex-1]//raid5后一个子文件
                print("temp1.count"+"\(temp1.count)")
                print("temp2.count"+"\(temp2.count)")
                print("这是第"+"\(i)"+"个子文件")
                
                if  temp1.count == temp2.count//每个子文件有相同的行数
                {
                    for i in 0..<temp1.count//遍历每个子文件的行
                    {
                        myflag=0
                        for j in 0 ..< oneData!.metadata.chunk_size//遍历每一列
                        {
                            if temp1[i][j]==temp2[i][j]
                            {
                                myflag+=0
                                
                                
                            }
                            else
                            {
                                myflag+=1
                                
                            }
                        }
                        print("这是第"+"\(i)"+"行","有"+"\(myflag)"+"个错误")
                        count+=myflag
                    }
                    
                }
            }
        }
        if missRow == resultOfRaid5[0].count-1 || count==0
        {
            return true
        }
        else
        {
            return false
        }

    }
    
    
    func getFileInfo(_ fileInfo:AnyObject)->String
    {
        print(NSHomeDirectory())
        //第一个是网盘名字，第二个是文件的创建时间
        let No=(fileInfo as! DKY_FileDir).metadata.diskNo
        var diskName:Dictionary<Int,String> = [0:"金山快盘",1:"百度云盘",2:"dropbox",3:"skydrive",4:"新浪微盘",5:"360云盘",6:"GoogleDrive",7:"网易网盘",8:"腾讯微云"];
        var name=[String]()
        var subFileNum=(fileInfo as! DKY_FileDir).metadata.subFileNum
        let plistName=(fileInfo as! DKY_FileDir).metadata.plistName
        //var splitNum=(fileInfo as! DKY_FileDir).metadata.splitNum
        for i in No//查找网盘名字
        {
            name.append(diskName[i]!)
            print(name)
        }
        var path=NSHomeDirectory()+"/Documents/"
        let manager=FileManager.default
       
        for diskName in name
        {
            path=NSHomeDirectory()+"/Documents/"
//            path=path+diskName+"/"
//            print(path)
            for str in plistName
            {
                print("examinate",str)
                if str.hasPrefix(diskName)
                {
                    if manager.fileExists(atPath: path+str+".plist")
                    {
                        continue
                    }
                    else
                    {
                        return diskName
                    }
                }
            }
        }
        return "OK"
    }
    
    func deleteFile()
    {
        let manager=FileManager.default
        var path=""
        if (oneData as! DKY_FileDir).celldata.count>0
        {
            for data in (oneData as! DKY_FileDir).celldata//对于每一个文件
            {
                for str in (data as AnyObject).metadata.plistName
                {
                    path=NSHomeDirectory()+"/Documents/"+str+".plist"
                    if manager.fileExists(atPath: path)
                    {
                        do
                        {
                            try manager.removeItem(atPath: path)
                        }
                        catch let error as NSError
                        {
                            print( error)
                        }
                    }
                }
            }
        }
        else
        {
            for str in (oneData as! DKY_FileDir).metadata.plistName
            {
                path=NSHomeDirectory()+"/Documents/"+str+".plist"
                if manager.fileExists(atPath: path)
                {
                    do
                    {
                        try manager.removeItem(atPath: path)
                    }
                    catch let error as NSError
                    {
                        print( error)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        longPress.minimumPressDuration = 0.5
        // Do any additional setup after loading the view, typically from a nib.
        diskTableView.delegate=self
        longPress.addTarget(self, action: #selector(ViewController.tableviewCellLongPressed(_:)))
        
        longPress.delegate=self
        //longPress.minimumPressDuration=0.5
        diskTableView.isUserInteractionEnabled=true
        diskTableView.addGestureRecognizer(longPress)
//        var path=NSHomeDirectory()+"/Documents/"
//        print(path)
        
        self.diskTableView!.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        print("当前有：" + "\(fileDirObject.celldata.count)")
        if click==true
        {
            saveBtn.isEnabled=false
        }
        for vc in (self.navigationController?.viewControllers)!{
            if vc.isKind(of: Process.self){
                if (vc as! Process).isDownLoad == true
                {
                    saveBtn.isEnabled=false
                }
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.fileDirObject.celldata.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView .dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        let row=(indexPath as NSIndexPath).row as Int
        let obj = self.fileDirObject.celldata[row] as! DKY_FileDir
        cell.textLabel!.text=obj.name
        //cell.imageView!.image = UIImage(named:"green.png")
        return cell;
        
        
//        var cell:UITableViewCell=tableView.dequeueReusableCellWithIdentifier("cell0",forIndexPath: indexPath)
//        cell.textLabel?.text=celldata[indexPath.row]
//        cell.imageView?.image = UIImage(named:cellimg[indexPath.row])
//        
//        return cell
    }
//    func longPressTableView()
//    {
//        tableView(<#T##tableView: UITableView##UITableView#>, canEditRowAtIndexPath: <#T##NSIndexPath#>)
//    }
    func tableviewCellLongPressed(_ gestureRecognizer:UILongPressGestureRecognizer)
    {
        if (gestureRecognizer.state == UIGestureRecognizerState.began)
        {
            print("UIGestureRecognizerStateBegan");
            oneData=nil
        }
        if (gestureRecognizer.state == UIGestureRecognizerState.changed)
        {
            print("UIGestureRecognizerStateChanged");
        }
        
        if (gestureRecognizer.state == UIGestureRecognizerState.ended)
        {
            print("UIGestureRecognizerStateEnded");
            //在正常状态和编辑状态之间切换
            if(self.diskTableView!.isEditing == false)
            {
                self.diskTableView!.setEditing(true, animated:true)
            }
            else
            {
                self.diskTableView!.setEditing(false, animated:true)
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
        forRowAt indexPath: IndexPath)
    {
        if(editingStyle == UITableViewCellEditingStyle.delete)
        {
            oneData = fileDirObject.celldata[indexRow] as AnyObject?
            deleteFile()
            do{
                try self.fileDirObject.celldata.removeObject(at: (indexPath as NSIndexPath).row)
            }
            catch let error as NSError
            {
                print(error)
            }
            //oneData = fileDirObject.celldata[indexPath.row]
            
            var vc : ViewController
            for vc in (self.navigationController?.viewControllers)!
            {
                if vc.isKind(of: Process.self)
                {
                    
                    dataModel.saveData((vc as! Process).dataModel.file)
                }
            }
            self.diskTableView!.reloadData()
            self.diskTableView!.setEditing(true, animated: true)
            print("你确认了删除按钮")
            print(fileDirObject.celldata.count)
            
           
            // Array
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // var vc=self.storyboard?.instantiateViewControllerWithIdentifier("login") as! LoginVC
        //c.selectedDisk=celldata[indexPath.row]
        //print(vc.selectedDisk)
         oneData = fileDirObject.celldata[(indexPath as NSIndexPath).row] as AnyObject?
        indexRow=(indexPath as NSIndexPath).row
        if oneData!.celldata.count == 0{
            print("this is a file")
            print("filePath:"+"\(oneData!.filePath)")
            print("cellData:"+"\(oneData!.celldata)")
            print("name:"+"\(oneData!.metadata.name)")
            print("ID:"+"\(oneData!.metadata.ID)")
            print("size:"+"\(oneData!.metadata.size)")
            print("chunk_size:"+"\(oneData!.metadata.chunk_size)")
            print("diskNo:"+"\(oneData!.metadata.diskNo)")
            print("createTime:"+"\(oneData!.metadata.createTime)")
            print("plistName:"+"\(oneData!.metadata.plistName)")
            print("plistNum:"+"\(oneData!.metadata.subFileNum)")
            print("placeHolderSize:"+"\(oneData!.metadata.placeHolderSize)")
             print("fileType:"+"\(oneData!.metadata.fileType)")
        }else{
            print("this is a directory")
             print("filePath:"+"\(oneData!.filePath)")
            let row=(indexPath as NSIndexPath).row as Int
            let obj = self.fileDirObject.celldata[row] as! DKY_FileDir

            
            let vc=self.storyboard?.instantiateViewController(withIdentifier: "l") as! ViewController
            vc.setData(obj)
            if click==true
            {
                vc.click=true
            }
            self.navigationController?.pushViewController(vc, animated: true)

        }
        
    }
    func display()
    {
        var process = self.storyboard?.instantiateViewController(withIdentifier: "process") as! Process
        
    }
    func setData(_ data:DKY_FileDir){
        self.fileDirObject = data
        
    }

        
    override func viewWillDisappear(_ animated: Bool) {
        print("willdisappera")
        
    }
    func getTime()->String
    {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = " yyyy-MM-dd 'at' HH:mm:ss.sss"
        let strNowTime = timeFormatter.string(from: date) as String
        return strNowTime
    }
    

}

