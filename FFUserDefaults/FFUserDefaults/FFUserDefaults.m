//
//  FFUserDefaults.m
//  FFUserDefaults
//
//  Created by Florian Friedrich on 18.5.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import "FFUserDefaults.h"
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

- (instancetype)initWithDefaults:(NSDictionary *)defaults
{
    self = [super init];
    if (self) {
        if (defaults) {
            [self.userDefaults registerDefaults:defaults];
        }
        //        self.properties = FFUDPropertiesOfClass([self class]);
        NSLog(@"Properties of %@:\n%@", NSStringFromClass([self class]), [[self class] dynamicProperties]);
        [self setupObservers];
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
    NSLog(@"%@%@", NSStringFromSelector(_cmd), NSStringFromSelector(sel));
    
    NSArray *dynamicProperties = [self dynamicProperties];
    NSArray *getters = [dynamicProperties valueForKey:@"getter"];
    if ([getters containsObject:NSStringFromSelector(sel)]) {
        FFUDProperty *prop = dynamicProperties[[getters indexOfObject:NSStringFromSelector(sel)]];
        NSString *type = [prop.shortType stringByAppendingString:@"@:"];
        IMP implementation = [FFUDImplementationFactory getterForProperty:prop];
        if (implementation == NULL) return NO; // TODO: Better handling
        class_addMethod(self, sel, implementation, [type UTF8String]);
        return YES;
    }
    NSArray *setters = [dynamicProperties valueForKey:@"setter"];
    if ([setters containsObject:NSStringFromSelector(sel)]) {
        FFUDProperty *prop = dynamicProperties[[setters indexOfObject:NSStringFromSelector(sel)]];
        NSString *type = [@"v@:" stringByAppendingString:prop.shortType];
        IMP implementation = [FFUDImplementationFactory setterForProperty:prop];
        if (implementation == NULL) return NO; // TODO: Better handling
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

#pragma mark - Properties
- (NSUserDefaults *)userDefaults
{
    return [NSUserDefaults standardUserDefaults];
}

#pragma mark - KVO
- (void)setupObservers
{
    NSUserDefaults *userDefaults = self.userDefaults;
    NSArray *keys = [[[self class] dynamicProperties] valueForKey:@"name"];
    [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        NSString *keyPath = [@"values." stringByAppendingString:key];
        [userDefaults addObserver:self forKeyPath:keyPath
                          options:(NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew)
                          context:FFUDKVOContext];
    }];
}

- (void)tearDownObservers
{
    NSUserDefaults *userDefaults = self.userDefaults;
    NSArray *keys = [[[self class] dynamicProperties] valueForKey:@"name"];
    [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        NSString *keyPath = [@"values." stringByAppendingString:key];
        [userDefaults removeObserver:self forKeyPath:keyPath context:FFUDKVOContext];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    if (context == FFUDKVOContext) {
        if (object == self.userDefaults) {
            NSString *key = [keyPath substringFromIndex:@"values.".length];
            [self willChangeValueForKey:key];
            [self didChangeValueForKey:key];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
