//
//  ViewController.m
//  Tippy
//
//  Created by Michael Abelar on 6/26/18.
//  Copyright © 2018 Michael Abelar. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *billField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;
@property (weak, nonatomic) IBOutlet UILabel *tipLabelText;
@property (weak, nonatomic) IBOutlet UILabel *totalLabelText;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;
@property (weak, nonatomic) IBOutlet UILabel *perPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *pricePerPersonLabel;

@end

@implementation ViewController

double billTotalGlobal = 0;

static int const EditingOffset = 50;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //change segmented control text color
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //load the last used bill
    double past_bill = [defaults doubleForKey:@"last_bill"];
    NSArray *percentages = @[@(0.15), @(0.2), @(0.22)];
    if (past_bill != 0) {
        double tipPercentage = [percentages[self.tipControl.selectedSegmentIndex] doubleValue];
        double tip = tipPercentage * past_bill;
        double total = past_bill + tip;
        billTotalGlobal = total;
        self.tipLabel.text = [NSString stringWithFormat:@"$%.2f", tip];
        self.totalLabel.text = [NSString stringWithFormat:@"$%.2f", total];
        
        int currValue = (int) self.slider.value;
        double perPersonCost = billTotalGlobal / ((double) currValue);
        
        self.pricePerPersonLabel.text = [NSString stringWithFormat:@"$%.2f", perPersonCost];
        
        self.billField.text = [NSString stringWithFormat: @"%.2f", past_bill];
    }
    
    [self.billField becomeFirstResponder];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //get default value
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    double index = [defaults doubleForKey:@"default_tip"];
    
    _tipControl.selectedSegmentIndex = index;
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}

//when the segmented controler changes
- (IBAction)onEdit:(id)sender {
    //current bill value
    double bill = [self.billField.text doubleValue];
    
    //prevents multiple decimal places 
    NSArray  *arrayOfString = [self.billField.text componentsSeparatedByString:@"."];
    if ([arrayOfString count] > 2 ) {
        self.billField.text = [NSString stringWithFormat:@"%.2f", bill];
    }
    
    NSArray *percentages = @[@(0.15), @(0.2), @(0.22)];
    
    double tipPercentage = [percentages[self.tipControl.selectedSegmentIndex] doubleValue];
    
    double tip = tipPercentage * bill;
    double total = bill + tip;
    billTotalGlobal = total;
    
    //save the value for future uses
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setDouble:bill forKey:@"last_bill"];
    [defaults synchronize];
    
    self.tipLabel.text = [NSString stringWithFormat:@"$%.2f", tip];
    self.totalLabel.text = [NSString stringWithFormat:@"$%.2f", total];

    int currValue = (int) self.slider.value;
    double perPersonCost = billTotalGlobal / ((double) currValue);
    
    self.pricePerPersonLabel.text = [NSString stringWithFormat:@"$%.2f", perPersonCost];
    
}

//when slider changes, change how the bill will be split
- (IBAction)sliderChanged:(id)sender {
    int currValue = (int) self.slider.value;
    self.peopleLabel.text = [NSString stringWithFormat:@"%d People", currValue];
    
    double perPersonCost = billTotalGlobal / ((double) currValue);
    self.pricePerPersonLabel.text = [NSString stringWithFormat:@"$%.2f", perPersonCost];
}

//function that changes the alpha of the remaining elements on the screen
-(void)changeAlpha:(double)alpha {
    self.tipLabel.alpha = alpha;
    self.totalLabel.alpha = alpha;
    self.tipControl.alpha = alpha;
    self.totalLabelText.alpha = alpha;
    self.tipLabelText.alpha = alpha;
    self.slider.alpha = alpha;
    self.peopleLabel.alpha = alpha;
    self.perPersonLabel.alpha = alpha;
    self.pricePerPersonLabel.alpha = alpha;
}


//animation function for editing the bill field
- (IBAction)onEditingBegin:(id)sender {
    
    
    [UIView animateWithDuration:0.2 animations:^{
        //put the bill entry at the center of the screen
        self.billField.frame = CGRectMake(self.billField.frame.origin.x, ([UIScreen mainScreen].bounds.size.width / 2) + EditingOffset, self.billField.frame.size.width, self.billField.frame.size.height);
        [self changeAlpha:0];
    }];
    
    }

//animation function for exiting editing the bill field
- (IBAction)onEditingEnd:(id)sender {
    CGRect newFrame = self.billField.frame;
    newFrame.origin.y = EditingOffset;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.billField.frame = newFrame;
        [self changeAlpha:1];
    }];
    
}


@end
