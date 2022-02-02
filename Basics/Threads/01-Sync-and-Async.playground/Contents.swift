import UIKit
import PlaygroundSupport


let imageView = UIImageView()


/// Когда мы получаем данные Data из сети на другой очереди DispatchQueue, Main thread — свободна и обслуживает все события, которые происходят на UI. Давайте посмотрим, как выглядит реальный код для этого случая:

let imageURL = URL(string: "http://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg")!
let queue = DispatchQueue.global(qos: .utility)

/// Для выполнения загрузки данных по URL-адресу imageURL, что может занять значительное время и заблокировать Main queue, мы АСИНХРОННО переключаем выполнение этого ресурса-емкого задания на глобальную параллельную очередь с качеством обслуживания qos, равным .utility (более подробно об этом чуть позже):
queue.async {
    if let data = try? Data(contentsOf: imageURL) {
        
        /// После получения данных data мы вновь возвращаемся на Main queue, чтобы обновить наш UI элемент imageView.image с помощью этих данных.
        DispatchQueue.main.async {
            imageView.image = UIImage(data: data)
            print("Image has been downloaded - \(String(describing: imageView.image))")
        }
    }
}

/// Заметьте, что переключение затратных заданий с Main queue на другой поток всегда АСИНХРОННО.
/// Нужно быть очень внимательным с методом sync для очередей, потому что «текущий поток» вынужден ждать окончания выполнения задания на другой очереди. НИКОГДА НЕ вызывайте метод sync на Main queue, потому что это приведет к deadlock вашего приложения! (об этом ниже)

