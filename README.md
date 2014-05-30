# FFUserDefaults
Ever worked with `NSUserDefaults` and tired of handling all the keys? Ever wanted to observe changes without listening to `NSUserDefaultsDidChangeNotification` and manually trying to figure out what has changed?
Then `FFUserDefaults` is the perfect library for you!

Just create a subclass of `FFUserDefaults` and define the properties you need. Then implement them as `@dynamic` and `FFUserDefaults` will do the rest.

## How does it work?
`FFUserDefaults` retrieves all `@dynamic` properties at runtime. It then creates accessors for these properties. The values are just stored in the `NSUserDefaults`. If you need `NSUserDefaults` other than `standardUserDefaults` you can just override the getter method `- (NSUserDefaults *)userDefaults;` in your subclass and return whatever `NSUserDefaults` you would like `FFUserDefaults` to use.

## What kind of properties can I use?
You can of course use any object property. Further the following primitive data types are supported:
- `BOOL`
- `double`
- `float`
- `char`
- `unsigned char`
- `short`
- `unsigned short`
- `int`
- `unsigned int`
- `long`
- `unsigned long`
- `long long`
- `unsigned long long`
- `NSInteger`
- `NSUInteger`

## Example

An example class would look like this.
`FFExampleSettings.h`:
````
#import <FFUserDefaults/FFUserDefaults.h>

@interface FFExampleSettings : FFUserDefaults

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSDate *reminderDate;
@property (nonatomic, getter = isReminderEnabled) BOOL reminderEnabled;

@end
````

`FFExampleSettings.m`:
````
#import "FFExampleSettings.h"

@implementation FFExampleSettings

@dynamic username;
@dynamic reminderDate;
@dynamic reminderEnabled;

@end
````

There's also a sample project.

## LICENSE
`FFUserDefaults` is licensed under MIT. For more information see the `LICENSE.md` file.