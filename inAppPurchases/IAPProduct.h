//
//  IAPProduct.h
//  inAppPurchases
//
//  Created by Olivier Delecueillerie on 22/10/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface IAPProduct : NSObject

+(IAPProduct *) createProductFrom:(SKProduct *)product;
@property(strong, nonatomic) NSString *identifier;
@property(strong, nonatomic) NSString *localizedDescription;
@property(strong, nonatomic) NSString *localizedTitle;
@property(strong, nonatomic) NSString *price;
@property BOOL purchased;

@end
