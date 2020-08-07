//
//  MutexDemo.m
//  gcd01
//
//  Created by AnleSu on 2020/8/5.
//  Copyright © 2020 AnleSu. All rights reserved.
//

#import "MutexDemo.h"
#import <pthread.h>
@interface MutexDemo()
@property (nonatomic, assign) pthread_mutex_t moneylock;
@property (nonatomic, assign) pthread_mutex_t ticketlock;
@property (nonatomic, assign) pthread_mutex_t mutex;
@end
@implementation MutexDemo
- (void)_initMutex:(pthread_mutex_t)mutex {
    //        初始化属性
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_NORMAL);
    
    //        初始化锁
    pthread_mutex_init(&mutex, &attr);
    //        销毁属性
    pthread_mutexattr_destroy(&attr);
}

//递归锁
//- (void)_initRecursiveMutex:(pthread_mutex_t)mutex {
//    //        初始化属性
//            pthread_mutexattr_t attr;
//            pthread_mutexattr_init(&attr);
//            pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
//
//    //        初始化锁
//            pthread_mutex_init(&mutex, &attr);
//    //        销毁属性
//            pthread_mutexattr_destroy(&attr);
//}
- (instancetype)init
{
    self = [super init];
    if (self) {
//        pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;  静态初始化
        [self _initMutex:_moneylock];
        [self _initMutex:_ticketlock];
        [self _initMutex:_mutex];
//        [self _initRecursiveMutex:_mutex];
    }
    return self;
}

- (void)__saveMoney {
    pthread_mutex_lock(&_moneylock);
    [super __saveMoney];
    pthread_mutex_unlock(&_moneylock);
    
}

- (void)__drawMoney {
    pthread_mutex_lock(&_moneylock);
    [super __drawMoney];
    pthread_mutex_unlock(&_moneylock);
    
}

- (void)__saleTicket {
    pthread_mutex_lock(&_ticketlock);
    [super __saleTicket];
    pthread_mutex_unlock(&_ticketlock);
    
    
}

//死锁
//解决方案一： 两个方法中用不同的锁
//解决方案二： 递归锁
- (void)otherTest {
    pthread_mutex_lock(&_mutex);
    
    NSLog(@"%s",__func__);
    [self otherTest];
    
    pthread_mutex_unlock(&_mutex);
    
}

- (void)otherTest1 {
    pthread_mutex_lock(&_mutex);
    NSLog(@"%s",__func__);
    [self otherTest1];
    pthread_mutex_unlock(&_mutex);
   
    
}

- (void)recursiveLock {
    __block pthread_mutex_t recursiveMutex;
    pthread_mutexattr_t recursiveMutexattr;
    pthread_mutexattr_init(&recursiveMutexattr);
    pthread_mutexattr_settype(&recursiveMutexattr, PTHREAD_MUTEX_RECURSIVE);
    pthread_mutex_init(&recursiveMutex, &recursiveMutexattr);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        static void (^RecursiveBlock)(int);
        RecursiveBlock = ^(int  value) {
            pthread_mutex_lock(&recursiveMutex);
            // 这里要设置递归结束的条件或次数，不然会无限递归下去
            if (value > 0) {
                NSLog(@"处理中... %d",value);
                sleep(1);
                RecursiveBlock(--value);
            }
            NSLog(@"处理完成!");
            pthread_mutex_unlock(&recursiveMutex);
        };
        RecursiveBlock(4);
    });
}



- (void)dealloc
{
    pthread_mutex_destroy(&_moneylock);
    pthread_mutex_destroy(&_ticketlock);
}
@end
