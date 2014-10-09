//
//  IAPTVController.m
//  inAppPurchases
//
//  Created by Olivier Delecueillerie on 03/10/2014.
//  Copyright (c) 2014 lagspoon. All rights reserved.
//

#import "IAPTVController.h"
#import "IAPEngineForSFMK.h"
#import <StoreKit/StoreKit.h>

@interface IAPTVController ()

@property (strong, nonatomic) NSArray *products;
@property (strong, nonatomic) NSNumberFormatter * priceFormatter;
@end

@implementation IAPTVController

/*//////////////////////////////////////////////////////////////////////////////////
 View Lifecycle
 //////////////////////////////////////////////////////////////////////////////////*/

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"In App Rage";
    
    //Refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    [self reload];
    [self.refreshControl beginRefreshing];
    
    //Price formatter
    self.priceFormatter = [[NSNumberFormatter alloc] init];
    [self.priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [self.priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Restore" style:UIBarButtonItemStylePlain target:self action:@selector(restoreTapped:)];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPEngineProductPurchasedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*//////////////////////////////////////////////////////////////////////////////////
 Table view datasource & delegate
 //////////////////////////////////////////////////////////////////////////////////*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.products count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    SKProduct * product = (SKProduct *) self.products[indexPath.row];
    cell.textLabel.text = product.localizedTitle;
    
    [self.priceFormatter setLocale:product.priceLocale];
    cell.detailTextLabel.text = [self.priceFormatter stringFromNumber:product.price];
    
    if ([[IAPEngineForSFMK sharedInstance] productPurchased:product.productIdentifier]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.accessoryView = nil;
    } else {
        UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        buyButton.frame = CGRectMake(0, 0, 72, 37);
        [buyButton setTitle:@"Buy" forState:UIControlStateNormal];
        buyButton.tag = indexPath.row;
        [buyButton addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = buyButton;
    }
    return cell;
}

/*//////////////////////////////////////////////////////////////////////////////////
 Triggered action
 //////////////////////////////////////////////////////////////////////////////////*/

- (void)reload {
    self.products = nil;
    [self.tableView reloadData];
    [[IAPEngineForSFMK sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            self.products = products;
            [self.tableView reloadData];
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)buyButtonTapped:(id)sender {
    
    UIButton *buyButton = (UIButton *)sender;
    SKProduct *product = self.products[buyButton.tag];
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[IAPEngineForSFMK sharedInstance] buyProduct:product];
    
}

- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    [self.products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            *stop = YES;
        }
    }];
    
}

- (void)restoreTapped:(id)sender {
    [[IAPEngineForSFMK sharedInstance] restoreCompletedTransactions];
}
@end
