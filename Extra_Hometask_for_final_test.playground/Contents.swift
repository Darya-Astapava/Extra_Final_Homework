import Foundation



// -----------------------------------------------
// MARK: - Простые задачи
// -----------------------------------------------


// =================================
// MARK: - Task 1
// =================================
/*
 1. Объявите опциональную переменную типа Int.
 
 2. Подкиньте монетку (Bool.random()). Если значение монетки true, то присвойте переменной любое число.
 В противном случае оставьте опционал пустым.
 
 3. Воспользовавшись optional binding, разверните переменную и выведите в консоль её значение.
 Если не удалось развернуть, то выведите в консоль случайное число от 1 до 100 */


// -----------------------------------------------
// MARK: - Task 1. Solution
// -----------------------------------------------

var resultNumber: Int?
if Bool.random() == true { resultNumber = 100 }
if let result: Int = resultNumber {
    print(result)
} else {
    print(Int.random(in: 1...100))
}


// =================================
// MARK: - Task 2
// =================================
/*
 1. Создайте перечисление вещей, которые вас вдохновляют.
 
 2. Выведите все вещи в консоль с помощью CaseIterable.
 
 3. Напишите switch case по перечислению вдохновляющих вещей (для этого понадобится создать какую-то одну вещь).
 В каждом case выведите в консоль сообщение с объяснением, почему именно это вас вдохновляет.
 
 4. Объедините несколько case через запятую
 
 5. Реализуйте кейс по умолчанию для тех вещей, которые не хочется объяснять.*/


// -----------------------------------------------
// MARK: - Task 2. Solution
// -----------------------------------------------

enum InspirationalThings: CaseIterable {
    case succes
    case praise
    case freshAir
    case sport
    case driving
    case appearance
}

print(InspirationalThings.allCases)

var thing: InspirationalThings = .driving

switch thing {
case .succes:
    print("Someone's success makes the possibility of your success more real")
case .freshAir, .sport:
    print("Fresh air and sport add you cheerfulness")
case .driving, .appearance:
    print("Appropriate appearance and behavior give the feeling that you can already what you want to achive")
default:
    print("Something inspires, but I don't want to explain why")
}

// =================================
// MARK: - Task 3
// =================================
/*
 1. Игрок стреляет в мишень. Каждый выстрел состоит из номера попытки, сообщения "SHOT!" и результата (от 0 до 10 очков).
 
 2. Напишите программу, которая делает 10 выстрелов и находит общее количество выбитых очков
 
 3. Очки за выстрел начисляются следующим образом:
 • если игрок промахнулся (0), то в консоль выводится сообщение о промахе и от общего результата отнимается 1 штрафной балл.
 • если игрок попал в сектор от 1 до 5 и это нечетный выстрел, то результат выстрела увеличивается на 20%
 • если игрок попал в сектор от 6 до 10 и это четный выстрел, то результат выстрела увеличивается на 30%
 • если это 7 попытка, то у игрока отнимается 1 балл от общего результата
 • во всех остальных случаях количество очков за выстрел остаётся неизменным
 
 4. В каждом условии выведите в консоль номер выстрела, сообщение, очки за выстрел и общий результат. */

var shot = (attempt: 1, message: "SHOT!", score: Int.random(in: 0...10))

// -----------------------------------------------
// MARK: - Task 3. Solution
// -----------------------------------------------
var finalScore: Double = 0

func doShot(shot: inout (attempt: Int, message: String, score: Int)) {
    if shot.score == 0 {
        print("Miss")
        finalScore -= 1
    }
    if shot.score > 1, shot.score <= 5 && shot.attempt % 2 == 1 {
        finalScore *= 1.2
    }
    if shot.score > 6 && shot.attempt % 2 == 0 {
        finalScore *= 1.3
    }
    if shot.attempt == 7 {
        finalScore -= 1
    }
    finalScore += Double(shot.score)
    print("attemp \(shot.attempt), \(shot.message), score \(shot.score), final score \(Int(finalScore))")
    shot.attempt += 1
    shot.score = Int.random(in: 0...10)
}

for _ in 1...10 { doShot(shot: &shot) }

// =================================
// MARK: - Task 4
// =================================
/*
 1. Создайте случайную строку случайной длины, состоящей из только из цифр
 
 2. Строка может начинаться с 0
 
 3. Посчитайте сумму цифр, которые содержатся в строке
 
 4. Через каждые 4 цифры вставьте символ "-"
 
 5. Если в строке будет найден любой другой символ или буква,
 то выбросьте ошибку с описанием символа, который не подходит */

// -----------------------------------------------
// MARK: - Task 4. Solution
// -----------------------------------------------

enum StringError: Error {
    case incorrectSymbol(symbol: Character)
}

var randomString: String {
    var item: String = ""
    for _ in 1...Int.random(in: 5...100) {
        item.append(String(Int.random(in: 0...9)))
    }
    return item
}

var ourStringToWork = randomString
let sumOfNumbers = ourStringToWork.compactMap {str in Int(String(str)) }.reduce(0, +)

var someIndex: Int = 4
for _ in 1...ourStringToWork.count / 4 {
    ourStringToWork.insert("-", at: ourStringToWork.index(ourStringToWork.startIndex, offsetBy: someIndex))
    someIndex += 5
}
print(ourStringToWork)

func checkString(_ item: String) throws {
    try item.forEach() { guard $0.isNumber == true || $0 == "-" else { throw StringError.incorrectSymbol(symbol: $0) } }
}
try checkString(ourStringToWork)
// -----------------------------------------------
// MARK: - Комплексные задачи
// -----------------------------------------------

// =================================
// MARK: - Task 1. Server Response
// =================================

/*
 Решим задачу, которая поможет нам реализовать логику обработки ответа от сервера.
 */

/// Ответ содержит 4 параметра:
///   - `statusCode` (обязательный)
///   - `message` (необязательный),
///   - `errorMessage` (необязательный) - все строковые значения
///   - `dictionary` со следующими ключами и значениям соответственно:
///     * `age` - возраст студента
///     * `name` - имя студента
///     * `surname` - фамилия студента
///
/// 1. Создайте класс `ResponseModel`, который содержит переменные, соответствующие ключам аргумента `dictionary` серверного ответа
///
/// 2. Создайте структуру `Response`, которая состоит из
///   - `statusCode` (обязательный, типа `Int`)
///   - `message` (обязательный),
///   - `errorMessage` (необязательный)
///   - `reponseModel` типа созданного вами класса в 1 пункте
///
/// 3. Создайте функцию `parseServerResponse`, которая в качестве аргументов принимает все 4 параметра из ответа сервера и возвращает `Response`
/// Функция должна возвращать объект `Response`, проинициализированный всеми property, учитывая следующие требования:
///   - Преобразовывать `statusCode` в Int. При неуспешном приведении реализовать ранний выход и вывести ошибку в консоль
///   - При отсутствии `message` использовать сообщение по умолчанию: `"OK"`
///   - Создавать объект `ResponseModel`, вычитывая ключи из`dictionary`. Если какого-либо ключа не пришло, то реализовать ранний выход и вывести ошибку в консоль
///
/// 4. Создайте ещё одну функцию `handleResponse`, которая обрабатывает `Response`:
///   - Выводит в консоль `message`, если `statusCode` от 200 до 300 включительно
///   - Для остальных кодов выводит `errorMessage`.
///   - В случае отсутствия `errorMessage`, выведите шаблонный текст ошибки (фантазируйте)
///
/// 5. Вызовите функцию `parseServerResponse`, сохранив ответ в переменную
///
/// 6. Вызовите функцию `handleResponse`
///
/// 7. Создайте ещё одну переменную типа `Response`, присвоив ей уже имеющуюся переменную `Response`
///
/// 8. Выведите в консоль имя студента из первой и второй переменной
///
/// 9. Поменяйте имя студента в первом ответе сервера
///
/// 10. Снова выведите в консоль имя студента из первой и второй переменной.
///
/// 11. Изменилось ли оно в двух переменных? Как?
/// Ваш подробный ответ запишите в переменную `answer`, которая будет содержать многострочный текст.
/// Содержание переменной `answer` выведите в консоль.


// -----------------------------------------------
// MARK: - Task 1. Solution
// -----------------------------------------------

/*
 Ваше решение можно оформить тут */

enum ResponseError: Error {
    case incorrectStatusCodeType
    case notFoundResponse
}

class ResponseModel {
    var age: Int
    var name: String
    var surname: String
    
    init(age: Int, name: String, surname: String) {
        self.age = age
        self.name = name
        self.surname = surname
    }
}

struct Response {
    var statusCode: Int
    var message: String
    var errorMessage: String? = nil
    var responseModel: ResponseModel
}

func parseServerResponse(statusCode: Int?, message: String?, errorMessage: String?, responseModel: ResponseModel?) throws -> Response {
    guard let status: Int = statusCode else { throw ResponseError.incorrectStatusCodeType }
    guard let model: ResponseModel = responseModel,
          let _: Int = responseModel?.age,
          let _: String = responseModel?.name,
          let _: String = responseModel?.surname else { throw ResponseError.notFoundResponse }
    return Response(statusCode: status, message: message ?? "OK", errorMessage: errorMessage, responseModel: model)
}

func handleResponse(with response: Response) {
    if response.statusCode > 200, response.statusCode <= 300 {
        print(response.message)
    } else {
        if let message: String = response.errorMessage {
            print(message)
        } else { print("Something is wrong") }
    }
}

var responseFromServer = try parseServerResponse(statusCode: 208,
                                                 message: "Already Reported",
                                                 errorMessage: nil,
                                                 responseModel: .init(age: 28, name: "Nailya", surname: "Balabanoga"))

var newServerResponse: Response = responseFromServer
print("First students name is \(responseFromServer.responseModel.name), second students name is \(newServerResponse.responseModel.name)")
responseFromServer.responseModel.name = "Michail"
print("First students name is \(responseFromServer.responseModel.name), second students name is \(newServerResponse.responseModel.name)")

var answer: String = "Имя меняется в обоих ответах, потому что не смотря на то, что Response - это структура, само свойство имя принадлежит классу ResponseModel, на который ссылается свойство responseModel из структуры. Т.е. сама структура не хранит значение, она хранит ссылку на класс, в котором и хранится значение"
print(answer)


// =================================
// MARK: - Task 2. Shop Basket
// =================================

/*
 Ниже представлено условие задачи, для которой я приложил решение.
 
 В этот раз, Вам будет нужно разобраться:
 - Как этот код работает?
 - Что в нем можно поменять?
 - Что можно упростить?
 - Что переписать?
 
 А затем, выполнить несколько заданий из списка ниже.
 Если что-то будет непонятно - спрашивайте.
 
 Умение разбираться в коде очень важно и полезно для разработчиков разного уровня. */


/// `Условие`
///
/// Реализуйте программу магазин, которая позволит пользователям пользоваться корзинками, складывать в них товар, а также рассчитваться за покупки.
/// 1. Реализуйте протокол `Shoppable`, который будет описывать:
///   -  `baskets` - массив корзинок и тележек
/// а также позволит реализовать функции `buy` и `fillBasket` (описание методов смотрите ниже по условию)
///
/// 2. Реализуйте классовый протокол `ShopItem`, который будет описывать:
///   - `id` (тип `UUID`) - уникальный идентификатор продукта
///   - `name` - String - название
///   - `weight`- Double - вес
///   - `pricePerKg` - Double - цена за килограмм
///   - `price` - Double - цена
///
/// 3. Создайте расширение для протокола `ShopItem`, в котором рассчитайте значение для computed property `price`
///   Цена должна рассчитываться по формуле: `цена за килограмм x ( вес / 1000 )`
///
/// 4. Создайте класс `Basket`, который состоит из:
///     - Типа корзины `basketType` типа`BasketType`
///     - массива товаров `goods` типа `[ShopItem]`
///
///     `BasketType` - перечисление, которое содержит:
///         * тип корзинки
///         - `handbasket` - ручная корзинка
///         - `trolleyBasket`- тележка
///
///         * максимальную вместительность каждой корзинки `maxGoodAmount` типа `Int` (computed property):
///                 -  4 единицы товара для корзинки
///                 - 10 единиц товара для тележки
///
///     В инициализаторе класса `Basket` реализуйте возможность случайной генерации типа корзинки для параметра `basketType`
///     Если создать не получилось - верните `handbasket`
///
/// 5. Создайте класс `Goods` и подчините его протоколу `ShopItem`
///
/// 6. Создайте классы `Fruit` and `Vegetable` и наследуйте их от класса `Goods`
///   - для фруктов добавьте поле `levelOfSweetness` типа `Int`
///   - для овощей - `levelOfRipeness` типа `Int`
///
/// 7. Реализуйте класс `Shop` и подчините его протоколу `Shoppable`:
///   - Массив корзинок и тележек `baskets` заполните самостоятельно в произвольном объеме.
///
///   Реализуйте методы:
///   - `getBasket` - который позволяет покупателю брать корзинку (-1 объект из массива `baskets`)
///     - `Basket.BasketType` - тип корзинки
///     Если не получилось взять корзинку - верните ошибку `noBasket`, которая сможет вывести сообщение в консоль,
///     что свободных корзин в магазине нет
///
///   - `calculateChange` - который вернет покупателю сдачу
///     - `customerCash`: Double - обязательный - сумма пользователя
///     - `totalAmount`: Double - обязательный - стоимость товаров из корзинки
///          а возвращает - `Change` (Double)
///     Метод должен уметь возвращать ошибку `notEnoughMoney`, если у пользователя не хватает денег на товары из корзины
///     А также сообщение в консоль
///
///   - а также реализуйте методы из протокола:
///     - `buy` -
///         - `basket`: - корзина покупателя
///         - `discountType` - тип товара, к которому будет применена скидка (Фрукты или Овощи)
///         - `discount` - размер скидки
///         - `paymentHandler` - `(Double) -> (Double)` - замыкание, которое передает сумму к оплате товара
///         - `successHandler` - `(Double) -> Void`  - замыкание об успешном выполнении операции
///         - `errorHandler` - замыкание, которое вызывается в случае нехватки денежных средств
///
///     - `fillBasket` - метод, который позволяет наполнить корзину покупателя покупками
///       - `basket`: - корзина покупателя
///       - `products` - товары из корзины
///       - `fillingBasketErrorHandler`: если не получилось заполнить корзину
///


// MARK: - Protocols
protocol Shoppable {
    typealias PaidAmount = Double
    typealias PaymentHandler = (_ totalAmount: Double) -> (PaidAmount)
    
    var baskets: [Basket] { get }
    
    func buy<T>(basket: Basket,
                discountType: T.Type,
                discount: Double,
                paymentHandler: PaymentHandler,
                successHandler: (Double) -> Void,
                errorHandler: (FinanceException) -> Void)
    
    func fillBasket(_ basket: inout Basket, with products: [Goods],
                    fillingBasketErrorHandler: ([ShopItem]) -> Void) -> Basket
}

protocol ShopItem: class {
    var id: UUID { get }
    var name: String { get }
    var weight: Double { get }
    var pricePerKg: Double { get set }
    
    var price: Double { get }
}

// MARK: - Extensions
extension ShopItem {
    var price: Double {
        pricePerKg * (weight / 1000)
    }
}

// MARK: - Enums
enum BasketException: LocalizedError, Error {
    case noBasket
    
    var description: String {
        switch self {
        case .noBasket:
            return NSLocalizedString("No basket in the shop", comment: "")
        }
    }
}

enum FinanceException: Error {
    case notEnoughMoney(needded: Double)
    
    var description: String {
        switch self {
        case .notEnoughMoney(needded: let money):
            return NSLocalizedString("Not enought money. Give \(money) else", comment: "")
        }
    }
}

// MARK: - Classes
class Basket {
    enum BasketType: CaseIterable {
        case handbasket, trolleyBasket
        
        var maxGoodAmount: Int {
            switch self {
            case .handbasket:
                return 4
            case .trolleyBasket:
                return 10
            }
        }
    }
    
    var basketType: BasketType
    var goods: [ShopItem] = []
    
    init() {
        self.basketType = BasketType.allCases.randomElement() ?? .handbasket
    }
}

class Goods: ShopItem {
    var id: UUID = UUID()
    var name: String
    var weight: Double
    var pricePerKg: Double
    
    init(name: String, weight: Double, pricePerKg: Double) {
        self.name = name
        self.weight = weight
        self.pricePerKg = pricePerKg
    }
}

class Fruit: Goods {
    let levelOfSweetness: Int
    
    init(levelOfSweetness: Int, name: String, weight: Double, pricePerKg: Double) {
        self.levelOfSweetness = levelOfSweetness
        super.init(name: name, weight: weight, pricePerKg: pricePerKg)
    }
}

class Vegetable: Goods {
    let levelOfRipeness: Int
    
    init(levelOfRipeness: Int, name: String, weight: Double, pricePerKg: Double) {
        self.levelOfRipeness = levelOfRipeness
        super.init(name: name, weight: weight, pricePerKg: pricePerKg)
    }
}

class Shop: Shoppable {
    typealias Change = Double
    
    var baskets: [Basket]
    
    init(baskets: [Basket]) {
        self.baskets = baskets
    }
    
    /**
     Берем корзину соответствующего типа, переданного в параметре
     - parameter type: Basket.BasketType
     - returns: Basket
     */
    func getBasket(type: Basket.BasketType) throws -> Basket {
        var filterBaskets = baskets.filter { $0.basketType == type }
        let basket: Basket? = filterBaskets.removeFirst()
        self.baskets = filterBaskets + baskets.filter { $0.basketType != type }
        if let basket = basket {
            return basket
        } else {
            throw BasketException.noBasket
        }
    }
    
    /**
     Наполняем корзину продуктами, проверяем вместимость корзины. Если продуктов больше, чем корзина вмещает, обрабатываем ошибку
     - parameter basket: Basket
     - parameter with: [Goods] - массив продуктов
     - parameter  fillingBasketErrorHandler: ([ShopItem]) -> Void - замыкание, проверяем чтобы продукты не повторялись
     - returns: Basket
     */
    func fillBasket(_ basket: inout Basket,
                    with products: [Goods],
                    fillingBasketErrorHandler: ([ShopItem]) -> Void) -> Basket {
        for product in products {
            if basket.goods.count < basket.basketType.maxGoodAmount {
                basket.goods.append(product)
            } else {
                fillingBasketErrorHandler(products.filter { product in
                    !basket.goods.contains { $0.id != product.id }
                })
                break
            }
        }
        return basket
    }
    
    /**
     Выполняем покупку.
     - parameter basket: Basket
     - parameter discountType: T.Type - определяем тип продуктов, на которые расспространяется скидка
     - parameter discount: Double
     - parameter paymentHandler: (Double) -> (Shop.PaidAmount)
     - parameter successHandler: (Double) -> Void,
     - parameter errorHandler: (FinanceException) -> Void)
     */
    func buy<T>(basket: Basket,
                discountType: T.Type,
                discount: Double,
                paymentHandler: (Double) -> (Shop.PaidAmount),
                successHandler: (Double) -> Void,
                errorHandler: (FinanceException) -> Void) {
        basket.goods.map { if $0 is T { $0.pricePerKg *= discount } }
        
        print("Type of customers basket is \(basket.basketType)")
        defer { self.baskets.append(basket) }
        
        var totalAmount: Double = 0
        basket.goods.forEach { totalAmount += $0.price }
        
        do {
            try successHandler(self.calculateChange(customerCash: paymentHandler(totalAmount),
                                                    totalAmount: totalAmount))
        } catch let error as FinanceException {
            errorHandler(error)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /**
     Считаем сдачу
     - parameter customerCash: Double
     - parameter totalAmount: Double
     - returns: Change (Double)
     */
    private func calculateChange(customerCash: Double, totalAmount: Double) throws -> Change {
        let cash = String(format: "%.2f", customerCash)
        print("You gave me: \(cash)")
        guard customerCash >= totalAmount else {
            throw FinanceException.notEnoughMoney(needded: ((totalAmount - customerCash) * 100).rounded() / 100)
        }
        return customerCash - totalAmount
    }
}



// MARK: - Body
let apple = Fruit(levelOfSweetness: 5, name: "Apple", weight: 1000, pricePerKg: 15)
let tomato = Vegetable(levelOfRipeness: 8, name: "Tomato", weight: 500, pricePerKg: 45)
let milk = Goods(name: "Milk", weight: 1, pricePerKg: 50)
let orange = Fruit(levelOfSweetness: 3, name: "Orange", weight: 1000, pricePerKg: 25)
let bread = Goods(name: "Bread", weight: 1, pricePerKg: 30)
let eggs = Goods(name: "Eggs", weight: 10, pricePerKg: 60)
let butter = Goods(name: "Butter", weight: 1, pricePerKg: 60)

let shop = Shop(baskets: [Basket(), Basket(), Basket(), Basket(), Basket(), Basket()])
shop.baskets.forEach {
    print($0.basketType)
}

do {
    var basket = try shop.getBasket(type: .handbasket)
    shop.fillBasket(
        &basket,
        with: [apple, tomato, milk, bread, butter, orange, eggs]) {
        print("Following products weren't added: \($0.map { $0.name }.joined(separator: ", "))")
    }
    shop.buy(
        basket: basket,
        discountType: Fruit.self,
        discount: 0.5,
        paymentHandler: { (totalAmount) -> (Shop.PaidAmount) in
            print("Your total amount is: \((totalAmount * 100).rounded() / 100)")
            return Double.random(in: 0...totalAmount )
        }, successHandler: { (change) in
            print("Your change is \(change)")
        }, errorHandler: { error in
            print(error.description)
        })
} catch let error as BasketException {
    print(error.description)
} catch let error as FinanceException {
    print(error.description)
}

shop.baskets.forEach {
    print("After: \($0.basketType)")
}


/// `Дополнительное задание`
/// `1. Реализовать функционал, который позволит вернуть корзинки в магазин`
///     - как при успешном, так  при и неуспешном расчете покупателя

/// `2. Все суммы, которые отображаются в консоли должны содержать только два знака после точки / запятой`
///     (Частая задача на продакшне при разработке финансовых приложений)
///
/// `3. Задокументировать код `
///     - Напишите по всем правилам, что делает каждая из функций в программе
///
/// `4. Реализуйте заполнение корзины пользователя различными товарами с разными ценами в различном объеме`
///     - Можете добавить новые категории товаров или случайным оьбразом



// -----------------------------------------------
// MARK: - Task 2. Solution
// -----------------------------------------------

/*
 Ваше решение можно оформить тут */
