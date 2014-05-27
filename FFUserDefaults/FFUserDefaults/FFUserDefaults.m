//
//  FFUserDefaults.m
//  FFUserDefaults
//
//  Created by Florian Friedrich on 18.5.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import "FFUserDefaults.h"
#import <objc/runtime.h>

@interface FFUDProperty : NSObject <NSSecureCoding>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *shortType;
@property (nonatomic, strong) NSString *fullType;
@property (nonatomic, getter = isPrimitive) BOOL primitive;
@property (nonatomic, strong) NSString *instanceVariable;
@property (nonatomic, strong) NSString *getter;
@property (nonatomic, strong) NSString *setter;
@property (nonatomic, getter = isReadonly) BOOL readonly;
@property (nonatomic, getter = isNonatomic) BOOL nonatomic;
@property (nonatomic, getter = isDynamic) BOOL dynamic;
@property (nonatomic, getter = isCopy) BOOL copy;
@property (nonatomic, getter = isWeak) BOOL weak;
@property (nonatomic, getter = isStrong) BOOL strong;
@property (nonatomic, strong, readonly) NSString *userDefaultsKey;
+ (NSString *)fullTypeForPrimitiveShortType:(NSString *)type;
@end

@implementation FFUDProperty
+ (NSString *)fullTypeForPrimitiveShortType:(NSString *)type
{
    return @{@"c": @"char",
             @"d": @"double",
             @"i": @"int",
             @"f": @"float",
             @"l": @"long",
             @"s": @"short",
             @"B": @"bool",
             @"I": @"unsigned",
             @"Q": @"unsignedInteger"
             }[type];
//    @{@"^?": @"function pointer",
//      @"^v", @"void pointer"};
}

#pragma mark - NSSecureCoding
+ (BOOL)supportsSecureCoding { return YES; }

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        self.name = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"name"];
        self.fullType = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"fullType"];
        self.shortType = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"shortType"];
        self.primitive = [aDecoder decodeBoolForKey:@"primitive"];
        self.instanceVariable = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"instanceVariable"];
        self.getter = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"getter"];
        self.setter = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"setter"];
        self.readonly = [aDecoder decodeBoolForKey:@"readonly"];
        self.nonatomic = [aDecoder decodeBoolForKey:@"nonatomic"];
        self.dynamic = [aDecoder decodeBoolForKey:@"dynamic"];
        self.copy = [aDecoder decodeBoolForKey:@"copy"];
        self.weak = [aDecoder decodeBoolForKey:@"weak"];
        self.strong = [aDecoder decodeBoolForKey:@"strong"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.fullType forKey:@"fullType"];
    [aCoder encodeObject:self.shortType forKey:@"shortType"];
    [aCoder encodeBool:self.primitive forKey:@"primitive"];
    [aCoder encodeObject:self.instanceVariable forKey:@"instanceVariable"];
    [aCoder encodeObject:self.getter forKey:@"getter"];
    [aCoder encodeObject:self.setter forKey:@"setter"];
    [aCoder encodeBool:self.readonly forKey:@"readonly"];
    [aCoder encodeBool:self.nonatomic forKey:@"nonatomic"];
    [aCoder encodeBool:self.dynamic forKey:@"dynamic"];
    [aCoder encodeBool:self.copy forKey:@"copy"];
    [aCoder encodeBool:self.weak forKey:@"weak"];
    [aCoder encodeBool:self.strong forKey:@"strong"];
}

#pragma mark - NSObject
- (NSString *)description
{
    NSString *(^StringFromBOOL)(BOOL b) = ^NSString *(BOOL b) {
        return (b) ? @"YES" : @"NO";
    };
    NSMutableString *desc = [NSMutableString string];
    [desc appendFormat:@"<%@ %p> {", NSStringFromClass([self class]), self];
    [desc appendFormat:@"%@ %@ (%@):\r", self.name, self.fullType, self.shortType];
    [desc appendFormat:@"    - instance variable: %@\r", self.instanceVariable];
    [desc appendFormat:@"    - getter: %@\r", self.getter];
    [desc appendFormat:@"    - setter: %@\r", self.setter];
    [desc appendFormat:@"    - readonly: %@\r", StringFromBOOL(self.isReadonly)];
    [desc appendFormat:@"    - nonatomic: %@\r", StringFromBOOL(self.isNonatomic)];
    [desc appendFormat:@"    - dynamic: %@\r", StringFromBOOL(self.isDynamic)];
    [desc appendFormat:@"    - copy: %@\r", StringFromBOOL(self.isCopy)];
    [desc appendFormat:@"    - weak: %@\r", StringFromBOOL(self.isWeak)];
    [desc appendFormat:@"    - strong: %@\r}", StringFromBOOL(self.isStrong)];
    return [desc copy];
}

- (NSUInteger)hash
{
    return self.name.hash ^ self.fullType.hash ^ self.shortType.hash;
}

- (BOOL)isEqual:(id)object
{
    if (!object) return NO;
    if (![object isKindOfClass:[self class]]) return NO;
    __typeof(self) obj = object;
    return [obj.name isEqualToString:self.name] &&
    [obj.shortType isEqualToString:self.shortType] &&
    [obj.fullType isEqualToString:self.fullType];
}

#pragma mark - Properties
- (NSString *)getter
{
    if (!_getter) {
        _getter = [self.name copy];
    }
    return _getter;
}

- (NSString *)setter
{
    if (!_setter) {
        _setter = [NSString stringWithFormat:@"set%@:", [self.name capitalizedString]];
    }
    return _setter;
}

- (NSString *)userDefaultsKey
{
    NSString *capitalizedName = [self.name capitalizedString];
    NSString *prefix = @"FFUD";
    NSString *key = [prefix stringByAppendingString:capitalizedName];
    return key;
}

@end

extern FFUDProperty *FFUDPropertyForObjCProperty(objc_property_t property) {
    FFUDProperty *prop = [[FFUDProperty alloc] init];
    prop.name = [NSString stringWithUTF8String:property_getName(property)];
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    printf("attributes=%s\n", attributes);
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T') {
            if (attribute[1] != '@') {
                // it's a C primitive type:
                const char *type = [[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
                prop.shortType = [NSString stringWithUTF8String:type];
                prop.fullType = [FFUDProperty fullTypeForPrimitiveShortType:prop.shortType];
                prop.primitive = YES;
            } else if (attribute[1] == '@' && strlen(attribute) == 2) {
                // it's an ObjC id type:
                prop.shortType = @"id";
                prop.fullType = @"id";
            } else if (attribute[1] == '@') {
                // it's another ObjC object type:
                const char *type = (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
                prop.shortType = [NSString stringWithUTF8String:type];
                prop.fullType = [NSString stringWithUTF8String:type];
            }
        } else if (attribute[0] == 'V') { // Instance Variable
            prop.instanceVariable = [NSString stringWithUTF8String:(const char *)[[NSData dataWithBytes:(attribute + 1)
                                                                                                 length:strlen(attribute) - 1] bytes]];
        } else if (attribute[0] == 'R') { // Readonly
            prop.readonly = YES;
        } else if (attribute[0] == 'N') { // Nonatomic
            prop.nonatomic = YES;
        } else if (attribute[0] == 'D') { // Dynamic
            prop.dynamic = YES;
        } else if (attribute[0] == 'G') { // Getter
            prop.getter = [NSString stringWithUTF8String:(const char *)[[NSData dataWithBytes:(attribute + 1)
                                                                                       length:strlen(attribute) - 1] bytes]];
        } else if (attribute[0] == 'S') { // Setter
            prop.setter = [NSString stringWithUTF8String:(const char *)[[NSData dataWithBytes:(attribute + 1)
                                                                                       length:strlen(attribute) - 1] bytes]];
        } else if (attribute[0] == 'C') { // Copy
            prop.copy = YES;
        } else if (attribute[0] == '&') { // Strong
            prop.strong = YES;
        } else if (attribute[0] == 'W') { // Weak
            prop.weak = YES;
        }
    }
    return prop;
}

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

+ (instancetype)sharedFactory
{
    static id SharedFactory = nil;
    static dispatch_once_t SharedFactoryToken;
    dispatch_once(&SharedFactoryToken, ^{ SharedFactory = [[self alloc] init]; });
    return SharedFactory;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.properties = FFUDPropertiesOfClass([self class]);
        NSLog(@"Properties of %@:\n%@", NSStringFromClass([self class]), [[self class] dynamicProperties]);
        [self setupObservers];
    }
    return self;
}

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
        return YES;
    }
    NSArray *setters = [dynamicProperties valueForKey:@"setter"];
    if ([setters containsObject:NSStringFromSelector(sel)]) {
        return YES;
    }
    
    return [super resolveInstanceMethod:sel];
}

id userDefaultsGetter(FFUserDefaults *self, SEL _cmd) {
    NSArray *dynamicProperties = [[self class] dynamicProperties];
    NSArray *getters = [dynamicProperties valueForKey:@"getter"];
    NSUInteger idx = [getters indexOfObject:NSStringFromSelector(_cmd)];
    FFUDProperty *property = dynamicProperties[idx];
    return [self.userDefaults objectForKey:property.userDefaultsKey];
}

void userDefaultsSetter(FFUserDefaults *self, SEL _cmd, id newValue) {
    NSArray *dynamicProperties = [[self class] dynamicProperties];
    NSArray *setters = [dynamicProperties valueForKey:@"setter"];
    NSUInteger idx = [setters indexOfObject:NSStringFromSelector(_cmd)];
    FFUDProperty *property = dynamicProperties[idx];
    [self.userDefaults setObject:newValue forKey:property.userDefaultsKey];
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
    NSUserDefaults *userDefaults = self.userDefaults; //[[self class ] userDefaults];
    NSArray *keys = [[[self class] properties] valueForKey:@"name"];
    [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        NSString *keyPath = [@"values." stringByAppendingString:key];
        [userDefaults addObserver:self forKeyPath:keyPath
                          options:(NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew)
                          context:FFUDKVOContext];
    }];
}

- (void)tearDownObservers
{
    NSUserDefaults *userDefaults = self.userDefaults; //[[self class ] userDefaults];
    NSArray *keys = [[[self class] properties] valueForKey:@"name"];
    [keys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        NSString *keyPath = [@"values." stringByAppendingString:key];
        [userDefaults removeObserver:self forKeyPath:keyPath context:FFUDKVOContext];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    if (context == FFUDKVOContext) {
        if (object == self.userDefaults /*[[self class ] userDefaults]*/) {
            NSString *key = [keyPath substringFromIndex:@"values.".length];
            [self willChangeValueForKey:key];
            [self didChangeValueForKey:key];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
