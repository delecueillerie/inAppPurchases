//
//  SKPaymentTransaction+IAPPaymentTransactionVerfied.m
//  inAppPurchases
//
//  Created by Olivier Delecueillerie on 07/10/2014.
//  Copyright (c) 2014 lagspoon. All rights reserved.
//

#import "SKPaymentTransaction+Verfied.h"

@implementation SKPaymentTransaction (IAPPaymentTransactionVerfied)


/*////////////////////////////////////////////////////////////////////////////////
 Receipt validation
 ///////////////////////////////////////////////////////////////////////////////*/
/*
- (BOOL)validateReceipt {
    IAPReceiptValidationController *verifier = [IAPReceiptValidationController sharedInstance];
    [verifier verifyPurchase:transaction completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Successfully verified receipt!");
            [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
        } else {
            NSLog(@"Failed to validate receipt.");
            [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
        }
    }];
}
*/

-(BOOL) isPaymentTransactionValid {
    return YES;
}


// This method should be called once a transaction gets to the SKPaymentTransactionStatePurchased or SKPaymentTransactionStateRestored state
// Call it with the SKPaymentTransaction.transactionReceipt

/*
- (void)verifyPurchaseWithcompletionHandler:(VerifyCompletionHandler)completionHandler {

    BOOL isOk = [self isTransactionAndItsReceiptValid];
    if (!isOk)
    {
        // There was something wrong with the transaction we got back, so no need to call verifyReceipt.
        NSLog(@"Invalid transacion");
        completionHandler(FALSE);
        return;
    }
    
    // The transaction looks ok, so start the verify process.
    
    // Encode the receiptData for the itms receipt verification POST request.
    NSString *jsonObjectString = [self encodeBase64:(uint8_t *)self.transactionReceipt.bytes
                                             length:self.transactionReceipt.length];
    
    // Create the POST request payload.
    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\", \"password\" : \"%@\"}",
                         jsonObjectString, ITC_CONTENT_PROVIDER_SHARED_SECRET];
    
    NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    
#warning Check for the correct itms verify receipt URL
    // Use ITMS_SANDBOX_VERIFY_RECEIPT_URL while testing against the sandbox.
    NSString *serverURL = ITMS_SANDBOX_VERIFY_RECEIPT_URL; //ITMS_PROD_VERIFY_RECEIPT_URL;
    
    // Create the POST request to the server.
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serverURL]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:payloadData];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    _completionHandlers[[NSValue valueWithNonretainedObject:conn]] = completionHandler;
    
    [conn start];
    
    // The transation receipt has not been validated yet.  That is done from the NSURLConnection callback.
}

*/

/*
// Check the validity of the receipt.  If it checks out then also ensure the transaction is something
// we haven't seen before and then decode and save the purchaseInfo from the receipt for later receipt validation.
- (BOOL)isTransactionAndItsReceiptValid {
    if (!(self && self.transactionReceipt && [transaction.transactionReceipt length] > 0))
    {
        // Transaction is not valid.
        return NO;
    }
    
    // Pull the purchase-info out of the transaction receipt, decode it, and save it for later so
    // it can be cross checked with the verifyReceipt.
    NSDictionary *receiptDict       = [self dictionaryFromPlistData:transaction.transactionReceipt];
    NSString *transactionPurchaseInfo = [receiptDict objectForKey:@"purchase-info"];
    NSString *decodedPurchaseInfo   = [self decodeBase64:transactionPurchaseInfo length:nil];
    NSDictionary *purchaseInfoDict  = [self dictionaryFromPlistData:[decodedPurchaseInfo dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *transactionId         = [purchaseInfoDict objectForKey:@"transaction-id"];
    NSString *purchaseDateString    = [purchaseInfoDict objectForKey:@"purchase-date"];
    NSString *signature             = [receiptDict objectForKey:@"signature"];
    
    // Convert the string into a date
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss z"];
    
    NSDate *purchaseDate = [dateFormat dateFromString:[purchaseDateString stringByReplacingOccurrencesOfString:@"Etc/" withString:@""]];
    
    
    if (![self isTransactionIdUnique:transactionId])
    {
        // We've seen this transaction before.
        // Had [transactionsReceiptStorageDictionary objectForKey:transactionId]
        // Got purchaseInfoDict
        return NO;
    }
    
    // Check the authenticity of the receipt response/signature etc.
    
    BOOL result = checkReceiptSecurity(transactionPurchaseInfo, signature,
                                       (__bridge CFDateRef)(purchaseDate));
    
    if (!result)
    {
        return NO;
    }
    
    // Ensure the transaction itself is legit
    if (![self doTransactionDetailsMatchPurchaseInfo:transaction withPurchaseInfo:purchaseInfoDict])
    {
        return NO;
    }
    
    // Make a note of the fact that we've seen the transaction id already
    [self saveTransactionId:transactionId];
    
    // Save the transaction receipt's purchaseInfo in the transactionsReceiptStorageDictionary.
    [transactionsReceiptStorageDictionary setObject:purchaseInfoDict forKey:transactionId];
    
    return YES;
}
 */
@end
