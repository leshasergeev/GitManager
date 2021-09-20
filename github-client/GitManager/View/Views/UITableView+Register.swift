//
//  UITableView+Register.swift
//  GitManager
//
//  Created by Aleksei Sergeev on 10.08.2021.
//

import UIKit

protocol CellWithIdentifier: UITableViewCell {
    static var cellIdentifier: String { get }
}

protocol CellRegistration {
    func register<T: CellWithIdentifier>(_: T.Type)
    func dequeue<T: CellWithIdentifier>(_: T.Type, indexPath: IndexPath) -> T?
}

extension UITableView: CellRegistration {
    func register<T>(_: T.Type) where T: CellWithIdentifier {
        register(T.self, forCellReuseIdentifier: T.cellIdentifier)
    }

    func dequeue<T>(_: T.Type, indexPath: IndexPath) -> T? where T: CellWithIdentifier {
        return dequeueReusableCell(withIdentifier: T.cellIdentifier, for: indexPath) as? T
    }
}
