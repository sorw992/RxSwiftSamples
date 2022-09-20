
//
//  RxSwift Samples
//
//  Created by Soroush Sarlak on 6/29/22.
//

import UIKit
import RxSwift
import RxCocoa
//import RxRelay
/*
 Subjects
 Subject = Observable + Observer so we can emit and receive elements,
 There are four subject types in Rxswift
 1- PublishSubject: only emits new elements to subscribers
 2- BehaviorSubject: emits the last element to new subscriber
 3- ReplaySubject: emits a buffer size of elements to new subscribers
 4- AsyncSubject: emits only the last next event in the sequence, and only when the subject receives a completed event.
 
 Relays are subjects that never complete and they are useful for ui works
 they only emit next event
 Relays = wrappers around subjects that never complete
 1- publish relay: wraps around Publish Subject
 2- behavior relay: wraps around Behavior Subject
 It is guaranteed that they never emit error or completed events. which makes them great for ui related work
 */


// publish subject
// our subject will emits elements of type string
let pSub = PublishSubject<String>()

pSub.onNext("PublishSubject E1 1")

let observer = pSub.subscribe(onNext: {
    elem in
    print("elem", elem)
})

pSub.onNext("PublishSubject E1 2")


// behavior subject
// our subject will emits elements of type string
// you cant create a behavior subject without initial value
let bSub = BehaviorSubject<String>(value: "BehaviorSubject E1 1")
//bSub.onNext("BehaviorSubject E1 2")


let observer2 = bSub.subscribe(onNext: {
    elem in
    print("elem", elem)
})



// replay subject
// emits elements of type int, we have to define buffer size for it.
let rSub = ReplaySubject<Int>.create(bufferSize: 2)
// lets put three elements inside it
// add three events
rSub.onNext(1)
rSub.onNext(2)
rSub.onNext(3)

let observer3 = rSub.subscribe(onNext: {
    elem in
    // we just received number 2 and 3, now if modify buffer size from 2 to 3, we will get all three elements
    print("Observer on replay subject", elem)
})


// async subject
// it will emit string and we don't have to initialize with anything
let aSub = AsyncSubject<String>()
// add two events
aSub.onNext("AsyncSubject E1 1")
aSub.onNext("AsyncSubject E1 2")

// object receives a completed event
aSub.onCompleted()

let observer4 = aSub.subscribe(onNext: {
    elem in
    // prints nothing if we dont use aSub.onCompleted(). because AsyncSubject didn't emit a completed event.
    print("Observer on Async Object", elem)
})



// publish relay
// it will emits String elements and we dont have to initialize it with any value like we so in the Publish Subject example.
let pRel = PublishRelay<String>()

// this time (for publish relay) to add next event, we dont use onNext method anymore but this special method used by all relays called accept().
pRel.accept("Publish Relay E1 1")

let observer5 = pRel.subscribe(onNext: {
    elem in

    // nothing happens because the observer subscribe after accept() method
    print("elem in observer 5", elem)
    
})

pRel.accept("Publish Relay E1 2")



// Behavior Relay
// it requires a value like behavior subject
let bRel = BehaviorRelay<String>(value: "Behavior Relay E1 1")

let observer6 = bRel.subscribe(onNext: {
    elem in
    
    print("elem in observer 6", elem)
    
    
})

// we can add another element with the aid of accept method
bRel.accept("Behavior Relay E1 2")


//---------------------


// replay subject
// emits elements of type int, we have to define buffer size for it.
let rSub2 = ReplaySubject<Int>.create(bufferSize: 3)
// lets put three elements inside it
// add three events
rSub2.onNext(1)
rSub2.onNext(2)
rSub2.onNext(3)

// map operator is used to transform the values emitted by an observable
let observer3_2 = rSub2.map({ elem in
    // elem get transformed according to our needs
    elem * 2 // instead of 1,2,3 we received 2,4,6
}).subscribe(onNext: {
    elem in
    // we just received number 2 and 3, now if modify buffer size from 2 to 3, we will get all three elements
    print("Observer3_2 on replay subject 2", elem)
})

