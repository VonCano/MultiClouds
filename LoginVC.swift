//
//  LoginVC.swift
//  APP
//
//  Created by 段剀越 on 15/12/12.
//  Copyright © 2015年 段剀越. All rights reserved.
//

import UIKit
import Foundation
class LoginVC: UIViewController {
    var selectedDisk:NSString=" "
    @IBOutlet weak var userPWD: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var showTitle: UILabel!
    @IBAction func confirm(_ sender: UIButton) {
        let path=Bundle.main.resourcePath!+"/AccountInfo.txt"
        if selectedDisk.isEqual(to: "快盘")
        {selectedDisk="kuaipan"}
        if selectedDisk.isEqual(to: "微盘")
        {selectedDisk="vdisk"}
        var str:NSString=" "
        do{try  str=NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)}
        catch{}
        //str是从文件中读取的字符串，包含特殊字符
        var account=str.substring(from: (str.range(of: selectedDisk.lowercased).toRange()?.lowerBound)!)
        /*rangeOfString可以用来查询字符串中特定字符的范围，startIndex是范围的起始位置
        subStringFromIndex可以截取字符串，lowercaseString将字符串转化成小写*/
        let  m=account.range(of: "\n")!//m查询回车的位置，只要查询到字符串中第一个就结束
        print(m.lowerBound)
        account=account.substring(to: m.lowerBound)//将字符串范围缩小
        print(account)
        let name=account.substring(to: (account.range(of: selectedDisk .lowercased)?.upperBound)!)//获取用户名
        let password=account.substring(from: (account.range(of: "password:")?.upperBound)!)//获取密码
        print(name)
        print(password)
        let whitespace = CharacterSet.whitespacesAndNewlines
        let getUserName=userName.text!.trimmingCharacters(in: whitespace)as NSString
        let getUserPWD=userPWD.text!.trimmingCharacters(in: whitespace) as NSString
        if(getUserName.isEqual(to: name) && getUserPWD.isEqual(to: password))
        {
            self.performSegue(withIdentifier: "validuser", sender: self)
        }
        else
        {
            let alertController = UIAlertController(title: "Alert", message: "登录 失败！", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "重置！", style: UIAlertActionStyle.destructive)//如果点击按钮有操作，删掉handler和nil，把下面注释符号去掉，in后面写代码
                {
                    (action: UIAlertAction!) -> Void in
                   self.userPWD.text=""
                    self.userName.text=""
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    @IBAction func forget(_ sender: UIButton) {
        self.performSegue(withIdentifier: "validuser", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        var addrK=NSHomeDirectory()+"/Documents/kuaipan"
//        var addrV=NSHomeDirectory()+"/Documents/vdisk"
//        var addrS=NSHomeDirectory()+"/Documents/skydrive"
//        var manager=NSFileManager.defaultManager()
//        do{ try manager.createDirectoryAtPath(addrK, withIntermediateDirectories: true, attributes: nil)}
//        catch{print("sorry")}
//        
//        do{ try manager.createDirectoryAtPath(addrV, withIntermediateDirectories: true, attributes: nil)}
//        catch{}
//        do{ try manager.createDirectoryAtPath(addrS, withIntermediateDirectories: true, attributes: nil)}
//        catch{}
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
         //showTitle.text="登录"+"\(selectedDisk)"+"网盘"
        showTitle.text="欢迎使用多云存储系统"
        print(selectedDisk)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
