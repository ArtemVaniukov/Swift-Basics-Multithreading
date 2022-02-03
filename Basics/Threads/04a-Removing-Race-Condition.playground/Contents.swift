import UIKit
import PlaygroundSupport


enum ExecutionType: String {
    case sync
    case async
}


let mySerialQueue = DispatchQueue.global(qos: .default)

var value = "🥳"

func changeValue(variant: ExecutionType) {
    sleep(1)
    value += "🐔"
    print("\(value) - \(variant.rawValue)")
}



print("--- Removing Race Condition with Sync Execution ---")

/// Давайте заменим метод async на sync:
mySerialQueue.sync {
    changeValue(variant: .sync)
}
value // check value --------->


value = "🦊"
mySerialQueue.sync {
    changeValue(variant: .sync)
}
value // check value --------->


/// И печать, и результат изменились:
