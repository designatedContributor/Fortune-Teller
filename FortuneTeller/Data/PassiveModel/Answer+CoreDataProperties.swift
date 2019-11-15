//
//  Answer+CoreDataProperties.swift
//  
//
//  Created by Dmitry Grin on 10/17/19.
//
//

import Foundation
import CoreData

extension Answer {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Answer> {
        return NSFetchRequest<Answer>(entityName: "Answer")
    }

    @NSManaged public var answer: String
    @NSManaged public var date: Date
    @NSManaged public var type: String
    @NSManaged public var identifier: String
}
