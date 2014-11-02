IOS inAppPurchase
==============

# Goal of this librairy
This App/Library deal with the InApp Purchase process (IAP)
It can :
- verify the receipt locally
- get the info from the receipt (previous purchased product, etc)
- get product informations
- deal with the payment transaction process

For a first view of the IAP purchase, here a few link from [Apple Library](https://developer.apple.com/library/ios/navigation/index.html#section=Frameworks&topic=StoreKit)

- [sample code](https://developer.apple.com/library/ios/samplecode/sc1991/Introduction/Intro.html#//apple_ref/doc/uid/DTS40014726)
- [WWDC14 Optimizing IAP](https://developer.apple.com/videos/wwdc/2014/?id=303)
- [WWDC14 Preventing Unauthorized Purchases with Receipts](https://developer.apple.com/videos/wwdc/2014/?id=305)

##How to test the app

A few things to know :

- During development (sandbox) you need to use SKReceiptRefreshRequest and wait for its delegate’s requestDidFinish to have the receipt file at the defined URL
- You cannot use simulator (no receipt file loaded)
- You have to allow the user for in-App purchased in Settings/General/Restriction on your device


# Verify the receipt locally
After reading the [Apple doc](https://developer.apple.com/library/ios/releasenotes/General/ValidateAppStoreReceipt/Chapters/ValidateLocally.html#//apple_ref/doc/uid/TP40010573-CH1-SW2) I was not feeling confortable.

Thus, I googlised and found inspiration with :

- https://github.com/rmaddy/VerifyStoreReceiptiOS

All the difficult part (extract receipt from container, receipt parsing, function from openssl, etc.) can be understood reading the [source code](https://github.com/rmaddy/VerifyStoreReceiptiOS/blob/master/VerifyStoreReceipt.m)



## Get the receipt
It's easy to get the receipt

```
-(NSData *) receipt {
if (!_receipt) {
NSURL *url = [[NSBundle mainBundle] appStoreReceiptURL];
_receipt = [NSData dataWithContentsOfURL:url];
}
return _receipt;
}
```
Be careful, during development (sandbox) you need to use SKReceiptRefreshRequest and wait for its delegate’s requestDidFinish to have the receipt file at the defined URL

Thus you have to put this code somewhere :
```
if (!self.receipt) {
    //sandbox environment ?
    self.receiptRequestRefresh = [[SKReceiptRefreshRequest alloc] init];
    self.receiptRequestRefresh.delegate = self;
    [self.receiptRequestRefresh start];
}

- (void)requestDidFinish:(SKRequest *)request {
    if ([request isEqual:self.receiptRequestRefresh]){
        NSLog(@"Got receipt");
    }
}

        ```


# OpenSSL Framework buiding

To buid the OpenSSL library I found two shell script that make the job.
- http://www.cppguru.com/12-openssl-framework-for-ios-7.html
- https://github.com/x2on/OpenSSL-for-iPhone.git


# Deal with the payment transaction process
To have a quick view of Cocoa functionality [Ray Wenderlich tutorials](http://www.raywenderlich.com) are very useful. Here the [tutorial](http://www.raywenderlich.com/21081/introduction-to-in-app-purchases-in-ios-6-tutorial) about payment transactions process.






# Other links for information
- http://alexistaugeron.com/blog/2013/09/23/app-store-receipt-validation-on-ios-7/
- http://objectiveprogrammer.blogspot.fr/2013/12/verifying-ios-7-app-receipt.html
- https://github.com/rjstelling/ReceiptKit.git
