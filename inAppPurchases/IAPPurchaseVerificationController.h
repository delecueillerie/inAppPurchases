//
//  IAPPurchaseVerificationController.h
//  inAppPurchases
//
//  Created by Olivier Delecueillerie on 22/10/2014.
//  Copyright (c) 2014 lagspoon. All rights reserved.
//

#import "IAPPurchaseVerificationSecretController.h"
#import <StoreKit/StoreKit.h>

@interface IAPPurchaseVerificationController : IAPPurchaseVerificationSecretController <SKRequestDelegate>
+(IAPPurchaseVerificationController *)sharedInstance;
-(void) reloadReceipt:(void (^)(BOOL success))completion;
@property(strong, nonatomic) NSSet *productPurchasedIdentifiers;
@end
