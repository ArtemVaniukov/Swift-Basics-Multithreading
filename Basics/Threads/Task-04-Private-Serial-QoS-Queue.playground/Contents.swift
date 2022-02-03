import UIKit
import PlaygroundSupport


PlaygroundPage.current.needsIndefiniteExecution = true

let tasker = Tasker()

/// Давайте назначим нашей Private последовательной очереди serialPriorityQueue качество обслуживания qos, равное .userInitiated, и поставим асинхронно в эту очередь сначала задания
///
/// task("😊")
///
/// а потом
/// 
/// task("👹")
///
/// Этот эксперимент убедит нас в том, что наша новая очередь serialPriorityQueue действительно является последовательной, и несмотря на использование async метода, задания выполняются последовательно друг за другом в порядке поступления:



// let task1: () = task("😊")
// let task2: () = task("👹")


func runTest1() {
    print("\n")
    print("------------------------------------------------")
    print("   Private .serial Q1 - .userInitiated     ")
    print("------------------------------------------------")

    let serialPriorityQueue = DispatchQueue(label: "com.basics.threads.task4.serialQueue.userInititated",
                                        qos: .userInitiated)

    serialPriorityQueue.async { tasker.task("😊") }
    serialPriorityQueue.async { tasker.task("👹") }
    sleep(1)
}

/// Таким образом, для многопоточного выполнения кода недостаточно использовать метод async, нужно иметь много потоков либо за счет разных очередей, либо за счет того, что сама очередь является параллельной (.concurrent). Ниже в эксперименте с параллельными (.concurrent) очередями мы увидим аналогичный эксперимент с Private параллельной (.concurrent) очередью workerQueue, но там будет совсем другая картина, когда мы будем помещать в эту очередь те же самые задания.

/// Давайте используем последовательные Private очереди с разными приоритетами для асинхронной постановки в эту очереди сначала заданий
///
/// task("😊")
///
/// а потом заданий
///
/// task("👹")
 
func runTest2() {
    /// очередь serialUserInititatedQueue c qos .userInitiated
    let serialUserInititatedQueue = DispatchQueue(label: "com.basics.threads.task4.serialQueue.userInititated",
                                                  qos: .userInitiated)

    /// очередь serialBackgroundQueue c qos .background
    let serialBackgroundQueue = DispatchQueue(label: "com.basics.threads.task4.serialQueue.background",
                                              qos: .background)

    print("\n")
    print("------------------------------------------------")
    print("   Private .serial Q1 - .userInitiated     ")
    print("                   Q2 - .background        ")
    print("------------------------------------------------")

    serialUserInititatedQueue.async { tasker.task("😊") }
    serialBackgroundQueue.async { tasker.task("👹") }
    sleep(1)
    
    /// Здесь происходит многопоточное выполнение заданий, и задания чаще исполняются на очереди serialUserInititatedQueue, имеющей более приоритетное качество обслуживания qos: .userIniatated.
}

func runTest3() {
    /// Вы можете задержать выполнение заданий на любой очереди DispatchQueue на заданное время, например, на now() + 0.1 с помощью функции asyncAfter и еще изменить при этом качество обслуживания qos:
    ///
    print("\n")
    print("------------------------------------------------")
    print("   asyncAfter(.userInteractive) на Q2")
    print("   Private .serial Q1 - .utility     ")
    print("                   Q2 - .background  ")
    print("------------------------------------------------")
    
    let serialUtilityQueue = DispatchQueue(label: "com.basics.threads.task4.serialQueue.utility",
                                           qos: .utility)
    let serialBackgroundQueue = DispatchQueue(label: "com.basics.threads.task4.serialQueue.background",
                                              qos: .background)
    
    serialBackgroundQueue.asyncAfter(deadline: .now() + 0.1, qos: .userInteractive) { tasker.task("👹") }
    serialUtilityQueue.async { tasker.task("😊") }
    sleep(1)
}

/// Switch between tests
runTest1()
runTest2()
runTest3()
