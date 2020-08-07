//
//  OSSpinLockDemo.m
//  gcd01
//
//  Created by AnleSu on 2020/8/5.
//  Copyright © 2020 AnleSu. All rights reserved.
//

#import "OSSpinLockDemo.h"
#import <libkern/OSAtomic.h>
@interface OSSpinLockDemo()
@property (nonatomic, assign) OSSpinLock moneylock;
//@property (nonatomic, assign) OSSpinLock ticketlock;
@end
@implementation OSSpinLockDemo
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.moneylock = OS_SPINLOCK_INIT;
//        self.ticketlock = OS_SPINLOCK_INIT;
    }
    return self;
}

- (void)__saveMoney {
    OSSpinLockLock(&_moneylock);
    [super __saveMoney];
    
    OSSpinLockUnlock(&_moneylock);
}

- (void)__drawMoney {
    OSSpinLockLock(&_moneylock);
    [super __drawMoney];
    OSSpinLockUnlock(&_moneylock);
    
}

- (void)__saleTicket {
//    static 变量也可以  因为#define    OS_SPINLOCK_INIT    0
    static  OSSpinLock ticketlock = OS_SPINLOCK_INIT; 
    OSSpinLockLock(&ticketlock);
    [super __saleTicket];
    OSSpinLockUnlock(&ticketlock);
    
}
@end
