//
//  FFUserDefaults+Internal.h
//  FFUserDefaults
//
//  Created by Florian Friedrich on 27.5.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import "FFUserDefaults.h"

extern NSString *FFUDKeyForPropertyName(NSString *propertyName);
extern NSString *FFUDPropertyNameForUDKey(NSString *userDefaultsKey);

@interface FFUserDefaults (Internal)

+ (NSArray *)properties;
+ (NSArray *)dynamicProperties;
+ (NSArray *)dynamicGetters;
+ (NSArray *)dynamicSetters;

@end
