//
//  IAPProduct.m
//  inAppPurchases
//
//  Created by Olivier Delecueillerie on 22/10/2014.
//  Copyright (c) 2014 Olivier Delecueillerie. All rights reserved.
//

#import "IAPProduct.h"
@interface IAPProduct ()

@property (strong, nonatomic) NSNumberFormatter *numberFormatter;

@end





@implementation IAPProduct

/*////////////////////////////////////////////////////////////////////////////////////////
 Accessors
 /*///////////////////////////////////////////////////////////////////////////////////////*/
-(NSNumberFormatter *) numberFormatter {
    if (!_numberFormatter) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        [_numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [_numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    }
    return _numberFormatter;
}



/*////////////////////////////////////////////////////////////////////////////////////////
 Initializer
 /*///////////////////////////////////////////////////////////////////////////////////////*/

+(IAPProduct *) createProductFrom:(SKProduct *)product {
    IAPProduct *productCreated = [[IAPProduct alloc] init];
    productCreated.identifier = product.productIdentifier;
    productCreated.localizedDescription = product.localizedDescription;
    productCreated.localizedTitle = product.localizedTitle;
    
    
    [productCreated.numberFormatter setLocale:product.priceLocale];
    productCreated.price = [productCreated.numberFormatter stringFromNumber:product.price];
    
    return productCreated;
}


@end
