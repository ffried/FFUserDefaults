//
//  FFUDImplementationFactory.m
//  FFUserDefaults
//
//  Created by Florian Friedrich on 27.05.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import "FFUDImplementationFactory.h"
#import "FFUserDefaults.h"
#import "FFUDProperty+Internal.h"

@interface FFUserDefaults (Internal)
+ (NSArray *)dynamicProperties;
@end

#pragma mark - Objects
id FFUDGetter(FFUserDefaults *self, SEL _cmd) {
    NSArray *dynamicProperties = [[self class] dynamicProperties];
    NSArray *getters = [dynamicProperties valueForKey:@"getter"];
    NSUInteger idx = [getters indexOfObject:NSStringFromSelector(_cmd)];
    FFUDProperty *property = dynamicProperties[idx];
    return [self.userDefaults objectForKey:property.userDefaultsKey];
}

void FFUDSetter(FFUserDefaults *self, SEL _cmd, id newValue) {
    NSArray *dynamicProperties = [[self class] dynamicProperties];
    NSArray *setters = [dynamicProperties valueForKey:@"setter"];
    NSUInteger idx = [setters indexOfObject:NSStringFromSelector(_cmd)];
    FFUDProperty *property = dynamicProperties[idx];
    return [self.userDefaults setObject:newValue forKey:property.userDefaultsKey];
}

#pragma mark - Primitives
BOOL FFUDBoolGetter(FFUserDefaults *self, SEL _cmd) {
    return [FFUDGetter(self, _cmd) boolValue];
}

void FFUDBoolSetter(FFUserDefaults *self, SEL _cmd, BOOL b) {
    return FFUDSetter(self, _cmd, @(b));
}

int FFUDIntGetter(FFUserDefaults *self, SEL _cmd) {
    return [FFUDGetter(self, _cmd) intValue];
}

void FFUDIntSetter(FFUserDefaults *self, SEL _cmd, int i) {
    return FFUDSetter(self, _cmd, @(i));
}

@implementation FFUDImplementationFactory

+ (IMP)getterForProperty:(FFUDProperty *)property
{
    if (!property.isPrimitive) {
        return (IMP)FFUDGetter;
    } else {
        return NULL;
    }
}

+ (IMP)setterForProperty:(FFUDProperty *)property
{
    if (!property.isPrimitive) {
        return (IMP)FFUDSetter;
    } else {
        return NULL;
    }
}

@end
