//
//  SerialQueueDemo.m
//  gcd01
//
//  Created by AnleSu on 2020/8/6.
//  Copyright © 2020 AnleSu. All rights reserved.
//

#import "SerialQueueDemo.h"

@interface SerialQueueDemo()
@property (nonatomic, strong) dispatch_queue_t ticketQueue;
@property (nonatomic, strong) dispatch_queue_t moneyQueue;
@end
@implementation SerialQueueDemo
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.ticketQueue = dispatch_queue_create("ticketQueue", DISPATCH_QUEUE_SERIAL);
        self.moneyQueue = dispatch_queue_create("ticketQueue", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}
- (void)__saveMoney {
    dispatch_sync(self.moneyQueue, ^{
        [super __saveMoney];
    });
}

- (void)__drawMoney {
    dispatch_sync(self.moneyQueue, ^{
        [super __drawMoney];
    });
}

- (void)__saleTicket {
    dispatch_sync(self.ticketQueue, ^{
        [super __saleTicket];
    });

}

@end
