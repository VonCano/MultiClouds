//
//      } KuaiPanClientVC.swift
//  nnetwork
//
//  Created by 段剀越 on 16/5/2.
//  Copyright © 2016年 段剀越. All rights reserved.
//

import UIKit
import Foundation

class KuaiPanClientVC: UIViewController,UIWebViewDelegate {
   var getLocalInfo=false
    
            var test=KuaiPanClient(app_id: "xcv0szzauygHEbCS", app_secret: "IKbD9B5bmt0h193a", user_account: "742941651@qq.com")
    
    static var flag=true
    static var dst=""
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() //当视图装载时调用
    {
        super.viewDidLoad()
        
        let load=SaveInfo()
        let info = load.loadData()
        let oauth_token=info.accessToken
        let oauth_token_secret=info.refreshToken
        let user_id=info.user_Id
        let charged_dir=info.charged_Dir
        
        if oauth_token.isEmpty// 本地没有Token数据，就需要访问
        {
            if KuaiPanClientVC.flag//第一次载入时才执行
            {
                KuaiPanClientVC.dst=test.makeAuthorizationUrl()
                KuaiPanClientVC.flag=false
            }
            let url=URL(string: KuaiPanClientVC.dst)
            let request=URLRequest(url: url!)
            webView.loadRequest(request)
        }
        else
        {
            if KuaiPanClientVC.flag
            {print(oauth_token,oauth_token_secret,user_id,charged_dir)
            KuaiPanClient.token=Token(access_token: oauth_token, refresh_token: oauth_token_secret, expires: 31536000)
            //test.getUserInfo()
            //var info=test.getUploadLocate()
            //test.uploadFast("/", filename: "pic1.png",uploadInfo: info!)
                KuaiPanClientVC.flag=false
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    {
        
        let alertController = UIAlertController(title: "Alert", message: "请牢记您的验证码！", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "好！", style: UIAlertActionStyle.destructive,handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)

        print(request.url)
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
    
}


