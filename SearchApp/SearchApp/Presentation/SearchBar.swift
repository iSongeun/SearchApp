//
//  SearchBar.swift
//  SearchAppTests
//
//  Created by 이송은 on 2022/11/30.
//

//들어오는 텍스트 메인뷰의 리스트 뷰에 뿌려줌, 검색버튼은 최종 발생 텍스트만 전달하는 역할
import Foundation
import RxSwift
import RxCocoa
import UIKit
import SnapKit

class SearchBar : UISearchBar{
    let disposeBag = DisposeBag()
    let searchButton = UIButton()
    
    //버튼 탭 이벤트
    let searchButtonTapped = PublishRelay<Void>()
    
    //외부로 보낼 이벤트
    var shouldLoadResult = Observable<String>.of("")
    
    override init(frame : CGRect) {
        super.init(frame:  frame)
        bind()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func bind(){
        Observable.merge(self.rx.searchButtonClicked.asObservable(),
                         searchButton.rx.tap.asObservable())
        .bind(to: searchButtonTapped).disposed(by: disposeBag)
        
        searchButtonTapped.asSignal().emit(to: self.rx.endEditing).disposed(by: disposeBag)
        
        self.shouldLoadResult = searchButtonTapped.withLatestFrom(self.rx.text){$1 ?? ""}
            .filter{ !$0.isEmpty }.distinctUntilChanged()
    }
    
    private func attribute(){
        searchButton.setTitle("검색", for: .normal)
        searchButton.setTitleColor(.systemBlue, for: .normal)
        
        
    }
    
    private func layout(){
        addSubview(searchButton)
        searchTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalTo(searchButton.snp.leading).offset(-12)
            $0.centerY.equalToSuperview()
            
        }
        
        searchButton.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
    }
    
}

extension Reactive where Base : SearchBar {
    var endEditing : Binder<Void>{
        return Binder(base){ base , _ in
            base.endEditing(true)
        }
    }
}
