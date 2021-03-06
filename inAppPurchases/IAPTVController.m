//
//  IAPTVController.m
//  inAppPurchases
//
//  Created by Olivier Delecueillerie on 03/10/2014.
//  Copyright (c) 2014 lagspoon. All rights reserved.
//

#import "IAPTVController.h"

#import "IAPStoreContentSecretController.h"
#import "IAPPaymentQueueController.h"
#import "IAPProduct.h"

@interface IAPTVController ()

@property(strong, nonatomic) IAPStoreContentSecretController *storeContentController;
@property(strong, nonatomic) IAPPaymentQueueController *paymentController;
@end

@implementation IAPTVController

/*//////////////////////////////////////////////////////////////////////////////////
 Accessors
 //////////////////////////////////////////////////////////////////////////////////*/





/*//////////////////////////////////////////////////////////////////////////////////
 View Lifecycle
 //////////////////////////////////////////////////////////////////////////////////*/

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Olivier Delecueillerie In-App Purchase sample";
    
    
    self.storeContentController = [IAPStoreContentSecretController sharedInstance];
    self.paymentController = [IAPPaymentQueueController sharedInstance];
    
    //Refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    if (!self.storeContentController.products) {
        [self.refreshControl beginRefreshing];
        [self reload];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Restore" style:UIBarButtonItemStylePlain target:self action:@selector(restoreTapped:)];
    
}

- (void)viewWillAppear:(BOOL)animated {
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPEngineProductPurchasedNotification object:nil];
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
    return [self.storeContentController.products count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    IAPProduct * product = self.storeContentController.productsArray[indexPath.row];
    cell.textLabel.text = product.localizedTitle;
    
    cell.detailTextLabel.text = product.price;
    
    if (product.purchased) {
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
    [self.storeContentController requestContent:^(BOOL success) {
        if (success) {
            NSLog(@"productArray description %@",[self.storeContentController.productsArray description]);
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];

        } else {
            [self.refreshControl endRefreshing];

        }
    }];

}

- (void)buyButtonTapped:(id)sender {
    
    //UIButton *buyButton = (UIButton *)sender;
    NSUInteger index = [[self.tableView indexPathForSelectedRow] row];
    IAPProduct *product = self.storeContentController.productsArray[index];
    
    NSLog(@"Buying %@...", product.localizedTitle);
    [self.paymentController buyProduct:product];
    
}


- (void)restoreTapped:(id)sender {
    [self.paymentController restoreCompletedTransactions];
}
@end
