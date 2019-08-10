//
//  Stats.swift
//  Keeper
//
//  Created by admin on 5/5/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import Foundation
import CoreData


class Stats: NSManagedObject {

    @NSManaged var worksCompleted: NSNumber?
    @NSManaged var moneyEarned: NSNumber?
    @NSManaged var timeWorked: NSNumber?
    @NSManaged var title: String?

}
