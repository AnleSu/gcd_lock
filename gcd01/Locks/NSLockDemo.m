//
//  NSLockDemo.m
//  gcd01
//
//  Created by AnleSu on 2020/8/6.
//  Copyright © 2020 AnleSu. All rights reserved.
//

#import "NSLockDemo.h"
@interface NSLockDemo()
@property (nonatomic, strong) NSLock *moneylock;
@property (nonatomic, strong) NSLock *ticketlock;
@property (nonatomic, strong) NSRecursiveLock *recursiveLock;
@end
@implementation NSLockDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.moneylock = [[NSLock alloc] init];
        self.ticketlock = [[NSLock alloc] init];
    }
    return self;
}

- (void)__saveMoney {
    [self.moneylock lock];
    [super __saveMoney];
    [self.moneylock unlock];
}

- (void)__drawMoney {
    [self.moneylock lock];
    [super __drawMoney];
    [self.moneylock unlock];
}

- (void)__saleTicket {
    [self.ticketlock lock];
    [super __saleTicket];
    [self.ticketlock unlock];
}
@end

