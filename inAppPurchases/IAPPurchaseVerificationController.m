//
//  IAPPurchaseVerificationController.m
//  inAppPurchases
//
//  Created by Olivier Delecueillerie on 22/10/2014.
//  Copyright (c) 2014 lagspoon. All rights reserved.
//

#import "IAPPurchaseVerificationController.h"
#import "IAPProduct.h"

@interface IAPPurchaseVerificationController ()

@property (strong, nonatomic) NSData *receipt;
@property (strong, nonatomic) SKReceiptRefreshRequest *receiptRequestRefresh;
@property (copy) void (^reloadReceiptCompletion)(BOOL success);

@end

@implementation IAPPurchaseVerificationController


/*////////////////////////////////////////////////////////////////////////////////////////
 Accessors
 /*///////////////////////////////////////////////////////////////////////////////////////*/

-(NSData *) receipt {
    if (!_receipt) {
        NSURL *url = [[NSBundle mainBundle] appStoreReceiptURL];
        _receipt = [NSData dataWithContentsOfURL:url];
    }
    return _receipt;
}

-(NSSet *) productPurchasedIdentifiers {
    if (!_productPurchasedIdentifiers) {
        if (self.receipt) {
            NSMutableSet *mSet = [[NSMutableSet alloc] init];
            NSArray *inAppPurchases = [self getInAppPurchasesFromReceiptPath:[[[NSBundle mainBundle] appStoreReceiptURL] path]];
            for (NSDictionary *inAppPurchase in inAppPurchases) {
                [mSet addObject:[inAppPurchase valueForKey:kReceiptInAppProductIdentifier]];
            }
            _productPurchasedIdentifiers = [NSSet setWithSet:mSet];
        }
    }
    return _productPurchasedIdentifiers;
}

-(SKReceiptRefreshRequest *)receiptRequestRefresh {
    // Query the App Store for product information
    if (!_receiptRequestRefresh) {
        _receiptRequestRefresh = [[SKReceiptRefreshRequest alloc] init];
        _receiptRequestRefresh.delegate = self;
    }
    return _receiptRequestRefresh;
}
/*////////////////////////////////////////////////////////////////////////////////////////
 Initializer
 /*///////////////////////////////////////////////////////////////////////////////////////*/

+(IAPPurchaseVerificationController *)sharedInstance {
    static dispatch_once_t once;
    static IAPPurchaseVerificationController *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id) init {
    self = [super init];
    if (self) {
        if (!self.receipt) {
            [self.receiptRequestRefresh start];
        }
    }
    return self;
}

/*////////////////////////////////////////////////////////////////////////////////////////
 Trigerred Actions
 /*///////////////////////////////////////////////////////////////////////////////////////*/

-(void) reloadReceipt:(void (^)(BOOL))completion {
    self.receipt = nil;
    self.productPurchasedIdentifiers = nil;
    [self.receiptRequestRefresh start];
    self.reloadReceiptCompletion = completion;
}

/*////////////////////////////////////////////////////////////////////////////////
SKRequestDelegate
///////////////////////////////////////////////////////////////////////////////*/

- (void)requestDidFinish:(SKRequest *)request
{
    if ([request isEqual:self.receiptRequestRefresh]){
        NSLog(@"Got receipt");
        self.reloadReceiptCompletion(YES);
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    if ([request isEqual:self.receiptRequestRefresh]){
        NSLog(@"Error getting receipt");
        self.reloadReceiptCompletion(NO);
    }
}


@end
