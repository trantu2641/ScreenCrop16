#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static BOOL SCEnabled(void) {
    NSString *version = UIDevice.currentDevice.systemVersion;
    if (![version hasPrefix:@"16.4"]) {
        return NO;
    }

    NSNumber *value = [[NSUserDefaults standardUserDefaults]
        objectForKey:@"SC16Enabled"];

    return value ? value.boolValue : YES;
}

%hook UIScreen

- (CGFloat)_displayCornerRadius {
    if (SCEnabled()) {
        return 0.0;
    }

    return %orig;
}

- (UIEdgeInsets)_sceneSafeAreaInsets {
    if (SCEnabled()) {
        return UIEdgeInsetsZero;
    }

    return %orig;
}

%end


%hook UITraitCollection

- (CGFloat)displayCornerRadius {
    if (SCEnabled()) {
        return 0.0;
    }

    return %orig;
}

- (CGFloat)_displayCornerRadius {
    if (SCEnabled()) {
        return 0.0;
    }

    return %orig;
}

+ (instancetype)traitCollectionWithDisplayCornerRadius:(CGFloat)radius {
    if (SCEnabled()) {
        return %orig(0.0);
    }

    return %orig(radius);
}

%end


%ctor {
    @autoreleasepool {
        if (SCEnabled()) {
            NSLog(@"[ScreenCrop16] iOS 16.4 loaded");
        }
    }
}
