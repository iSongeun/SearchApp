//
//  CombiningOperator(not_using).swift
//  SearchApp
//
//  Created by 이송은 on 2022/11/28.
//

import Foundation

import UIKit
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()

func test1(){
    print("-----startwith")
    let children = Observable<String>.of("0","1","2")
    
    //enumnerated - element와 index 분리
    children.enumerated().map { index , element in
        element + "어린이" + "\(index)"
        
    }.startWith("teacher").subscribe(onNext : {
        print($0)
    }).disposed(by: disposeBag)
    
    print("-----concat1")
    let teacher = Observable<String>.of("teacher")
    let lineWalking = Observable.concat([teacher,children])
    
    lineWalking.subscribe(onNext : {
        print($0)
    }).disposed(by: disposeBag)
    
    print("-----concat2")
    teacher.concat(children).subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
    
    print("-----concatMap")
    let childrenHouse : [String : Observable<String>] = [
        "yellow" : Observable.of("alla","bell","soma"),
        "blue" : Observable.of("deny","kalla","justin")
    ]
    Observable.of("yellow","blue").concatMap{ ban in
        childrenHouse[ban] ?? .empty()
    }.subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
    
    print("-----merge1")
    let buk = Observable.from(["강북","성북","동대문","종로"])
    let nam = Observable.from(["강남","강동","영등포","양천"])
    
    Observable.of(buk,nam).merge().subscribe(onNext : {
        print($0)
    }).disposed(by: disposeBag)
    
    print("-----merge2")
    Observable.of(buk,nam).merge(maxConcurrent: 1).subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
    
    
    
    print("-----combineLastest")
    let lastname = PublishSubject<String>()
    let firstname = PublishSubject<String>()
    
    let name = Observable.combineLatest(firstname, lastname){ firstname, lastname in
        lastname + firstname
    }
    
    name.subscribe(onNext : {
        print($0)
    }).disposed(by: disposeBag)
    
    lastname.onNext("kim")
    firstname.onNext("martin")
    
    lastname.onNext("lee")
    firstname.onNext("namu")
    
    lastname.onNext("choi")
    //최신값 반영
    
    print("-----combineLastest2")
    let format = Observable<DateFormatter.Style>.of(.short , .long)
    let nowDate = Observable<Date>.of(Date())
    
    let show = Observable.combineLatest(format, nowDate, resultSelector: { form, date -> String in
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = form
        return dateformatter.string(from: date)
    })
    
    show.subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
    
    print("-----combineLastest3")
    
    let lastname2 = PublishSubject<String>()
    let firstname2 = PublishSubject<String>()
    
    let fullname = Observable.combineLatest([firstname2,lastname2]){ name in
        name.joined(separator: " ")
    }
    
    fullname.subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
    
    lastname2.onNext("kim")
    firstname2.onNext("suzy")
    firstname2.onNext("jenny")
    
    print("-----zip")
    enum winlose{
        case win
        case lose
    }
    let fight = Observable<winlose>.of(.lose,.lose,.win,.win,.lose)
    let player = Observable<String>.of("korea","japan","china")
    
    let fightresult = Observable.zip(fight,player) { result, flag in
        return flag + "선수" + "\(result)"
    }
    
    fightresult.subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
    
    print("-----withLastestfrom1")
    //마지막 방출
    let go = PublishSubject<Void>()
    let runplayer = PublishSubject<String>()
    
    go.withLatestFrom(runplayer).subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
    
    runplayer.onNext("1,2,3")
    runplayer.onNext("1,2,3,4")
    
    go.onNext(Void())
    //        go.onNext(Void())
    
    print("-----sample")
    //마지막 한번만
    let start = PublishSubject<Void>()
    let F1 = PublishSubject<String>()
    
    F1.sample(start).subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
    
    
    F1.onNext("1")
    F1.onNext("1       2 ")
    F1.onNext("1              2      3")
    start.onNext(Void())
    start.onNext(Void())
    start.onNext(Void())
    
    print("-----amb")
    let bus1 = PublishSubject<String>()
    let bus2 = PublishSubject<String>()
    
    let station = bus1.amb(bus2)
    
    station.subscribe(onNext : {
        print($0)
    }).disposed(by: disposeBag)
    
    bus2.onNext("버스2 - 승객0")
    bus2.onNext("버스2 - 승객1")
    bus1.onNext("버스1 - 승객0")
    bus1.onNext("버스1 - 승객1")
    bus1.onNext("버스1 - 승객2")
    bus2.onNext("버스2 - 승객2")
    //두개중 모두 구독하지만 두개중에 하나만 방출 ( 먼저 방출 요소만 방출 )
    
    print("-----switchLastest")
    let student1 = PublishSubject<String>()
    let student2 = PublishSubject<String>()
    let student3 = PublishSubject<String>()
    
    let raisehand = PublishSubject<Observable<String>>()
    
    let handclass = raisehand.switchLatest()
    handclass.subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
    
    raisehand.onNext(student1)
    student1.onNext("1")
    student2.onNext("2")
    
    raisehand.onNext(student2)
    student2.onNext("2")
    student3.onNext("3")
    student1.onNext("1")
    
    raisehand.onNext(student3)
    student3.onNext("3")
    student2.onNext("2")
    student1.onNext("1")
    
    raisehand.onNext(student1)
    student1.onNext("1")
    student2.onNext("2")
    student3.onNext("3")
    
    print("-----reduce")
    Observable.from((1...10)).reduce(0, accumulator: { summery, newValue in
        return summery + newValue
    }).subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
    
    print("-----reduce2")
    Observable.from((1...10)).reduce(0, accumulator: +
    ).subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
    
    print("-----scan")
    //reduce와 달리 observable값으로 보임 매번 새로운 타입 보여줌
    Observable.from((1...10)).scan(0, accumulator: +).subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
    
}

func test2(){
    print("----------replay")
    let hello = PublishSubject<String>()
    let ang = hello.replay(10)
    ang.connect()
    
    hello.onNext("1.hello")
    hello.onNext("2.hi")
    
    ang.subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
    
    hello.onNext("3.hiiiiiii")
    
    print("----------replay")
    let doctorstrange = PublishSubject<String>()
    let timestone = doctorstrange.replayAll()
    timestone.connect()
    
    doctorstrange.onNext("doctor")
    doctorstrange.onNext("im sick")
    
    doctorstrange.onNext("doctor")
    doctorstrange.onNext("im sick")
    doctorstrange.onNext("doctor")
    doctorstrange.onNext("im sick")
    doctorstrange.onNext("doctor")
    doctorstrange.onNext("im sick")
    
    timestone.subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
    
    print("----------buffer")
    //array방출
//        let source = PublishSubject<String>()
//        var count = 0
//        let timer = DispatchSource.makeTimerSource()
//
//        timer.schedule(deadline: .now() + 2, repeating:  .seconds(1))
//        timer.setEventHandler{
//            count += 1
//            source.onNext("\(count)")
//        }
//        timer.resume()
//
//        source
//            .buffer(timeSpan: .seconds(2), count: 2, scheduler: MainScheduler.instance)
//            .subscribe(onNext: {
//                print($0)
//            })
//            .disposed(by: disposeBag)
    //동작x
    
    print("----------window")
    //observerbale방출
//        let max = 1
//        let time = RxTimeInterval.seconds(2)
//
//        let window = PublishSubject<String>()
//
//        var windowcount = 0
//        let windowtimerSource = DispatchSource.makeTimerSource()
//        windowtimerSource.schedule(deadline: .now() + 2, repeating: .seconds(1))
//        windowtimerSource.setEventHandler{
//            windowcount += 1
//            window.onNext("\(windowcount)")
//        }
//
//        windowtimerSource.resume()
//        window.window(
//            timeSpan: time, count: max, scheduler: MainScheduler.instance)
//        .flatMap{windowObservable -> Observable<(index : Int, element : String)> in
//            return windowObservable.enumerated()
//        }.subscribe(onNext: {
//            print("\($0.index)번째 Observable요소 \($0.element)")
//        }).disposed(by: disposeBag)

    print("----------delaySubscription")
//        let delaySource = PublishSubject<String>()
//        var delayCount = 0
//        let delayTimeSource = DispatchSource.makeTimerSource()
//
//        delayTimeSource.schedule(deadline: .now() + 2 , repeating:  .seconds(1))
//        delayTimeSource.setEventHandler{
//            delayCount += 1
//            delaySource.onNext("\(delayCount)")
//        }
//
//        delayTimeSource.resume()
//        delaySource.delaySubscription(.seconds(5), scheduler: MainScheduler.instance)
//            .subscribe(onNext: {
//                print($0)
//            }).disposed(by: disposeBag)
    
    print("----------delay")
    print("----------interval")
    print("----------timer")
    //5초 후 2초마다
    Observable<Int>.timer(.seconds(5), period: .seconds(2), scheduler: MainScheduler.instance).subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
    
    print("----------time out")
    

}

func test3(){
    
}
