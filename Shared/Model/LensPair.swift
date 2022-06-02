//
//  LensPair.swift
//  ContactLenses (iOS)
//
//  Created by Lawrence Bensaid on 5/31/22.
//
//

import Foundation
import CoreData

@objc(LensPair)
public class LensPair: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LensPair> { NSFetchRequest<LensPair>(entityName: "LensPair") }

    @NSManaged public var startAt: Date
    @NSManaged public var endAt: Date
    @NSManaged public var days: Int16
    @NSManaged public var left: Lens?
    @NSManaged public var right: Lens?
    
    public var material: Lens.Material { left?.material ?? right?.material ?? .soft }
    public var wearSchedule: WearSchedule {
        get { days > 1 ? .extended : .daily }
        set {
            switch newValue {
            case .daily:
                days = 1
            case .extended:
                days = 30
            }
        }
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
    
    public enum WearSchedule: String {
        case daily = "daily"
        case extended = "extended"
    }
    
    public func copy(_ managedObjectContext: NSManagedObjectContext? = nil) -> LensPair? {
        guard let context = managedObjectContext ?? self.managedObjectContext else { return nil }
        let pair = LensPair(context: context)
        pair.left = left?.copy(context)
        pair.right = right?.copy(context)
        return pair
    }
    
    public static var preview: LensPair {
        let pair = LensPair(context: PersistenceController.preview.container.viewContext)
        pair.startAt = Date()
        pair.endAt = Date().addingTimeInterval(30 * 24 * 60 * 60)
        return pair
    }

}

extension LensPair: Identifiable {
    
    public var id: Int {
        var hasher = Hasher()
        hasher.combine(left?.id)
        hasher.combine(right?.id)
        return hasher.finalize()
    }
    
}
