//
//  IAPPaymentQueueController.m
//  inAppPurchases
//
//  Created by Olivier Delecueillerie on 22/10/2014.
//  Copyright (c) 2014 lagspoon. All rights reserved.
//

#import "IAPPaymentQueueController.h"

@implementation IAPPaymentQueueController


/*////////////////////////////////////////////////////////////////////////////////////////
 Accessors
 ////////////////////////////////////////////////////////////////////////////////////////*/




/*////////////////////////////////////////////////////////////////////////////////////////
 Initializer
 ////////////////////////////////////////////////////////////////////////////////////////*/

+(IAPPaymentQueueController *)sharedInstance {
    static dispatch_once_t once;
    static IAPPaymentQueueController *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id) init {
    self = [super init];
    if (self) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

/*////////////////////////////////////////////////////////////////////////////////
 Triggered action
 ///////////////////////////////////////////////////////////////////////////////*/

- (void)buyProduct:(SKProduct *)product {
    if([SKPaymentQueue canMakePayments]) {
        
        NSLog(@"Buying %@...", product.productIdentifier);
        SKPayment * payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    } else {
        // Warn the user that they are not allowed to make purchases.
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                           message:@"Purchases are disabled on this device."
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [alerView show];
    }
}

- (void)restoreCompletedTransactions {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}


/*////////////////////////////////////////////////////////////////////////////////
 SKPaymentTransactionObserver delegate
 ///////////////////////////////////////////////////////////////////////////////*/

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}


- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"completeTransaction...");
    /*    if ([self validateReceiptForTransaction:transaction]) {
     [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
     [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
     }*/
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"restoreTransaction...");
    /*    if ([self validateReceiptForTransaction:transaction]) {
     [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
     [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
     }*/
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"failedTransaction...");
    if (transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

@end
