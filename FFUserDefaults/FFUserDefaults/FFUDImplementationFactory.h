//
//  FFUDImplementationFactory.h
//  FFUserDefaults
//
//  Created by Florian Friedrich on 27.05.14.
//  Copyright (c) 2014 Florian Friedrich. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FFUDProperty;
@interface FFUDImplementationFactory : NSObject

+ (IMP)getterForProperty:(FFUDProperty *)property;
+ (IMP)setterForProperty:(FFUDProperty *)property;

@end
