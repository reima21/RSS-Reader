//
//  ListViewController.swift
//  rssReader
//
//  Created by 松平 礼史 on 2017/03/14.
//  Copyright © 2017年 松平礼史. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController, XMLParserDelegate{
    
    
    //プロパティ
    //rssデータを解析するためのXMLParserクラスのインスタンスを格納するためのプロパティ
    var parser: XMLParser!
    
    //複数の記事を格納するためのプロパティ
    var items = [Item]()
    var item:Item?
    
    //抽出した文字列を一時的に格納するためのプロパティ
    var currentString = ""
    
    //xibファイルをregisterNib(…)で登録
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let nib:UINib = UINib(nibName: "FeedTableViewCell", bundle: nil)
        
        self.tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        
    }
    
    
    //セルの幅を指定
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 70
    }
    
    
    
    //表示するセルの数を３つにする
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    //表示するセルを作成する
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //dequeueReusableCellでセルの再利用
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        
        //cellのtextLabelに取得したタイトルを格納
        cell.title?.text = items[indexPath.row].title
        
        //タイトルのフォントを13ピクセルに
        cell.title?.font = UIFont.systemFont(ofSize: 13)
        
        //タイトルの下にWontedly
        cell.desc?.text = "Wantedly"
        
        
        //画像をURLで取得しUIImageとしてthumbnailViewに格納
        let url2 = items[indexPath.row].link.components(separatedBy: "?")[0]
        let url = URL(string: url2 + "/cover_image?style=200x200#")
        let imageData = try? Data(contentsOf: url!)
        let image2 = UIImage(data:imageData!)
        cell.thumbnailView?.contentMode = UIViewContentMode.scaleAspectFit
        cell.thumbnailView?.image = image2
        cell.thumbnailView?.alpha = 1
        
        

        
        
//        if items[indexPath.row].image != "" {
//            let imageP = NSURL(string: items[indexPath.row].image)
//            let imageData: NSData? = NSData(contentsOf: imageP as! URL)
//            if((imageData) != nil){
//                let image: UIImage = UIImage(data:imageData! as Data)!
//                cell.thumbnailView?.image = image
//            }
//        }
        
        //rssにimage要素がなかった場合にテンプレートの画像を用意する
        if(cell.thumbnailView?.image == nil){
            cell.thumbnailView?.image = #imageLiteral(resourceName: "wantedly")
        }

        
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let color = UIColor(red: 26/255, green: 164/255, blue: 185/255, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = color
        startdownload()
    }
    
    func startdownload(){
        
        //初期化
        self.items = []
        
        //サイトのURLを指定
        if let url = NSURL(string: "https://www.wantedly.com/projects.xml"){
            
            //parserのインスタンスを作成
            //引数は上記
            //optional binding
            if let parser = XMLParser(contentsOf: url as URL){
                
                //解析の開始
                self.parser = parser
                self.parser.delegate = self
                self.parser.parse()
            }
        }
    }
    
    //必要なデータだけを取り出す
    //要素名の開始タグが見つかるごとに呼び出される
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String]) {
        
        //初期化
        self.currentString = ""
        
        //要素名がitemの時のみ
        if elementName == "item" {
            
            //itemを作成
            self.item = Item()
        }
    }
    
    //内容を取り出す
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        //引数の中身をcurrentStringに追加していく
        self.currentString += string
    }
    
    //要素の終了タグが見つかるごとに呼び出される
    //switch文
    func parser(_ parser: XMLParser,
                
                //要素名はelementNameに格納
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        
        //要素ごとに処理
        switch elementName {
        case "title": self.item?.title = currentString
        case "link": self.item?.link = currentString
        case "item": self.items.append(self.item!)
        case "image": self.item?.image = currentString
        default : break
        }
    }
    
    //解析が終了すると呼び出される
    func parserDidEndDocument(_ parser: XMLParser) {
        self.tableView.reloadData()
    }
    
    
    
    
    
    
    
    
    //UITableViewControllerを継承しているのでoverrideする
    //cellがタップされた時
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //xibカスタムセル設定によりsegueが無効になっているためsegueを発生させる
        self.performSegue(withIdentifier: "next", sender: self.tableView)
        
    }
        
        
        //segueはストーリーボード上の矢印
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            
            //UITableViewクラスのindexPathForSelectedRowメソッドを使ってタップしたセルのindexPathを取得し、その値を用いてitens配列から該当する記事(items)を取得
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let item = items[indexPath.row]
                
                //controllerに遷移先のビューコントローラーを格納
                let controller = segue.destination as! DetailViewController
                
                //DetaliViewControllerのtitleプロパティに記事のタイトルを格納
                controller.title = item.title
                
                //DetaliViewControllerのlinkプロパティに記事のURLを格納
                controller.link = item.link
                
              
            }
        }
}


