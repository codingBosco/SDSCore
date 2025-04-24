//
//  File.swift
//  SDSCore
//
//  Created by Sese on 23/02/25.
//

import Foundation


public struct StudentSorter: SortComparator {
    public func compare(_ lhs: Student, _ rhs: Student) -> ComparisonResult {
        lhs.surname > rhs.surname ? .orderedDescending : .orderedAscending
    }
    
    public typealias Compared = Student
    
    public var order: SortOrder = .forward
    
    
}

public struct ClassSorter: SortComparator {
    
    public typealias Compared = Classe
    public var order: SortOrder = .forward
    
    public func compare(_ lhs: Classe, _ rhs: Classe) -> ComparisonResult {
        lhs.formalClass > rhs.formalClass ? .orderedDescending : .orderedAscending
    }
    
}

public struct PackSorter: SortComparator {
    
    public typealias Compared = Pack
    public var order: SortOrder = .forward
    
    public func compare(_ lhs: Pack, _ rhs: Pack) -> ComparisonResult {
        lhs.formal > rhs.formal ? .orderedDescending : .orderedAscending
    }
    
}

public let studentSorter = StudentSorter()
public let classroomsSorter = ClassSorter()
public let packSorter = PackSorter()
