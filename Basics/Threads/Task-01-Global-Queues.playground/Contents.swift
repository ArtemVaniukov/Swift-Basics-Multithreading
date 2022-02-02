import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true


// 1. Global SERIAL Main Queue
let mainQueue = DispatchQueue.main

// 2. Global CONCURRENT Dispatch Queues
let userInteractiveQueue = DispatchQueue.global(qos: .userInteractive)
let userInititatedQueue = DispatchQueue.global(qos: .userInitiated)
let utilityQueue = DispatchQueue.global(qos: .utility)
let backgroundQueue = DispatchQueue.global(qos: .background)

// 3. Global CONCURRENT Default Dispatch Queue
let defaultQueue = DispatchQueue.global(qos: .default)

// Let's check execution of differently prioretized queues
let tasker = Tasker()

userInteractiveQueue.async { tasker.task("🔵") }
userInititatedQueue.async { tasker.task("🟢") }
defaultQueue.async { tasker.task("🟡") }
utilityQueue.async { tasker.task("🟠") }
backgroundQueue.async { tasker.task("🔴") }

userInteractiveQueue.async { tasker.taskHighPriority("🟪") }
userInteractiveQueue.async { tasker.taskHighPriority("🟪") }
userInteractiveQueue.async { tasker.taskHighPriority("🟪") }
