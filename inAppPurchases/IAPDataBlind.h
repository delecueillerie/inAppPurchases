//
//  IAPDataBlind.h
//  inAppPurchases
//
//  Created by Olivier Delecueillerie on 21/10/2014.
//  Copyright (c) 2014 lagspoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IAPDataBlind : NSObject
+(NSSet *) productIdentifiers;
+(NSString *) bundleIdentifier;
+(NSString *) bundleVersion;
@end
