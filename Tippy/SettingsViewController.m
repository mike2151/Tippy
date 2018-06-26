//
//  SettingsViewController.m
//  Tippy
//
//  Created by Michael Abelar on 6/26/18.
//  Copyright © 2018 Michael Abelar. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *defaultTipController;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
    
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)defaultTipChanged:(id)sender {

    long newDefaultValue = self.defaultTipController.selectedSegmentIndex;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setDouble:newDefaultValue forKey:@"default_tip"];
    [defaults synchronize];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //get default value
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    double index = [defaults doubleForKey:@"default_tip"];
    
    _defaultTipController.selectedSegmentIndex = index;
    
}

@end
