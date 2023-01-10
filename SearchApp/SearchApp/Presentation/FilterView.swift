//
//  FilterView.swift
//  SearchApp
//
//  Created by 이송은 on 2022/12/01.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class FilterView : UITableViewHeaderFooterView {
    let disposeBag = DisposeBag()
    
    let sortButton = UIButton()
    let bottomborder = UIView()
    
    let sortButtonTapped = PublishRelay<Void>()
    
    override init(reuseIdentifier : String?){
        super.init(reuseIdentifier: reuseIdentifier)
        
        bind()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(){
        sortButton.rx.tap.bind(to: sortButtonTapped).disposed(by: disposeBag)
    }
    
    private func attribute(){
        sortButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
    }
    
    private func layout(){
        [sortButton, bottomborder].forEach { addSubview($0) }
        
        sortButton.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
            $0.width.height.equalTo(28)
        }
        
        bottomborder.snp.makeConstraints{
            $0.top.equalTo(sortButton.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
}
