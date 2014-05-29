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
@property (nonatomic) BOOL ignoreKVO;
@end

@implementation FFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.settings addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:NULL];
    [self.settings addObserver:self forKeyPath:@"reminderDate" options:NSKeyValueObservingOptionNew context:NULL];
    [self.settings addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)dealloc
{
    [self.settings removeObserver:self forKeyPath:@"name"];
    [self.settings removeObserver:self forKeyPath:@"reminderDate"];
    [self.settings removeObserver:self forKeyPath:@"selected"];
}

- (void)reminderDatePickerChanged:(id)sender
{
    self.ignoreKVO = YES;
    self.settings.reminderDate = self.reminderDatePicker.date;
}

- (void)selectedSwitchChanged:(id)sender
{
    self.ignoreKVO = YES;
    self.settings.selected = self.selectedSwitch.on;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.ignoreKVO = YES;
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.settings.name = newString;
    return YES;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (self.ignoreKVO) {
        self.ignoreKVO = NO;
        return;
    }
    if (object == self.settings) {
        if ([keyPath isEqualToString:@"name"]) {
            self.nameField.text = self.settings.name;
        } else if ([keyPath isEqualToString:@"reminderDate"]) {
            self.reminderDatePicker.date = self.settings.reminderDate;
        } else if ([keyPath isEqualToString:@"selected"]) {
            self.selectedSwitch.on = self.settings.isSelected;
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
