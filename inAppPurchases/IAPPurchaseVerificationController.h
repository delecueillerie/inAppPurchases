//
//  IAPPurchaseVerificationController.h
//  inAppPurchases
//
//  Created by Olivier Delecueillerie on 22/10/2014.
//  Copyright (c) 2014 lagspoon. All rights reserved.
//

#import "IAPPurchaseVerificationSecretController.h"

@interface IAPPurchaseVerificationController : IAPPurchaseVerificationSecretController
+(IAPPurchaseVerificationController *)sharedInstance;
@end
