//
//  FFViewController.h
//  FFUserDefaults Sample
//
//  Created by Florian Friedrich on 18.5.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FFSettings;
@interface FFViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet FFSettings *settings;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UILabel *reminderDateLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *reminderDatePicker;
@property (weak, nonatomic) IBOutlet UILabel *selectedLabel;
@property (weak, nonatomic) IBOutlet UISwitch *selectedSwitch;

- (IBAction)reminderDatePickerChanged:(id)sender;
- (IBAction)selectedSwitchChanged:(id)sender;

@end
