#import <Foundation/Foundation.h>



typedef struct WPTBXMLAttribute {
    char *name;
    char *value;
    struct WPTBXMLAttribute *next;
} WPTBXMLAttribute;

typedef struct WPTBXMLElement {
    char *name;
    char *text;
    WPTBXMLAttribute *firstAttribute;
    struct WPTBXMLElement *parentElement;
    struct WPTBXMLElement *firstChild;
    struct WPTBXMLElement *currentChild;
    struct WPTBXMLElement *nextSibling;
    struct WPTBXMLElement *previousSibling;
} WPTBXMLElement;

typedef struct WPTBXMLElementBuffer {
    WPTBXMLElement *elements;
    struct WPTBXMLElementBuffer *next;
    struct WPTBXMLElementBuffer *previous;
} WPTBXMLElementBuffer;

typedef struct WPTBXMLAttributeBuffer {
    WPTBXMLAttribute *attributes;
    struct WPTBXMLAttributeBuffer *next;
    struct WPTBXMLAttributeBuffer *previous;
} WPTBXMLAttributeBuffer;

@interface WPTBXML : NSObject {

@private
    WPTBXMLElement *rootXMLElement;
    WPTBXMLElementBuffer *currentElementBuffer;
    WPTBXMLAttributeBuffer *currentAttributeBuffer;
    long currentElement;
    long currentAttribute;
    char *bytes;
    long bytesLength;
}

@property(nonatomic, readonly) WPTBXMLElement *rootXMLElement;


+ (id)tbxmlWithURL:(NSURL *)aURL;

+ (id)tbxmlWithXMLString:(NSString *)aXMLString;

+ (id)tbxmlWithXMLData:(NSData *)aData;

- (id)initWithURL:(NSURL *)aURL;

- (id)initWithXMLString:(NSString *)aXMLString;

- (id)initWithXMLData:(NSData *)aData;

@end

@interface WPTBXML (StaticFunctions)

+ (NSString *)elementName:(WPTBXMLElement *)aXMLElement;

+ (NSString *)textForElement:(WPTBXMLElement *)aXMLElement;

+ (int)numberForElement:(WPTBXMLElement *)aXMLElement;

+ (BOOL)boolForElement:(WPTBXMLElement *)aXMLElement;

+ (int)negativeNumberForUnknownElement:(WPTBXMLElement *)aXMLElement;

+ (NSString *)valueOfAttributeNamed:(NSString *)aName forElement:(WPTBXMLElement *)aXMLElement;

+ (NSString *)attributeName:(WPTBXMLAttribute *)aXMLAttribute;

+ (NSString *)attributeValue:(WPTBXMLAttribute *)aXMLAttribute;

+ (WPTBXMLElement *)nextSiblingNamed:(NSString *)aName searchFromElement:(WPTBXMLElement *)aXMLElement;

+ (WPTBXMLElement *)childElementNamed:(NSString *)aName parentElement:(WPTBXMLElement *)aParentXMLElement;

@end
