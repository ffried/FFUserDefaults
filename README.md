#FFUserDefaults
Ever worked with `NSUserDefaults` and tired of handling all the keys? Ever wanted to observe changes without listening to `NSUserDefaultsDidChangeNotification` and manually trying to figure out what has changed?
Then `FFUserDefaults` is the perfect library for you.

Just create a subclass of `FFUserDefaults` and define the properties you need. Then implement them as `@dynamic` and `FFUserDefaults` will do the rest.

##How does it work?
`FFUserDefaults` retrieves all `@dynamic` properties at runtime. It then creates accessors for these properties. The values are just stored in the `NSUserDefaults`. If you need `NSUserDefaults` other than `standardUserDefaults` you can just override the getter method `- (NSUserDefaults *)userDefaults;` in your subclass and return whatever `NSUserDefaults` you would like `FFUserDefaults` to use.

##What kind of properties can I use?
Right now only object properties are supported. Primitive data types aren’t yet supported. But I’m planning to add support for the most important of them as well.

##LICENSE
`FFUserDefaults` is under MIT License. For more information see the `LICENSE.md` file.
