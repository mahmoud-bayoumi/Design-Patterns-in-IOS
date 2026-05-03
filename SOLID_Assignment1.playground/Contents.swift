class Data{}
/* 1
 class Handler {
    
    func handle(){
        let data = requestDataToAPI()
        let array = parse(data: data)
        saveToDB(array: array)
    }
    
    private func requestDataToAPI() -> Data{
        // send API request and wait the response
        return data
    }
    
    private func parse(data : Data) -> [String]{
        // pase the data and create the array
        return str
    }
    
    private func saveToDB(array : [String]) {
        // save the array in a database (CoreData / Realm / ... )
        
    }
}

 Violates
   - Single Responsbility Principle
   - Dependency Inversion Principle (Depnends on concerete imp)
   - Open/Closed Principle (while saving to other db)
 
 */

protocol APIClient {
    func requestData() -> Data
}

protocol Parser {
    func parse(data: Data) -> [String]
}

protocol Storage {
    func save(array: [String])
}


final class DefaultAPIClient: APIClient {
    func requestData() -> Data {
        // send API request and wait for the response
        return Data()
    }
}

final class DefaultParser: Parser {
    func parse(data: Data) -> [String] {
        // parse the data and create the array
        return []
    }
}

final class CoreDataStorage: Storage {
    func save(array: [String]) {
        // save the array using CoreData
    }
}

final class Handler {
    
    private let apiClient: APIClient
    private let parser: Parser
    private let storage: Storage
    
    init(apiClient: APIClient,
         parser: Parser,
         storage: Storage) {
        self.apiClient = apiClient
        self.parser = parser
        self.storage = storage
    }
    
    func handle() {
        let data = apiClient.requestData()
        let array = parser.parse(data: data)
        storage.save(array: array)
    }
}

// 2
/*
 class UserFetcher {
     
     func fetchUsers(onComplete: @escaping ([User]) -> Void) {
         let session = URLSession.shared
         let url = URL(string: "")!
         session.dataTask(with: url) { (data, _, error) in
             guard let data = data else {
                 print(error!)
                 onComplete([])
                 return
             }
             
             let decoder = JSONDecoder()
             let decoded = try? decoder.decode([User].self, from: data)
             onComplete(decoded ?? [])
         }
     }
 }
 
 Violates
   - Single Responsbility Principle
   - Dependency Inversion Principle (Depnends on concerete imp)
   - Open/Closed Principle (changing the endpoint or change the netwrok layer )
 
 */



protocol NetworkSession {
    func loadData(from url: URL, completion: @escaping (Data?, Error?) -> Void)
}

protocol DataDecoding {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) -> T?
}

protocol Fetching {
    func fetch<T: Decodable>(_ type: T.Type, onComplete: @escaping (T?) -> Void)
}


class URLSessionNetworkSession: NetworkSession {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func loadData(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        session.dataTask(with: url) { data, _, error in
            completion(data, error)
        }.resume()
    }
}

class JSONDataDecoder: DataDecoding {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) -> T? {
        let decoder = JSONDecoder()
        return try? decoder.decode(type, from: data)
    }
}


class UserFetcher: Fetching {
    private let session: NetworkSession
    private let decoder: DataDecoding
    private let url: URL

    init(session: NetworkSession, decoder: DataDecoding, url: URL) {
        self.session = session
        self.decoder = decoder
        self.url = url
    }

    // it now returns Generic <T> ( can use it to return use , product , ... )
    func fetch<T: Decodable>(_ type: T.Type, onComplete: @escaping (T?) -> Void) {
        session.loadData(from: url) { [weak self] data, error in
            guard let self = self else { return }
            guard let data = data else {
                print(error ?? "Unknown error")
                onComplete(nil)
                return
            }
            onComplete(self.decoder.decode(type, from: data))
        }
    }
}

// 3
/*
 protocol GestureProtocol {
     func didTap()
     func didDoubleTap()
     func didLongPress()
 }

 class SuperButton: GestureProtocol {

     func didTap() {
         // send tap action
     }

     func didDoubleTap() {
         // send double tap action
     }

     func didLongPress() {
         // send long press action
     }
 }

 class PoorButton: GestureProtocol {

     func didTap() {
         // send tap action
     }

     func didDoubleTap() {
         // do nothing
     }

     func didLongPress() {
         // do nothing
     }
 }
 Violates
    - Interface Segregation Principle ( empty implementation in some methods )
 */


protocol Tappable {
    func didTap()
}

protocol DoubleTappable {
    func didDoubleTap()
}

protocol LongPressable {
    func didLongPress()
}


class SuperButton: Tappable, DoubleTappable, LongPressable {

    func didTap() {
        // send tap action
        print("Tapped!")
    }

    func didDoubleTap() {
        // send double tap action
        print("Double Tapped!")
    }

    func didLongPress() {
        // send long press action
        print("Long Pressed!")
    }
}

class PoorButton: Tappable {

    func didTap() {
        // send tap action
        print("Tapped!")
    }
}
