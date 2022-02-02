import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true


let tasker = Tasker()

/// Для того, чтобы инициализировать Private параллельную (.concurrent) очередь достаточно указать при инициализации Private очереди значение аргумента attributes равное .concurrent. Если вы не указываете этот аргумент, то Private очередь будет последовательной (.serial). Аргумент qos также не требуется и может быть пропущен без всяких проблем.

let workerQueue = DispatchQueue(label: "com.basics.threads.task5.concurrentQueue.userInititated",
                                qos: .userInitiated,
                                attributes: .concurrent)

/// Давайте назначим нашей параллельной очереди workerQueue качество обслуживания qos, равное .userInitiated, и поставим асинхронно в эту очередь сначала задания
/// task("😁")
/// а потом
/// task("😡")

/// Наша новая параллельная очередь workerQueue действительно является параллельной, и задания в ней выполняются одновременно, хотя все, что мы сделали по сравнению со четвертым экспериментом (одна последовательная очередь serialPriorityQueue), это задали аргумент attributes равном .concurrent:

func runTest1() {
    print("\n")
    print("------------------------------------------------")
    print("   Private .concurrent Q - .userInitiated     ")
    print("------------------------------------------------")
    
    workerQueue.async { tasker.task("😁") }
    workerQueue.async { tasker.task("😡") }
    sleep(2)
    
    /// Картина совершенно другая по сравнению с одной последовательной очередью. Если там все задания выполняются строго в том порядке, в котором они поступают на выполнение, то для нашей параллельной (многопоточной) очереди workerQueue, которая может «расщепляться» на несколько потоков, задания действительно выполняются параллельно: некоторые задания с символом
    /// "😡"
    /// будучи позже поставлены в очередь workerQueue, выполняются быстрее на параллельном потоке.
}

func runTest2() {
    print("\n")
    print("------------------------------------------------")
    print("   .concurrent Q1 - .userInitiated ")
    print("               Q2 - .background ")
    print("------------------------------------------------")
    /// Давайте используем параллельные Private очереди с разными приоритетами:

    /// очередь userInitiatedConcurrentQueue c qos .userInitiated
    let userInitiatedConcurrentQueue = DispatchQueue(label: "com.basics.threads.task5.concurrentQueue.userInititated",
                                                     qos: .userInitiated,
                                                     attributes: .concurrent)
    /// очередь backgroundConcurrentQueue c qos .background
    let backgroundConcurrentQueue = DispatchQueue(label: "com.basics.threads.task5.concurrentQueue.background",
                                                  qos: .background,
                                                  attributes: .concurrent)
    
    backgroundConcurrentQueue.async { tasker.task("😁") }
    userInitiatedConcurrentQueue.async { tasker.task("😡") }
    sleep(2)
    
    /// Здесь такая же картина, как и с разными последовательными Private очередями во втором эксперименте. Мы видим, что задания чаще исполняются на очереди workerQueue1, имеющей более высокий приоритет.
}

func runTest3() {
    print("\n")
    print("------------------------------------------------")
    print("   Concurrent Queue with Delayed Execution ")
    print("   Private .concurrent Q - .userInitiated, .inititallyInactive ")
    print("------------------------------------------------")
    
    /// Можно создавать очереди с отложенным выполнением с помощью аргумента attributes, а затем активировать выполнение заданий на ней в любое подходящее время c помощью метода activate():
    let workerDelayedQueue = DispatchQueue(label: "com.basics.threads.task5.concurrentQueue.delayedQueue",
                                           qos: .userInitiated,
                                           attributes: [.concurrent, .initiallyInactive])
    
    workerDelayedQueue.async { tasker.task("😁") }
    workerDelayedQueue.async { tasker.task("😡") }
    sleep(1)
    
    
    print("------------------------------------------------")
    print("   Task Execution on Concurrent Queue ")
    print("   With Delayed Execution ")
    print("------------------------------------------------")
    
    workerDelayedQueue.activate()
    sleep(1)
    
}

// Switch tests
runTest1()
//runTest2()
//runTest3()
