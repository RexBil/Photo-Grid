

import Foundation

extension URLSession{
    func reuquest<T:Codable>(url:URL?, expeating:T.Type, compleationHndler:@escaping (Result<T, Error>) -> Void){
        guard let url = url else {
            compleationHndler(.failure(AppError.invalidUrl))
            return
        }
        let task = dataTask(with: url) { (data, _, error) in
            guard let data = data else{
                if let error = error{
                    compleationHndler(.failure(error))
                }else{
                    compleationHndler(.failure(AppError.serverError("Invalid Data")))
                }
                return
            }
            do {
                let result = try JSONDecoder().decode(expeating, from: data)
                compleationHndler(.success(result))
              //  print(result)
            }catch{
                compleationHndler(.failure(error))
            }
        }
        task.resume()
    }
}
