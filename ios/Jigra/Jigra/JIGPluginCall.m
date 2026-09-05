#import <Foundation/Foundation.h>

#import "JIGPluginCall.h"

@implementation JIGPluginCallResult
- (instancetype)init:(NSDictionary<NSString *, id>*)data {
  self.data = data;
  return self;
}
@end

@implementation JIGPluginCallError

- (instancetype)initWithMessage:(NSString *)message code:(NSString *) code error:(NSError *)error data:(NSDictionary<NSString *,id> *)data {
  self.message = message;
  self.code = code;
  self.error = error;
  self.data = data;
  return self;
}

@end

@implementation JIGPluginCall

- (instancetype)initWithCallbackId:(NSString *)callbackId options:(NSDictionary *)options success:(JIGPluginCallSuccessHandler) success error:(JIGPluginCallErrorHandler) error {
  self.callbackId = callbackId;
  self.options = options;
  self.successHandler = success;
  self.errorHandler = error;
  return self;
}

- (void)save {
  self.isSaved = true;
}

@end
