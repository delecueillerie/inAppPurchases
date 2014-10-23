//
//  IAPPurchaseVerificationHidden.h
//  inAppPurchases
//
//  Created by Olivier Delecueillerie on 22/10/2014.
//  Copyright (c) 2014 lagspoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IAPPurchaseVerificationSecretController : NSObject

extern NSString *kReceiptBundleIdentifer;
extern NSString *kReceiptBundleIdentiferData;
extern NSString *kReceiptVersion;
extern NSString *kReceiptOpaqueValue;
extern NSString *kReceiptHash;
extern NSString *kReceiptInApp;
extern NSString *kReceiptOriginalVersion;
extern NSString *kReceiptExpirationDate;

extern NSString *kReceiptInAppQuantity;
extern NSString *kReceiptInAppProductIdentifier;
extern NSString *kReceiptInAppTransactionIdentifier;
extern NSString *kReceiptInAppPurchaseDate;
extern NSString *kReceiptInAppOriginalTransactionIdentifier;
extern NSString *kReceiptInAppOriginalPurchaseDate;
extern NSString *kReceiptInAppSubscriptionExpirationDate;
extern NSString *kReceiptInAppCancellationDate;
extern NSString *kReceiptInAppWebOrderLineItemID;


-(NSArray *) getInAppPurchasesFromReceiptPath:(NSString *) receiptPath;

@end
