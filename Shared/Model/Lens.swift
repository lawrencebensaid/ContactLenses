//
//  Lens.swift
//  ContactLenses (iOS)
//
//  Created by Lawrence Bensaid on 5/31/22.
//
//

import Foundation
import CoreData

@objc(Lens)
public class Lens: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lens> { NSFetchRequest<Lens>(entityName: "Lens") }
    
    @NSManaged public var power: Float
    @NSManaged public var diameter: Float
    @NSManaged public var curvature: Float
    
    @NSManaged public var isToric: Bool
    
    @NSManaged public var cylinder: Float
    @NSManaged public var axis: Int16
    
    public var id: Int {
        var hasher = Hasher()
        hasher.combine(power)
        hasher.combine(diameter)
        hasher.combine(curvature)
        hasher.combine(isToric)
        hasher.combine(cylinder)
        hasher.combine(axis)
        return hasher.finalize()
    }
    
    public override var description: String {
        var string = "Power \(String(format: "%.1f", power))"
        if isToric {
            string += " Toric"
        }
        return string
    }
    
    public func copy(_ managedObjectContext: NSManagedObjectContext? = nil) -> Lens? {
        guard let context = managedObjectContext ?? self.managedObjectContext else { return nil }
        let lens = Lens(context: context)
        lens.power = power
        lens.diameter = diameter
        lens.curvature = curvature
        lens.isToric = isToric
        lens.cylinder = cylinder
        lens.axis = axis
        return lens
    }
    
}

extension Lens: Identifiable {
    
}
