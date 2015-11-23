//
//  BoardingPassInterfaceController.swift
//  AirAber
//
//  Created by zhoupushan on 15/11/20.
//  Copyright © 2015年 Mic Pringle. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class BoardingPassInterfaceController: WKInterfaceController{

    @IBOutlet var originLabel: WKInterfaceLabel!
    @IBOutlet var destinationLabel: WKInterfaceLabel!
    @IBOutlet var boardingPassImage: WKInterfaceImage!
    /*
        WCSession 可以让watch 和 iphone 进行数据上的传输，
        设置代理WCSessionDelegate delegete
        通知开启session activeSession（）
    
        WCSession.isSupported // 需要判断
        WCSession.defaultSession() 创建Session
        ession!.sendMessage(）参数是你想告诉 app 你需要什么数据和请求参数
        
        当然，app也需要遵守WCSessionDelegate 并实现代理方法，
    */
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activateSession()
                
            }
        }
    }
    
    var flight: Flight? {
        didSet {
            if let flight = flight {
                originLabel.setText(flight.origin)
                destinationLabel.setText(flight.destination)
                
                if let _ = flight.boardingPass {
                    showBoardingPass()
                }
            }
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        if let flight = context as? Flight { self.flight = flight }
        
    }

    override func didAppear() {
        super.didAppear()
        // 1
        if let flight = flight where flight.boardingPass == nil && WCSession.isSupported() {
            // 2
            session = WCSession.defaultSession()
            // 3
            session!.sendMessage(["reference": flight.reference], replyHandler: { (response) -> Void in
                // 4
                if let boardingPassData = response["boardingPassData"] as? NSData, boardingPass = UIImage(data: boardingPassData) {
                    // 5
                    flight.boardingPass = boardingPass
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.showBoardingPass()
                    })
                }
                }, errorHandler: { (error) -> Void in
                    // 6
                    print(error)
            })
        }
    }

}

extension BoardingPassInterfaceController: WCSessionDelegate {
    // 设置boardingPassImage
    private func showBoardingPass() {
        boardingPassImage.stopAnimating()
        boardingPassImage.setWidth(120)
        boardingPassImage.setHeight(120)
        boardingPassImage.setImage(flight?.boardingPass)
//        self.dismissController()
    }
    
    
}
