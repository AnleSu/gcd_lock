//
//  OSUnfairLockDemo.m
//  gcd01
//
//  Created by AnleSu on 2020/8/5.
//  Copyright © 2020 AnleSu. All rights reserved.
//

#import "OSUnfairLockDemo.h"
#import <os/lock.h>
@interface OSUnfairLockDemo()
@property (nonatomic, assign) os_unfair_lock moneylock;
@property (nonatomic, assign) os_unfair_lock ticketlock;
@end
@implementation OSUnfairLockDemo
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.moneylock = OS_UNFAIR_LOCK_INIT;
        self.ticketlock = OS_UNFAIR_LOCK_INIT;
    }
    return self;
}

// 只加锁不解锁 相当于死锁 或者加锁和解锁的不是同一把锁
- (void)__saveMoney {
    os_unfair_lock_lock(&_moneylock);
    [super __saveMoney];
    os_unfair_lock_unlock(&_moneylock);
    
}

- (void)__drawMoney {
    os_unfair_lock_lock(&_moneylock);
    [super __drawMoney];
    os_unfair_lock_unlock(&_moneylock);
    
}

- (void)__saleTicket {
    os_unfair_lock_lock(&_ticketlock);
    [super __saleTicket];
    os_unfair_lock_unlock(&_ticketlock);
    
    
}


@end
