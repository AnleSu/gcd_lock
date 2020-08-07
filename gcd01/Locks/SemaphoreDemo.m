//
//  SemaphoreDemo.m
//  gcd01
//
//  Created by AnleSu on 2020/8/6.
//  Copyright © 2020 AnleSu. All rights reserved.
//

#import "SemaphoreDemo.h"

@interface SemaphoreDemo()
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, strong) dispatch_semaphore_t ticketSemaphore;
@property (nonatomic, strong) dispatch_semaphore_t moneySemaphore;
@end
@implementation SemaphoreDemo
- (instancetype)init
{
    self = [super init];
    if (self) {
//        控制最大并发数为5
        self.semaphore = dispatch_semaphore_create(5);
        self.ticketSemaphore = dispatch_semaphore_create(1);
        self.moneySemaphore = dispatch_semaphore_create(1);
    }
    return self;
}
- (void)otherTest {
    for (int i = 0; i < 20; i++) {
        
        [[[NSThread alloc] initWithBlock:^{
            [self test];
        }] start];
        
    }
}

- (void)test {
//    如果信号量的值>0 就会让信号量值-1  然后继续执行下面的代码
//    如果<= 0 就会休眠等待 直到信号量>0  就让信号量-1 然后继续往下执行
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    sleep(1);
    NSLog(@"%s - %@",__func__, [NSThread currentThread]);
//    让信号量+1
    dispatch_semaphore_signal(self.semaphore);
}

- (void)__saveMoney {
//DISPATCH_TIME_FOREVER 一直等到信号量>0
    dispatch_semaphore_wait(self.moneySemaphore, DISPATCH_TIME_FOREVER);
    [super __saveMoney];
    dispatch_semaphore_signal(self.moneySemaphore);
}

- (void)__drawMoney {
    dispatch_semaphore_wait(self.moneySemaphore, DISPATCH_TIME_FOREVER);
    [super __drawMoney];
    dispatch_semaphore_signal(self.moneySemaphore);
}

-(void)__saleTicket {
    dispatch_semaphore_wait(self.ticketSemaphore, DISPATCH_TIME_FOREVER);
    [super __saleTicket];
    dispatch_semaphore_signal(self.ticketSemaphore);
}
@end
