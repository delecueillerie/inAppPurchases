//
//  IAPStoreController.m
//  inAppPurchases
//
//  Created by Olivier Delecueillerie on 22/10/2014.
//  Copyright (c) 2014 lagspoon. All rights reserved.
//

#import "IAPStoreController.h"
//#import <UIKit/UIKit.h>
@interface IAPStoreController ()

@property (strong, nonatomic) SKProductsRequest *productsRequest;
@property (strong, nonatomic) SKReceiptRefreshRequest *receiptRequestRefresh;


@property (strong, nonatomic) RequestProductsCompletionHandler completionHandler;
@property (strong, nonatomic) NSMutableSet *purchasedProductIdentifiers;
@end

@implementation IAPStoreController

NSString *const IAPEngineProductPurchasedNotification = @"IAPEngineProductPurchasedNotification";

/*////////////////////////////////////////////////////////////////////////////////////////
 Accessors
 /*///////////////////////////////////////////////////////////////////////////////////////*/


-(NSMutableSet *) purchasedProductIdentifiers {
    if (!_purchasedProductIdentifiers) {
        _purchasedProductIdentifiers = [NSMutableSet set];
    }
    return _purchasedProductIdentifiers;
}

/*////////////////////////////////////////////////////////////////////////////////////////
 Initializer
 /*///////////////////////////////////////////////////////////////////////////////////////*/

+(IAPStoreController *)sharedInstance {
    static dispatch_once_t once;
    static IAPStoreController *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}



- (id)init {
    
    if ((self = [super init])) {

        // Check for previously purchased products
        
        
        for (NSString * productIdentifier in self.productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [self.purchasedProductIdentifiers addObject:productIdentifier];
                NSLog(@"Previously purchased: %@", productIdentifier);
            } else {
                NSLog(@"Not purchased: %@", productIdentifier);
            }
        }
        
    }
    return self;
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
    
    
    // Query the App Store for product information if the user is is allowed to make purchases.
    // Display an alert, otherwise.
    if([SKPaymentQueue canMakePayments])
    {
        self.completionHandler = [completionHandler copy];
        self.productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:self.productIdentifiers];
        self.productsRequest.delegate = self;
        [self.productsRequest start];
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
 Provide Content
 ///////////////////////////////////////////////////////////////////////////////*/

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    
    [self.purchasedProductIdentifiers addObject:productIdentifier];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPEngineProductPurchasedNotification object:productIdentifier userInfo:nil];
}




@end
