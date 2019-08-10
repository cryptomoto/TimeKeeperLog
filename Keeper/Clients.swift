//
//  Clients.swift
//  Keeper
//
//  Created by admin on 5/15/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import Foundation
import CoreData


class Clients: NSManagedObject {
    
    @NSManaged var company: String?
    @NSManaged var email: String?
    @NSManaged var name: String?
    @NSManaged var projectBudget: String?
    @NSManaged var projectTitle: String?
    @NSManaged var projectType: String?
    @NSManaged var rating: NSNumber?
    @NSManaged var phone: String?
    
}
