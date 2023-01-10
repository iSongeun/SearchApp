//
//  SearchBlogNetwork.swift
//  SearchApp
//
//  Created by 이송은 on 2022/12/05.
//

import Foundation
import RxSwift

enum SearchNetworkError : Error{
    case invalidJSON
    case networkError
    case invalidURL
}


class SearchBlogNetwork {
    private let session : URLSession
    let api = SearchBlogAPI()
    
    init(session : URLSession = .shared){
        self.session = session
    }
    
    func searchBlog(query : String) -> Single<Result<DKBlog,SearchNetworkError>> {
        guard let url = api.searchBlog(query: query).url else {
            return .just(.failure(.invalidURL))
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK 0d39db22e7eab62a51521e16c0028155", forHTTPHeaderField: "Authorization")
        
        return session.rx.data(request: request as URLRequest)
            .map { data in
                do{
                    //json decoding here
                    let blogData = try JSONDecoder().decode(DKBlog.self, from: data)
                    return .success(blogData)
                }catch {
                    return .failure(.invalidJSON)
                }
            }.catch { _ in
                    .just(.failure(.networkError))
            }.asSingle()
        
    }
}
