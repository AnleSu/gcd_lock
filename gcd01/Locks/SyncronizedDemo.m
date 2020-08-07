//
//  SyncronizedDemo.m
//  gcd01
//
//  Created by AnleSu on 2020/8/6.
//  Copyright © 2020 AnleSu. All rights reserved.
//

#import "SyncronizedDemo.h"

@implementation SyncronizedDemo
//保证 小括号中的对象 都是同一个对象 才能起到加锁的作用 @synchronized (self)
//用法是最简单的 但是并不推荐使用 效率低
//底层也是pthread_mutex 递归锁的封装
- (void)__saveMoney {
    @synchronized (self) {
        [super __saveMoney];
    }
}

- (void)__drawMoney {
    @synchronized (self) {//objc_sync_enter
        [super __drawMoney];
    }//objc_sync_exit
}

-(void)__saleTicket {
    static NSObject *lock;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lock = [[NSObject alloc] init];
    });
    @synchronized (lock) {
        [super __saleTicket];
    }
}

- (void)otherTest {
    @synchronized (self) {
        NSLog(@"111");
        [self otherTest];
    }
}
@end
