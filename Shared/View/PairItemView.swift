//
//  PairItemView.swift
//  ContactLenses (iOS)
//
//  Created by Lawrence Bensaid on 6/1/22.
//

import SwiftUI

struct PairItemView: View {
    
    private var pair: Pair
    
    public init(_ pair: Pair) {
        self.pair = pair
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(pair.startAt, format: .dateTime.month())")
                VStack(alignment: .leading) {
                    if let left = pair.left {
                        Text("Left: \(left.description)")
                    }
                    if let right = pair.right {
                        Text("Right: \(right.description)")
                    }
                }
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("Needs replacement \(pair.endAt, format: .relative(presentation: .numeric))")
            }
            .font(.system(size: 14))
            .foregroundColor(.secondary)
        }
    }
    
}

//struct PairItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        PairItemView()
//    }
//}
