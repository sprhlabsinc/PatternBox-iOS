//
//  PurchaseController.m
//  PatternBox
//
//  Created by mac on 4/11/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import "PurchaseController.h"
#import "AppManager.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface PurchaseController ()<SKPaymentTransactionObserver, SKProductsRequestDelegate>{

}

@end

@implementation PurchaseController

- (void)viewDidLoad {
    [super viewDidLoad];
//    if ([AppManager sharedInstance].purchaseStatus == PurchasePluse) {
//        _productID = @"com.patternbox.plus.fullpattern";
//        [self.m_btnBuy setTitle:@"Buy (6.99$)" forState:UIControlStateNormal];
//    } else if([AppManager sharedInstance].purchaseStatus == PurchasePremium){
//        _productID = @"com.patternbox.plus.premiumpattern";
//        [self.m_btnBuy setTitle:@"Buy (3.99$)" forState:UIControlStateNormal];
//    }else{
//
//    }
    [self getProductInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actionPurchase:(id)sender {
    SKPayment *payment = [SKPayment paymentWithProduct:_product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (IBAction)actionRestore:(id)sender {
//    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    
    SKReceiptRefreshRequest* request = [[SKReceiptRefreshRequest alloc] init];
    request.delegate = self;
    [request start];
    
}

-(void)getProductInfo
{
   
    if ([SKPaymentQueue canMakePayments])
    {
        SKProductsRequest *request = [[SKProductsRequest alloc]
                                      initWithProductIdentifiers:
                                      [NSSet setWithObject:_productID]];
        request.delegate = self;
        
        [request start];
    }
    else{
        NSLog(@"Please enable In App Purchase in Settings");
    }

}
#pragma mark SKProductsRequestDelegate

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    
    NSArray *products = response.products;
    
    if (products.count != 0)
    {
        _product = products[0];
        _m_btnBuy.enabled = YES;
        //_productTitle.text = _product.localizedTitle;
        //_productDetail.text = _product.localizedDescription;
    } else {
        _m_btnBuy.enabled = NO;
        _productDetail.text = @"Product not found";
    }
    
    products = response.invalidProductIdentifiers;
    
    for (SKProduct *product in products)
    {
        NSLog(@"Product not found: %@", product);
    }
}

#pragma mark SKPaymentTransactionObserver

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self unlockFeature];
                [[SKPaymentQueue defaultQueue]
                 finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                NSLog(@"Transaction Failed");
                [[SKPaymentQueue defaultQueue]
                 finishTransaction:transaction];
                break;
                
            default:
                break;
        }
    }
}
-(void)unlockFeature
{
    _m_btnBuy.enabled = NO;
    [_m_btnBuy setTitle:@"Purchased"
                forState:UIControlStateDisabled];
    [self updatePurchaseStatus];
}

#pragma mark Update Purchase Staus
-(void)updatePurchaseStatus{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[AppManager sharedInstance] putRequest:@"purchase" parameter:nil withCallback:^(NSDictionary *response, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            bool fail = [[response objectForKey:@"error"] boolValue];
            if (fail || !response) {
                NSString* message = [response objectForKey:@"message"];
                [[AppManager sharedInstance] showMessageWithTitle:@"" message:message view:self];
            }else{
                //[AppManager sharedInstance].purchaseStatus = PurchaseDone;
                [self.navigationController popViewControllerAnimated:YES];
            }
        } else {
            [[AppManager sharedInstance] showMessageWithTitle:@"" message:[error localizedDescription] view:self];
        }
    }];
}
@end
