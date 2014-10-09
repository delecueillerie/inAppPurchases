//
//  IAPReceiptValidation.h
//  inAppPurchases
//
//  Created by Olivier Delecueillerie on 06/10/2014.
//  Copyright (c) 2014 lagspoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface IAPReceiptValidationController : NSObject



@property (strong, nonatomic) NSMutableDictionary *transactionsReceiptStorageDictionary;

+ (IAPReceiptValidationController *) sharedInstance;

// Checking the results of this is not enough.
// The final verification happens in the connection:didReceiveData: callback within
// this class.  So ensure IAP feaures are unlocked from there.



//- (void)verifyPurchase:(SKPaymentTransaction *)transaction completionHandler:(VerifyCompletionHandler)completionHandler;




@end
