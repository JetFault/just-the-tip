//
//  TipViewController.m
//  just-the-tip
//
//  Created by Jerry Reptak on 1/6/14.
//  Copyright (c) 2014 Jerry Reptak. All rights reserved.
//

#import "TipViewController.h"
#import "SettingViewController.h"

@interface TipViewController ()

@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;

- (IBAction)onTap:(id)sender;
- (void)updateValues;

@end

@implementation TipViewController

static const int defaultTipValues[] = { 10, 15, 20};

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Just the Tip";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadTipAmounts];
    
    [self updateValues];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingsButton)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
    [self updateValues];
}

- (void)loadTipAmounts {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self loadTip:0 :defaults];
    [self loadTip:1 :defaults];
    [self loadTip:2 :defaults];
    
    [defaults synchronize];
    
    int defaultIndex = [defaults integerForKey:@"TipDefaultIndex"];
    
    self.tipControl.selectedSegmentIndex = defaultIndex;
}

- (void)loadTip:(int)index :(NSUserDefaults *)defaults {
    int tipAmount = [defaults integerForKey:[NSString stringWithFormat:@"TipAmount%d", index]];
    
    if(!tipAmount) {
        tipAmount = defaultTipValues[index];
        [defaults setInteger:tipAmount forKey:[NSString stringWithFormat:@"TipAmount%d", index]];
    }
    
    [self.tipControl setTitle:[NSString stringWithFormat:@"%d", tipAmount] forSegmentAtIndex:index];
}


- (void)updateValues{
    float billAmount = [self.billTextField.text floatValue];
    
    int tipPercent = [[self.tipControl titleForSegmentAtIndex:self.tipControl.selectedSegmentIndex] intValue];
    float tipAmount = billAmount * tipPercent / 100;
    float totalAmount = billAmount + tipAmount;
    
    self.tipLabel.text = [NSString stringWithFormat:@"$%0.2f", tipAmount];
    self.totalLabel.text = [NSString stringWithFormat:@"$%0.2f", totalAmount];
}

- (void)onSettingsButton {
    [self.navigationController pushViewController:[[SettingViewController alloc] init] animated:YES];
}

@end
