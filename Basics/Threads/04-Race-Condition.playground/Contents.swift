import UIKit
import PlaygroundSupport


enum ExecutionType: String {
    case sync
    case async
}


let mySerialQueue = DispatchQueue.global(qos: .default)


/// Мы можем воспроизвести простейший случай race condition, если будем изменять переменную value асинхронно на private очереди, а показывать value на текущем потоке:
var value = "🥳" // 1

func changeValue(variant: ExecutionType) {
    sleep(1) // 4, 9
    value += "🐔" // 10, 14
    print("\(value) - \(variant.rawValue)") // 11, 15
}

print("--- Race Condition Imitation ---")

// Async call
mySerialQueue.async { // 2
    changeValue(variant: .async) // 3
} // 16
value // check value ---------> // 5


value = "🦊" // 6

// Sync call
mySerialQueue.sync { // 7
    changeValue(variant: .sync) // 8
} // 12
value // check value ---------> // 13

/// У нас есть обычная переменная value и обычная функция changeValue для ее изменения, причем умышленно мы сделали с помощью оператора sleep(1) так, что изменение переменной value требует значительного времени. Если мы будем запускать функцию changeValue АСИНХРОННО с помощью async, то прежде, чем дойдет дело до размещения измененного значения в переменной value, на текущем потоке переменная value может быть переустановлена в другое значение, это и есть race condition. Этому коду соответствует печать в виде:
