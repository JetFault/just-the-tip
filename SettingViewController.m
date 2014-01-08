//
//  SettingViewController.m
//  just-the-tip
//
//  Created by Jerry Reptak on 1/6/14.
//  Copyright (c) 2014 Jerry Reptak. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tipField1;
@property (weak, nonatomic) IBOutlet UITextField *tipField2;
@property (weak, nonatomic) IBOutlet UITextField *tipField3;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipDefaultControl;

- (IBAction)onTap:(id)sender;

- (IBAction)onTipChange:(id)sender;
- (IBAction)onControlTap:(id)sender;

- (void)updateTipControl;
- (void)saveTip:(UISegmentedControl *)tipControl :(int)index :(NSUserDefaults *)defaults;

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadTipAmounts];
    [self updateTipControl];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)onTipChange:(id)sender {
    [self updateTipControl];
}

- (IBAction)onControlTap:(id)sender {
    [self saveSettings];
}

- (void)loadTipAmounts {
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self loadTip:self.tipField1 :0 :defaults];
    [self loadTip:self.tipField2 :1 :defaults];
    [self loadTip:self.tipField3 :2 :defaults];
    
    int defaultIndex = [defaults integerForKey:@"TipDefaultIndex"];
    
    self.tipDefaultControl.selectedSegmentIndex = defaultIndex;
}

- (void)loadTip:(UITextField *)textField :(int)index :(NSUserDefaults *)defaults {
    int tipAmount = [defaults integerForKey:[NSString stringWithFormat:@"TipAmount%d", index]];
    textField.text = [NSString stringWithFormat:@"%d", tipAmount];
    
}

- (void)updateTipControl {
    [self.tipDefaultControl setTitle:self.tipField1.text forSegmentAtIndex:0];
    [self.tipDefaultControl setTitle:self.tipField2.text forSegmentAtIndex:1];
    [self.tipDefaultControl setTitle:self.tipField3.text forSegmentAtIndex:2];
    
    [self saveSettings];
}

- (void)saveSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:self.tipDefaultControl.selectedSegmentIndex forKey:@"TipDefaultIndex"];
    
    NSLog(@"WTF");
    
    [self saveTip:self.tipDefaultControl :0 :defaults];
    [self saveTip:self.tipDefaultControl :1 :defaults];
    [self saveTip:self.tipDefaultControl :2 :defaults];
    
    [defaults synchronize];
}

- (void)saveTip:(UISegmentedControl *)tipControl :(int)index :(NSUserDefaults *)defaults {
    int tipAmount = [[tipControl titleForSegmentAtIndex:index] intValue];
    [defaults setInteger:tipAmount forKey:[NSString stringWithFormat:@"TipAmount%d", index]];
}

@end
