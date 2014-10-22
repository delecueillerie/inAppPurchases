//
//  IAPDataBlind.h
//  inAppPurchases
//
//  Created by Olivier Delecueillerie on 21/10/2014.
//  Copyright (c) 2014 lagspoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IAPDataSecret : NSObject

+(IAPDataSecret *)sharedInstance;
@property (strong, nonatomic) NSString *bundleIdentifier;
@property (strong, nonatomic) NSString *bundleVersion;


@end
