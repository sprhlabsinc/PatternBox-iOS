//
//  PurchaseController.h
//  PatternBox
//
//  Created by mac on 4/11/17.
//  Copyright © 2017 youandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface PurchaseController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *productDetail;
@property (weak, nonatomic) IBOutlet UIButton *m_btnBuy;

@property (strong, nonatomic) SKProduct *product;
@property (strong, nonatomic) NSString *productID;

- (IBAction)actionPurchase:(id)sender;
- (IBAction)actionRestore:(id)sender;

@end
