//
//  Tasker.swift
//  Basics
//
//  Created by Artem Vaniukov on 28.01.2022.
//

import Foundation


class Tasker {
    /// В качестве задания task выберем печать любых десяти одинаковых символов и приоритета текущей очереди. Еще одно задание taskHIGH, которое будет печатать один символ, мы будем запускать с высоким приоритетом:
    
    func task(_ symbol: String) { for i in 1...10 {
        print("\(symbol) \(i) priority - \(qos_class_self().rawValue)")
        }
    }
        
    func taskHighPriority(_ symbol: String) {
        print("\(symbol) HIGH PRIORITY - \(qos_class_self().rawValue)")
    }
}
