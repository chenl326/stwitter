//
//  CLBaseViewController.swift
//  stwitter
//
//  Created by sun on 2017/5/17.
//  Copyright © 2017年 sun. All rights reserved.
// b84a4b28bcb1d9b0eb37f05e7b939534

import UIKit

class CLBaseViewController: UIViewController {
//    var userLogin = true
    
    //访客试图
    var visitorInfoDict:[String:String]?
    
    
    var tableView:UITableView?
    
    var refreshControl:UIRefreshControl?
    
    //是否上啦
    var isPullup = false
    
    
    
    
    lazy var navigationBar = UINavigationBar.init(frame:CGRect.init(x: 0, y: 0, width: UIScreen.yw_screenWidth(), height: 64))
    
    lazy var navItem = UINavigationItem()
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        CLNetworkManager.shared.userLogin ? loadData() : ()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(rawValue: CLUserLoginSuccessedNotification), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
    override var title:String?{
        didSet{
            navItem.title = title
        }
    }
    
    func loadData() -> () {
        refreshControl?.endRefreshing()
    }
    


}
//  MARK - 访客监听
extension CLBaseViewController{
    
     @objc fileprivate func loginSuccess(){
        print(#function)
        navItem.leftBarButtonItem = nil
        navItem.rightBarButtonItem = nil
        view = nil
        NotificationCenter.default.removeObserver(self)
    }

    @objc fileprivate func login(){
        print(#function)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: CLUserShouldLoginNotification), object: nil)
    }
    
    @objc fileprivate func register(){
        print(#function)
    }
}

//MARK:-设置界面
extension CLBaseViewController{
    fileprivate func setupUI() -> () {
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        setupNavigationBar()
//        setupTableView()
        CLNetworkManager.shared.userLogin ? setupTableView() : setupVisitorView()
    }
    
    func setupTableView(){
        tableView = UITableView.init(frame: view.bounds,style: .plain)
        view.addSubview(tableView!)
        
        view.insertSubview(tableView!, belowSubview: navigationBar)
        tableView?.delegate = self
        tableView?.dataSource = self
        
        
        tableView?.contentInset = UIEdgeInsetsMake(navigationBar.bounds.height, 0, 0, 0)
        
        
        //设置导航条的缩进
        tableView?.scrollIndicatorInsets  = tableView!.contentInset
        
        //刷新
        refreshControl = UIRefreshControl()
        
        tableView?.addSubview(refreshControl!)
        refreshControl?.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        
    }
    
    fileprivate func setupNavigationBar(){
        
        view.addSubview(navigationBar)
        navigationBar.items = [navItem]
        navigationBar.barTintColor = UIColor.yw_color(withHex: 0xf6f6f6)
        //设置navBar 的标题字体颜色
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.darkGray]
        //设置系统按钮的文字渲染颜色  只对系统.plain 的方法有效
        navigationBar.tintColor = UIColor.orange

    }
    
    fileprivate func setupVisitorView(){
        let visitorView = CLVisitorView.init(frame: view.bounds)
        view.insertSubview(visitorView, belowSubview: navigationBar)
        
        visitorView.visitorInfo = visitorInfoDict
        
        visitorView.loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        visitorView.registerBtn.addTarget(self, action: #selector(register), for: .touchUpInside)
        
        navItem.leftBarButtonItem = UIBarButtonItem.init(title: "注册", target: self, action: #selector(register))
        navItem.rightBarButtonItem = UIBarButtonItem.init(title: "登录", target: self, action: #selector(login))
    }
}

extension CLBaseViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //判断indexpath是否最后一行
        let row = indexPath.row
        
        let section = tableView.numberOfSections - 1
        
        if row < 0 || section < 0 {
            return
        }
        let count = tableView.numberOfRows(inSection: section)
        if row == (count - 1) && !isPullup {
            print("上拉刷新")
            isPullup = true
            
            //
            loadData()
        }
        
//        print("section-------\(section)")
        
        
        
    }
    
}





