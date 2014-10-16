//
//  IAPHelper.h
//  inAppPurchases
//
//  Created by Olivier Delecueillerie on 03/10/2014.
//  Copyright (c) 2014 lagspoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);
UIKIT_EXTERN NSString *const IAPEngineProductPurchasedNotification;

@interface IAPEngine : NSObject <SKRequestDelegate>

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;
- (void)buyProduct:(SKProduct *)product;
- (BOOL)productPurchased:(NSString *)productIdentifier;
- (void)restoreCompletedTransactions;

@end
