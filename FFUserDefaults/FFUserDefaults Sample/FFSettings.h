//
//  FFSettings.h
//  FFUserDefaults
//
//  Created by Florian Friedrich on 18.5.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import <FFUserDefaults/FFUserDefaults.h>

@interface FFSettings : FFUserDefaults

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *reminderDate;
@property (nonatomic, getter = isSelected) BOOL selected;

@end
