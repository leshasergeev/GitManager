//
//  GitHubApiService.swift
//  GitManager
//
//  Created by Aleksei Sergeev on 15.08.2021.
//

import Foundation

protocol RepositoriesListsService: AnyObject {
    func getRepositoriesList(for name: String,
                             pageNumber: Int,
                             completion: @escaping (Result<RepositoriesListResponse, Error>) -> Void)
}

protocol OAuthAuthorizationService: AnyObject {
    func buildAuthRequest() -> URLRequest?
    func getToken(withAuthCode authCode: String?, completion: @escaping(Result<String, Error>) -> Void)
}

protocol UserInfoService {
    func getUserProfile(completion: @escaping(Result<UserProfile, Error>) -> Void)
}

enum NetworkError: Error {
    case invalidRequest, parsingError
}

class GitHubApiService: RepositoriesListsService {

    private let networking: Networking

    private let authService: AuthService

    private let scheme      = "https"
    private let gitHost     = "github.com"
    private let gitApiHost  = "api.github.com"
    private let getRepositoriesListPath = "/search/repositories"
    private let oauthAuthorizePath      = "/login/oauth/authorize"
    private let oauthAccessTokenPath    = "/login/oauth/access_token"

    private let clientID = "057e11fcbdd12c675c88"
    private let clientSecret = "19bc7b6764f948cb3e60e1b65dadd9fe77bdf370"

    required init(networking: Networking, authService: AuthService) {
        self.networking = networking
        self.authService = authService
    }

    func getRepositoriesList(for name: String,
                             pageNumber: Int = 1,
                             completion: @escaping (Result<RepositoriesListResponse, Error>) -> Void) {
        let queryItems = RepositoriesRequestQueryBuilder.makeRepositoriesRequestQuery(name: name,
                                                                                      language: nil,
                                                                                      regulation: .init(key: .stars,
                                                                                                        direction: .desc),
                                                                                      pageNumber: pageNumber)

        guard let urlRequest = makeUrlRequest(withHost: gitApiHost,
                                              path: getRepositoriesListPath,
                                              queryItems: queryItems,
                                              includeToken: true)
        else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        let task = networking.dataTask(with: urlRequest) { data, _, error in
            if let data = data {
                do {
                    if let repositoriesResponce = try self.parseJSON(data: data,
                                                                     toType: RepositoriesListResponse.self) {
                        completion(.success(repositoriesResponce))
                    } else {
                        completion(.failure(NetworkError.parsingError))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    private func makeUrlRequest(withHost host: String?,
                                path: String,
                                queryItems: [URLQueryItem]?,
                                includeToken: Bool = false) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = queryItems

        if let url = urlComponents.url {
            var urlRequest = URLRequest(url: url)
            if includeToken,
               let token = authService.authToken {
                urlRequest.addValue("token \(token)", forHTTPHeaderField: "Authorization")
            }
            return urlRequest
        }
        return nil
    }

    private func parseJSON<T: Decodable>(data: Data, toType type: T.Type) throws -> T? {
        let jsonDecoder = JSONDecoder()
        if let decodedData = try? jsonDecoder.decode(type, from: data) {
            return decodedData
        }
        return nil
    }
}

extension GitHubApiService: OAuthAuthorizationService {
    func buildAuthRequest() -> URLRequest? {
        let qItems = [
            "client_id": clientID,
            "state": UUID().uuidString
        ].map { URLQueryItem(name: $0.key, value: $0.value) }

        return makeUrlRequest(withHost: gitHost, path: oauthAuthorizePath, queryItems: qItems)
    }

    func getToken(withAuthCode authCode: String?, completion: @escaping(Result<String, Error>) -> Void) {
        guard let authCode = authCode else { completion(.failure(NetworkError.parsingError)); return }

        let qItems = [
            "client_id": clientID,
            "client_secret": clientSecret,
            "code": authCode
        ].map { URLQueryItem(name: $0.key, value: $0.value) }

        guard var accessRequest = makeUrlRequest(withHost: gitHost,
                                                 path: oauthAccessTokenPath,
                                                 queryItems: qItems) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        accessRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = networking.dataTask(with: accessRequest) { data, _, error in
            if let data = data {
                if let jsonData = try? JSONDecoder().decode([String: String].self, from: data),
                   let accessKeyStr = jsonData["access_token"] {
                    completion(.success(accessKeyStr))
                } else {
                    completion(.failure(NetworkError.parsingError))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

extension GitHubApiService: UserInfoService {
    func getUserProfile(completion: @escaping(Result<UserProfile, Error>) -> Void) {
        guard authService.isAuthorized,
              let urlRequest = makeUrlRequest(withHost: gitApiHost, path: "/user", queryItems: nil, includeToken: true)
        else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }

        let task = networking.dataTask(with: urlRequest) { data, _, error in
            if let data = data {
                do {
                    if let userProfileResponce = try self.parseJSON(data: data,
                                                                    toType: UserProfile.self) {
                        completion(.success(userProfileResponce))
                    } else {
                        completion(.failure(NetworkError.parsingError))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
