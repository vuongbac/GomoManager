//
//  Bill.swift
//  GomoAdmin
//
//  Created by BAC Vuong Toan (VTI.Intern) on 11/13/20.
//

import Foundation

struct Bill: Codable {
    var id: String? = nil
    var othermoney :String? = nil
    var numberTable: String? = nil
    var detailFood: String? = nil
    var detailPrice: String? = nil
    var Total:Int? = nil
    var date: String? = nil
    var time:String? = nil
    var listpricefood:String? = nil


}
