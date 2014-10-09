//
//  SKPaymentTransaction+IAPPaymentTransactionVerfied.h
//  inAppPurchases
//
//  Created by Olivier Delecueillerie on 07/10/2014.
//  Copyright (c) 2014 lagspoon. All rights reserved.
//

#import <StoreKit/StoreKit.h>

@interface SKPaymentTransaction (IAPPaymentTransactionVerfied)

typedef void (^VerifyCompletionHandler)(BOOL success);


-(BOOL) isPaymentTransactionValid;

@end
