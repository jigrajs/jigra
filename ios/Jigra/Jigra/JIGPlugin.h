#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@class JIGBridge;
@class JIGPluginCall;
@class JIGConfig;

@interface JIGPlugin : NSObject

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSString *pluginId;
@property (nonatomic, strong) NSString *pluginName;
@property (nonatomic, strong) JIGBridge *bridge;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<JIGPluginCall *>*> *eventListeners;
@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *retainedEventArguments;

- (instancetype) initWithBridge:(JIGBridge*) bridge pluginId:(NSString*) pluginId pluginName:(NSString*) pluginName;
- (void)addEventListener:(NSString *) eventName listener:(JIGPluginCall *)listener;
- (void)removeEventListener:(NSString *) eventName listener:(JIGPluginCall *)listener;
- (void)notifyListeners:(NSString *) eventName data:(NSDictionary<NSString *, id>*)data;
- (void)notifyListeners:(NSString *) eventName data:(NSDictionary<NSString *, id>*)data retainUntilConsumed:(BOOL)retain;
- (NSArray<JIGPluginCall *>*)getListeners:(NSString *)eventName;
- (BOOL)hasListeners:(NSString *)eventName;
- (void)addListener:(JIGPluginCall *)call;
- (void)removeListener:(JIGPluginCall *)call;
- (void)removeAllListeners:(JIGPluginCall *)call;
/**
 * Give the plugins a chance to take control when a URL is about to be loaded in the WebView.
 * Returning true causes the WebView to abort loading the URL.
 * Returning false causes the WebView to continue loading the URL.
 * Returning nil will defer to the default Jigra policy
 */
- (NSNumber *)shouldOverrideLoad:(WKNavigationAction *)navigationAction;

// Called after init if the plugin wants to do
// some loading so the plugin author doesn't
// need to override init()
-(void) load;
-(NSString *)getId;
-(BOOL)getBool:(JIGPluginCall*) call field:(NSString *)field defaultValue:(BOOL)defaultValue;
-(NSString *) getString:(JIGPluginCall *)call field:(NSString *)field defaultValue:(NSString *)defaultValue;
-(id)getConfigValue:(NSString *) key;
-(void)setCenteredPopover:(UIViewController *) vc;
-(BOOL)supportsPopover;

@end
