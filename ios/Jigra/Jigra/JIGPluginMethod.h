#import "JIGPluginCall.h"
#import "JIGPlugin.h"

typedef enum {
  JIGPluginMethodArgumentNotNullable,
  JIGPluginMethodArgumentNullable
} JIGPluginMethodArgumentNullability;

typedef NSString JIGPluginReturnType;

/**
 * Represents a single argument to a plugin method.
 */
@interface JIGPluginMethodArgument : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) JIGPluginMethodArgumentNullability nullability;

- (instancetype)initWithName:(NSString *)name nullability:(JIGPluginMethodArgumentNullability)nullability type:(NSString *)type;

@end

/**
 * Represents a method that a plugin supports, with the ability
 * to compute selectors and invoke the method.
 */
@interface JIGPluginMethod : NSObject

@property (nonatomic, assign) SEL selector;
@property (nonatomic, strong) NSString *name; // Raw method name
@property (nonatomic, strong) JIGPluginReturnType *returnType; // Return type of method (i.e. callback/promise/sync)

- (instancetype)initWithName:(NSString *)name returnType:(JIGPluginReturnType *)returnType;


@end
