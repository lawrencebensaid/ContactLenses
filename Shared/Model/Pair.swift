//
//  Pair.swift
//  ContactLenses (iOS)
//
//  Created by Lawrence Bensaid on 5/31/22.
//
//

import Foundation
import CoreData

@objc(Pair)
public class Pair: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pair> { NSFetchRequest<Pair>(entityName: "Pair") }

    @NSManaged public var startAt: Date
    @NSManaged public var endAt: Date
    @NSManaged public var left: Lens?
    @NSManaged public var right: Lens?
    
    public var id: Int {
        var hasher = Hasher()
        hasher.combine(left?.id)
        hasher.combine(right?.id)
        return hasher.finalize()
    }
    
    public var power: Float? {
        guard left?.power == right?.power else { return nil }
        return left?.power
    }
    
    public override var description: String {
        var string = ""
        if let left = left {
            string += "L: \(left.description) "
        }
        if let right = right {
            string += "R: \(right.description)"
        }
        return string
    }
    
    public func copy(_ managedObjectContext: NSManagedObjectContext? = nil) -> Pair? {
        guard let context = managedObjectContext ?? self.managedObjectContext else { return nil }
        let pair = Pair(context: context)
        pair.left = left?.copy(context)
        pair.right = right?.copy(context)
        return pair
    }

}

extension Pair: Identifiable {

    public static var preview: Pair {
        let pair = Pair(context: PersistenceController.preview.container.viewContext)
        pair.startAt = Date()
        pair.endAt = Date().addingTimeInterval(30 * 24 * 60 * 60)
        return pair
    }
    
}
