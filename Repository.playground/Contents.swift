import UIKit

class Repository<T:Codable> {
    var path: String
    init(withPath path:String){
        self.path = path
    }
    // READ a single object
    func fetch(withId id: Int, withCompletion completion: @escaping (T?) -> Void) {
        let URLstring = path + "\(id)"
        if let url = URL.init(string: URLstring){
            let task = URLSession.shared.dataTask(with: url, completionHandler:
            {(data, response, error) in
                if let user = try? JSONDecoder().decode(T.self, from: data!){
                    completion (user)
                }
            })
            task.resume()
        }
    }
    
    //TODO: Build and test comparable methods for the other CRUD items
    //create user
    func create( a:T, withCompletion completion: @escaping (T?) -> Void ) {
        let URLstring = URL.init(string: path)
        var urlRequest = URLRequest.init(url: URLstring!)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try? JSONEncoder().encode(a)
        
        let task = URLSession.shared.dataTask(with: urlRequest) {
            (data, response, error) in
            let user = try? JSONDecoder().decode(T.self, from: data!)
            completion (user)
        }
        task.resume()
    }
    
    //update user
    func update( withId id:Int, a:T) {
        if let url = URL.init(string: path + "\(id)"){
            var urlRequest = URLRequest.init(url: url)
            urlRequest.httpMethod = "PUT"
            urlRequest.httpBody = try? JSONEncoder().encode(a)
            let task = URLSession.shared.dataTask(with: urlRequest)
            task.resume()
        }
    }
    
    // Delete User
    func delete( withId id:Int ) {
        if let url = URL.init(string: path + "\(id)"){
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "DELETE"
            let task = URLSession.shared.dataTask(with: urlRequest)
            task.resume()
        }
    }
    
}

class User: Codable {
    var UserID: String?
    var FirstName: String?
    var LastName: String?
    var PhoneNumber: String?
    var SID: String?
}

//Create a User Repository for the API at http://216.186.69.45/services/device/users/
let userRepo = Repository<User>(withPath: "http://216.186.69.45/services/device/users/")

//Fetch a single User
userRepo.fetch(withId: 45, withCompletion: {(user) in
    print(user!.FirstName ?? "no user")
    
    //Create a new user
    let user = User()
    user.FirstName = "Billy"
    user.LastName = "joe"
    user.PhoneNumber = "595959595"
    user.SID = "9999999"
    
    userRepo.create(a: user, withCompletion: { (user) in
        print(user!.FirstName ?? "no user")
    })
    
    //Update User
    user.FirstName = "notbilly"
    userRepo.update(withId: 112, a: user)
    print(user.FirstName ?? "no user")
    
    
    // Delete User
    userRepo.delete(withId: 111)
})

/**
 * TODO: // Refactor the code using Generics and protocols so that you can re-use it as shown below
 */
//Create a User Repository for the API at http://216.186.69.45/services/device/users/
//let userRepo = Repository<User>(withPath: "http://216.186.69.45/services/device/users/")

//Fetch a single User
//userRepo.fetch(withId: 43, withCompletion: {(user) in
// print(user!.FirstName ?? "no user")
//})

// Another type of object
class Match: Codable {
    var name: String?
    var password: String?
    var countTIme: String?
    var seekTime: String?
    var status: String?
}
//Create a Match Repository for a different API at http://216.186.69.45/services/hidenseek/matches/
let matchRepo = Repository<Match>(withPath: "http://216.186.69.45/services/hidenseek/matches/")

//Fetch a single User
matchRepo.fetch(withId: 1185, withCompletion: {(match) in
    print(match!.status ?? "no match")
})


