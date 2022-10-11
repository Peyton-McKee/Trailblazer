//
//  CustomCell.swift
//  SundayRiver
//
//  Created by Peyton McKee on 9/28/22.
//

import Foundation
import UIKit
import MapKit
class CustomCell : UITableViewCell
{
    @IBOutlet var label : UILabel!
    var cellTrail : Trail = Trail(name: "", difficulty: "", annotations: [])
}
