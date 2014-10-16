//
//  IAPHelper.m
//  inAppPurchases
//
//  Created by Olivier Delecueillerie on 03/10/2014.
//  Copyright (c) 2014 lagspoon. All rights reserved.
//

#import "IAPEngine.h"
#import "SKPaymentTransaction+Verfied.h"

@interface IAPEngine () <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (strong, nonatomic) SKProductsRequest *productsRequest;
@property (strong, nonatomic) SKReceiptRefreshRequest *receiptRequestRefresh;


@property (strong, nonatomic) RequestProductsCompletionHandler completionHandler;
@property (strong, nonatomic) NSData *receipt;
@property (strong, nonatomic) NSSet *productIdentifiers;
@property (strong, nonatomic) NSMutableSet *purchasedProductIdentifiers;
@end

@implementation IAPEngine

NSString *const IAPEngineProductPurchasedNotification = @"IAPEngineProductPurchasedNotification";



-(NSData *) receipt {
    if (!_receipt) {
        NSURL *url = [[NSBundle mainBundle] appStoreReceiptURL];
        _receipt = [NSData dataWithContentsOfURL:url];
    }
    return _receipt;
}



- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    
    if ((self = [super init])) {
       
        // Store product identifiers
        self.productIdentifiers = productIdentifiers;
        
        if (!self.receipt) { //sandbox environment ?
            self.receiptRequestRefresh = [[SKReceiptRefreshRequest alloc] init];
            self.receiptRequestRefresh.delegate = self;
            [self.receiptRequestRefresh start];
        }
        
        if ([self isAppReceiptValidated]) {
            
            /*
            // Check for previously purchased products
            self.purchasedProductIdentifiers = [NSMutableSet set];
            
            for (NSString * productIdentifier in self.productIdentifiers) {
                BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
                if (productPurchased) {
                    [self.purchasedProductIdentifiers addObject:productIdentifier];
                    NSLog(@"Previously purchased: %@", productIdentifier);
                } else {
                    NSLog(@"Not purchased: %@", productIdentifier);
                }
            }
             */
             
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        }
    }
    return self;
}



- (BOOL) isAppReceiptValidated {
    
    

    
    return NO;
}

/*////////////////////////////////////////////////////////////////////////////////
 SKRequestDelegate
 ///////////////////////////////////////////////////////////////////////////////*/

- (void)requestDidFinish:(SKRequest *)request
{
    if ([request isEqual:self.receiptRequestRefresh]){
        NSLog(@"Got receipt");
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    if ([request isEqual:self.receiptRequestRefresh]){
        NSLog(@"Error getting receipt");
    } else if ([request isEqual:self.productsRequest]) {
        NSLog(@"Failed to load list of products.");
        NSLog(@"error : %@",[error description]);
        self.productsRequest = nil;
        //    self.completionHandler(NO, nil);
        //    self.completionHandler = nil;
    }
    
    

}












- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {

    self.completionHandler = [completionHandler copy];
    self.productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:self.productIdentifiers];
    self.productsRequest.delegate = self;
    [self.productsRequest start];
}

/*////////////////////////////////////////////////////////////////////////////////
 SKProductsRequestDelegate
 ///////////////////////////////////////////////////////////////////////////////*/

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSLog(@"Loaded list of products...");
    self.productsRequest = nil;
    
    NSArray * skProducts = response.products;
    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    self.completionHandler(YES, skProducts);
    self.completionHandler = nil;
}



/*////////////////////////////////////////////////////////////////////////////////
 Buying product
 ///////////////////////////////////////////////////////////////////////////////*/

- (BOOL)productPurchased:(NSString *)productIdentifier {
    return [self.purchasedProductIdentifiers containsObject:productIdentifier];
}

- (void)buyProduct:(SKProduct *)product {
    
    NSLog(@"Buying %@...", product.productIdentifier);
    
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

- (void)restoreCompletedTransactions {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
/*////////////////////////////////////////////////////////////////////////////////
 SKPaymentTransactionObserver delegate
 ///////////////////////////////////////////////////////////////////////////////*/

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction * transaction in transactions) {
    }
}

/*////////////////////////////////////////////////////////////////////////////////
 Transaction
 ///////////////////////////////////////////////////////////////////////////////*/

- (void) performTransaction:(SKPaymentTransaction *) transaction {
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

/*////////////////////////////////////////////////////////////////////////////////
 Provide Content
 ///////////////////////////////////////////////////////////////////////////////*/

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    
    [self.purchasedProductIdentifiers addObject:productIdentifier];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPEngineProductPurchasedNotification object:productIdentifier userInfo:nil];
}



@end
