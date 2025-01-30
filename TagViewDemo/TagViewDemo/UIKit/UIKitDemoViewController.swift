//
//  UIKitDemoViewController.swift
//  TagViewDemo
//
//  Created by Michael Namara on 2024/4/1.
//

import UIKit
import MNTagView

class UIKitDemoViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.delegate = self
        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension UIKitDemoViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = "Tag style"
            
        case 1:
            cell.textLabel?.text = "Tag method"

        case 2:
            cell.textLabel?.text = "Tag Expand"
            
        case 3:
            cell.textLabel?.text = "Tag with remove button"
            
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let vc = Demo1ViewController()
            navigationController?.pushViewController(vc, animated: true)
            
        case 1:
            let vc = Demo2ViewController()
            navigationController?.pushViewController(vc, animated: true)
            
        case 2:
            let vc = Demo3ViewController()
            navigationController?.pushViewController(vc, animated: true)
            
        default:
            return
        }
    }
}
