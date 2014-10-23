//
//  IAPStoreContentSecretModel.h
//  inAppPurchases
//
//  Created by Olivier Delecueillerie on 22/10/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "IAPProduct.h"

@interface IAPStoreContentSecretController : NSObject < SKProductsRequestDelegate>

+(IAPStoreContentSecretController *)sharedInstance;
-(void) reloadContentWithCompletionHandler:(BOOL (^)(void))success;
-(IAPProduct *)productWithIdentifier:(NSString *)identifier;

@property (strong, nonatomic) NSSet *productIdentifiers;
@property (strong, nonatomic) NSSet *products; // NSSet of IAPProduct objects
@property (strong, nonatomic) NSArray *productsArray; // NSSet of IAPProduct objects


@end
