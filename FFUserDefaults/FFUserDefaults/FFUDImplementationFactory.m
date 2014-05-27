//
//  FFUDImplementationFactory.m
//  FFUserDefaults
//
//  Created by Florian Friedrich on 27.05.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import "FFUDImplementationFactory.h"
#import "FFUserDefaults+Internal.h"
#import "FFUDProperty+Internal.h"

typedef NS_ENUM(NSInteger, FFUDType) {
    FFUDGetterType,
    FFUDSetterType
};

#pragma mark - Helpers
extern inline NSString *FFUDKeyForSelector(FFUserDefaults *userDefaults, SEL selector, FFUDType type) {
    NSArray *dynamicAccessors;
    switch (type) {
        case FFUDSetterType:
            dynamicAccessors = [[userDefaults class] dynamicSetters];
            break;
        case FFUDGetterType:
        default:
            dynamicAccessors = [[userDefaults class] dynamicGetters];
            break;
    }
    NSArray *dynamicProperties = [[userDefaults class] dynamicProperties];
    NSUInteger idx = [dynamicAccessors indexOfObject:NSStringFromSelector(selector)];
    FFUDProperty *property = dynamicProperties[idx];
    return FFUDKeyForPropertyName(property.name);
}

#pragma mark - Objects
id FFUDGetter(FFUserDefaults *self, SEL _cmd) {
    NSString *key = FFUDKeyForSelector(self, _cmd, FFUDGetterType);
    return [self.userDefaults objectForKey:key];
}

void FFUDSetter(FFUserDefaults *self, SEL _cmd, id obj) {
    NSString *key = FFUDKeyForSelector(self, _cmd, FFUDSetterType);
    return [self.userDefaults setObject:obj forKey:key];
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

unsigned int FFUDUnsignedIntGetter(FFUserDefaults *self, SEL _cmd) {
    return [FFUDGetter(self, _cmd) unsignedIntValue];
}

void FFUDUnsignedIntSetter(FFUserDefaults *self, SEL _cmd, unsigned int i) {
    return FFUDSetter(self, _cmd, @(i));
}

NSInteger FFUDIntegerGetter(FFUserDefaults *self, SEL _cmd) {
    return [FFUDGetter(self, _cmd) integerValue];
}

void FFUDIntegerSetter(FFUserDefaults *self, SEL _cmd, NSInteger i) {
    return FFUDSetter(self, _cmd, @(i));
}

NSUInteger FFUDUnsignedIntegerGetter(FFUserDefaults *self, SEL _cmd) {
    return [FFUDGetter(self, _cmd) unsignedIntegerValue];
}

void FFUDUnsignedIntegerSetter(FFUserDefaults *self, SEL _cmd, NSUInteger i) {
    return FFUDSetter(self, _cmd, @(i));
}

#pragma mark - Factory
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
