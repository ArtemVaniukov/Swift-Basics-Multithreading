import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true


var view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))

imageView.backgroundColor = .yellow
imageView.contentMode = .scaleAspectFit

view.addSubview(imageView)

PlaygroundPage.current.liveView = view

let imageURL = URL(string: K.URL.imageURLs.randomElement()!)!


/// Classical way
func fetchImageInAClassicalWay() {
    let queue = DispatchQueue.global(qos: .utility)
    
    queue.async {
        if let data = try? Data(contentsOf: imageURL) {
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        }
    }
}

func fetchImageWithURLSession() {
    URLSession.shared.dataTask(with: imageURL) { data, response, error in
        guard error == nil else { return }
        if let data = data {
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        }
    }.resume()
}

func fetchImageWithDispatchWorkItem() {
    /// Можно использовать класс DispatchWorkItem и его метод notify (queue:, execute:), а также метод экземпляра класса DispatchQueue
    var data: Data?
    let queue = DispatchQueue.global(qos: .utility)
    
    let workItem = DispatchWorkItem { data = try? Data(contentsOf: imageURL) }
    
    /// Мы формируем синхронное задание в виде экземпляра workItem класса DispatchWorlItem, состоящее в получение данных data из «сети» по заданному imageURL адресу. Выполняем асинхронно задание workItem на параллельной глобальной очереди queue с качеством обслуживания qos: .utility с помощью функции:
    queue.async(execute: workItem)
    
    /// С помощью функции
    workItem.notify(queue: .main) {
        if let data = data {
            imageView.image =  UIImage(data: data)
        }
    }
    /// мы ждем уведомление об окончании загрузки данных в data. Как только это произошло, мы оповещаем delegate о завершении работы
}

func fetchImageWithAsyncLoadWrapper(url: URL,
                                    runQueue: DispatchQueue,
                                    completionQueue: DispatchQueue,
                                    completion: @escaping (UIImage?, Error?) -> Void) {
    runQueue.async {
        do {
            let data = try Data(contentsOf: url)
            completionQueue.async { completion(UIImage(data: data), nil) }
        } catch {
            completion(nil, error)
        }
    }
}

fetchImageInAClassicalWay()
//fetchImageWithURLSession()
//etchImageWithDispatchWorkItem()
//fetchImageWithAsyncLoadWrapper(url: imageURL, runQueue: .global(qos: .utility), completionQueue: .main) { image, error in
//    guard error == nil else { print(error ?? "Unknown Error")
//        return
//    }
//    imageView.image = image
//}

