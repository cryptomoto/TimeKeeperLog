//
//  Works.swift
//  Keeper
//
//  Created by admin on 5/15/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import Foundation
import CoreData


class Works: NSManagedObject {
    
    @NSManaged var allTime: NSNumber?
    @NSManaged var checked: NSNumber?
    @NSManaged var clientName: String?
    @NSManaged var estimate: NSNumber?
    @NSManaged var hourRate: NSNumber?
    @NSManaged var money: NSNumber?
    @NSManaged var statsTotalEarned: NSNumber?
    @NSManaged var statsTotalWorked: NSNumber?
    @NSManaged var statsWorksCompleted: NSNumber?
    @NSManaged var title: String?
    @NSManaged var todayTime: NSNumber?
    @NSManaged var type: String?
    @NSManaged var types: String?
    @NSManaged var fixprice: NSNumber
    @NSManaged var futureMoney: NSNumber?
    
}
