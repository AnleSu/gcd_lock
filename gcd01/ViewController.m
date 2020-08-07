//
//  ViewController.m
//  gcd01
//
//  Created by AnleSu on 2020/8/5.
//  Copyright © 2020 AnleSu. All rights reserved.
//

#import "ViewController.h"
#import <libkern/OSAtomic.h>
#import "BaseDemo.h"
#import "MutexDemo.h"
#import "OSUnfairLockDemo.h"
#import "MutexDemo2.h"
#import "NSLockDemo.h"
#import "NSConditionDemo.h"
#import "NSConditionLockDemo.h"
#import "SerialQueueDemo.h"
#import "SemaphoreDemo.h"
#import "SyncronizedDemo.h"

#define SemaphoreBegin \
static dispatch_semaphore_t semaphore; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
    semaphore = dispatch_semaphore_create(1); \
});\
dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

#define SemaphoreEnd \
dispatch_semaphore_signal(semaphore);

@interface ViewController ()
@property (nonatomic, strong) NSThread *thread;
@end

@implementation ViewController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    self.money = 100;
//    self.lock = OS_SPINLOCK_INIT;
//}
///*
// 存钱 取钱也不能同时进行 所以存取操作应该共用一把锁
// */
//
////存钱
//- (void)saveMoney {
//    OSSpinLockLock(&_lock);
//    int oldMoney = self.money;
//    sleep(.2);
//    oldMoney += 50;
//    self.money = oldMoney;
//    NSLog(@"存50  还剩%d元 - %@",self.money, [NSThread currentThread]);
//     OSSpinLockUnlock(&_lock);
//
//}
////取钱
//- (void)drawMoney {
//    OSSpinLockLock(&_lock);
//
//    int oldMoney = self.money;
//    sleep(.2);
//    oldMoney -= 20;
//    self.money = oldMoney;
//    NSLog(@"取20  还剩%d元 - %@",self.money, [NSThread currentThread]);
//
//     OSSpinLockUnlock(&_lock);
//}
//
//- (void)moneyTest {
//    self.money = 100;
//    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
//    dispatch_async(queue, ^{
//        for (int i = 0; i < 10; i++) {
//            [self saveMoney];
//        }
//
//    });
//
//    dispatch_async(queue, ^{
//        for (int i = 0; i < 10; i++) {
//            [self drawMoney];
//        }
//    });
//
//
//}
//
//
////卖一张票
////- (void)saleTicket {
////
//////    #import <libkern/OSAtomic.h>
//////    初始化锁
////    OSSpinLock lock = OS_SPINLOCK_INIT;
////     //加锁
////    OSSpinLockLock(&lock);
////
////    int oldTicketsCount = self.ticketsCount;
////    sleep(.2);//为了更逼真的模拟多线程同时访问
////    oldTicketsCount--;
////    self.ticketsCount = oldTicketsCount;
////
////    NSLog(@"还剩%d张票 - %@",self.ticketsCount, [NSThread currentThread]);
//////    解锁
////    OSSpinLockUnlock(&lock);
////
////    //这么写依然有问题 因为lock是个局部变量 每次进这个方法都会重新初始化一个锁  需要用同一把锁加锁  所以写成成员变量
////}
//
//- (void)saleTicket {
//
//
//     //加锁
//    OSSpinLockLock(&_lock);
////    while (锁没放开) {
////        ;
////    }
//
//    int oldTicketsCount = self.ticketsCount;
//    sleep(.2);//为了更逼真的模拟多线程同时访问
//    oldTicketsCount--;
//    self.ticketsCount = oldTicketsCount;
//
//    NSLog(@"还剩%d张票 - %@",self.ticketsCount, [NSThread currentThread]);
////    解锁
//    OSSpinLockUnlock(&_lock);
//
//}
//
//
////演示卖票的操作
//- (void)saleTickets {
//    self.ticketsCount = 9;
//
//    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
//    dispatch_async(queue, ^{
//        for (int i = 0; i < 3; i++) {
//            [self saleTicket];
//        }
//
//    });
//
//    dispatch_async(queue, ^{
//        for (int i = 0; i < 3; i++) {
//            [self saleTicket];
//        }
//    });
//
//    dispatch_async(queue, ^{
//        for (int i = 0; i < 3; i++) {
//            [self saleTicket];
//        }
//    });
//}
//
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self saleTickets];
//}

- (void)viewDidLoad {
    SyncronizedDemo *demo = [[SyncronizedDemo alloc] init];
//    [demo ticketsTest];
//    [demo moneyTest];
    [demo otherTest];
    
//    self.thread = [[NSThread alloc] initWithBlock:^{
//        NSLog(@"1");
//
//        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
//        [[NSRunLoop currentRunLoop] run];
//    }];
//
//    [self.thread start];
    //线程中的任务一旦执行完 生命周期就结束了 无法再使用
    //使用runloop 是为了让线程处于激活状态  并不是说让他不销毁（对象还在内存中）  这是两个概念  激活状态才可以继续使用 继续执行任务
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self performSelector:@selector(test) onThread:self.thread withObject:nil waitUntilDone:NO];
}

- (void)test {
    NSLog(@"%s",__func__);
}

//使用技巧  每个方法都是独立的一把锁
- (void)test1 {
    static dispatch_semaphore_t semaphore;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        semaphore = dispatch_semaphore_create(1);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    // ...
    
    dispatch_semaphore_signal(semaphore);
}

- (void)test12 {
    SemaphoreBegin;
    
    SemaphoreEnd;
}
@end
