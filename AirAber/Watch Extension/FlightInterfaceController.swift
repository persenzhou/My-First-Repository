//
//  FlightInterfaceController.swift
//  AirAber
//
//  Created by zhoupushan on 15/11/20.
//  Copyright © 2015年 Mic Pringle. All rights reserved.
//

import WatchKit
import Foundation


class FlightInterfaceController: WKInterfaceController {
    @IBOutlet var flightLabel: WKInterfaceLabel!
    @IBOutlet var routeLabel: WKInterfaceLabel!
    @IBOutlet var boardingLabel: WKInterfaceLabel!
    @IBOutlet var boardTimeLabel: WKInterfaceLabel!
    @IBOutlet var statusLabel: WKInterfaceLabel!
    @IBOutlet var gateLabel: WKInterfaceLabel!
    @IBOutlet var seatLabel: WKInterfaceLabel!
    
    var flight: Flight?{
        // 这里使用 didset 就想OC里面的 set方法，来做到一个监听的作用！
        didSet{
            if let flight = flight
            {
                flightLabel.setText("Flight\(flight.shortNumber)")
                routeLabel.setText(flight.route)
                boardingLabel.setText("\(flight.number) Boards")
                boardTimeLabel.setText(flight.boardsAt)
                
                if flight.onSchedule {
                    statusLabel.setText("On Time")
                } else {
                    statusLabel.setText("Delayed")
                    statusLabel.setTextColor(UIColor.redColor())
                }
                gateLabel.setText("Gate \(flight.gate)")
                seatLabel.setText("Seat \(flight.seat)")
            }
        }
    }
    
    //在控制器第一次显示时候 调用该方法 
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

        //使用 if语句 安全的对flight 赋值
        if let flight = context as? Flight { self.flight = flight }
    }

}
