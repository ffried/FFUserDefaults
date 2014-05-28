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

long FFUDLongGetter(FFUserDefaults *self, SEL _cmd) {
    return [FFUDGetter(self, _cmd) longValue];
}

void FFUDLongSetter(FFUserDefaults *self, SEL _cmd, long l) {
    return FFUDSetter(self, _cmd, @(l));
}

unsigned long FFUDUnsignedLongGetter(FFUserDefaults *self, SEL _cmd) {
    return [FFUDGetter(self, _cmd) unsignedLongValue];
}

void FFUDUnsignedLongSetter(FFUserDefaults *self, SEL _cmd, unsigned long l) {
    return FFUDSetter(self, _cmd, @(l));
}

long long FFUDLongLongGetter(FFUserDefaults *self, SEL _cmd) {
    return [FFUDGetter(self, _cmd) longLongValue];
}

void FFUDLongLongSetter(FFUserDefaults *self, SEL _cmd, long long l) {
    return FFUDSetter(self, _cmd, @(l));
}

unsigned long long FFUDUnsignedLongLongGetter(FFUserDefaults *self, SEL _cmd) {
    return [FFUDGetter(self, _cmd) unsignedLongLongValue];
}

void FFUDUnsignedLongLongSetter(FFUserDefaults *self, SEL _cmd, unsigned long long l) {
    return FFUDSetter(self, _cmd, @(l));
}

double FFUDDoubleGetter(FFUserDefaults *self, SEL _cmd) {
    return [FFUDGetter(self, _cmd) doubleValue];
}

void FFUDDoubleSetter(FFUserDefaults *self, SEL _cmd, double d) {
    return FFUDSetter(self, _cmd, @(d));
}

float FFUDFloatGetter(FFUserDefaults *self, SEL _cmd) {
    return [FFUDGetter(self, _cmd) floatValue];
}

void FFUDFloatSetter(FFUserDefaults *self, SEL _cmd, float f) {
    return FFUDSetter(self, _cmd, @(f));
}

short FFUDShortGetter(FFUserDefaults *self, SEL _cmd) {
    return [FFUDGetter(self, _cmd) shortValue];
}

void FFUDShortSetter(FFUserDefaults *self, SEL _cmd, short s) {
    return FFUDSetter(self, _cmd, @(s));
}

unsigned short FFUDUnsignedShortGetter(FFUserDefaults *self, SEL _cmd) {
    return [FFUDGetter(self, _cmd) unsignedShortValue];
}

void FFUDUnicharSetter(FFUserDefaults *self, SEL _cmd, unsigned short s) {
    return FFUDSetter(self, _cmd, @(s));
}

char FFUDCharGetter(FFUserDefaults *self, SEL _cmd) {
    return [FFUDGetter(self, _cmd) charValue];
}

void FFUDCharSetter(FFUserDefaults *self, SEL _cmd, char c) {
    return FFUDSetter(self, _cmd, @(c));
}

#pragma mark - Factory
@implementation FFUDImplementationFactory

+ (NSDictionary *)primitiveGettersDictionary
{
    static NSDictionary *FFUDPrimitiveGettersDictionary = nil;
    if (!FFUDPrimitiveGettersDictionary) {
        FFUDPrimitiveGettersDictionary = @{@"c": [NSValue valueWithPointer:(IMP)FFUDCharGetter],
                                           @"d": [NSValue valueWithPointer:(IMP)FFUDDoubleGetter],
                                           @"i": [NSValue valueWithPointer:(IMP)FFUDIntGetter],
                                           @"f": [NSValue valueWithPointer:(IMP)FFUDFloatGetter],
                                           @"l": [NSValue valueWithPointer:(IMP)FFUDLongGetter],
                                           @"s": [NSValue valueWithPointer:(IMP)FFUDShortGetter],
                                           @"B": [NSValue valueWithPointer:(IMP)FFUDBoolGetter],
                                           @"I": [NSValue valueWithPointer:(IMP)FFUDUnsignedIntGetter],
                                           @"Q": [NSValue valueWithPointer:(IMP)FFUDUnsignedIntegerGetter]
                                           };
    }
    return FFUDPrimitiveGettersDictionary;
}

+ (NSDictionary *)primitiveSettersDictionary
{
    static NSDictionary *FFUDPrimitiveSettersDictionary = nil;
    if (!FFUDPrimitiveSettersDictionary) {
        FFUDPrimitiveSettersDictionary = @{@"c": [NSValue valueWithPointer:(IMP)FFUDCharSetter],
                                           @"d": [NSValue valueWithPointer:(IMP)FFUDDoubleSetter],
                                           @"i": [NSValue valueWithPointer:(IMP)FFUDIntSetter],
                                           @"f": [NSValue valueWithPointer:(IMP)FFUDFloatSetter],
                                           @"l": [NSValue valueWithPointer:(IMP)FFUDLongSetter],
                                           @"s": [NSValue valueWithPointer:(IMP)FFUDShortSetter],
                                           @"B": [NSValue valueWithPointer:(IMP)FFUDBoolSetter],
                                           @"I": [NSValue valueWithPointer:(IMP)FFUDUnsignedIntSetter],
                                           @"Q": [NSValue valueWithPointer:(IMP)FFUDUnsignedIntegerSetter]
                                           };
    }
    return FFUDPrimitiveSettersDictionary;
}

+ (IMP)getterForProperty:(FFUDProperty *)property
{
    if (!property.isPrimitive) {
        return (IMP)FFUDGetter;
    } else {
        NSDictionary *getters = [self primitiveGettersDictionary];
        NSValue *impValue = getters[property.shortType];
        if (impValue) return (IMP)[impValue pointerValue];
        return NULL;
    }
}

+ (IMP)setterForProperty:(FFUDProperty *)property
{
    if (!property.isPrimitive) {
        return (IMP)FFUDSetter;
    } else {
        NSDictionary *setters = [self primitiveSettersDictionary];
        NSValue *impValue = setters[property.shortType];
        if (impValue) return (IMP)[impValue pointerValue];
        return NULL;
    }
}

@end
