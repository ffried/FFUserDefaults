//
//  FFViewController.m
//  FFUserDefaults Sample
//
//  Created by Florian Friedrich on 18.5.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import "FFViewController.h"
#import "FFSettings.h"

@interface FFViewController ()
@property (nonatomic, strong, readonly) NSDateFormatter *dateFormatter;
@end

@implementation FFViewController
@synthesize dateFormatter = _dateFormatter;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.settings addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:NULL];
    [self.settings addObserver:self forKeyPath:@"reminderDate" options:NSKeyValueObservingOptionNew context:NULL];
    [self.settings addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.nameField.text = self.settings.name;
    self.nameLabel.text = self.settings.name;
    [self.reminderDatePicker setDate:self.settings.reminderDate animated:animated];
    self.reminderDateLabel.text = [self.dateFormatter stringFromDate:self.settings.reminderDate];
    [self.selectedSwitch setOn:self.settings.selected animated:animated];
    self.selectedLabel.text = self.settings.selected ? @"YES": @"NO";
}

- (void)dealloc
{
    [self.settings removeObserver:self forKeyPath:@"name"];
    [self.settings removeObserver:self forKeyPath:@"reminderDate"];
    [self.settings removeObserver:self forKeyPath:@"selected"];
}

#pragma mark - Properties
- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateStyle = NSDateFormatterShortStyle;
        _dateFormatter.timeStyle = NSDateFormatterShortStyle;
    }
    return _dateFormatter;
}

#pragma mark - Action
- (void)reminderDatePickerChanged:(id)sender
{
    self.settings.reminderDate = self.reminderDatePicker.date;
}

- (void)selectedSwitchChanged:(id)sender
{
    self.settings.selected = self.selectedSwitch.on;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.settings.name = newString;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.settings) {
        if ([keyPath isEqualToString:@"name"]) {
            self.nameLabel.text = self.settings.name;
        } else if ([keyPath isEqualToString:@"reminderDate"]) {
            self.reminderDateLabel.text = [self.dateFormatter stringFromDate:self.settings.reminderDate];
        } else if ([keyPath isEqualToString:@"selected"]) {
            self.selectedLabel.text = self.settings.isSelected ? @"YES" : @"NO";
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
