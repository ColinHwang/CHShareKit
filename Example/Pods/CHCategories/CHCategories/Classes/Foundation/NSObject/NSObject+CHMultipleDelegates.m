//
//  NSObject+CHMultipleDelegates.m
//  CHCategories
//
//  Created by CHwang on 2018/6/2.
//

#import "NSObject+CHMultipleDelegates.h"
#import "NSObject+CHBase.h"
#import "NSPointerArray+CHBase.h"
#import <objc/runtime.h>

@interface NSObject ()

@property (nonatomic, assign) BOOL _ch_delegatesSelf; ///< 是否代理为自身(self.delegate = self)

@end


/**
 NSObject类属性信息
 */
@interface CHNSObjectClassPropertyInfo : NSObject

@property (nonatomic, readonly) objc_property_t property;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) BOOL isWeak;
@property (nonatomic, readonly) BOOL isStrong;

- (instancetype)initWithProperty:(objc_property_t)property;

@end

@implementation CHNSObjectClassPropertyInfo

- (instancetype)initWithProperty:(objc_property_t)property {
    if (!property) return nil;
    
    self = [super init];
    _property = property;
    const char *name = property_getName(property);
    if (name) {
        _name = [NSString stringWithUTF8String:name];
    }
    
    char *isStrongAttributeValue = property_copyAttributeValue(property, "&");
    char *isWeakAttributeValue = property_copyAttributeValue(property, "W");
    _isStrong = isStrongAttributeValue != NULL;
    _isWeak = isWeakAttributeValue != NULL;
    if (isStrongAttributeValue != NULL) {
        free(isStrongAttributeValue);
    }
    if (isWeakAttributeValue != NULL) {
        free(isWeakAttributeValue);
    }
    return self;
}

@end


/**
 代理容器类
 */
@interface CHNSObjectMultipleDelegates : NSObject

@property (nonatomic, strong) NSPointerArray *delegates;;
@property (nonatomic, weak) NSObject *parentObject;

+ (instancetype)weakDelegates;
+ (instancetype)strongDelegates;

- (void)addDelegate:(id)delegate;
- (BOOL)removeDelegate:(id)delegate;
- (void)removeAllDelegates;

@end

@implementation CHNSObjectMultipleDelegates

+ (instancetype)weakDelegates {
    CHNSObjectMultipleDelegates *delegates = [[CHNSObjectMultipleDelegates alloc] init];
    delegates.delegates = [NSPointerArray weakObjectsPointerArray];
    return delegates;
}

+ (instancetype)strongDelegates {
    CHNSObjectMultipleDelegates *delegates = [[CHNSObjectMultipleDelegates alloc] init];
    delegates.delegates = [NSPointerArray strongObjectsPointerArray];
    return delegates;
}

- (void)addDelegate:(id)delegate {
    if (![self containsDelegate:delegate] && delegate != self) {
        [self.delegates addPointer:(__bridge void *)delegate];
    }
}

- (BOOL)removeDelegate:(id)delegate {
    NSUInteger index = [self.delegates ch_indexOfPointer:(__bridge void *)delegate];
    if (index != NSNotFound) {
        [self.delegates removePointerAtIndex:index];
        return YES;
    }
    return NO;
}

- (void)removeAllDelegates {
    for (NSInteger i = self.delegates.count - 1; i >= 0; i--) {
        [self.delegates removePointerAtIndex:i];
    }
}

- (BOOL)containsDelegate:(id)delegate {
    return [self.delegates ch_containsPointer:(__bridge void *)delegate];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *result = [super methodSignatureForSelector:aSelector];
    if (result) return result;
    
    NSPointerArray *delegates = [self.delegates copy];
    for (id delegate in delegates) {
        result = [delegate methodSignatureForSelector:aSelector];
        if (result && [delegate respondsToSelector:aSelector]) return result;
    }
    // https://github.com/facebookarchive/AsyncDisplayKit/pull/1562
    // Unfortunately, in order to get this object to work properly, the use of a method which creates an NSMethodSignature
    // from a C string. -methodSignatureForSelector is called when a compiled definition for the selector cannot be found.
    // This is the place where we have to create our own dud NSMethodSignature. This is necessary because if this method
    // returns nil, a selector not found exception is raised. The string argument to -signatureWithObjCTypes: outlines
    // the return type and arguments to the message. To return a dud NSMethodSignature, pretty much any signature will
    // suffice. Since the -forwardInvocation call will do nothing if the delegate does not respond to the selector,
    // the dud NSMethodSignature simply gets us around the exception.
    return [NSMethodSignature signatureWithObjCTypes:"@^v^c"];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL selector = anInvocation.selector;
    NSPointerArray *delegates = [self.delegates copy];
    for (id delegate in delegates) {
        if ([delegate respondsToSelector:selector]) {
            [anInvocation invokeWithTarget:delegate];
        }
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([super respondsToSelector:aSelector]) return YES;
    
    NSPointerArray *delegates = [self.delegates copy];
    for (id delegate in delegates) {
        if (class_respondsToSelector(self.class, aSelector)) return YES;
        
        // 处理delegate为CHNSObjectMultipleDelegates情况
        BOOL delegateCanRespondToSelector = [delegate isKindOfClass:self.class] ? [delegate respondsToSelector:aSelector] : class_respondsToSelector(((NSObject *)delegate).class, aSelector);
        
        // 处理obj.delegate = self情况
        BOOL isDelegateSelf = ((NSObject *)delegate)._ch_delegatesSelf;
        
        if (delegateCanRespondToSelector && !isDelegateSelf) return YES;
    }
    return NO;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@, parentObject is %@, %@", [super description], self.parentObject, self.delegates];
}

- (NSPointerArray *)delegates {
    if (!_delegates) {
        _delegates = [NSPointerArray weakObjectsPointerArray];
    }
    return _delegates;
}

@end


static const int CH_NS_OBJECT_DELEGATES_KEY;
static const int CH_NS_OBJECT_MULTIPLE_DELEGATES_ENABLED_KEY;
static const int CH_NS_OBJECT_DELEGATES_SELF_KEY;
static NSMutableSet<NSString *> *_ch_methodsReplacedClasses;

@interface NSObject ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, CHNSObjectMultipleDelegates *> *_ch_delegates;

@end


@implementation NSObject (CHMultipleDelegates)

- (void)ch_registerDelegateSelector:(SEL)getter {
    if (!self.ch_multipleDelegatesEnabled) return;

    Class targetClass = [self class];
    SEL originDelegateSetter = [self _ch_originSetterWithGetter:getter];
    SEL newDelegateSetter = [self _ch_newSetterWithGetter:getter];
    Method originMethod = class_getInstanceMethod(targetClass, originDelegateSetter);
    if (!originMethod) return;

    // 为这个 selector 创建一个 CHNSObjectMultipleDelegates 容器
    NSString *delegateGetterKey = NSStringFromSelector(getter);
    if (!self._ch_delegates[delegateGetterKey]) {
        objc_property_t property = class_getProperty(self.class, delegateGetterKey.UTF8String);
        CHNSObjectClassPropertyInfo *propertyInfo = [[CHNSObjectClassPropertyInfo alloc] initWithProperty:property];
        // 处理strong修饰delegate
        if (propertyInfo.isStrong) {
            CHNSObjectMultipleDelegates *strongDelegates = [CHNSObjectMultipleDelegates strongDelegates];
            strongDelegates.parentObject = self;
            self._ch_delegates[delegateGetterKey] = strongDelegates;
        } else {
            CHNSObjectMultipleDelegates *weakDelegates = [CHNSObjectMultipleDelegates weakDelegates];
            weakDelegates.parentObject = self;
            self._ch_delegates[delegateGetterKey] = weakDelegates;
        }
    }

    // 避免为某个 class 重复替换同一个方法的实现
    if (!_ch_methodsReplacedClasses) {
        _ch_methodsReplacedClasses = [NSMutableSet set];
    }
    NSString *classAndMethodIdentifier = [NSString stringWithFormat:@"%@-%@", NSStringFromClass(targetClass), delegateGetterKey];
    if (![_ch_methodsReplacedClasses containsObject:classAndMethodIdentifier]) {
        [_ch_methodsReplacedClasses addObject:classAndMethodIdentifier];
        
        IMP originIMP = method_getImplementation(originMethod);
        void (*originSelectorIMP)(id, SEL, id);
        originSelectorIMP = (void (*)(id, SEL, id))originIMP;
        
        BOOL isAddedMethod = class_addMethod(targetClass, newDelegateSetter, imp_implementationWithBlock(^(NSObject *selfObject, id aDelegate) {
            // 处理替换方法导致父类及父类的所有子类都被替换
            if (!selfObject.ch_multipleDelegatesEnabled || selfObject.class != targetClass) {
                originSelectorIMP(selfObject, originDelegateSetter, aDelegate);
                return;
            }
            
            CHNSObjectMultipleDelegates *delegates = selfObject._ch_delegates[delegateGetterKey];
            if (!aDelegate) {
                // 对应 setDelegate:nil，表示清理所有的 delegate
                [delegates removeAllDelegates];
                selfObject._ch_delegatesSelf = NO;
                // 只要 multipleDelegatesEnabled 开启，就会保证 delegate 一直是 delegates，所以不去调用系统默认的 set nil
                return;
            }
            
            if (aDelegate != delegates) {
                // 过滤掉容器自身，避免把 delegates 传进去 delegates 里，导致死循环
                [delegates addDelegate:aDelegate];
            }
            
            // 将类似 textView.delegate = textView 的情况标志起来，避免产生循环调用
            selfObject._ch_delegatesSelf = [delegates.delegates ch_containsPointer:(__bridge void * _Nullable)(selfObject)];
            
            originSelectorIMP(selfObject, originDelegateSetter, nil);// 先置为 nil 再设置 delegates，从而避免这个问题 https://github.com/QMUI/QMUI_iOS/issues/305
            originSelectorIMP(selfObject, originDelegateSetter, delegates);// 不管外面将什么 object 传给 setDelegate:，最终实际上传进去的都是 QMUIMultipleDelegates 容器
        }), method_getTypeEncoding(originMethod));
        
        if (isAddedMethod) {
            Method newMethod = class_getInstanceMethod(targetClass, newDelegateSetter);
            method_exchangeImplementations(originMethod, newMethod);
        }
    }
    
    // 如果原来已经有 delegate，则将其加到新建的容器里, 处理已有值的 object 打开 qmui_multipleDelegatesEnabled 会导致原来的值丢失
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    id originDelegate = [self performSelector:getter];
    if (originDelegate && originDelegate != self._ch_delegates[delegateGetterKey]) {
        [self performSelector:originDelegateSetter withObject:originDelegate];
    }
#pragma clang diagnostic pop
}

- (void)ch_removeDelegate:(id)delegate {
    if (!self.ch_multipleDelegatesEnabled) return;
    
    NSMutableArray<NSString *> *delegateGetters = [[NSMutableArray alloc] init];
    [self._ch_delegates enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, CHNSObjectMultipleDelegates * _Nonnull obj, BOOL * _Nonnull stop) {
        BOOL removeSucceed = [obj removeDelegate:delegate];
        if (removeSucceed) {
            [delegateGetters addObject:key];
        }
    }];
    if (delegateGetters.count > 0) {
        for (NSString *getterString in delegateGetters) {
            [self _ch_refreshDelegateWithGetter:NSSelectorFromString(getterString)];
        }
    }
}

- (void)_ch_refreshDelegateWithGetter:(SEL)getter {
    SEL originSetterSEL = [self _ch_newSetterWithGetter:getter];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    id originDelegate = [self performSelector:getter];
    [self performSelector:originSetterSEL withObject:nil];// 先置为 nil 再设置 delegates，从而避免这个问题 https://github.com/QMUI/QMUI_iOS/issues/305
    [self performSelector:originSetterSEL withObject:originDelegate];
#pragma clang diagnostic pop
}

// 根据 delegate property 的 getter，得到它对应的 setter
- (SEL)_ch_originSetterWithGetter:(SEL)getter {
    NSString *getterString = NSStringFromSelector(getter);
    NSMutableString *setterString = [[NSMutableString alloc] initWithString:@"set"];
    [setterString appendString:[getterString substringToIndex:1].uppercaseString];
    [setterString appendString:[getterString substringFromIndex:1]];
    [setterString appendString:@":"];
    SEL setter = NSSelectorFromString(setterString);
    return setter;
}

// 根据 delegate property 的 getter，得到 CHNSObjectMultipleDelegates 为它的 setter 创建的新 setter 方法，最终交换原方法，因此利用这个方法返回的 SEL，可以调用到原来的 delegate property setter 的实现
- (SEL)_ch_newSetterWithGetter:(SEL)getter {
    return NSSelectorFromString([NSString stringWithFormat:@"_ch_%@", NSStringFromSelector([self _ch_originSetterWithGetter:getter])]);
}

- (void)_ch_setDelegates:(NSMutableDictionary<NSString *, CHNSObjectMultipleDelegates *> *)ch_delegates {
    [self ch_setAssociatedValue:ch_delegates withKey:&CH_NS_OBJECT_DELEGATES_KEY];
}

- (NSMutableDictionary<NSString *, CHNSObjectMultipleDelegates *> *)_ch_delegates {
    NSMutableDictionary *delegates = [self ch_getAssociatedValueForKey:&CH_NS_OBJECT_DELEGATES_KEY];
    if (!delegates) {
        delegates = @{}.mutableCopy;
        [self _ch_setDelegates:delegates];
    }
    return delegates;
}

- (void)setCh_multipleDelegatesEnabled:(BOOL)ch_multipleDelegatesEnabled {
    [self ch_setAssociatedValue:@(ch_multipleDelegatesEnabled) withKey:&CH_NS_OBJECT_MULTIPLE_DELEGATES_ENABLED_KEY];
    if (ch_multipleDelegatesEnabled) {
        [self ch_registerDelegateSelector:@selector(delegate)];
        if ([self isKindOfClass:NSClassFromString(@"UITableView")] || [self isKindOfClass:NSClassFromString(@"UICollectionView")]) {
            [self ch_registerDelegateSelector:@selector(dataSource)];
        }
    }
}

- (BOOL)ch_multipleDelegatesEnabled {
    return [[self ch_getAssociatedValueForKey:&CH_NS_OBJECT_MULTIPLE_DELEGATES_ENABLED_KEY] boolValue];
}

- (void)set_ch_delegatesSelf:(BOOL)_ch_delegatesSelf {
    [self ch_setAssociatedValue:@(_ch_delegatesSelf) withKey:&CH_NS_OBJECT_DELEGATES_SELF_KEY];
}

- (BOOL)_ch_delegatesSelf {
    return [[self ch_getAssociatedValueForKey:&CH_NS_OBJECT_DELEGATES_SELF_KEY] boolValue];
}

@end
