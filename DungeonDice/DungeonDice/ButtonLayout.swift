//
//  ButtonLayout.swift
//  DungeonDice
//
//  Created by Huo, Sarah Z on 4/22/24.
//

import SwiftUI

struct ButtonLayout: View {
    enum Dice: Int, CaseIterable{
        case four = 4
        case six = 6
        case eight = 8
        case ten = 10
        case twelve = 12
        case twenty = 20
        case hundred = 100
        
        func roll() -> Int {
            return Int.random(in:1...self.rawValue)
        }
    }
    struct DeviceWidthPreferenceKey: PreferenceKey{
        static var defaultValue: CGFloat = 0
        
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
        
        typealias Value = CGFloat
        
        
    }
    
    @State private var buttonsleftOver = 0 //# of buttons in a less than full row
    @Binding var resultMessage: String
    
    let horizontalPadding: CGFloat = 16
    let spacing: CGFloat = 0 //between buttons
    let buttonWidth: CGFloat = 102
    
    var body: some View {
        VStack{
            LazyVGrid(columns: [GridItem(.adaptive(minimum: buttonWidth), spacing: spacing)]) {
                ForEach(Dice.allCases.dropLast(buttonsleftOver), id: \.self) { dice in
                    Button("\(dice.rawValue)-sided") {
                        resultMessage = "You rolled a \(dice.roll()) on a \(dice.rawValue)-sided dice"
                    }
                    .frame(width: buttonWidth)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }
            
            HStack{
                ForEach(Dice.allCases.suffix(buttonsleftOver), id: \.self) { dice in
                    Button("\(dice.rawValue)-sided") {
                        resultMessage = "You rolled a \(dice.roll()) on a \(dice.rawValue)-sided dice"
                    }
                    .frame(width: buttonWidth)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }
        }
        
        .overlay {
            GeometryReader { geo in
                Color.clear
                    .preference(key: DeviceWidthPreferenceKey.self, value: geo.size.width)
            }
        }
        .onPreferenceChange(DeviceWidthPreferenceKey.self) { deviceWidth in
            arrangeGridItems(deviceWidth: deviceWidth)
        }
    }
    
    func arrangeGridItems(deviceWidth: CGFloat){
        var screenWidth = deviceWidth - horizontalPadding*2 //padding on both sides
        if Dice.allCases.count > 1 {
            screenWidth += spacing
        }
        
        // calculate numOfButtonsPerRow as Int
        let numberOfButtonsPerRow = Int(screenWidth)/Int(buttonWidth+spacing)
        buttonsleftOver = Dice.allCases.count % numberOfButtonsPerRow
        
    }
}

struct ButtonLayout_Previews: PreviewProvider {
    static var previews: some View {
        ButtonLayout(resultMessage: .constant(""))
    }
}
