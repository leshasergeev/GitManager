//
//  RepositoriesListViewController.swift
//  GitManager
//
//  Created by Aleksei Sergeev on 06.08.2021.
//

import UIKit

protocol RepositoriesListView: AnyObject {
    var state: RepositoriesListViewState { get set }
    func updateListOfRepositories()
}

enum RepositoriesListViewState {
    case placeholder, table, error, emptyRequest
}

class RepositoriesListViewController: UIViewController, RepositoriesListView {

    var state: RepositoriesListViewState = .placeholder {
        didSet { switchState() }
    }

    private let presenter: RepositoriesListPresenter

    private let emptyRequestStr = NSLocalizedString("Type request to search", comment: "")
    private let nothingFoundStr = NSLocalizedString("Nothing found for you request, try another one.", comment: "")
    private let errorStr        = NSLocalizedString("Something went wrong!", comment: "")

    private let tableForListOfReps: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.tableFooterView = UIView(frame: .zero)
        table.keyboardDismissMode = .onDrag
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 50
        table.accessibilityLabel = "table_ListOfReps"
        return table
    }()

    private lazy var searchBar: UISearchBar = {
        let search = UISearchBar(frame: .zero)
        search.backgroundColor = .clear
        search.searchBarStyle = .minimal
        search.placeholder = emptyRequestStr
        search.accessibilityLabel = "searchBar_repos"
        return search
    }()

    private let blankView: UIView = {
        let blank = UIView(frame: .zero)
        blank.backgroundColor = UIColor(named: "white")
        return blank
    }()

    private let placeholder = PlaceholderView()

    init(presenter: RepositoriesListPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)

        blankView.translatesAutoresizingMaskIntoConstraints = false
        tableForListOfReps.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        placeholder.translatesAutoresizingMaskIntoConstraints = false

        setupTabBarItem()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "white")

        tableForListOfReps.delegate     = self
        tableForListOfReps.dataSource   = self
        tableForListOfReps.register(RepositoriesTableViewCell.self)

        searchBar.delegate = self

        constructViewHierarchy()
        configureConstraints()

        presenter.viewIsReady()

        registerKeyboardNotifications()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func updateListOfRepositories() {
        self.tableForListOfReps.reloadData()
    }

    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillAppear(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillDisappear),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillAppear(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }

    @objc
    private func keyboardWillAppear(_ notification: Notification) {
        guard let info = notification.userInfo,
              let keyboardRect: CGRect = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }

        let insetHight = tableForListOfReps.frame.maxY - view.convert(keyboardRect, from: nil).minY
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: insetHight, right: 0)

        tableForListOfReps.contentInset = insets
        tableForListOfReps.scrollIndicatorInsets = insets
    }

    @objc
    private func keyboardWillDisappear() {
        tableForListOfReps.contentInset = .zero
        tableForListOfReps.scrollIndicatorInsets = .zero
    }

    private func switchState() {
        switch state {
        case .placeholder:
            tableForListOfReps.isHidden = true
            placeholder.isHidden = false
            placeholder.text = nothingFoundStr
        case .error:
            tableForListOfReps.isHidden = true
            placeholder.isHidden = false
            placeholder.text = errorStr
        case .table:
            placeholder.isHidden = true
            tableForListOfReps.isHidden = false
        case .emptyRequest:
            tableForListOfReps.isHidden = true
            placeholder.isHidden = false
            placeholder.text = emptyRequestStr
        }
    }

    private func constructViewHierarchy() {
        [searchBar, tableForListOfReps, placeholder, blankView].forEach { view.addSubview($0) }
    }

    private func configureConstraints() {
        setConstraintsForSearchTextField()
        setConstraintsForTableView()
        setConstraintsForPlaceholder()
        setConstraintsForBlankView()
    }

    private func setConstraintsForBlankView() {
        NSLayoutConstraint.activate([
            blankView.topAnchor.constraint(equalTo: tableForListOfReps.bottomAnchor),
            blankView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            blankView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            blankView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func setConstraintsForTableView() {
        NSLayoutConstraint.activate([
            tableForListOfReps.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 5),
            tableForListOfReps.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            tableForListOfReps.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            tableForListOfReps.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ])
    }

    private func setConstraintsForSearchTextField() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
            searchBar.heightAnchor.constraint(equalToConstant: 50),
            searchBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            searchBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -5)
        ])
    }

    private func setConstraintsForPlaceholder() {
        NSLayoutConstraint.activate([
            placeholder.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            placeholder.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            placeholder.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            placeholder.heightAnchor.constraint(equalTo: placeholder.widthAnchor)
        ])
    }

    private func setupTabBarItem() {
        tabBarItem.title = "Respositories"
        tabBarItem.image = UIImage(named: "list_of_repositories_bar_logo")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.accessibilityLabel = "tabBarItem_repositories"
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
}

extension RepositoriesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.elementsCount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeue(RepositoriesTableViewCell.self, indexPath: indexPath)
        else { return UITableViewCell() }
        cell.accessibilityLabel = "cell_\(indexPath.row)"
        if let repository = presenter.retrieveRepository(atIndex: indexPath.row) {
            cell.setupCell(withRepository: repository)
        }
        cell.separatorInset = .zero
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.willDisplayItem(atIndex: indexPath.row)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension RepositoriesListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let nameOfRepos = searchBar.text else { return }
        presenter.searchRepositories(withName: nameOfRepos)
        searchBar.endEditing(true)
    }
}
