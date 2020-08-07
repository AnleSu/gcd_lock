//
//  NSConditionDemo.m
//  gcd01
//
//  Created by AnleSu on 2020/8/6.
//  Copyright © 2020 AnleSu. All rights reserved.
//

#import "NSConditionDemo.h"

@interface NSConditionDemo()
//把锁和条件都封装起来了 所以这里不需要再定义锁
@property (nonatomic, strong) NSCondition *condition;
@property (nonatomic, strong) NSMutableArray *data;

@end
@implementation NSConditionDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.condition = [[NSCondition alloc] init];
        self.data = [NSMutableArray array];
    }
    return self;
}

- (void)__add {
    [self.condition lock];
    
    [self.data addObject:@"str"];
    NSLog(@"%s",__func__);
    
    //    信号 唤醒 然后解锁
    [self.condition signal]; //signal 之后 remove方法中的条件部分 并不能立刻被唤醒然后加锁 还是需要先解锁 条件等待处才能加锁  signal放在unlock后面也可以 那样信号发出之后remove方法中锁会被立刻唤醒并往下执行
    //    广播 所有等待这个条件的线程
    //    [self.condition broadcast];
    
    sleep(2);
    
    [self.condition unlock];
}

- (void)__remove {
    NSLog(@"__remove begin");
    [self.condition lock];
    
    if (self.data.count == 0) {
//        解锁  等待被条件唤醒    被唤醒 再加锁
        [self.condition wait];
    }
    
    [self.data removeLastObject];
    NSLog(@"%s",__func__);
    [self.condition unlock];
}

- (void)otherTest {
    [[[NSThread alloc] initWithTarget:self selector:@selector(__remove) object:nil] start];
    sleep(1);
    [[[NSThread alloc] initWithTarget:self selector:@selector(__add) object:nil] start];
}

@end

