//
//  IAPPurchaseVerificationController.m
//  inAppPurchases
//
//  Created by Olivier Delecueillerie on 22/10/2014.
//  Copyright (c) 2014 lagspoon. All rights reserved.
//

#import "IAPPurchaseVerificationController.h"

@interface IAPPurchaseVerificationController ()

@property (strong, nonatomic) NSData *receipt;

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
        
    }
    return self;
}
@end
