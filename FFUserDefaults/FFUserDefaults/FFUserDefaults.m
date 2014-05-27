//
//  FFUserDefaults.m
//  FFUserDefaults
//
//  Created by Florian Friedrich on 18.5.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import "FFUserDefaults+Internal.h"
#import "FFUDProperty+Internal.h"
#import "FFUDImplementationFactory.h"
#import <objc/runtime.h>

extern FFUDProperty *FFUDPropertyForObjCProperty(objc_property_t property);
extern NSArray *FFUDPropertiesOfClass(Class class) {
    if (class == NULL) return nil;
    NSMutableArray *classProperties = [NSMutableArray array];
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(class, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        FFUDProperty *p = FFUDPropertyForObjCProperty(property);
        [classProperties addObject:p];
    }
    free(properties);
    return [NSArray arrayWithArray:classProperties];
}

@interface FFUserDefaults ()
@end

@implementation FFUserDefaults
static void *FFUDKVOContext = &FFUDKVOContext;
static NSString *const FFNSUDValuesPrefix = @""; // Just in case NSUserDefaults KVOing ever needs the values. prefix again, just put it here.

#pragma mark - Initializer
- (instancetype)initWithDefaults:(NSDictionary *)defaults
{
    self = [super init];
    if (self) {
        if (defaults) {
            [self.userDefaults registerDefaults:defaults];
        }
        [self setupObservers];
        [[[self class] dynamicProperties] enumerateObjectsUsingBlock:^(FFUDProperty *property, NSUInteger idx, BOOL *stop) {
            [[self class] resolveInstanceMethod:NSSelectorFromString(property.getter)];
            [[self class] resolveInstanceMethod:NSSelectorFromString(property.setter)];
        }];
//        NSLog(@"Properties of %@:\n%@", NSStringFromClass([self class]), [[self class] dynamicProperties]);
    }
    return self;
}

- (instancetype)init { return [self initWithDefaults:nil]; }

- (void)dealloc
{
    [self tearDownObservers];
}

#pragma mark - Method handling
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    NSArray *dynamicProperties = [self dynamicProperties];
    NSArray *getters = [self dynamicGetters];
    if ([getters containsObject:NSStringFromSelector(sel)]) {
        FFUDProperty *prop = dynamicProperties[[getters indexOfObject:NSStringFromSelector(sel)]];
        NSString *type = prop.getterFormat;
        IMP implementation = [FFUDImplementationFactory getterForProperty:prop];
        if (implementation == NULL) return [super resolveInstanceMethod:sel]; // TODO: Better handling
        class_addMethod(self, sel, implementation, [type UTF8String]);
        return YES;
    }
    NSArray *setters = [self dynamicSetters];
    if ([setters containsObject:NSStringFromSelector(sel)]) {
        FFUDProperty *prop = dynamicProperties[[setters indexOfObject:NSStringFromSelector(sel)]];
        NSString *type = prop.setterFormat;
        IMP implementation = [FFUDImplementationFactory setterForProperty:prop];
        if (implementation == NULL) return [super resolveInstanceMethod:sel]; // TODO: Better handling
        class_addMethod(self, sel, implementation, [type UTF8String]);
        return YES;
    }
    
    return [super resolveInstanceMethod:sel];
}

#pragma mark - Class Properties
+ (NSArray *)properties
{
    static NSMutableDictionary *FFUDClassProperties = nil;
    if (!FFUDClassProperties) {
        FFUDClassProperties = [NSMutableDictionary dictionary];
    }
    NSArray *properties = FFUDClassProperties[NSStringFromClass(self)];
    if (!properties) {
        properties = FFUDPropertiesOfClass(self);
        FFUDClassProperties[NSStringFromClass(self)] = properties;
    }
    return properties;
}

+ (NSArray *)dynamicProperties
{
    static NSMutableDictionary *FFUDDynamicClassProperties = nil;
    if (!FFUDDynamicClassProperties) {
        FFUDDynamicClassProperties = [NSMutableDictionary dictionary];
    }
    NSArray *dynamicProperties = FFUDDynamicClassProperties[NSStringFromClass(self)];
    if (!dynamicProperties) {
        NSArray *properties = [self properties];
        NSPredicate *dynamicPredicate = [NSPredicate predicateWithFormat:@"self.dynamic == YES"];
        dynamicProperties = [properties filteredArrayUsingPredicate:dynamicPredicate];
        FFUDDynamicClassProperties[NSStringFromClass(self)] = dynamicProperties;
    }
    return dynamicProperties;
}

+ (NSArray *)dynamicGetters
{
    static NSMutableDictionary *FFUDDynamicClassGetters = nil;
    if (!FFUDDynamicClassGetters) {
        FFUDDynamicClassGetters = [NSMutableDictionary dictionary];
    }
    NSArray *getters = FFUDDynamicClassGetters[NSStringFromClass(self)];
    if (!getters) {
        NSArray *dynamic = [self dynamicProperties];
        NSMutableArray *m_getters = [NSMutableArray array];
        [dynamic enumerateObjectsUsingBlock:^(FFUDProperty *p, NSUInteger idx, BOOL *stop) {
            [m_getters addObject:p.getter];
        }];
        getters = [NSArray arrayWithArray:m_getters];
        FFUDDynamicClassGetters[NSStringFromClass(self)] = getters;
    }
    return getters;
}

+ (NSArray *)dynamicSetters
{
    static NSMutableDictionary *FFUDDynamicClassSetters = nil;
    if (!FFUDDynamicClassSetters) {
        FFUDDynamicClassSetters = [NSMutableDictionary dictionary];
    }
    NSArray *setters = FFUDDynamicClassSetters[NSStringFromClass(self)];
    if (!setters) {
        NSArray *dynamic = [self dynamicProperties];
        NSMutableArray *m_setters = [NSMutableArray array];
        [dynamic enumerateObjectsUsingBlock:^(FFUDProperty *p, NSUInteger idx, BOOL *stop) {
            [m_setters addObject:p.setter];
        }];
        setters = [NSArray arrayWithArray:m_setters];
    }
    return setters;
}

#pragma mark - Properties
- (NSUserDefaults *)userDefaults
{
    return [NSUserDefaults standardUserDefaults];
}

#pragma mark - KVO
- (void)setupObservers
{
    NSUserDefaults *userDefaults = self.userDefaults;
    NSArray *properties = [[self class] dynamicProperties];
    [properties enumerateObjectsUsingBlock:^(FFUDProperty *property, NSUInteger idx, BOOL *stop) {
        NSString *key = FFUDKeyForPropertyName(property.name);
        NSString *keyPath = [FFNSUDValuesPrefix stringByAppendingString:key];
        [userDefaults addObserver:self forKeyPath:keyPath
                          options:NSKeyValueObservingOptionNew
                          context:FFUDKVOContext];
    }];
}

- (void)tearDownObservers
{
    NSUserDefaults *userDefaults = self.userDefaults;
    NSArray *properties = [[self class] dynamicProperties];
    [properties enumerateObjectsUsingBlock:^(FFUDProperty *property, NSUInteger idx, BOOL *stop) {
        NSString *key = FFUDKeyForPropertyName(property.name);
        NSString *keyPath = [FFNSUDValuesPrefix stringByAppendingString:key];
        [userDefaults removeObserver:self forKeyPath:keyPath context:FFUDKVOContext];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    if (context == FFUDKVOContext) {
        if (object == self.userDefaults) {
            NSString *key = [keyPath substringFromIndex:FFNSUDValuesPrefix.length];
            key = FFUDPropertyNameForUDKey(key);
            [self willChangeValueForKey:key];
            [self didChangeValueForKey:key];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
