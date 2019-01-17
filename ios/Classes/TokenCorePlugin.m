#import "TokenCorePlugin.h"
#import <token_core_plugin/token_core_plugin-Swift.h>

@implementation TokenCorePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTokenCorePlugin registerWithRegistrar:registrar];
}
@end
