import UIKit
import PlaygroundSupport


/// Apple обеспечивает нас единственной ГЛОБАЛЬНОЙ serial (ПОСЛЕДОВАТЕЛЬНОЙ) очередью — это упомянутая выше Main queue. На этой очереди нежелательно выполнять ресурсоёмкие операции (например, загрузку данных из сети), не относящиеся с изменению UI, чтобы не «замораживать» UI на время выполнения этой операции и сохранить отзывчивость пользовательского интерфейса на действия пользователя в любой момент времени, например, на жесты.

/// Есть и еще одно жесткое требование — ТОЛЬКО на Main queue мы можем изменять UI элементы.
///
/// Это потому, что мы хотим, чтобы Main queue была не только “отзывчивой” на действия с UI (да, это основная причина), но мы хотим также, чтобы пользовательский интерфейс был защищен от “разлаживания” в многопоточной среде, то есть реакция на действия пользователя выполнялась бы строго последовательно в упорядоченной манере. Если мы разрешим нашим элементам UI выполнять свои действия в различных очередях, то может случиться, что рисование будет происходить с разной скоростью, и действия будет пересекаться, что приведет к полной непредсказуемости на экране. Мы используем Main queue как своего рода “точку синхронизации”, в которую возвращается каждый, кто хочет “рисовать” на экране.
