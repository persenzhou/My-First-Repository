//
//  ScheduleInterfaceController.swift
//  AirAber
//
//  Created by zhoupushan on 15/11/20.
//  Copyright © 2015年 Mic Pringle. All rights reserved.
//

import WatchKit
import Foundation


class ScheduleInterfaceController: WKInterfaceController {
    // 这是一个tableview
    @IBOutlet var flightsTable: WKInterfaceTable!
    var selectedIndex = 0// 记录点击的selected
    var flights = Flight.allFlights()// 数据源
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        /*
            在watchOS 中 table的datasource使用的不是代理而是用table的方法代替
        例如：setNumberOfRows(rowCount,RowType),rowType可以在stroyboard中 通过 table的 identifier中定义
        
            而每一行其实是一个 AnyObject 可以说是一个Model
            我在想 这里有复用吗？
        */
        flightsTable.setNumberOfRows(flights.count, withRowType: "FlightRow")
        // 便利赋值
        for index in 0..<flightsTable.numberOfRows {
            if let controller = flightsTable.rowControllerAtIndex(index) as? FlightRowController {
                controller.flight = flights[index]
            }
        }
        // Configure interface objects here.
    }

    override func didAppear() {
        super.didAppear()
        // 1
        if flights[selectedIndex].checkedIn, let controller = flightsTable.rowControllerAtIndex(selectedIndex) as? FlightRowController {
            // 2 通过一个动画改变颜色
            animateWithDuration(0.35, animations: { () -> Void in
                // 3 改变颜色
                controller.updateForCheckIn()
            })
        }
    }

    //如果有interfaceTable 就可以实现该方法
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        let flight = flights[rowIndex]
        let controllers = flight.checkedIn ? ["Flight", "BoardingPass"] : ["Flight", "CheckIn"]
        selectedIndex = rowIndex
        // 参数： 1. 你要跳转的 controller identifier 2.上下文传递的参数
        presentControllerWithNames(controllers, contexts:[flight, flight])
    }
}
