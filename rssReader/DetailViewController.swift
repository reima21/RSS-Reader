//
//  DetailViewController.swift
//  rssReader
//
//  Created by 松平 礼史 on 2017/03/14.
//  Copyright © 2017年 松平礼史. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController{
    @IBOutlet weak var webView: UIWebView!
    
    var link:String!
    
    //記事画面が表示される前に呼び出される
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //テキストフィールドに入力された文字列を引数にして、NSURLクラスのurlインスタンスを作成する
        if let url = URL(string: self.link) {
            
            //urlインスタンスを引数にして、NSURLRequestクラスのrequestインスタンスを作成する
            let request = URLRequest(url: url)
            
            //requestインスタンスを引数にして、webViewプロパティのloadRequestメソッドを実行する
            self.webView.loadRequest(request)
        }
    }
}
