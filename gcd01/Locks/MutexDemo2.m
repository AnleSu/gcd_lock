//
//  MutexDemo2.m
//  gcd01
//
//  Created by AnleSu on 2020/8/6.
//  Copyright © 2020 AnleSu. All rights reserved.
//

#import "MutexDemo2.h"
#import <pthread.h>
@interface MutexDemo2()
@property (nonatomic, assign) pthread_mutex_t mutex;
@property (nonatomic, assign) pthread_cond_t cond;
@property (nonatomic, strong) NSMutableArray *data;
@end
@implementation MutexDemo2
- (instancetype)init
{
    self = [super init];
    if (self) {
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_NORMAL);
        //        初始化锁
        pthread_mutex_init(&_mutex, &attr);
        //        销毁属性
        pthread_mutexattr_destroy(&attr);
        
//        初始化条件
        pthread_cond_init(&_cond, NULL);
        
        self.data = [NSMutableArray array];
    }
    return self;
}

- (void)__add {
    pthread_mutex_lock(&_mutex);
    
    [self.data addObject:@"str"];
     NSLog(@"%s",__func__);
//    信号 唤醒 然后解锁
    pthread_cond_signal(&_cond);
//    广播 所有等待这个条件的线程
//    pthread_cond_broadcast(&_cond);
   
    pthread_mutex_unlock(&_mutex);
}

- (void)__remove {
    NSLog(@"__remove begin");
    pthread_mutex_lock(&_mutex);
    
    if (self.data.count == 0) {
//        解锁  等待被条件唤醒    被唤醒 再加锁
        pthread_cond_wait(&_cond, &_mutex);
    }
    
    [self.data removeLastObject];
    NSLog(@"%s",__func__);
    pthread_mutex_unlock(&_mutex);
}

- (void)otherTest {
    [[[NSThread alloc] initWithTarget:self selector:@selector(__remove) object:nil] start];
    sleep(1);
    [[[NSThread alloc] initWithTarget:self selector:@selector(__add) object:nil] start];
}

- (void)dealloc
{
    pthread_mutex_destroy(&_mutex);
    pthread_cond_destroy(&_cond);
}
@end
