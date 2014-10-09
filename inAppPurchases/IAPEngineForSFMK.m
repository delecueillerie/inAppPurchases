//
//  IAPSpellingForMyKids.m
//  inAppPurchases
//
//  Created by Olivier Delecueillerie on 03/10/2014.
//  Copyright (c) 2014 lagspoon. All rights reserved.
//

#import "IAPEngineForSFMK.h"
#import "blind.h"

@implementation IAPEngineForSFMK


+ (IAPEngineForSFMK *)sharedInstance {
    static dispatch_once_t once;
    static IAPEngineForSFMK *sharedInstance;
    dispatch_once(&once, ^{
        NSSet *productIdentifiers = [NSSet setWithObjects:
                                      productId1,
                                      productId2,
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}


@end
