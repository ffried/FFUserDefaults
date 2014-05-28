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
#pragma mark BOOL
BOOL FFUDBoolGetter(FFUserDefaults *self, SEL _cmd) {
    return [FFUDGetter(self, _cmd) boolValue];
}

void FFUDBoolSetter(FFUserDefaults *self, SEL _cmd, BOOL b) {
    return FFUDSetter(self, _cmd, @(b));
}

#pragma mark double
double FFUDDoubleGetter(FFUserDefaults *self, SEL _cmd) {
    return [FFUDGetter(self, _cmd) doubleValue];
}

void FFUDDoubleSetter(FFUserDefaults *self, SEL _cmd, double d) {
    return FFUDSetter(self, _cmd, @(d));
}

#pragma mark float
float FFUDFloatGetter(FFUserDefaults *self, SEL _cmd) {
    return [FFUDGetter(self, _cmd) floatValue];
}

void FFUDFloatSetter(FFUserDefaults *self, SEL _cmd, float f) {
    return FFUDSetter(self, _cmd, @(f));
}

#pragma mark char
char FFUDCharGetter(FFUserDefaults *self, SEL _cmd) {
    return [FFUDGetter(self, _cmd) charValue];
}

void FFUDCharSetter(FFUserDefaults *self, SEL _cmd, char c) {
    return FFUDSetter(self, _cmd, @(c));
}

#pragma mark unsigned char
unsigned char FFUDUnsignedCharGetter(FFUserDefaults *self, SEL _cmd) {
    return [FFUDGetter(self, _cmd) unsignedCharValue];
}

void FFUDUnsignedCharSetter(FFUserDefaults *self, SEL _cmd, unsigned char c) {
    return FFUDSetter(self, _cmd, @(c));
}

#pragma mark short
short FFUDShortGetter(FFUserDefaults *self, SEL _cmd) {
    return [FFUDGetter(self, _cmd) shortValue];
}

void FFUDShortSetter(FFUserDefaults *self, SEL _cmd, short s) {
    return FFUDSetter(self, _cmd, @(s));
}

#pragma mark unsigned short
unsigned short FFUDUnsignedShortGetter(FFUserDefaults *self, SEL _cmd) {
    return [FFUDGetter(self, _cmd) unsignedShortValue];
}

void FFUDUnsignedShortSetter(FFUserDefaults *self, SEL _cmd, unsigned short s) {
    return FFUDSetter(self, _cmd, @(s));
}

#pragma mark int
int FFUDIntGetter(FFUserDefaults *self, SEL _cmd) {
    return [FFUDGetter(self, _cmd) intValue];
}

void FFUDIntSetter(FFUserDefaults *self, SEL _cmd, int i) {
    return FFUDSetter(self, _cmd, @(i));
}

#pragma mark unsigned int
unsigned int FFUDUnsignedIntGetter(FFUserDefaults *self, SEL _cmd) {
    return [FFUDGetter(self, _cmd) unsignedIntValue];
}

void FFUDUnsignedIntSetter(FFUserDefaults *self, SEL _cmd, unsigned int i) {
    return FFUDSetter(self, _cmd, @(i));
}

#pragma mark long
long FFUDLongGetter(FFUserDefaults *self, SEL _cmd) {
    return [FFUDGetter(self, _cmd) longValue];
}

void FFUDLongSetter(FFUserDefaults *self, SEL _cmd, long l) {
    return FFUDSetter(self, _cmd, @(l));
}

#pragma mark unsigned long
unsigned long FFUDUnsignedLongGetter(FFUserDefaults *self, SEL _cmd) {
    return [FFUDGetter(self, _cmd) unsignedLongValue];
}

void FFUDUnsignedLongSetter(FFUserDefaults *self, SEL _cmd, unsigned long l) {
    return FFUDSetter(self, _cmd, @(l));
}

// long long not yet used
#pragma mark long long
long long FFUDLongLongGetter(FFUserDefaults *self, SEL _cmd) {
    return [FFUDGetter(self, _cmd) longLongValue];
}

void FFUDLongLongSetter(FFUserDefaults *self, SEL _cmd, long long l) {
    return FFUDSetter(self, _cmd, @(l));
}

#pragma mark unsigned long long
unsigned long long FFUDUnsignedLongLongGetter(FFUserDefaults *self, SEL _cmd) {
    return [FFUDGetter(self, _cmd) unsignedLongLongValue];
}

void FFUDUnsignedLongLongSetter(FFUserDefaults *self, SEL _cmd, unsigned long long l) {
    return FFUDSetter(self, _cmd, @(l));
}

#pragma mark integer
NSInteger FFUDIntegerGetter(FFUserDefaults *self, SEL _cmd) {
    return [FFUDGetter(self, _cmd) integerValue];
}

void FFUDIntegerSetter(FFUserDefaults *self, SEL _cmd, NSInteger i) {
    return FFUDSetter(self, _cmd, @(i));
}

#pragma mark unsigned integer
NSUInteger FFUDUnsignedIntegerGetter(FFUserDefaults *self, SEL _cmd) {
    return [FFUDGetter(self, _cmd) unsignedIntegerValue];
}

void FFUDUnsignedIntegerSetter(FFUserDefaults *self, SEL _cmd, NSUInteger i) {
    return FFUDSetter(self, _cmd, @(i));
}

#pragma mark - Factory
@implementation FFUDImplementationFactory

+ (NSDictionary *)primitiveGettersDictionary
{
    static NSDictionary *FFUDPrimitiveGettersDictionary = nil;
    if (!FFUDPrimitiveGettersDictionary) {
        FFUDPrimitiveGettersDictionary = @{@"B": [NSValue valueWithPointer:(IMP)FFUDBoolGetter],
                                           @"d": [NSValue valueWithPointer:(IMP)FFUDDoubleGetter],
                                           @"f": [NSValue valueWithPointer:(IMP)FFUDFloatGetter],
                                           @"c": [NSValue valueWithPointer:(IMP)FFUDCharGetter],
                                           @"C": [NSValue valueWithPointer:(IMP)FFUDUnsignedCharGetter],
                                           @"s": [NSValue valueWithPointer:(IMP)FFUDShortGetter],
                                           @"S": [NSValue valueWithPointer:(IMP)FFUDUnsignedShortGetter],
                                           @"i": [NSValue valueWithPointer:(IMP)FFUDIntGetter],
                                           @"I": [NSValue valueWithPointer:(IMP)FFUDUnsignedIntGetter],
                                           @"l": [NSValue valueWithPointer:(IMP)FFUDLongGetter],
                                           @"L": [NSValue valueWithPointer:(IMP)FFUDUnsignedLongGetter],
                                           @"q": [NSValue valueWithPointer:(IMP)FFUDIntegerGetter],
                                           @"Q": [NSValue valueWithPointer:(IMP)FFUDUnsignedIntegerGetter]};
    }
    return FFUDPrimitiveGettersDictionary;
}

+ (NSDictionary *)primitiveSettersDictionary
{
    static NSDictionary *FFUDPrimitiveSettersDictionary = nil;
    if (!FFUDPrimitiveSettersDictionary) {
        FFUDPrimitiveSettersDictionary = @{@"B": [NSValue valueWithPointer:(IMP)FFUDBoolSetter],
                                           @"d": [NSValue valueWithPointer:(IMP)FFUDDoubleSetter],
                                           @"f": [NSValue valueWithPointer:(IMP)FFUDFloatSetter],
                                           @"c": [NSValue valueWithPointer:(IMP)FFUDCharSetter],
                                           @"C": [NSValue valueWithPointer:(IMP)FFUDUnsignedCharSetter],
                                           @"s": [NSValue valueWithPointer:(IMP)FFUDShortSetter],
                                           @"S": [NSValue valueWithPointer:(IMP)FFUDUnsignedShortSetter],
                                           @"i": [NSValue valueWithPointer:(IMP)FFUDIntSetter],
                                           @"I": [NSValue valueWithPointer:(IMP)FFUDUnsignedIntSetter],
                                           @"l": [NSValue valueWithPointer:(IMP)FFUDLongSetter],
                                           @"L": [NSValue valueWithPointer:(IMP)FFUDUnsignedLongSetter],
                                           @"q": [NSValue valueWithPointer:(IMP)FFUDIntegerSetter],
                                           @"Q": [NSValue valueWithPointer:(IMP)FFUDUnsignedIntegerSetter]};
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
