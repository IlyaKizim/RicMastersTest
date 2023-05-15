
import Foundation

enum APIError: Error {
    case failedTogetData
    case invalidURL
    case invalidResponse
}

protocol GetApi {
    func getCamera(completion: @escaping (Result<ApiResponse, Error>) -> Void)
    func getDoors(completion: @escaping (Result<[Door], Error>) -> Void)
}


final class APICaller: GetApi{
    
    func getCamera(completion: @escaping (Result<ApiResponse, Error>) -> Void) {
        guard let url = URL(string: Constants.apiCamera) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedTogetData))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200 ..< 300 ~= httpResponse.statusCode else {
                completion(.failure(APIError.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(ApiResponse.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(APIError.failedTogetData))
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
   
    func getDoors(completion: @escaping (Result<[Door], Error>) -> Void) {
        guard let url = URL(string: Constants.apiDoors) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(APIError.failedTogetData))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, 200 ..< 300 ~= httpResponse.statusCode else {
                completion(.failure(APIError.invalidResponse))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(APIDoors.self, from: data)
                completion(.success(result.data))

            } catch {
                completion(.failure(APIError.failedTogetData))
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
}
