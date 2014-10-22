//
//  IAPPaymentQueueController.h
//  inAppPurchases
//
//  Created by Olivier Delecueillerie on 22/10/2014.
//  Copyright (c) 2014 lagspoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface IAPPaymentQueueController : NSObject <SKPaymentTransactionObserver>

+(IAPPaymentQueueController *)sharedInstance;

@end
