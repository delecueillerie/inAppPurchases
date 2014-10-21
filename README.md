inAppPurchases
==============

# Goal of this librairy
This App/Library deal with the InApp Purchase (IAP) verification locally.

After reading the [Apple doc](https://developer.apple.com/library/ios/releasenotes/General/ValidateAppStoreReceipt/Chapters/ValidateLocally.html#//apple_ref/doc/uid/TP40010573-CH1-SW2) I was not feeling confortable.

Thus, I googlised and found inspiration with :

- https://github.com/rmaddy/VerifyStoreReceiptiOS

All the difficult part (extract receipt from container, receipt parsing, function from openssl, etc.) can be understood reading the [source code] (https://github.com/rmaddy/VerifyStoreReceiptiOS/blob/master/VerifyStoreReceipt.m)




- http://alexistaugeron.com/blog/2013/09/23/app-store-receipt-validation-on-ios-7/
- http://objectiveprogrammer.blogspot.fr/2013/12/verifying-ios-7-app-receipt.html
- https://github.com/rjstelling/ReceiptKit.git
- https://github.com/rmaddy/VerifyStoreReceiptiOS

# First step

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

but you must know :
- During development (sandbox) you need to use SKReceiptRefreshRequest and wait for its delegate’s requestDidFinish to have the receipt file at the defined URL
- You cannot use simulator (no receipt file loaded)


# OpenSSL Framework buiding

I took a look at :
http://www.cppguru.com/12-openssl-framework-for-ios-7.html
https://github.com/x2on/OpenSSL-for-iPhone.git
Both look ok.




list of links that helped me
http://objectiveprogrammer.blogspot.dk/
