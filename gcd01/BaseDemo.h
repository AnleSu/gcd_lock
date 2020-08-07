//
//  BaseDemo.h
//  gcd01
//
//  Created by AnleSu on 2020/8/5.
//  Copyright © 2020 AnleSu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseDemo : NSObject
- (void)moneyTest;
- (void)ticketsTest;
- (void)otherTest;

- (void)__saveMoney;
- (void)__drawMoney;
- (void)__saleTicket;

@end

NS_ASSUME_NONNULL_END
