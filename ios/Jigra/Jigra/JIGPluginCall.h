
@interface JIGPluginCallResult : NSObject

@property (nonatomic, strong) NSDictionary<NSString *, id>* data;

- (instancetype)init:(NSDictionary<NSString *, id>*)data;

@end

@interface JIGPluginCallError : NSObject

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSDictionary<NSString *, id> *data;

- (instancetype)initWithMessage:(NSString *)message code:(NSString *)code error:(NSError *)error data:(NSDictionary<NSString *, id>*)data;

@end

@class JIGPluginCall;

typedef void(^JIGPluginCallSuccessHandler)(JIGPluginCallResult *result, JIGPluginCall* call);
typedef void(^JIGPluginCallErrorHandler)(JIGPluginCallError *error);

@interface JIGPluginCall : NSObject

@property (nonatomic, assign) BOOL isSaved;
@property (nonatomic, strong) NSString *callbackId;
@property (nonatomic, strong) NSDictionary *options;
@property (nonatomic, copy) JIGPluginCallSuccessHandler successHandler;
@property (nonatomic, copy) JIGPluginCallErrorHandler errorHandler;

- (instancetype)initWithCallbackId:(NSString *)callbackId options:(NSDictionary *)options success:(JIGPluginCallSuccessHandler)success error:(JIGPluginCallErrorHandler)error;

- (void)save;
@end


