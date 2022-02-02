import UIKit
import PlaygroundSupport

/// Взаимная блокировка — это аварийное состояние системы, которое может возникать при вложенности блокировок ресурсов. Допустим в системе существуют две задачи с низким (А) и высоким (Б) приоритетом, которые используют два ресурса — X и Y:

/// В момент времени T1 задача (А) блокирует ресурс X. Затем в момент времени T2 задачу (А) вытесняет более приоритетная задача (Б), которая в момент времени T3 блокирует ресурс Y. Если задача (Б) попытается заблокировать ресурс X (T4) не освободив ресурс Y, то она будет переведена в состояние ожидания, а выполнение задачи (А) будет продолжено. Если в момент времени T5 задача (А) попытается заблокировать ресурс Y, не освободив X, возникнет состояние взаимной блокировки — ни одна из задач (А) и (Б) не сможет получить управление.

/// Взаимная блокировка возможна только тогда, когда в системе используется зависимый (вложенный) многопоточный доступ к ресурсам. Взаимной блокировки можно избежать, если не использовать вложенность, или если ресурс использует протокол увеличения приоритета.
/// Если мы в задаче, представленной в начале поста, после получения данных из сети в фоновой очереди, попытаемся использовать для возвращения на main queue метод sync, то мы мы получим взаимную блокировку (deadock).


// НИКОГДА НЕ вызывайте метод sync на main queue, потому что это приведет к взаимной блокировке (deadlock) вашего приложения!


PlaygroundPage.current.needsIndefiniteExecution = true

let url = "http://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg"

var view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))

var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
imageView.backgroundColor = .yellow
imageView.contentMode = .scaleAspectFit

view.addSubview(imageView)


PlaygroundPage.current.liveView = view

func fetchImage(at url: URL?) {
    guard let url = url else { return }

    let queue = DispatchQueue.global(qos: .utility)
    queue.async {
        if let data = try? Data(contentsOf: url) {
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
                print("Image set")
            }
            print("Image data downloaded")
        }
    }
}

fetchImage(at: URL(string: url))


// PlaygroundPage.current.finishExecution()
