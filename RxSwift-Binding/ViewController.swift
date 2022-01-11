//
//  ViewController.swift
//  RxSwift-Binding
//
//  Created by Haru on 2022/01/11.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var todos = [String]()
    var todosRelay = BehaviorRelay(value: [String]())
    
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 이 화면에 이 컴포넌트에는 이 셀 쓸거라는 뜻, 그래서 클래스랑 아이디 등록
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TodoCell")
        
        bindToRx()
    }
 
    func bindToRx() {
        // when clicked add button
        // 클릭 되는 순간마다 next event 발생
        addButton.rx.tap.subscribe ( onNext: {
            // if textField is empty, nothing happens
            guard self.textField.text?.isEmpty == false else {
                return
            }
            
            self.todos.append(self.textField.text!)
            self.todosRelay.accept(self.todos)   // for watch change, accept todos on BehaviorRelay
            self.textField.text = ""
        }).disposed(by: disposeBag)
        
        // when todos has been changed
        todosRelay
            .bind(to: tableView.rx.items(cellIdentifier: "TodoCell")) {
                (index, todo: String, cell: UITableViewCell) in
                cell.textLabel?.text = todo // set text label
            }.disposed(by: disposeBag)
    }
}
