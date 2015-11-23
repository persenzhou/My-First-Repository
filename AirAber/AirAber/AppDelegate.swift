//
//  AppDelegate.swift
//  AirAber
//
//  Created by Mic Pringle on 05/08/2015.
//  Copyright © 2015 Mic Pringle. All rights reserved.
//

import UIKit
import WatchConnectivity
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    // 添加一个属性 并设置session
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activateSession()
            }
        }
    }
    
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    //判断 初始化
    if WCSession.isSupported() {
        session = WCSession.defaultSession()
    }
    return true
  }

}

extension AppDelegate: WCSessionDelegate {
    //实现代理方法
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        if let reference = message["reference"] as? String, boardingPass = QRCode(reference) {
            print("\(reference)")
            replyHandler(["boardingPassData": boardingPass.PNGData])
        }
    }
    
}