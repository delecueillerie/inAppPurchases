//
//  IAPStoreContentSecretModel.h
//  inAppPurchases
//
//  Created by Olivier Delecueillerie on 22/10/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IAPStoreContentSecretModel : NSObject
+(IAPStoreContentSecretModel *)sharedInstance;
@property (strong, nonatomic) NSSet *productIdentifiers;
@end
