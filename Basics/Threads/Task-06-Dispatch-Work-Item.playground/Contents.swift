import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let tasker = Tasker()

/// Если вы хотите иметь дополнительные возможности по управлению выполнением различных заданий на Dispatch очередях, то можно создать DispatchWorkItem, для которого можно задать качество обслуживания qos, и оно будет воздействовать на его выполнение:
let highPriorityItem = DispatchWorkItem(qos: .userInteractive, flags: [.enforceQoS]) {
    tasker.taskHighPriority("🌺")
}
/// Задавая флаг [.enforceQoS] при подготовке DispatchWorkItem, мы получаем более высокий приоритет для задания highPriorityItem перед остальными заданиями на той же очереди:

func runTest1() {
    print("\n")
    print("------------------------------------------------")
    print("   .concurrent Q1 - .userInitiated ")
    print("               Q2 - .background ")
    print("------------------------------------------------")
    
    let userInitiatedConcurrentQueue = DispatchQueue(label: "com.basics.threads.task6.concurrentQueue.userInititated",
                                                     qos: .userInitiated,
                                                     attributes: .concurrent)
    let backgroundConcurrentQueue = DispatchQueue(label: "com.basics.threads.task6.concurrentQueue.background",
                                                  qos: .background,
                                                  attributes: .concurrent)
    
    userInitiatedConcurrentQueue.async { tasker.task("🥸") }
    backgroundConcurrentQueue.async { tasker.task("🤢") }
    
    userInitiatedConcurrentQueue.async(execute: highPriorityItem)
    backgroundConcurrentQueue.async(execute: highPriorityItem)
    
    sleep(1)
    
    /// Это позволяет принудительно повышать приоритет выполнения конкретного задания на Dispatch Queue c определенным качеством обслуживания qos и, таким образом, бороться с явлением «инверсия приоритетов». Мы видим, что несмотря на то, что два задания highPriorityItem стартуют самыми последними, они выполняется в самом начале благодаря флагу [.enforceQoS] и повышению приоритета до .userInteractive. Кроме того, задание highPriorityItem может запускаться многократно на различных очередях.
}

func runTest2() {
    print("\n")
    print("------------------------------------------------")
    print("   .concurrent Q1 - .userInitiated ")
    print("               Q2 - .background ")
    print("------------------------------------------------")
    
    /// Если мы уберем флаг [.enforceQoS]:
    let highPriorityItem = DispatchWorkItem(qos: .userInteractive) {
        tasker.taskHighPriority("🌺")
    }
    ///  то задания highPriorityItem будут брать то качество обслуживание qos, которое установлено для очереди, на которой они запускаются:
    
    let userInitiatedConcurrentQueue = DispatchQueue(label: "com.basics.threads.task6.concurrentQueue.userInititated",
                                                     qos: .userInitiated,
                                                     attributes: .concurrent)
    let backgroundConcurrentQueue = DispatchQueue(label: "com.basics.threads.task6.concurrentQueue.background",
                                                  qos: .background,
                                                  attributes: .concurrent)
    
    userInitiatedConcurrentQueue.async { tasker.task("🥸") }
    backgroundConcurrentQueue.async { tasker.task("🤢") }
    
    userInitiatedConcurrentQueue.async(execute: highPriorityItem)
    backgroundConcurrentQueue.async(execute: highPriorityItem)
    
    sleep(1)
}

// Switch tests
runTest1()
//runTest2()
