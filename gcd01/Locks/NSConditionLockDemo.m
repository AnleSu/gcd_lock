//
//  NSConditionLockDemo.m
//  gcd01
//
//  Created by AnleSu on 2020/8/6.
//  Copyright © 2020 AnleSu. All rights reserved.
//

#import "NSConditionLockDemo.h"
@interface NSConditionLockDemo()
//把锁和条件都封装起来了 所以这里不需要再定义锁
@property (nonatomic, strong) NSConditionLock *conditionLock;
@property (nonatomic, strong) NSMutableArray *data;

@end
@implementation NSConditionLockDemo

- (instancetype)init
{
    self = [super init];
    if (self) {
//        初始化如果不设置条件值  默认是0   lock直接加锁 直接调用lock就不会判断条件值了
        self.conditionLock = [[NSConditionLock alloc] initWithCondition:1];
        self.data = [NSMutableArray array];
    }
    return self;
}

- (void)__add {
    [self.conditionLock lockWhenCondition:2];
    
    [self.data addObject:@"str"];
    NSLog(@"%s",__func__);
    
    [self.conditionLock unlock];
}

- (void)__remove {
    NSLog(@"__remove begin");
    [self.conditionLock lockWhenCondition:1];
    
 
    [self.data removeLastObject];
    NSLog(@"%s",__func__);
    
    [self.conditionLock unlockWithCondition:2];
}

- (void)otherTest {
    //可以实现线程依赖  用条件限制执行的先后顺序
    [[[NSThread alloc] initWithTarget:self selector:@selector(__add) object:nil] start];
    sleep(1);
    [[[NSThread alloc] initWithTarget:self selector:@selector(__remove) object:nil] start];
}

@end

