//
//  IDVC.swift
//  nnetwork
//
//  Created by 段剀越 on 16/5/12.
//  Copyright © 2016年 段剀越. All rights reserved.
//

import UIKit
import Foundation

class IDVC: UIViewController {
    var test=KuaiPanClient(app_id: "xcv0szzauygHEbCS", app_secret: "IKbD9B5bmt0h193a", user_account: "742941651@qq.com")
    static var IDCode=""
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() //当视图装载时调用
    {
        super.viewDidLoad()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func getIDCode(_ sender: UIButton){
        if textField.text!.isEmpty
        {
            let alertController = UIAlertController(title: "Alert", message: "您的验证码不能为空！", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "好！", style: UIAlertActionStyle.destructive,handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)

        }
        else
        {
            IDVC.IDCode=textField.text!
 
            textField.text!=""
            test.getAccessToken(IDVC.IDCode)
            var temp=self.navigationController?.viewControllers
            print(self.navigationController?.viewControllers)
            //self.navigationController?.popViewControllerAnimated(true)

            self.navigationController?.popToViewController(temp![0], animated: true)
            //self.performSegueWithIdentifier("gotoTableView", sender: self)
        }
    }
}
