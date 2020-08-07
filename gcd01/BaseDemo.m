//
//  BaseDemo.m
//  gcd01
//
//  Created by AnleSu on 2020/8/5.
//  Copyright © 2020 AnleSu. All rights reserved.
//

#import "BaseDemo.h"
@interface BaseDemo()
@property (nonatomic, assign) int ticketsCount;
@property (nonatomic, assign) int money;
@end
@implementation BaseDemo
/*
 存钱 取钱也不能同时进行 所以存取操作应该共用一把锁
 */

//存钱
- (void)__saveMoney {
   
    int oldMoney = self.money;
    sleep(.2);
    oldMoney += 50;
    self.money = oldMoney;
    NSLog(@"存50  还剩%d元 - %@",self.money, [NSThread currentThread]);
    
    
}
//取钱
- (void)__drawMoney {
   
    
    int oldMoney = self.money;
    sleep(.2);
    oldMoney -= 20;
    self.money = oldMoney;
    NSLog(@"取20  还剩%d元 - %@",self.money, [NSThread currentThread]);
    
     
}

- (void)moneyTest {
    self.money = 100;
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self __saveMoney];
        }
        
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            [self __drawMoney];
        }
    });
    
   
}


//卖一张票
//- (void)saleTicket {
//
////    #import <libkern/OSAtomic.h>
////    初始化锁
//    OSSpinLock lock = OS_SPINLOCK_INIT;
//     //加锁
//    OSSpinLockLock(&lock);
//
//    int oldTicketsCount = self.ticketsCount;
//    sleep(.2);//为了更逼真的模拟多线程同时访问
//    oldTicketsCount--;
//    self.ticketsCount = oldTicketsCount;
//
//    NSLog(@"还剩%d张票 - %@",self.ticketsCount, [NSThread currentThread]);
////    解锁
//    OSSpinLockUnlock(&lock);
//
//    //这么写依然有问题 因为lock是个局部变量 每次进这个方法都会重新初始化一个锁  需要用同一把锁加锁  所以可以写成成员变量  static变量 或者dispatch_once中创建只要保证是同一把锁就可以
//}

- (void)__saleTicket {
   

    
    int oldTicketsCount = self.ticketsCount;
    sleep(.2);//为了更逼真的模拟多线程同时访问
    oldTicketsCount--;
    self.ticketsCount = oldTicketsCount;
    
    NSLog(@"还剩%d张票 - %@",self.ticketsCount, [NSThread currentThread]);
//    解锁
   
    
}


//演示卖票的操作
- (void)ticketsTest {
    self.ticketsCount = 9;
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            [self __saleTicket];
        }
        
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            [self __saleTicket];
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 3; i++) {
            [self __saleTicket];
        }
    });
}

- (void)otherTest {}
@end
