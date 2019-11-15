import UIKit

/* Task:
    1) implement deadlock with two queues
    2) cancellation of DispatchWorkItem:
        create background queue,
        create DispatchWorkItem with infinite print("0") use "while true" cycle
        schedule async item on queue and then cancel it after two seconds (async after)
 */

//======================2=======================//
let task = DispatchQueue.global(qos: .background)

var item: DispatchWorkItem?
item = DispatchWorkItem {
    while true {
        if (item?.isCancelled)! {
            print("CANCELLED")
            break
        }
        print("0")
    }
}

task.async(execute: item!)

task.async {
    sleep(2)
    item?.cancel()
}

//CAUTION: following code will produce an error
//======================1=======================//

//when you submit a task synchronously to the current queue, which blocks the current queue and
//your task tries to access a resource in the current queue, then your app will DEADLOCK

let label = UILabel()

DispatchQueue.global(qos: .utility).sync {
   label.text = "Downloading content"
    print(label.text)
    DispatchQueue.main.sync {
        label.text = "New articles available!"
        print(label.text)
    }
    print("I will never be executed")
}
