{$mode objfpc}
{$modeswitch objectivec1}
program IvarSize;
uses
 objcrtl,objcrtlmacosx,CocoaAll;
type
 TDerivedNSAffineTransform = objcclass (NSAffineTransform)
 extraptr: pointer
;end;
type
 TDerivedNSAppleEventDescriptor = objcclass (NSAppleEventDescriptor)
 extraptr: pointer
;end;
type
 TDerivedNSAppleEventManager = objcclass (NSAppleEventManager)
 extraptr: pointer
;end;
type
 TDerivedNSAppleScript = objcclass (NSAppleScript)
 extraptr: pointer
;end;
type
 TDerivedNSArchiver = objcclass (NSArchiver)
 extraptr: pointer
;end;
type
 TDerivedNSUnarchiver = objcclass (NSUnarchiver)
 extraptr: pointer
;end;
type
 TDerivedNSArray = objcclass (NSArray)
 extraptr: pointer
;end;
type
 TDerivedNSMutableArray = objcclass (NSMutableArray)
 extraptr: pointer
;end;
type
 TDerivedNSAttributedString = objcclass (NSAttributedString)
 extraptr: pointer
;end;
type
 TDerivedNSMutableAttributedString = objcclass (NSMutableAttributedString)
 extraptr: pointer
;end;
type
 TDerivedNSAutoreleasePool = objcclass (NSAutoreleasePool)
 extraptr: pointer
;end;
type
 TDerivedNSBundle = objcclass (NSBundle)
 extraptr: pointer
;end;
type
 TDerivedNSCalendar = objcclass (NSCalendar)
 extraptr: pointer
;end;
type
 TDerivedNSDateComponents = objcclass (NSDateComponents)
 extraptr: pointer
;end;
type
 TDerivedNSCalendarDate = objcclass (NSCalendarDate)
 extraptr: pointer
;end;
type
 TDerivedNSCharacterSet = objcclass (NSCharacterSet)
 extraptr: pointer
;end;
type
 TDerivedNSMutableCharacterSet = objcclass (NSMutableCharacterSet)
 extraptr: pointer
;end;
type
 TDerivedNSClassDescription = objcclass (NSClassDescription)
 extraptr: pointer
;end;
type
 TDerivedNSCoder = objcclass (NSCoder)
 extraptr: pointer
;end;
type
 TDerivedNSComparisonPredicate = objcclass (NSComparisonPredicate)
 extraptr: pointer
;end;
type
 TDerivedNSCompoundPredicate = objcclass (NSCompoundPredicate)
 extraptr: pointer
;end;
type
 TDerivedNSConnection = objcclass (NSConnection)
 extraptr: pointer
;end;
type
 TDerivedNSDistantObjectRequest = objcclass (NSDistantObjectRequest)
 extraptr: pointer
;end;
type
 TDerivedNSData = objcclass (NSData)
 extraptr: pointer
;end;
type
 TDerivedNSMutableData = objcclass (NSMutableData)
 extraptr: pointer
;end;
type
 TDerivedNSDate = objcclass (NSDate)
 extraptr: pointer
;end;
type
 TDerivedNSDateFormatter = objcclass (NSDateFormatter)
 extraptr: pointer
;end;
type
 TDerivedNSDecimalNumber = objcclass (NSDecimalNumber)
 extraptr: pointer
;end;
type
 TDerivedNSDecimalNumberHandler = objcclass (NSDecimalNumberHandler)
 extraptr: pointer
;end;
type
 TDerivedNSDictionary = objcclass (NSDictionary)
 extraptr: pointer
;end;
type
 TDerivedNSMutableDictionary = objcclass (NSMutableDictionary)
 extraptr: pointer
;end;
type
 TDerivedNSDistantObject = objcclass (NSDistantObject)
 extraptr: pointer
;end;
type
 TDerivedNSDistributedLock = objcclass (NSDistributedLock)
 extraptr: pointer
;end;
type
 TDerivedNSDistributedNotificationCenter = objcclass (NSDistributedNotificationCenter)
 extraptr: pointer
;end;
type
 TDerivedNSEnumerator = objcclass (NSEnumerator)
 extraptr: pointer
;end;
type
 TDerivedNSError = objcclass (NSError)
 extraptr: pointer
;end;
type
 TDerivedNSException = objcclass (NSException)
 extraptr: pointer
;end;
type
 TDerivedNSAssertionHandler = objcclass (NSAssertionHandler)
 extraptr: pointer
;end;
type
 TDerivedNSExpression = objcclass (NSExpression)
 extraptr: pointer
;end;
type
 TDerivedNSFileHandle = objcclass (NSFileHandle)
 extraptr: pointer
;end;
type
 TDerivedNSPipe = objcclass (NSPipe)
 extraptr: pointer
;end;
type
 TDerivedNSFileManager = objcclass (NSFileManager)
 extraptr: pointer
;end;
type
 TDerivedNSDirectoryEnumerator = objcclass (NSDirectoryEnumerator)
 extraptr: pointer
;end;
type
 TDerivedNSFormatter = objcclass (NSFormatter)
 extraptr: pointer
;end;
type
 TDerivedNSGarbageCollector = objcclass (NSGarbageCollector)
 extraptr: pointer
;end;
type
 TDerivedNSHashTable = objcclass (NSHashTable)
 extraptr: pointer
;end;
type
 TDerivedNSHost = objcclass (NSHost)
 extraptr: pointer
;end;
type
 TDerivedNSHTTPCookie = objcclass (NSHTTPCookie)
 extraptr: pointer
;end;
type
 TDerivedNSHTTPCookieStorage = objcclass (NSHTTPCookieStorage)
 extraptr: pointer
;end;
type
 TDerivedNSIndexPath = objcclass (NSIndexPath)
 extraptr: pointer
;end;
type
 TDerivedNSIndexSet = objcclass (NSIndexSet)
 extraptr: pointer
;end;
type
 TDerivedNSMutableIndexSet = objcclass (NSMutableIndexSet)
 extraptr: pointer
;end;
type
 TDerivedNSKeyedArchiver = objcclass (NSKeyedArchiver)
 extraptr: pointer
;end;
type
 TDerivedNSKeyedUnarchiver = objcclass (NSKeyedUnarchiver)
 extraptr: pointer
;end;
type
 TDerivedNSLocale = objcclass (NSLocale)
 extraptr: pointer
;end;
type
 TDerivedNSLock = objcclass (NSLock)
 extraptr: pointer
;end;
type
 TDerivedNSConditionLock = objcclass (NSConditionLock)
 extraptr: pointer
;end;
type
 TDerivedNSRecursiveLock = objcclass (NSRecursiveLock)
 extraptr: pointer
;end;
type
 TDerivedNSCondition = objcclass (NSCondition)
 extraptr: pointer
;end;
type
 TDerivedNSMapTable = objcclass (NSMapTable)
 extraptr: pointer
;end;
type
 TDerivedNSMetadataQuery = objcclass (NSMetadataQuery)
 extraptr: pointer
;end;
type
 TDerivedNSMetadataItem = objcclass (NSMetadataItem)
 extraptr: pointer
;end;
type
 TDerivedNSMetadataQueryAttributeValueTuple = objcclass (NSMetadataQueryAttributeValueTuple)
 extraptr: pointer
;end;
type
 TDerivedNSMetadataQueryResultGroup = objcclass (NSMetadataQueryResultGroup)
 extraptr: pointer
;end;
type
 TDerivedNSMethodSignature = objcclass (NSMethodSignature)
 extraptr: pointer
;end;
type
 TDerivedNSNetService = objcclass (NSNetService)
 extraptr: pointer
;end;
type
 TDerivedNSNetServiceBrowser = objcclass (NSNetServiceBrowser)
 extraptr: pointer
;end;
type
 TDerivedNSNotification = objcclass (NSNotification)
 extraptr: pointer
;end;
type
 TDerivedNSNotificationCenter = objcclass (NSNotificationCenter)
 extraptr: pointer
;end;
type
 TDerivedNSNotificationQueue = objcclass (NSNotificationQueue)
 extraptr: pointer
;end;
type
 TDerivedNSNull = objcclass (NSNull)
 extraptr: pointer
;end;
type
 TDerivedNSNumberFormatter = objcclass (NSNumberFormatter)
 extraptr: pointer
;end;
type
 TDerivedNSObject = objcclass (NSObject)
 extraptr: pointer
;end;
type
 TDerivedNSOperation = objcclass (NSOperation)
 extraptr: pointer
;end;
type
 TDerivedNSInvocationOperation = objcclass (NSInvocationOperation)
 extraptr: pointer
;end;
type
 TDerivedNSOperationQueue = objcclass (NSOperationQueue)
 extraptr: pointer
;end;
type
 TDerivedNSPointerArray = objcclass (NSPointerArray)
 extraptr: pointer
;end;
type
 TDerivedNSPort = objcclass (NSPort)
 extraptr: pointer
;end;
type
 TDerivedNSMachPort = objcclass (NSMachPort)
 extraptr: pointer
;end;
type
 TDerivedNSMessagePort = objcclass (NSMessagePort)
 extraptr: pointer
;end;
type
 TDerivedNSSocketPort = objcclass (NSSocketPort)
 extraptr: pointer
;end;
type
 TDerivedNSPortCoder = objcclass (NSPortCoder)
 extraptr: pointer
;end;
type
 TDerivedNSPortMessage = objcclass (NSPortMessage)
 extraptr: pointer
;end;
type
 TDerivedNSPortNameServer = objcclass (NSPortNameServer)
 extraptr: pointer
;end;
type
 TDerivedNSMachBootstrapServer = objcclass (NSMachBootstrapServer)
 extraptr: pointer
;end;
type
 TDerivedNSMessagePortNameServer = objcclass (NSMessagePortNameServer)
 extraptr: pointer
;end;
type
 TDerivedNSSocketPortNameServer = objcclass (NSSocketPortNameServer)
 extraptr: pointer
;end;
type
 TDerivedNSPredicate = objcclass (NSPredicate)
 extraptr: pointer
;end;
type
 TDerivedNSProcessInfo = objcclass (NSProcessInfo)
 extraptr: pointer
;end;
type
 TDerivedNSPropertyListSerialization = objcclass (NSPropertyListSerialization)
 extraptr: pointer
;end;
type
 TDerivedNSProtocolChecker = objcclass (NSProtocolChecker)
 extraptr: pointer
;end;
type
 TDerivedNSProxy = objcclass (NSProxy)
 extraptr: pointer
;end;
type
 TDerivedNSRunLoop = objcclass (NSRunLoop)
 extraptr: pointer
;end;
type
 TDerivedNSScanner = objcclass (NSScanner)
 extraptr: pointer
;end;
type
 TDerivedNSScriptClassDescription = objcclass (NSScriptClassDescription)
 extraptr: pointer
;end;
type
 TDerivedNSScriptCoercionHandler = objcclass (NSScriptCoercionHandler)
 extraptr: pointer
;end;
type
 TDerivedNSScriptCommand = objcclass (NSScriptCommand)
 extraptr: pointer
;end;
type
 TDerivedNSScriptCommandDescription = objcclass (NSScriptCommandDescription)
 extraptr: pointer
;end;
type
 TDerivedNSScriptExecutionContext = objcclass (NSScriptExecutionContext)
 extraptr: pointer
;end;
type
 TDerivedNSScriptObjectSpecifier = objcclass (NSScriptObjectSpecifier)
 extraptr: pointer
;end;
type
 TDerivedNSIndexSpecifier = objcclass (NSIndexSpecifier)
 extraptr: pointer
;end;
type
 TDerivedNSMiddleSpecifier = objcclass (NSMiddleSpecifier)
 extraptr: pointer
;end;
type
 TDerivedNSNameSpecifier = objcclass (NSNameSpecifier)
 extraptr: pointer
;end;
type
 TDerivedNSPositionalSpecifier = objcclass (NSPositionalSpecifier)
 extraptr: pointer
;end;
type
 TDerivedNSPropertySpecifier = objcclass (NSPropertySpecifier)
 extraptr: pointer
;end;
type
 TDerivedNSRandomSpecifier = objcclass (NSRandomSpecifier)
 extraptr: pointer
;end;
type
 TDerivedNSRangeSpecifier = objcclass (NSRangeSpecifier)
 extraptr: pointer
;end;
type
 TDerivedNSRelativeSpecifier = objcclass (NSRelativeSpecifier)
 extraptr: pointer
;end;
type
 TDerivedNSUniqueIDSpecifier = objcclass (NSUniqueIDSpecifier)
 extraptr: pointer
;end;
type
 TDerivedNSWhoseSpecifier = objcclass (NSWhoseSpecifier)
 extraptr: pointer
;end;
type
 TDerivedNSCloneCommand = objcclass (NSCloneCommand)
 extraptr: pointer
;end;
type
 TDerivedNSCloseCommand = objcclass (NSCloseCommand)
 extraptr: pointer
;end;
type
 TDerivedNSCountCommand = objcclass (NSCountCommand)
 extraptr: pointer
;end;
type
 TDerivedNSCreateCommand = objcclass (NSCreateCommand)
 extraptr: pointer
;end;
type
 TDerivedNSDeleteCommand = objcclass (NSDeleteCommand)
 extraptr: pointer
;end;
type
 TDerivedNSExistsCommand = objcclass (NSExistsCommand)
 extraptr: pointer
;end;
type
 TDerivedNSGetCommand = objcclass (NSGetCommand)
 extraptr: pointer
;end;
type
 TDerivedNSMoveCommand = objcclass (NSMoveCommand)
 extraptr: pointer
;end;
type
 TDerivedNSQuitCommand = objcclass (NSQuitCommand)
 extraptr: pointer
;end;
type
 TDerivedNSSetCommand = objcclass (NSSetCommand)
 extraptr: pointer
;end;
type
 TDerivedNSScriptSuiteRegistry = objcclass (NSScriptSuiteRegistry)
 extraptr: pointer
;end;
type
 TDerivedNSScriptWhoseTest = objcclass (NSScriptWhoseTest)
 extraptr: pointer
;end;
type
 TDerivedNSLogicalTest = objcclass (NSLogicalTest)
 extraptr: pointer
;end;
type
 TDerivedNSSpecifierTest = objcclass (NSSpecifierTest)
 extraptr: pointer
;end;
type
 TDerivedNSSet = objcclass (NSSet)
 extraptr: pointer
;end;
type
 TDerivedNSMutableSet = objcclass (NSMutableSet)
 extraptr: pointer
;end;
type
 TDerivedNSCountedSet = objcclass (NSCountedSet)
 extraptr: pointer
;end;
type
 TDerivedNSSortDescriptor = objcclass (NSSortDescriptor)
 extraptr: pointer
;end;
type
 TDerivedNSSpellServer = objcclass (NSSpellServer)
 extraptr: pointer
;end;
type
 TDerivedNSStream = objcclass (NSStream)
 extraptr: pointer
;end;
type
 TDerivedNSInputStream = objcclass (NSInputStream)
 extraptr: pointer
;end;
type
 TDerivedNSOutputStream = objcclass (NSOutputStream)
 extraptr: pointer
;end;
type
 TDerivedNSString = objcclass (NSString)
 extraptr: pointer
;end;
type
 TDerivedNSMutableString = objcclass (NSMutableString)
 extraptr: pointer
;end;
type
 TDerivedNSSimpleCString = objcclass (NSSimpleCString)
 extraptr: pointer
;end;
type
 TDerivedNSTask = objcclass (NSTask)
 extraptr: pointer
;end;
type
 TDerivedNSThread = objcclass (NSThread)
 extraptr: pointer
;end;
type
 TDerivedNSTimer = objcclass (NSTimer)
 extraptr: pointer
;end;
type
 TDerivedNSTimeZone = objcclass (NSTimeZone)
 extraptr: pointer
;end;
type
 TDerivedNSUndoManager = objcclass (NSUndoManager)
 extraptr: pointer
;end;
type
 TDerivedNSURL = objcclass (NSURL)
 extraptr: pointer
;end;
type
 TDerivedNSURLAuthenticationChallenge = objcclass (NSURLAuthenticationChallenge)
 extraptr: pointer
;end;
type
 TDerivedNSCachedURLResponse = objcclass (NSCachedURLResponse)
 extraptr: pointer
;end;
type
 TDerivedNSURLCache = objcclass (NSURLCache)
 extraptr: pointer
;end;
type
 TDerivedNSURLConnection = objcclass (NSURLConnection)
 extraptr: pointer
;end;
type
 TDerivedNSURLCredential = objcclass (NSURLCredential)
 extraptr: pointer
;end;
type
 TDerivedNSURLCredentialStorage = objcclass (NSURLCredentialStorage)
 extraptr: pointer
;end;
type
 TDerivedNSURLDownload = objcclass (NSURLDownload)
 extraptr: pointer
;end;
type
 TDerivedNSURLHandle = objcclass (NSURLHandle)
 extraptr: pointer
;end;
type
 TDerivedNSURLProtectionSpace = objcclass (NSURLProtectionSpace)
 extraptr: pointer
;end;
type
 TDerivedNSURLProtocol = objcclass (NSURLProtocol)
 extraptr: pointer
;end;
type
 TDerivedNSURLRequest = objcclass (NSURLRequest)
 extraptr: pointer
;end;
type
 TDerivedNSMutableURLRequest = objcclass (NSMutableURLRequest)
 extraptr: pointer
;end;
type
 TDerivedNSURLResponse = objcclass (NSURLResponse)
 extraptr: pointer
;end;
type
 TDerivedNSHTTPURLResponse = objcclass (NSHTTPURLResponse)
 extraptr: pointer
;end;
type
 TDerivedNSUserDefaults = objcclass (NSUserDefaults)
 extraptr: pointer
;end;
type
 TDerivedNSValue = objcclass (NSValue)
 extraptr: pointer
;end;
type
 TDerivedNSNumber = objcclass (NSNumber)
 extraptr: pointer
;end;
type
 TDerivedNSValueTransformer = objcclass (NSValueTransformer)
 extraptr: pointer
;end;
type
 TDerivedNSXMLDocument = objcclass (NSXMLDocument)
 extraptr: pointer
;end;
type
 TDerivedNSXMLDTD = objcclass (NSXMLDTD)
 extraptr: pointer
;end;
type
 TDerivedNSXMLDTDNode = objcclass (NSXMLDTDNode)
 extraptr: pointer
;end;
type
 TDerivedNSXMLElement = objcclass (NSXMLElement)
 extraptr: pointer
;end;
type
 TDerivedNSXMLNode = objcclass (NSXMLNode)
 extraptr: pointer
;end;
type
 TDerivedNSXMLParser = objcclass (NSXMLParser)
 extraptr: pointer
;end;
type
 TDerivedNSActionCell = objcclass (NSActionCell)
 extraptr: pointer
;end;
type
 TDerivedNSAlert = objcclass (NSAlert)
 extraptr: pointer
;end;
type
 TDerivedNSAnimation = objcclass (NSAnimation)
 extraptr: pointer
;end;
type
 TDerivedNSViewAnimation = objcclass (NSViewAnimation)
 extraptr: pointer
;end;
type
 TDerivedNSAnimationContext = objcclass (NSAnimationContext)
 extraptr: pointer
;end;
type
 TDerivedNSApplication = objcclass (NSApplication)
 extraptr: pointer
;end;
type
 TDerivedNSArrayController = objcclass (NSArrayController)
 extraptr: pointer
;end;
type
 TDerivedNSATSTypesetter = objcclass (NSATSTypesetter)
 extraptr: pointer
;end;
type
 TDerivedNSBezierPath = objcclass (NSBezierPath)
 extraptr: pointer
;end;
type
 TDerivedNSBitmapImageRep = objcclass (NSBitmapImageRep)
 extraptr: pointer
;end;
type
 TDerivedNSBox = objcclass (NSBox)
 extraptr: pointer
;end;
type
 TDerivedNSBrowser = objcclass (NSBrowser)
 extraptr: pointer
;end;
type
 TDerivedNSBrowserCell = objcclass (NSBrowserCell)
 extraptr: pointer
;end;
type
 TDerivedNSButton = objcclass (NSButton)
 extraptr: pointer
;end;
type
 TDerivedNSButtonCell = objcclass (NSButtonCell)
 extraptr: pointer
;end;
type
 TDerivedNSCachedImageRep = objcclass (NSCachedImageRep)
 extraptr: pointer
;end;
type
 TDerivedNSCell = objcclass (NSCell)
 extraptr: pointer
;end;
type
 TDerivedNSCIImageRep = objcclass (NSCIImageRep)
 extraptr: pointer
;end;
type
 TDerivedNSClipView = objcclass (NSClipView)
 extraptr: pointer
;end;
type
 TDerivedNSCollectionViewItem = objcclass (NSCollectionViewItem)
 extraptr: pointer
;end;
type
 TDerivedNSCollectionView = objcclass (NSCollectionView)
 extraptr: pointer
;end;
type
 TDerivedNSColor = objcclass (NSColor)
 extraptr: pointer
;end;
type
 TDerivedNSColorList = objcclass (NSColorList)
 extraptr: pointer
;end;
type
 TDerivedNSColorPanel = objcclass (NSColorPanel)
 extraptr: pointer
;end;
type
 TDerivedNSColorPicker = objcclass (NSColorPicker)
 extraptr: pointer
;end;
type
 TDerivedNSColorSpace = objcclass (NSColorSpace)
 extraptr: pointer
;end;
type
 TDerivedNSColorWell = objcclass (NSColorWell)
 extraptr: pointer
;end;
type
 TDerivedNSComboBox = objcclass (NSComboBox)
 extraptr: pointer
;end;
type
 TDerivedNSComboBoxCell = objcclass (NSComboBoxCell)
 extraptr: pointer
;end;
type
 TDerivedNSControl = objcclass (NSControl)
 extraptr: pointer
;end;
type
 TDerivedNSController = objcclass (NSController)
 extraptr: pointer
;end;
type
 TDerivedNSCursor = objcclass (NSCursor)
 extraptr: pointer
;end;
type
 TDerivedNSCustomImageRep = objcclass (NSCustomImageRep)
 extraptr: pointer
;end;
type
 TDerivedNSDatePicker = objcclass (NSDatePicker)
 extraptr: pointer
;end;
type
 TDerivedNSDatePickerCell = objcclass (NSDatePickerCell)
 extraptr: pointer
;end;
type
 TDerivedNSDictionaryController = objcclass (NSDictionaryController)
 extraptr: pointer
;end;
type
 TDerivedNSDockTile = objcclass (NSDockTile)
 extraptr: pointer
;end;
type
 TDerivedNSDocument = objcclass (NSDocument)
 extraptr: pointer
;end;
type
 TDerivedNSDocumentController = objcclass (NSDocumentController)
 extraptr: pointer
;end;
type
 TDerivedNSDrawer = objcclass (NSDrawer)
 extraptr: pointer
;end;
type
 TDerivedNSEPSImageRep = objcclass (NSEPSImageRep)
 extraptr: pointer
;end;
type
 TDerivedNSEvent = objcclass (NSEvent)
 extraptr: pointer
;end;
type
 TDerivedNSFileWrapper = objcclass (NSFileWrapper)
 extraptr: pointer
;end;
type
 TDerivedNSFont = objcclass (NSFont)
 extraptr: pointer
;end;
type
 TDerivedNSFontDescriptor = objcclass (NSFontDescriptor)
 extraptr: pointer
;end;
type
 TDerivedNSFontManager = objcclass (NSFontManager)
 extraptr: pointer
;end;
type
 TDerivedNSFontPanel = objcclass (NSFontPanel)
 extraptr: pointer
;end;
type
 TDerivedNSFormCell = objcclass (NSFormCell)
 extraptr: pointer
;end;
type
 TDerivedNSGlyphGenerator = objcclass (NSGlyphGenerator)
 extraptr: pointer
;end;
type
 TDerivedNSGlyphInfo = objcclass (NSGlyphInfo)
 extraptr: pointer
;end;
type
 TDerivedNSGradient = objcclass (NSGradient)
 extraptr: pointer
;end;
type
 TDerivedNSGraphicsContext = objcclass (NSGraphicsContext)
 extraptr: pointer
;end;
type
 TDerivedNSHelpManager = objcclass (NSHelpManager)
 extraptr: pointer
;end;
type
 TDerivedNSImage = objcclass (NSImage)
 extraptr: pointer
;end;
type
 TDerivedNSImageCell = objcclass (NSImageCell)
 extraptr: pointer
;end;
type
 TDerivedNSImageRep = objcclass (NSImageRep)
 extraptr: pointer
;end;
type
 TDerivedNSImageView = objcclass (NSImageView)
 extraptr: pointer
;end;
type
 TDerivedNSInputManager = objcclass (NSInputManager)
 extraptr: pointer
;end;
type
 TDerivedNSInputServer = objcclass (NSInputServer)
 extraptr: pointer
;end;
type
 TDerivedNSLayoutManager = objcclass (NSLayoutManager)
 extraptr: pointer
;end;
type
 TDerivedNSLevelIndicator = objcclass (NSLevelIndicator)
 extraptr: pointer
;end;
type
 TDerivedNSLevelIndicatorCell = objcclass (NSLevelIndicatorCell)
 extraptr: pointer
;end;
type
 TDerivedNSMatrix = objcclass (NSMatrix)
 extraptr: pointer
;end;
type
 TDerivedNSMenu = objcclass (NSMenu)
 extraptr: pointer
;end;
type
 TDerivedNSMenuItem = objcclass (NSMenuItem)
 extraptr: pointer
;end;
type
 TDerivedNSMenuItemCell = objcclass (NSMenuItemCell)
 extraptr: pointer
;end;
{$ifndef cpu64}
type
 TDerivedNSMenuView = objcclass (NSMenuView)
 extraptr: pointer
;end;
{$endif}
type
 TDerivedNSMovie = objcclass (NSMovie)
 extraptr: pointer
;end;
{$ifndef cpu64}
type
 TDerivedNSMovieView = objcclass (NSMovieView)
 extraptr: pointer
;end;
{$endif}
type
 TDerivedNSNib = objcclass (NSNib)
 extraptr: pointer
;end;
type
 TDerivedNSObjectController = objcclass (NSObjectController)
 extraptr: pointer
;end;
type
 TDerivedNSOpenGLPixelFormat = objcclass (NSOpenGLPixelFormat)
 extraptr: pointer
;end;
type
 TDerivedNSOpenGLPixelBuffer = objcclass (NSOpenGLPixelBuffer)
 extraptr: pointer
;end;
type
 TDerivedNSOpenGLContext = objcclass (NSOpenGLContext)
 extraptr: pointer
;end;
type
 TDerivedNSOpenGLView = objcclass (NSOpenGLView)
 extraptr: pointer
;end;
type
 TDerivedNSOpenPanel = objcclass (NSOpenPanel)
 extraptr: pointer
;end;
type
 TDerivedNSOutlineView = objcclass (NSOutlineView)
 extraptr: pointer
;end;
type
 TDerivedNSPageLayout = objcclass (NSPageLayout)
 extraptr: pointer
;end;
type
 TDerivedNSPanel = objcclass (NSPanel)
 extraptr: pointer
;end;
type
 TDerivedNSTextTab = objcclass (NSTextTab)
 extraptr: pointer
;end;
type
 TDerivedNSParagraphStyle = objcclass (NSParagraphStyle)
 extraptr: pointer
;end;
type
 TDerivedNSMutableParagraphStyle = objcclass (NSMutableParagraphStyle)
 extraptr: pointer
;end;
type
 TDerivedNSPasteboard = objcclass (NSPasteboard)
 extraptr: pointer
;end;
type
 TDerivedNSPathCell = objcclass (NSPathCell)
 extraptr: pointer
;end;
type
 TDerivedNSPathComponentCell = objcclass (NSPathComponentCell)
 extraptr: pointer
;end;
type
 TDerivedNSPathControl = objcclass (NSPathControl)
 extraptr: pointer
;end;
type
 TDerivedNSPDFImageRep = objcclass (NSPDFImageRep)
 extraptr: pointer
;end;
type
 TDerivedNSPersistentDocument = objcclass (NSPersistentDocument)
 extraptr: pointer
;end;
type
 TDerivedNSPICTImageRep = objcclass (NSPICTImageRep)
 extraptr: pointer
;end;
type
 TDerivedNSPopUpButton = objcclass (NSPopUpButton)
 extraptr: pointer
;end;
type
 TDerivedNSPopUpButtonCell = objcclass (NSPopUpButtonCell)
 extraptr: pointer
;end;
type
 TDerivedNSPredicateEditor = objcclass (NSPredicateEditor)
 extraptr: pointer
;end;
type
 TDerivedNSPrinter = objcclass (NSPrinter)
 extraptr: pointer
;end;
type
 TDerivedNSPrintInfo = objcclass (NSPrintInfo)
 extraptr: pointer
;end;
type
 TDerivedNSPrintOperation = objcclass (NSPrintOperation)
 extraptr: pointer
;end;
type
 TDerivedNSPrintPanel = objcclass (NSPrintPanel)
 extraptr: pointer
;end;
type
 TDerivedNSProgressIndicator = objcclass (NSProgressIndicator)
 extraptr: pointer
;end;
{$ifndef cpu64}
type
 TDerivedNSQuickDrawView = objcclass (NSQuickDrawView)
 extraptr: pointer
;end;
{$endif}
type
 TDerivedNSResponder = objcclass (NSResponder)
 extraptr: pointer
;end;
type
 TDerivedNSRuleEditor = objcclass (NSRuleEditor)
 extraptr: pointer
;end;
type
 TDerivedNSRulerMarker = objcclass (NSRulerMarker)
 extraptr: pointer
;end;
type
 TDerivedNSRulerView = objcclass (NSRulerView)
 extraptr: pointer
;end;
type
 TDerivedNSSavePanel = objcclass (NSSavePanel)
 extraptr: pointer
;end;
type
 TDerivedNSScreen = objcclass (NSScreen)
 extraptr: pointer
;end;
type
 TDerivedNSScroller = objcclass (NSScroller)
 extraptr: pointer
;end;
type
 TDerivedNSScrollView = objcclass (NSScrollView)
 extraptr: pointer
;end;
type
 TDerivedNSSearchField = objcclass (NSSearchField)
 extraptr: pointer
;end;
type
 TDerivedNSSearchFieldCell = objcclass (NSSearchFieldCell)
 extraptr: pointer
;end;
type
 TDerivedNSSecureTextField = objcclass (NSSecureTextField)
 extraptr: pointer
;end;
type
 TDerivedNSSecureTextFieldCell = objcclass (NSSecureTextFieldCell)
 extraptr: pointer
;end;
type
 TDerivedNSSegmentedControl = objcclass (NSSegmentedControl)
 extraptr: pointer
;end;
type
 TDerivedNSShadow = objcclass (NSShadow)
 extraptr: pointer
;end;
type
 TDerivedNSSlider = objcclass (NSSlider)
 extraptr: pointer
;end;
type
 TDerivedNSSliderCell = objcclass (NSSliderCell)
 extraptr: pointer
;end;
type
 TDerivedNSSound = objcclass (NSSound)
 extraptr: pointer
;end;
type
 TDerivedNSSpeechRecognizer = objcclass (NSSpeechRecognizer)
 extraptr: pointer
;end;
type
 TDerivedNSSpeechSynthesizer = objcclass (NSSpeechSynthesizer)
 extraptr: pointer
;end;
type
 TDerivedNSSpellChecker = objcclass (NSSpellChecker)
 extraptr: pointer
;end;
type
 TDerivedNSSplitView = objcclass (NSSplitView)
 extraptr: pointer
;end;
type
 TDerivedNSStatusBar = objcclass (NSStatusBar)
 extraptr: pointer
;end;
type
 TDerivedNSStatusItem = objcclass (NSStatusItem)
 extraptr: pointer
;end;
type
 TDerivedNSStepper = objcclass (NSStepper)
 extraptr: pointer
;end;
type
 TDerivedNSStepperCell = objcclass (NSStepperCell)
 extraptr: pointer
;end;
type
 TDerivedNSTableColumn = objcclass (NSTableColumn)
 extraptr: pointer
;end;
type
 TDerivedNSTableHeaderCell = objcclass (NSTableHeaderCell)
 extraptr: pointer
;end;
type
 TDerivedNSTableHeaderView = objcclass (NSTableHeaderView)
 extraptr: pointer
;end;
type
 TDerivedNSTableView = objcclass (NSTableView)
 extraptr: pointer
;end;
type
 TDerivedNSTabView = objcclass (NSTabView)
 extraptr: pointer
;end;
type
 TDerivedNSTabViewItem = objcclass (NSTabViewItem)
 extraptr: pointer
;end;
type
 TDerivedNSText = objcclass (NSText)
 extraptr: pointer
;end;
type
 TDerivedNSTextAttachmentCell = objcclass (NSTextAttachmentCell)
 extraptr: pointer
;end;
type
 TDerivedNSTextAttachment = objcclass (NSTextAttachment)
 extraptr: pointer
;end;
type
 TDerivedNSTextContainer = objcclass (NSTextContainer)
 extraptr: pointer
;end;
type
 TDerivedNSTextField = objcclass (NSTextField)
 extraptr: pointer
;end;
type
 TDerivedNSTextFieldCell = objcclass (NSTextFieldCell)
 extraptr: pointer
;end;
type
 TDerivedNSTextList = objcclass (NSTextList)
 extraptr: pointer
;end;
type
 TDerivedNSTextStorage = objcclass (NSTextStorage)
 extraptr: pointer
;end;
type
 TDerivedNSTextBlock = objcclass (NSTextBlock)
 extraptr: pointer
;end;
type
 TDerivedNSTextTableBlock = objcclass (NSTextTableBlock)
 extraptr: pointer
;end;
type
 TDerivedNSTextTable = objcclass (NSTextTable)
 extraptr: pointer
;end;
type
 TDerivedNSTextView = objcclass (NSTextView)
 extraptr: pointer
;end;
type
 TDerivedNSTokenField = objcclass (NSTokenField)
 extraptr: pointer
;end;
type
 TDerivedNSTokenFieldCell = objcclass (NSTokenFieldCell)
 extraptr: pointer
;end;
type
 TDerivedNSToolbar = objcclass (NSToolbar)
 extraptr: pointer
;end;
type
 TDerivedNSToolbarItem = objcclass (NSToolbarItem)
 extraptr: pointer
;end;
type
 TDerivedNSToolbarItemGroup = objcclass (NSToolbarItemGroup)
 extraptr: pointer
;end;
type
 TDerivedNSTrackingArea = objcclass (NSTrackingArea)
 extraptr: pointer
;end;
type
 TDerivedNSTreeController = objcclass (NSTreeController)
 extraptr: pointer
;end;
type
 TDerivedNSTreeNode = objcclass (NSTreeNode)
 extraptr: pointer
;end;
type
 TDerivedNSTypesetter = objcclass (NSTypesetter)
 extraptr: pointer
;end;
type
 TDerivedNSUserDefaultsController = objcclass (NSUserDefaultsController)
 extraptr: pointer
;end;
type
 TDerivedNSView = objcclass (NSView)
 extraptr: pointer
;end;
type
 TDerivedNSViewController = objcclass (NSViewController)
 extraptr: pointer
;end;
type
 TDerivedNSWindow = objcclass (NSWindow)
 extraptr: pointer
;end;
type
 TDerivedNSWindowController = objcclass (NSWindowController)
 extraptr: pointer
;end;
type
 TDerivedNSWorkspace = objcclass (NSWorkspace)
 extraptr: pointer
;end;

procedure PrintGlue1;
var
  pool: NSAutoReleasePool;
begin
 pool:=NSAutoReleasePool.alloc.init;
 if class_getInstanceSize(TDerivedNSAffineTransform) <> (class_getInstanceSize(NSAffineTransform)+sizeof(pointer)) then
 writeln('size of NSAffineTransform is wrong: ',class_getInstanceSize(TDerivedNSAffineTransform),' <> ',class_getInstanceSize(NSAffineTransform)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSAppleEventDescriptor) <> (class_getInstanceSize(NSAppleEventDescriptor)+sizeof(pointer)) then
 writeln('size of NSAppleEventDescriptor is wrong: ',class_getInstanceSize(TDerivedNSAppleEventDescriptor),' <> ',class_getInstanceSize(NSAppleEventDescriptor)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSAppleEventManager) <> (class_getInstanceSize(NSAppleEventManager)+sizeof(pointer)) then
 writeln('size of NSAppleEventManager is wrong: ',class_getInstanceSize(TDerivedNSAppleEventManager),' <> ',class_getInstanceSize(NSAppleEventManager)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSAppleScript) <> (class_getInstanceSize(NSAppleScript)+sizeof(pointer)) then
 writeln('size of NSAppleScript is wrong: ',class_getInstanceSize(TDerivedNSAppleScript),' <> ',class_getInstanceSize(NSAppleScript)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSArchiver) <> (class_getInstanceSize(NSArchiver)+sizeof(pointer)) then
 writeln('size of NSArchiver is wrong: ',class_getInstanceSize(TDerivedNSArchiver),' <> ',class_getInstanceSize(NSArchiver)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSUnarchiver) <> (class_getInstanceSize(NSUnarchiver)+sizeof(pointer)) then
 writeln('size of NSUnarchiver is wrong: ',class_getInstanceSize(TDerivedNSUnarchiver),' <> ',class_getInstanceSize(NSUnarchiver)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSArray) <> (class_getInstanceSize(NSArray)+sizeof(pointer)) then
 writeln('size of NSArray is wrong: ',class_getInstanceSize(TDerivedNSArray),' <> ',class_getInstanceSize(NSArray)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSMutableArray) <> (class_getInstanceSize(NSMutableArray)+sizeof(pointer)) then
 writeln('size of NSMutableArray is wrong: ',class_getInstanceSize(TDerivedNSMutableArray),' <> ',class_getInstanceSize(NSMutableArray)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSAttributedString) <> (class_getInstanceSize(NSAttributedString)+sizeof(pointer)) then
 writeln('size of NSAttributedString is wrong: ',class_getInstanceSize(TDerivedNSAttributedString),' <> ',class_getInstanceSize(NSAttributedString)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSMutableAttributedString) <> (class_getInstanceSize(NSMutableAttributedString)+sizeof(pointer)) then
 writeln('size of NSMutableAttributedString is wrong: ',class_getInstanceSize(TDerivedNSMutableAttributedString),' <> ',class_getInstanceSize(NSMutableAttributedString)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSAutoreleasePool) <> (class_getInstanceSize(NSAutoreleasePool)+sizeof(pointer)) then
 writeln('size of NSAutoreleasePool is wrong: ',class_getInstanceSize(TDerivedNSAutoreleasePool),' <> ',class_getInstanceSize(NSAutoreleasePool)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSBundle) <> (class_getInstanceSize(NSBundle)+sizeof(pointer)) then
 writeln('size of NSBundle is wrong: ',class_getInstanceSize(TDerivedNSBundle),' <> ',class_getInstanceSize(NSBundle)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSCalendar) <> (class_getInstanceSize(NSCalendar)+sizeof(pointer)) then
 writeln('size of NSCalendar is wrong: ',class_getInstanceSize(TDerivedNSCalendar),' <> ',class_getInstanceSize(NSCalendar)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSDateComponents) <> (class_getInstanceSize(NSDateComponents)+sizeof(pointer)) then
 writeln('size of NSDateComponents is wrong: ',class_getInstanceSize(TDerivedNSDateComponents),' <> ',class_getInstanceSize(NSDateComponents)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSCalendarDate) <> (class_getInstanceSize(NSCalendarDate)+sizeof(pointer)) then
 writeln('size of NSCalendarDate is wrong: ',class_getInstanceSize(TDerivedNSCalendarDate),' <> ',class_getInstanceSize(NSCalendarDate)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSCharacterSet) <> (class_getInstanceSize(NSCharacterSet)+sizeof(pointer)) then
 writeln('size of NSCharacterSet is wrong: ',class_getInstanceSize(TDerivedNSCharacterSet),' <> ',class_getInstanceSize(NSCharacterSet)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSMutableCharacterSet) <> (class_getInstanceSize(NSMutableCharacterSet)+sizeof(pointer)) then
 writeln('size of NSMutableCharacterSet is wrong: ',class_getInstanceSize(TDerivedNSMutableCharacterSet),' <> ',class_getInstanceSize(NSMutableCharacterSet)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSClassDescription) <> (class_getInstanceSize(NSClassDescription)+sizeof(pointer)) then
 writeln('size of NSClassDescription is wrong: ',class_getInstanceSize(TDerivedNSClassDescription),' <> ',class_getInstanceSize(NSClassDescription)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSCoder) <> (class_getInstanceSize(NSCoder)+sizeof(pointer)) then
 writeln('size of NSCoder is wrong: ',class_getInstanceSize(TDerivedNSCoder),' <> ',class_getInstanceSize(NSCoder)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSComparisonPredicate) <> (class_getInstanceSize(NSComparisonPredicate)+sizeof(pointer)) then
 writeln('size of NSComparisonPredicate is wrong: ',class_getInstanceSize(TDerivedNSComparisonPredicate),' <> ',class_getInstanceSize(NSComparisonPredicate)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSCompoundPredicate) <> (class_getInstanceSize(NSCompoundPredicate)+sizeof(pointer)) then
 writeln('size of NSCompoundPredicate is wrong: ',class_getInstanceSize(TDerivedNSCompoundPredicate),' <> ',class_getInstanceSize(NSCompoundPredicate)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSConnection) <> (class_getInstanceSize(NSConnection)+sizeof(pointer)) then
 writeln('size of NSConnection is wrong: ',class_getInstanceSize(TDerivedNSConnection),' <> ',class_getInstanceSize(NSConnection)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSDistantObjectRequest) <> (class_getInstanceSize(NSDistantObjectRequest)+sizeof(pointer)) then
 writeln('size of NSDistantObjectRequest is wrong: ',class_getInstanceSize(TDerivedNSDistantObjectRequest),' <> ',class_getInstanceSize(NSDistantObjectRequest)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSData) <> (class_getInstanceSize(NSData)+sizeof(pointer)) then
 writeln('size of NSData is wrong: ',class_getInstanceSize(TDerivedNSData),' <> ',class_getInstanceSize(NSData)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSMutableData) <> (class_getInstanceSize(NSMutableData)+sizeof(pointer)) then
 writeln('size of NSMutableData is wrong: ',class_getInstanceSize(TDerivedNSMutableData),' <> ',class_getInstanceSize(NSMutableData)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSDate) <> (class_getInstanceSize(NSDate)+sizeof(pointer)) then
 writeln('size of NSDate is wrong: ',class_getInstanceSize(TDerivedNSDate),' <> ',class_getInstanceSize(NSDate)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSDateFormatter) <> (class_getInstanceSize(NSDateFormatter)+sizeof(pointer)) then
 writeln('size of NSDateFormatter is wrong: ',class_getInstanceSize(TDerivedNSDateFormatter),' <> ',class_getInstanceSize(NSDateFormatter)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSDecimalNumber) <> (class_getInstanceSize(NSDecimalNumber)+sizeof(pointer)) then
 writeln('size of NSDecimalNumber is wrong: ',class_getInstanceSize(TDerivedNSDecimalNumber),' <> ',class_getInstanceSize(NSDecimalNumber)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSDecimalNumberHandler) <> (class_getInstanceSize(NSDecimalNumberHandler)+sizeof(pointer)) then
 writeln('size of NSDecimalNumberHandler is wrong: ',class_getInstanceSize(TDerivedNSDecimalNumberHandler),' <> ',class_getInstanceSize(NSDecimalNumberHandler)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSDictionary) <> (class_getInstanceSize(NSDictionary)+sizeof(pointer)) then
 writeln('size of NSDictionary is wrong: ',class_getInstanceSize(TDerivedNSDictionary),' <> ',class_getInstanceSize(NSDictionary)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSMutableDictionary) <> (class_getInstanceSize(NSMutableDictionary)+sizeof(pointer)) then
 writeln('size of NSMutableDictionary is wrong: ',class_getInstanceSize(TDerivedNSMutableDictionary),' <> ',class_getInstanceSize(NSMutableDictionary)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSDistantObject) <> (class_getInstanceSize(NSDistantObject)+sizeof(pointer)) then
 writeln('size of NSDistantObject is wrong: ',class_getInstanceSize(TDerivedNSDistantObject),' <> ',class_getInstanceSize(NSDistantObject)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSDistributedLock) <> (class_getInstanceSize(NSDistributedLock)+sizeof(pointer)) then
 writeln('size of NSDistributedLock is wrong: ',class_getInstanceSize(TDerivedNSDistributedLock),' <> ',class_getInstanceSize(NSDistributedLock)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSDistributedNotificationCenter) <> (class_getInstanceSize(NSDistributedNotificationCenter)+sizeof(pointer)) then
 writeln('size of NSDistributedNotificationCenter is wrong: ',class_getInstanceSize(TDerivedNSDistributedNotificationCenter),' <> ',class_getInstanceSize(NSDistributedNotificationCenter)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSEnumerator) <> (class_getInstanceSize(NSEnumerator)+sizeof(pointer)) then
 writeln('size of NSEnumerator is wrong: ',class_getInstanceSize(TDerivedNSEnumerator),' <> ',class_getInstanceSize(NSEnumerator)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSError) <> (class_getInstanceSize(NSError)+sizeof(pointer)) then
 writeln('size of NSError is wrong: ',class_getInstanceSize(TDerivedNSError),' <> ',class_getInstanceSize(NSError)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSException) <> (class_getInstanceSize(NSException)+sizeof(pointer)) then
 writeln('size of NSException is wrong: ',class_getInstanceSize(TDerivedNSException),' <> ',class_getInstanceSize(NSException)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSAssertionHandler) <> (class_getInstanceSize(NSAssertionHandler)+sizeof(pointer)) then
 writeln('size of NSAssertionHandler is wrong: ',class_getInstanceSize(TDerivedNSAssertionHandler),' <> ',class_getInstanceSize(NSAssertionHandler)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSExpression) <> (class_getInstanceSize(NSExpression)+sizeof(pointer)) then
 writeln('size of NSExpression is wrong: ',class_getInstanceSize(TDerivedNSExpression),' <> ',class_getInstanceSize(NSExpression)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSFileHandle) <> (class_getInstanceSize(NSFileHandle)+sizeof(pointer)) then
 writeln('size of NSFileHandle is wrong: ',class_getInstanceSize(TDerivedNSFileHandle),' <> ',class_getInstanceSize(NSFileHandle)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSPipe) <> (class_getInstanceSize(NSPipe)+sizeof(pointer)) then
 writeln('size of NSPipe is wrong: ',class_getInstanceSize(TDerivedNSPipe),' <> ',class_getInstanceSize(NSPipe)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSFileManager) <> (class_getInstanceSize(NSFileManager)+sizeof(pointer)) then
 writeln('size of NSFileManager is wrong: ',class_getInstanceSize(TDerivedNSFileManager),' <> ',class_getInstanceSize(NSFileManager)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSDirectoryEnumerator) <> (class_getInstanceSize(NSDirectoryEnumerator)+sizeof(pointer)) then
 writeln('size of NSDirectoryEnumerator is wrong: ',class_getInstanceSize(TDerivedNSDirectoryEnumerator),' <> ',class_getInstanceSize(NSDirectoryEnumerator)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSFormatter) <> (class_getInstanceSize(NSFormatter)+sizeof(pointer)) then
 writeln('size of NSFormatter is wrong: ',class_getInstanceSize(TDerivedNSFormatter),' <> ',class_getInstanceSize(NSFormatter)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSGarbageCollector) <> (class_getInstanceSize(NSGarbageCollector)+sizeof(pointer)) then
 writeln('size of NSGarbageCollector is wrong: ',class_getInstanceSize(TDerivedNSGarbageCollector),' <> ',class_getInstanceSize(NSGarbageCollector)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSHashTable) <> (class_getInstanceSize(NSHashTable)+sizeof(pointer)) then
 writeln('size of NSHashTable is wrong: ',class_getInstanceSize(TDerivedNSHashTable),' <> ',class_getInstanceSize(NSHashTable)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSHost) <> (class_getInstanceSize(NSHost)+sizeof(pointer)) then
 writeln('size of NSHost is wrong: ',class_getInstanceSize(TDerivedNSHost),' <> ',class_getInstanceSize(NSHost)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSHTTPCookie) <> (class_getInstanceSize(NSHTTPCookie)+sizeof(pointer)) then
 writeln('size of NSHTTPCookie is wrong: ',class_getInstanceSize(TDerivedNSHTTPCookie),' <> ',class_getInstanceSize(NSHTTPCookie)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSHTTPCookieStorage) <> (class_getInstanceSize(NSHTTPCookieStorage)+sizeof(pointer)) then
 writeln('size of NSHTTPCookieStorage is wrong: ',class_getInstanceSize(TDerivedNSHTTPCookieStorage),' <> ',class_getInstanceSize(NSHTTPCookieStorage)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSIndexPath) <> (class_getInstanceSize(NSIndexPath)+sizeof(pointer)) then
 writeln('size of NSIndexPath is wrong: ',class_getInstanceSize(TDerivedNSIndexPath),' <> ',class_getInstanceSize(NSIndexPath)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSIndexSet) <> (class_getInstanceSize(NSIndexSet)+sizeof(pointer)) then
 writeln('size of NSIndexSet is wrong: ',class_getInstanceSize(TDerivedNSIndexSet),' <> ',class_getInstanceSize(NSIndexSet)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSMutableIndexSet) <> (class_getInstanceSize(NSMutableIndexSet)+sizeof(pointer)) then
 writeln('size of NSMutableIndexSet is wrong: ',class_getInstanceSize(TDerivedNSMutableIndexSet),' <> ',class_getInstanceSize(NSMutableIndexSet)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSKeyedArchiver) <> (class_getInstanceSize(NSKeyedArchiver)+sizeof(pointer)) then
 writeln('size of NSKeyedArchiver is wrong: ',class_getInstanceSize(TDerivedNSKeyedArchiver),' <> ',class_getInstanceSize(NSKeyedArchiver)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSKeyedUnarchiver) <> (class_getInstanceSize(NSKeyedUnarchiver)+sizeof(pointer)) then
 writeln('size of NSKeyedUnarchiver is wrong: ',class_getInstanceSize(TDerivedNSKeyedUnarchiver),' <> ',class_getInstanceSize(NSKeyedUnarchiver)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSLocale) <> (class_getInstanceSize(NSLocale)+sizeof(pointer)) then
 writeln('size of NSLocale is wrong: ',class_getInstanceSize(TDerivedNSLocale),' <> ',class_getInstanceSize(NSLocale)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSLock) <> (class_getInstanceSize(NSLock)+sizeof(pointer)) then
 writeln('size of NSLock is wrong: ',class_getInstanceSize(TDerivedNSLock),' <> ',class_getInstanceSize(NSLock)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSConditionLock) <> (class_getInstanceSize(NSConditionLock)+sizeof(pointer)) then
 writeln('size of NSConditionLock is wrong: ',class_getInstanceSize(TDerivedNSConditionLock),' <> ',class_getInstanceSize(NSConditionLock)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSRecursiveLock) <> (class_getInstanceSize(NSRecursiveLock)+sizeof(pointer)) then
 writeln('size of NSRecursiveLock is wrong: ',class_getInstanceSize(TDerivedNSRecursiveLock),' <> ',class_getInstanceSize(NSRecursiveLock)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSCondition) <> (class_getInstanceSize(NSCondition)+sizeof(pointer)) then
 writeln('size of NSCondition is wrong: ',class_getInstanceSize(TDerivedNSCondition),' <> ',class_getInstanceSize(NSCondition)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSMapTable) <> (class_getInstanceSize(NSMapTable)+sizeof(pointer)) then
 writeln('size of NSMapTable is wrong: ',class_getInstanceSize(TDerivedNSMapTable),' <> ',class_getInstanceSize(NSMapTable)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSMetadataQuery) <> (class_getInstanceSize(NSMetadataQuery)+sizeof(pointer)) then
 writeln('size of NSMetadataQuery is wrong: ',class_getInstanceSize(TDerivedNSMetadataQuery),' <> ',class_getInstanceSize(NSMetadataQuery)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSMetadataItem) <> (class_getInstanceSize(NSMetadataItem)+sizeof(pointer)) then
 writeln('size of NSMetadataItem is wrong: ',class_getInstanceSize(TDerivedNSMetadataItem),' <> ',class_getInstanceSize(NSMetadataItem)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSMetadataQueryAttributeValueTuple) <> (class_getInstanceSize(NSMetadataQueryAttributeValueTuple)+sizeof(pointer)) then
 writeln('size of NSMetadataQueryAttributeValueTuple is wrong: ',class_getInstanceSize(TDerivedNSMetadataQueryAttributeValueTuple),' <> ',class_getInstanceSize(NSMetadataQueryAttributeValueTuple)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSMetadataQueryResultGroup) <> (class_getInstanceSize(NSMetadataQueryResultGroup)+sizeof(pointer)) then
 writeln('size of NSMetadataQueryResultGroup is wrong: ',class_getInstanceSize(TDerivedNSMetadataQueryResultGroup),' <> ',class_getInstanceSize(NSMetadataQueryResultGroup)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSMethodSignature) <> (class_getInstanceSize(NSMethodSignature)+sizeof(pointer)) then
 writeln('size of NSMethodSignature is wrong: ',class_getInstanceSize(TDerivedNSMethodSignature),' <> ',class_getInstanceSize(NSMethodSignature)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSNetService) <> (class_getInstanceSize(NSNetService)+sizeof(pointer)) then
 writeln('size of NSNetService is wrong: ',class_getInstanceSize(TDerivedNSNetService),' <> ',class_getInstanceSize(NSNetService)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSNetServiceBrowser) <> (class_getInstanceSize(NSNetServiceBrowser)+sizeof(pointer)) then
 writeln('size of NSNetServiceBrowser is wrong: ',class_getInstanceSize(TDerivedNSNetServiceBrowser),' <> ',class_getInstanceSize(NSNetServiceBrowser)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSNotification) <> (class_getInstanceSize(NSNotification)+sizeof(pointer)) then
 writeln('size of NSNotification is wrong: ',class_getInstanceSize(TDerivedNSNotification),' <> ',class_getInstanceSize(NSNotification)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSNotificationCenter) <> (class_getInstanceSize(NSNotificationCenter)+sizeof(pointer)) then
 writeln('size of NSNotificationCenter is wrong: ',class_getInstanceSize(TDerivedNSNotificationCenter),' <> ',class_getInstanceSize(NSNotificationCenter)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSNotificationQueue) <> (class_getInstanceSize(NSNotificationQueue)+sizeof(pointer)) then
 writeln('size of NSNotificationQueue is wrong: ',class_getInstanceSize(TDerivedNSNotificationQueue),' <> ',class_getInstanceSize(NSNotificationQueue)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSNull) <> (class_getInstanceSize(NSNull)+sizeof(pointer)) then
 writeln('size of NSNull is wrong: ',class_getInstanceSize(TDerivedNSNull),' <> ',class_getInstanceSize(NSNull)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSNumberFormatter) <> (class_getInstanceSize(NSNumberFormatter)+sizeof(pointer)) then
 writeln('size of NSNumberFormatter is wrong: ',class_getInstanceSize(TDerivedNSNumberFormatter),' <> ',class_getInstanceSize(NSNumberFormatter)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSObject) <> (class_getInstanceSize(NSObject)+sizeof(pointer)) then
 writeln('size of NSObject is wrong: ',class_getInstanceSize(TDerivedNSObject),' <> ',class_getInstanceSize(NSObject)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSOperation) <> (class_getInstanceSize(NSOperation)+sizeof(pointer)) then
 writeln('size of NSOperation is wrong: ',class_getInstanceSize(TDerivedNSOperation),' <> ',class_getInstanceSize(NSOperation)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSInvocationOperation) <> (class_getInstanceSize(NSInvocationOperation)+sizeof(pointer)) then
 writeln('size of NSInvocationOperation is wrong: ',class_getInstanceSize(TDerivedNSInvocationOperation),' <> ',class_getInstanceSize(NSInvocationOperation)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSOperationQueue) <> (class_getInstanceSize(NSOperationQueue)+sizeof(pointer)) then
 writeln('size of NSOperationQueue is wrong: ',class_getInstanceSize(TDerivedNSOperationQueue),' <> ',class_getInstanceSize(NSOperationQueue)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSPointerArray) <> (class_getInstanceSize(NSPointerArray)+sizeof(pointer)) then
 writeln('size of NSPointerArray is wrong: ',class_getInstanceSize(TDerivedNSPointerArray),' <> ',class_getInstanceSize(NSPointerArray)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSPort) <> (class_getInstanceSize(NSPort)+sizeof(pointer)) then
 writeln('size of NSPort is wrong: ',class_getInstanceSize(TDerivedNSPort),' <> ',class_getInstanceSize(NSPort)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSMachPort) <> (class_getInstanceSize(NSMachPort)+sizeof(pointer)) then
 writeln('size of NSMachPort is wrong: ',class_getInstanceSize(TDerivedNSMachPort),' <> ',class_getInstanceSize(NSMachPort)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSMessagePort) <> (class_getInstanceSize(NSMessagePort)+sizeof(pointer)) then
 writeln('size of NSMessagePort is wrong: ',class_getInstanceSize(TDerivedNSMessagePort),' <> ',class_getInstanceSize(NSMessagePort)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSSocketPort) <> (class_getInstanceSize(NSSocketPort)+sizeof(pointer)) then
 writeln('size of NSSocketPort is wrong: ',class_getInstanceSize(TDerivedNSSocketPort),' <> ',class_getInstanceSize(NSSocketPort)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSPortCoder) <> (class_getInstanceSize(NSPortCoder)+sizeof(pointer)) then
 writeln('size of NSPortCoder is wrong: ',class_getInstanceSize(TDerivedNSPortCoder),' <> ',class_getInstanceSize(NSPortCoder)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSPortMessage) <> (class_getInstanceSize(NSPortMessage)+sizeof(pointer)) then
 writeln('size of NSPortMessage is wrong: ',class_getInstanceSize(TDerivedNSPortMessage),' <> ',class_getInstanceSize(NSPortMessage)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSPortNameServer) <> (class_getInstanceSize(NSPortNameServer)+sizeof(pointer)) then
 writeln('size of NSPortNameServer is wrong: ',class_getInstanceSize(TDerivedNSPortNameServer),' <> ',class_getInstanceSize(NSPortNameServer)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSMachBootstrapServer) <> (class_getInstanceSize(NSMachBootstrapServer)+sizeof(pointer)) then
 writeln('size of NSMachBootstrapServer is wrong: ',class_getInstanceSize(TDerivedNSMachBootstrapServer),' <> ',class_getInstanceSize(NSMachBootstrapServer)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSMessagePortNameServer) <> (class_getInstanceSize(NSMessagePortNameServer)+sizeof(pointer)) then
 writeln('size of NSMessagePortNameServer is wrong: ',class_getInstanceSize(TDerivedNSMessagePortNameServer),' <> ',class_getInstanceSize(NSMessagePortNameServer)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSSocketPortNameServer) <> (class_getInstanceSize(NSSocketPortNameServer)+sizeof(pointer)) then
 writeln('size of NSSocketPortNameServer is wrong: ',class_getInstanceSize(TDerivedNSSocketPortNameServer),' <> ',class_getInstanceSize(NSSocketPortNameServer)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSPredicate) <> (class_getInstanceSize(NSPredicate)+sizeof(pointer)) then
 writeln('size of NSPredicate is wrong: ',class_getInstanceSize(TDerivedNSPredicate),' <> ',class_getInstanceSize(NSPredicate)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSProcessInfo) <> (class_getInstanceSize(NSProcessInfo)+sizeof(pointer)) then
 writeln('size of NSProcessInfo is wrong: ',class_getInstanceSize(TDerivedNSProcessInfo),' <> ',class_getInstanceSize(NSProcessInfo)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSPropertyListSerialization) <> (class_getInstanceSize(NSPropertyListSerialization)+sizeof(pointer)) then
 writeln('size of NSPropertyListSerialization is wrong: ',class_getInstanceSize(TDerivedNSPropertyListSerialization),' <> ',class_getInstanceSize(NSPropertyListSerialization)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSProtocolChecker) <> (class_getInstanceSize(NSProtocolChecker)+sizeof(pointer)) then
 writeln('size of NSProtocolChecker is wrong: ',class_getInstanceSize(TDerivedNSProtocolChecker),' <> ',class_getInstanceSize(NSProtocolChecker)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSProxy) <> (class_getInstanceSize(NSProxy)+sizeof(pointer)) then
 writeln('size of NSProxy is wrong: ',class_getInstanceSize(TDerivedNSProxy),' <> ',class_getInstanceSize(NSProxy)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSRunLoop) <> (class_getInstanceSize(NSRunLoop)+sizeof(pointer)) then
 writeln('size of NSRunLoop is wrong: ',class_getInstanceSize(TDerivedNSRunLoop),' <> ',class_getInstanceSize(NSRunLoop)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSScanner) <> (class_getInstanceSize(NSScanner)+sizeof(pointer)) then
 writeln('size of NSScanner is wrong: ',class_getInstanceSize(TDerivedNSScanner),' <> ',class_getInstanceSize(NSScanner)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSScriptClassDescription) <> (class_getInstanceSize(NSScriptClassDescription)+sizeof(pointer)) then
 writeln('size of NSScriptClassDescription is wrong: ',class_getInstanceSize(TDerivedNSScriptClassDescription),' <> ',class_getInstanceSize(NSScriptClassDescription)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSScriptCoercionHandler) <> (class_getInstanceSize(NSScriptCoercionHandler)+sizeof(pointer)) then
 writeln('size of NSScriptCoercionHandler is wrong: ',class_getInstanceSize(TDerivedNSScriptCoercionHandler),' <> ',class_getInstanceSize(NSScriptCoercionHandler)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSScriptCommand) <> (class_getInstanceSize(NSScriptCommand)+sizeof(pointer)) then
 writeln('size of NSScriptCommand is wrong: ',class_getInstanceSize(TDerivedNSScriptCommand),' <> ',class_getInstanceSize(NSScriptCommand)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSScriptCommandDescription) <> (class_getInstanceSize(NSScriptCommandDescription)+sizeof(pointer)) then
 writeln('size of NSScriptCommandDescription is wrong: ',class_getInstanceSize(TDerivedNSScriptCommandDescription),' <> ',class_getInstanceSize(NSScriptCommandDescription)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSScriptExecutionContext) <> (class_getInstanceSize(NSScriptExecutionContext)+sizeof(pointer)) then
 writeln('size of NSScriptExecutionContext is wrong: ',class_getInstanceSize(TDerivedNSScriptExecutionContext),' <> ',class_getInstanceSize(NSScriptExecutionContext)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSScriptObjectSpecifier) <> (class_getInstanceSize(NSScriptObjectSpecifier)+sizeof(pointer)) then
 writeln('size of NSScriptObjectSpecifier is wrong: ',class_getInstanceSize(TDerivedNSScriptObjectSpecifier),' <> ',class_getInstanceSize(NSScriptObjectSpecifier)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSIndexSpecifier) <> (class_getInstanceSize(NSIndexSpecifier)+sizeof(pointer)) then
 writeln('size of NSIndexSpecifier is wrong: ',class_getInstanceSize(TDerivedNSIndexSpecifier),' <> ',class_getInstanceSize(NSIndexSpecifier)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSMiddleSpecifier) <> (class_getInstanceSize(NSMiddleSpecifier)+sizeof(pointer)) then
 writeln('size of NSMiddleSpecifier is wrong: ',class_getInstanceSize(TDerivedNSMiddleSpecifier),' <> ',class_getInstanceSize(NSMiddleSpecifier)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSNameSpecifier) <> (class_getInstanceSize(NSNameSpecifier)+sizeof(pointer)) then
 writeln('size of NSNameSpecifier is wrong: ',class_getInstanceSize(TDerivedNSNameSpecifier),' <> ',class_getInstanceSize(NSNameSpecifier)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSPositionalSpecifier) <> (class_getInstanceSize(NSPositionalSpecifier)+sizeof(pointer)) then
 writeln('size of NSPositionalSpecifier is wrong: ',class_getInstanceSize(TDerivedNSPositionalSpecifier),' <> ',class_getInstanceSize(NSPositionalSpecifier)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSPropertySpecifier) <> (class_getInstanceSize(NSPropertySpecifier)+sizeof(pointer)) then
 writeln('size of NSPropertySpecifier is wrong: ',class_getInstanceSize(TDerivedNSPropertySpecifier),' <> ',class_getInstanceSize(NSPropertySpecifier)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSRandomSpecifier) <> (class_getInstanceSize(NSRandomSpecifier)+sizeof(pointer)) then
 writeln('size of NSRandomSpecifier is wrong: ',class_getInstanceSize(TDerivedNSRandomSpecifier),' <> ',class_getInstanceSize(NSRandomSpecifier)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSRangeSpecifier) <> (class_getInstanceSize(NSRangeSpecifier)+sizeof(pointer)) then
 writeln('size of NSRangeSpecifier is wrong: ',class_getInstanceSize(TDerivedNSRangeSpecifier),' <> ',class_getInstanceSize(NSRangeSpecifier)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSRelativeSpecifier) <> (class_getInstanceSize(NSRelativeSpecifier)+sizeof(pointer)) then
 writeln('size of NSRelativeSpecifier is wrong: ',class_getInstanceSize(TDerivedNSRelativeSpecifier),' <> ',class_getInstanceSize(NSRelativeSpecifier)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSUniqueIDSpecifier) <> (class_getInstanceSize(NSUniqueIDSpecifier)+sizeof(pointer)) then
 writeln('size of NSUniqueIDSpecifier is wrong: ',class_getInstanceSize(TDerivedNSUniqueIDSpecifier),' <> ',class_getInstanceSize(NSUniqueIDSpecifier)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSWhoseSpecifier) <> (class_getInstanceSize(NSWhoseSpecifier)+sizeof(pointer)) then
 writeln('size of NSWhoseSpecifier is wrong: ',class_getInstanceSize(TDerivedNSWhoseSpecifier),' <> ',class_getInstanceSize(NSWhoseSpecifier)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSCloneCommand) <> (class_getInstanceSize(NSCloneCommand)+sizeof(pointer)) then
 writeln('size of NSCloneCommand is wrong: ',class_getInstanceSize(TDerivedNSCloneCommand),' <> ',class_getInstanceSize(NSCloneCommand)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSCloseCommand) <> (class_getInstanceSize(NSCloseCommand)+sizeof(pointer)) then
 writeln('size of NSCloseCommand is wrong: ',class_getInstanceSize(TDerivedNSCloseCommand),' <> ',class_getInstanceSize(NSCloseCommand)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSCountCommand) <> (class_getInstanceSize(NSCountCommand)+sizeof(pointer)) then
 writeln('size of NSCountCommand is wrong: ',class_getInstanceSize(TDerivedNSCountCommand),' <> ',class_getInstanceSize(NSCountCommand)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSCreateCommand) <> (class_getInstanceSize(NSCreateCommand)+sizeof(pointer)) then
 writeln('size of NSCreateCommand is wrong: ',class_getInstanceSize(TDerivedNSCreateCommand),' <> ',class_getInstanceSize(NSCreateCommand)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSDeleteCommand) <> (class_getInstanceSize(NSDeleteCommand)+sizeof(pointer)) then
 writeln('size of NSDeleteCommand is wrong: ',class_getInstanceSize(TDerivedNSDeleteCommand),' <> ',class_getInstanceSize(NSDeleteCommand)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSExistsCommand) <> (class_getInstanceSize(NSExistsCommand)+sizeof(pointer)) then
 writeln('size of NSExistsCommand is wrong: ',class_getInstanceSize(TDerivedNSExistsCommand),' <> ',class_getInstanceSize(NSExistsCommand)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSGetCommand) <> (class_getInstanceSize(NSGetCommand)+sizeof(pointer)) then
 writeln('size of NSGetCommand is wrong: ',class_getInstanceSize(TDerivedNSGetCommand),' <> ',class_getInstanceSize(NSGetCommand)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSMoveCommand) <> (class_getInstanceSize(NSMoveCommand)+sizeof(pointer)) then
 writeln('size of NSMoveCommand is wrong: ',class_getInstanceSize(TDerivedNSMoveCommand),' <> ',class_getInstanceSize(NSMoveCommand)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSQuitCommand) <> (class_getInstanceSize(NSQuitCommand)+sizeof(pointer)) then
 writeln('size of NSQuitCommand is wrong: ',class_getInstanceSize(TDerivedNSQuitCommand),' <> ',class_getInstanceSize(NSQuitCommand)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSSetCommand) <> (class_getInstanceSize(NSSetCommand)+sizeof(pointer)) then
 writeln('size of NSSetCommand is wrong: ',class_getInstanceSize(TDerivedNSSetCommand),' <> ',class_getInstanceSize(NSSetCommand)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSScriptSuiteRegistry) <> (class_getInstanceSize(NSScriptSuiteRegistry)+sizeof(pointer)) then
 writeln('size of NSScriptSuiteRegistry is wrong: ',class_getInstanceSize(TDerivedNSScriptSuiteRegistry),' <> ',class_getInstanceSize(NSScriptSuiteRegistry)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSScriptWhoseTest) <> (class_getInstanceSize(NSScriptWhoseTest)+sizeof(pointer)) then
 writeln('size of NSScriptWhoseTest is wrong: ',class_getInstanceSize(TDerivedNSScriptWhoseTest),' <> ',class_getInstanceSize(NSScriptWhoseTest)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSLogicalTest) <> (class_getInstanceSize(NSLogicalTest)+sizeof(pointer)) then
 writeln('size of NSLogicalTest is wrong: ',class_getInstanceSize(TDerivedNSLogicalTest),' <> ',class_getInstanceSize(NSLogicalTest)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSSpecifierTest) <> (class_getInstanceSize(NSSpecifierTest)+sizeof(pointer)) then
 writeln('size of NSSpecifierTest is wrong: ',class_getInstanceSize(TDerivedNSSpecifierTest),' <> ',class_getInstanceSize(NSSpecifierTest)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSSet) <> (class_getInstanceSize(NSSet)+sizeof(pointer)) then
 writeln('size of NSSet is wrong: ',class_getInstanceSize(TDerivedNSSet),' <> ',class_getInstanceSize(NSSet)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSMutableSet) <> (class_getInstanceSize(NSMutableSet)+sizeof(pointer)) then
 writeln('size of NSMutableSet is wrong: ',class_getInstanceSize(TDerivedNSMutableSet),' <> ',class_getInstanceSize(NSMutableSet)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSCountedSet) <> (class_getInstanceSize(NSCountedSet)+sizeof(pointer)) then
 writeln('size of NSCountedSet is wrong: ',class_getInstanceSize(TDerivedNSCountedSet),' <> ',class_getInstanceSize(NSCountedSet)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSSortDescriptor) <> (class_getInstanceSize(NSSortDescriptor)+sizeof(pointer)) then
 writeln('size of NSSortDescriptor is wrong: ',class_getInstanceSize(TDerivedNSSortDescriptor),' <> ',class_getInstanceSize(NSSortDescriptor)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSSpellServer) <> (class_getInstanceSize(NSSpellServer)+sizeof(pointer)) then
 writeln('size of NSSpellServer is wrong: ',class_getInstanceSize(TDerivedNSSpellServer),' <> ',class_getInstanceSize(NSSpellServer)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSStream) <> (class_getInstanceSize(NSStream)+sizeof(pointer)) then
 writeln('size of NSStream is wrong: ',class_getInstanceSize(TDerivedNSStream),' <> ',class_getInstanceSize(NSStream)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSInputStream) <> (class_getInstanceSize(NSInputStream)+sizeof(pointer)) then
 writeln('size of NSInputStream is wrong: ',class_getInstanceSize(TDerivedNSInputStream),' <> ',class_getInstanceSize(NSInputStream)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSOutputStream) <> (class_getInstanceSize(NSOutputStream)+sizeof(pointer)) then
 writeln('size of NSOutputStream is wrong: ',class_getInstanceSize(TDerivedNSOutputStream),' <> ',class_getInstanceSize(NSOutputStream)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSString) <> (class_getInstanceSize(NSString)+sizeof(pointer)) then
 writeln('size of NSString is wrong: ',class_getInstanceSize(TDerivedNSString),' <> ',class_getInstanceSize(NSString)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSMutableString) <> (class_getInstanceSize(NSMutableString)+sizeof(pointer)) then
 writeln('size of NSMutableString is wrong: ',class_getInstanceSize(TDerivedNSMutableString),' <> ',class_getInstanceSize(NSMutableString)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSSimpleCString) <> (class_getInstanceSize(NSSimpleCString)+sizeof(pointer)) then
 writeln('size of NSSimpleCString is wrong: ',class_getInstanceSize(TDerivedNSSimpleCString),' <> ',class_getInstanceSize(NSSimpleCString)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSTask) <> (class_getInstanceSize(NSTask)+sizeof(pointer)) then
 writeln('size of NSTask is wrong: ',class_getInstanceSize(TDerivedNSTask),' <> ',class_getInstanceSize(NSTask)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSThread) <> (class_getInstanceSize(NSThread)+sizeof(pointer)) then
 writeln('size of NSThread is wrong: ',class_getInstanceSize(TDerivedNSThread),' <> ',class_getInstanceSize(NSThread)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSTimer) <> (class_getInstanceSize(NSTimer)+sizeof(pointer)) then
 writeln('size of NSTimer is wrong: ',class_getInstanceSize(TDerivedNSTimer),' <> ',class_getInstanceSize(NSTimer)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSTimeZone) <> (class_getInstanceSize(NSTimeZone)+sizeof(pointer)) then
 writeln('size of NSTimeZone is wrong: ',class_getInstanceSize(TDerivedNSTimeZone),' <> ',class_getInstanceSize(NSTimeZone)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSUndoManager) <> (class_getInstanceSize(NSUndoManager)+sizeof(pointer)) then
 writeln('size of NSUndoManager is wrong: ',class_getInstanceSize(TDerivedNSUndoManager),' <> ',class_getInstanceSize(NSUndoManager)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSURL) <> (class_getInstanceSize(NSURL)+sizeof(pointer)) then
 writeln('size of NSURL is wrong: ',class_getInstanceSize(TDerivedNSURL),' <> ',class_getInstanceSize(NSURL)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSURLAuthenticationChallenge) <> (class_getInstanceSize(NSURLAuthenticationChallenge)+sizeof(pointer)) then
 writeln('size of NSURLAuthenticationChallenge is wrong: ',class_getInstanceSize(TDerivedNSURLAuthenticationChallenge),' <> ',class_getInstanceSize(NSURLAuthenticationChallenge)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSCachedURLResponse) <> (class_getInstanceSize(NSCachedURLResponse)+sizeof(pointer)) then
 writeln('size of NSCachedURLResponse is wrong: ',class_getInstanceSize(TDerivedNSCachedURLResponse),' <> ',class_getInstanceSize(NSCachedURLResponse)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSURLCache) <> (class_getInstanceSize(NSURLCache)+sizeof(pointer)) then
 writeln('size of NSURLCache is wrong: ',class_getInstanceSize(TDerivedNSURLCache),' <> ',class_getInstanceSize(NSURLCache)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSURLConnection) <> (class_getInstanceSize(NSURLConnection)+sizeof(pointer)) then
 writeln('size of NSURLConnection is wrong: ',class_getInstanceSize(TDerivedNSURLConnection),' <> ',class_getInstanceSize(NSURLConnection)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSURLCredential) <> (class_getInstanceSize(NSURLCredential)+sizeof(pointer)) then
 writeln('size of NSURLCredential is wrong: ',class_getInstanceSize(TDerivedNSURLCredential),' <> ',class_getInstanceSize(NSURLCredential)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSURLCredentialStorage) <> (class_getInstanceSize(NSURLCredentialStorage)+sizeof(pointer)) then
 writeln('size of NSURLCredentialStorage is wrong: ',class_getInstanceSize(TDerivedNSURLCredentialStorage),' <> ',class_getInstanceSize(NSURLCredentialStorage)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSURLDownload) <> (class_getInstanceSize(NSURLDownload)+sizeof(pointer)) then
 writeln('size of NSURLDownload is wrong: ',class_getInstanceSize(TDerivedNSURLDownload),' <> ',class_getInstanceSize(NSURLDownload)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSURLHandle) <> (class_getInstanceSize(NSURLHandle)+sizeof(pointer)) then
 writeln('size of NSURLHandle is wrong: ',class_getInstanceSize(TDerivedNSURLHandle),' <> ',class_getInstanceSize(NSURLHandle)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSURLProtectionSpace) <> (class_getInstanceSize(NSURLProtectionSpace)+sizeof(pointer)) then
 writeln('size of NSURLProtectionSpace is wrong: ',class_getInstanceSize(TDerivedNSURLProtectionSpace),' <> ',class_getInstanceSize(NSURLProtectionSpace)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSURLProtocol) <> (class_getInstanceSize(NSURLProtocol)+sizeof(pointer)) then
 writeln('size of NSURLProtocol is wrong: ',class_getInstanceSize(TDerivedNSURLProtocol),' <> ',class_getInstanceSize(NSURLProtocol)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSURLRequest) <> (class_getInstanceSize(NSURLRequest)+sizeof(pointer)) then
 writeln('size of NSURLRequest is wrong: ',class_getInstanceSize(TDerivedNSURLRequest),' <> ',class_getInstanceSize(NSURLRequest)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSMutableURLRequest) <> (class_getInstanceSize(NSMutableURLRequest)+sizeof(pointer)) then
 writeln('size of NSMutableURLRequest is wrong: ',class_getInstanceSize(TDerivedNSMutableURLRequest),' <> ',class_getInstanceSize(NSMutableURLRequest)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSURLResponse) <> (class_getInstanceSize(NSURLResponse)+sizeof(pointer)) then
 writeln('size of NSURLResponse is wrong: ',class_getInstanceSize(TDerivedNSURLResponse),' <> ',class_getInstanceSize(NSURLResponse)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSHTTPURLResponse) <> (class_getInstanceSize(NSHTTPURLResponse)+sizeof(pointer)) then
 writeln('size of NSHTTPURLResponse is wrong: ',class_getInstanceSize(TDerivedNSHTTPURLResponse),' <> ',class_getInstanceSize(NSHTTPURLResponse)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSUserDefaults) <> (class_getInstanceSize(NSUserDefaults)+sizeof(pointer)) then
 writeln('size of NSUserDefaults is wrong: ',class_getInstanceSize(TDerivedNSUserDefaults),' <> ',class_getInstanceSize(NSUserDefaults)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSValue) <> (class_getInstanceSize(NSValue)+sizeof(pointer)) then
 writeln('size of NSValue is wrong: ',class_getInstanceSize(TDerivedNSValue),' <> ',class_getInstanceSize(NSValue)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSNumber) <> (class_getInstanceSize(NSNumber)+sizeof(pointer)) then
 writeln('size of NSNumber is wrong: ',class_getInstanceSize(TDerivedNSNumber),' <> ',class_getInstanceSize(NSNumber)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSValueTransformer) <> (class_getInstanceSize(NSValueTransformer)+sizeof(pointer)) then
 writeln('size of NSValueTransformer is wrong: ',class_getInstanceSize(TDerivedNSValueTransformer),' <> ',class_getInstanceSize(NSValueTransformer)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSXMLDocument) <> (class_getInstanceSize(NSXMLDocument)+sizeof(pointer)) then
 writeln('size of NSXMLDocument is wrong: ',class_getInstanceSize(TDerivedNSXMLDocument),' <> ',class_getInstanceSize(NSXMLDocument)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSXMLDTD) <> (class_getInstanceSize(NSXMLDTD)+sizeof(pointer)) then
 writeln('size of NSXMLDTD is wrong: ',class_getInstanceSize(TDerivedNSXMLDTD),' <> ',class_getInstanceSize(NSXMLDTD)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSXMLDTDNode) <> (class_getInstanceSize(NSXMLDTDNode)+sizeof(pointer)) then
 writeln('size of NSXMLDTDNode is wrong: ',class_getInstanceSize(TDerivedNSXMLDTDNode),' <> ',class_getInstanceSize(NSXMLDTDNode)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSXMLElement) <> (class_getInstanceSize(NSXMLElement)+sizeof(pointer)) then
 writeln('size of NSXMLElement is wrong: ',class_getInstanceSize(TDerivedNSXMLElement),' <> ',class_getInstanceSize(NSXMLElement)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSXMLNode) <> (class_getInstanceSize(NSXMLNode)+sizeof(pointer)) then
 writeln('size of NSXMLNode is wrong: ',class_getInstanceSize(TDerivedNSXMLNode),' <> ',class_getInstanceSize(NSXMLNode)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSXMLParser) <> (class_getInstanceSize(NSXMLParser)+sizeof(pointer)) then
 writeln('size of NSXMLParser is wrong: ',class_getInstanceSize(TDerivedNSXMLParser),' <> ',class_getInstanceSize(NSXMLParser)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSActionCell) <> (class_getInstanceSize(NSActionCell)+sizeof(pointer)) then
 writeln('size of NSActionCell is wrong: ',class_getInstanceSize(TDerivedNSActionCell),' <> ',class_getInstanceSize(NSActionCell)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSAlert) <> (class_getInstanceSize(NSAlert)+sizeof(pointer)) then
 writeln('size of NSAlert is wrong: ',class_getInstanceSize(TDerivedNSAlert),' <> ',class_getInstanceSize(NSAlert)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSAnimation) <> (class_getInstanceSize(NSAnimation)+sizeof(pointer)) then
 writeln('size of NSAnimation is wrong: ',class_getInstanceSize(TDerivedNSAnimation),' <> ',class_getInstanceSize(NSAnimation)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSViewAnimation) <> (class_getInstanceSize(NSViewAnimation)+sizeof(pointer)) then
 writeln('size of NSViewAnimation is wrong: ',class_getInstanceSize(TDerivedNSViewAnimation),' <> ',class_getInstanceSize(NSViewAnimation)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSAnimationContext) <> (class_getInstanceSize(NSAnimationContext)+sizeof(pointer)) then
 writeln('size of NSAnimationContext is wrong: ',class_getInstanceSize(TDerivedNSAnimationContext),' <> ',class_getInstanceSize(NSAnimationContext)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSApplication) <> (class_getInstanceSize(NSApplication)+sizeof(pointer)) then
 writeln('size of NSApplication is wrong: ',class_getInstanceSize(TDerivedNSApplication),' <> ',class_getInstanceSize(NSApplication)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSArrayController) <> (class_getInstanceSize(NSArrayController)+sizeof(pointer)) then
 writeln('size of NSArrayController is wrong: ',class_getInstanceSize(TDerivedNSArrayController),' <> ',class_getInstanceSize(NSArrayController)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSATSTypesetter) <> (class_getInstanceSize(NSATSTypesetter)+sizeof(pointer)) then
 writeln('size of NSATSTypesetter is wrong: ',class_getInstanceSize(TDerivedNSATSTypesetter),' <> ',class_getInstanceSize(NSATSTypesetter)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSBezierPath) <> (class_getInstanceSize(NSBezierPath)+sizeof(pointer)) then
 writeln('size of NSBezierPath is wrong: ',class_getInstanceSize(TDerivedNSBezierPath),' <> ',class_getInstanceSize(NSBezierPath)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSBitmapImageRep) <> (class_getInstanceSize(NSBitmapImageRep)+sizeof(pointer)) then
 writeln('size of NSBitmapImageRep is wrong: ',class_getInstanceSize(TDerivedNSBitmapImageRep),' <> ',class_getInstanceSize(NSBitmapImageRep)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSBox) <> (class_getInstanceSize(NSBox)+sizeof(pointer)) then
 writeln('size of NSBox is wrong: ',class_getInstanceSize(TDerivedNSBox),' <> ',class_getInstanceSize(NSBox)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSBrowser) <> (class_getInstanceSize(NSBrowser)+sizeof(pointer)) then
 writeln('size of NSBrowser is wrong: ',class_getInstanceSize(TDerivedNSBrowser),' <> ',class_getInstanceSize(NSBrowser)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSBrowserCell) <> (class_getInstanceSize(NSBrowserCell)+sizeof(pointer)) then
 writeln('size of NSBrowserCell is wrong: ',class_getInstanceSize(TDerivedNSBrowserCell),' <> ',class_getInstanceSize(NSBrowserCell)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSButton) <> (class_getInstanceSize(NSButton)+sizeof(pointer)) then
 writeln('size of NSButton is wrong: ',class_getInstanceSize(TDerivedNSButton),' <> ',class_getInstanceSize(NSButton)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSButtonCell) <> (class_getInstanceSize(NSButtonCell)+sizeof(pointer)) then
 writeln('size of NSButtonCell is wrong: ',class_getInstanceSize(TDerivedNSButtonCell),' <> ',class_getInstanceSize(NSButtonCell)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSCachedImageRep) <> (class_getInstanceSize(NSCachedImageRep)+sizeof(pointer)) then
 writeln('size of NSCachedImageRep is wrong: ',class_getInstanceSize(TDerivedNSCachedImageRep),' <> ',class_getInstanceSize(NSCachedImageRep)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSCell) <> (class_getInstanceSize(NSCell)+sizeof(pointer)) then
 writeln('size of NSCell is wrong: ',class_getInstanceSize(TDerivedNSCell),' <> ',class_getInstanceSize(NSCell)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSCIImageRep) <> (class_getInstanceSize(NSCIImageRep)+sizeof(pointer)) then
 writeln('size of NSCIImageRep is wrong: ',class_getInstanceSize(TDerivedNSCIImageRep),' <> ',class_getInstanceSize(NSCIImageRep)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSClipView) <> (class_getInstanceSize(NSClipView)+sizeof(pointer)) then
 writeln('size of NSClipView is wrong: ',class_getInstanceSize(TDerivedNSClipView),' <> ',class_getInstanceSize(NSClipView)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSCollectionViewItem) <> (class_getInstanceSize(NSCollectionViewItem)+sizeof(pointer)) then
 writeln('size of NSCollectionViewItem is wrong: ',class_getInstanceSize(TDerivedNSCollectionViewItem),' <> ',class_getInstanceSize(NSCollectionViewItem)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSCollectionView) <> (class_getInstanceSize(NSCollectionView)+sizeof(pointer)) then
 writeln('size of NSCollectionView is wrong: ',class_getInstanceSize(TDerivedNSCollectionView),' <> ',class_getInstanceSize(NSCollectionView)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSColor) <> (class_getInstanceSize(NSColor)+sizeof(pointer)) then
 writeln('size of NSColor is wrong: ',class_getInstanceSize(TDerivedNSColor),' <> ',class_getInstanceSize(NSColor)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSColorList) <> (class_getInstanceSize(NSColorList)+sizeof(pointer)) then
 writeln('size of NSColorList is wrong: ',class_getInstanceSize(TDerivedNSColorList),' <> ',class_getInstanceSize(NSColorList)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSColorPanel) <> (class_getInstanceSize(NSColorPanel)+sizeof(pointer)) then
 writeln('size of NSColorPanel is wrong: ',class_getInstanceSize(TDerivedNSColorPanel),' <> ',class_getInstanceSize(NSColorPanel)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSColorPicker) <> (class_getInstanceSize(NSColorPicker)+sizeof(pointer)) then
 writeln('size of NSColorPicker is wrong: ',class_getInstanceSize(TDerivedNSColorPicker),' <> ',class_getInstanceSize(NSColorPicker)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSColorSpace) <> (class_getInstanceSize(NSColorSpace)+sizeof(pointer)) then
 writeln('size of NSColorSpace is wrong: ',class_getInstanceSize(TDerivedNSColorSpace),' <> ',class_getInstanceSize(NSColorSpace)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSColorWell) <> (class_getInstanceSize(NSColorWell)+sizeof(pointer)) then
 writeln('size of NSColorWell is wrong: ',class_getInstanceSize(TDerivedNSColorWell),' <> ',class_getInstanceSize(NSColorWell)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSComboBox) <> (class_getInstanceSize(NSComboBox)+sizeof(pointer)) then
 writeln('size of NSComboBox is wrong: ',class_getInstanceSize(TDerivedNSComboBox),' <> ',class_getInstanceSize(NSComboBox)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSComboBoxCell) <> (class_getInstanceSize(NSComboBoxCell)+sizeof(pointer)) then
 writeln('size of NSComboBoxCell is wrong: ',class_getInstanceSize(TDerivedNSComboBoxCell),' <> ',class_getInstanceSize(NSComboBoxCell)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSControl) <> (class_getInstanceSize(NSControl)+sizeof(pointer)) then
 writeln('size of NSControl is wrong: ',class_getInstanceSize(TDerivedNSControl),' <> ',class_getInstanceSize(NSControl)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSController) <> (class_getInstanceSize(NSController)+sizeof(pointer)) then
 writeln('size of NSController is wrong: ',class_getInstanceSize(TDerivedNSController),' <> ',class_getInstanceSize(NSController)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSCursor) <> (class_getInstanceSize(NSCursor)+sizeof(pointer)) then
 writeln('size of NSCursor is wrong: ',class_getInstanceSize(TDerivedNSCursor),' <> ',class_getInstanceSize(NSCursor)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSCustomImageRep) <> (class_getInstanceSize(NSCustomImageRep)+sizeof(pointer)) then
 writeln('size of NSCustomImageRep is wrong: ',class_getInstanceSize(TDerivedNSCustomImageRep),' <> ',class_getInstanceSize(NSCustomImageRep)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSDatePicker) <> (class_getInstanceSize(NSDatePicker)+sizeof(pointer)) then
 writeln('size of NSDatePicker is wrong: ',class_getInstanceSize(TDerivedNSDatePicker),' <> ',class_getInstanceSize(NSDatePicker)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSDatePickerCell) <> (class_getInstanceSize(NSDatePickerCell)+sizeof(pointer)) then
 writeln('size of NSDatePickerCell is wrong: ',class_getInstanceSize(TDerivedNSDatePickerCell),' <> ',class_getInstanceSize(NSDatePickerCell)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSDictionaryController) <> (class_getInstanceSize(NSDictionaryController)+sizeof(pointer)) then
 writeln('size of NSDictionaryController is wrong: ',class_getInstanceSize(TDerivedNSDictionaryController),' <> ',class_getInstanceSize(NSDictionaryController)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSDockTile) <> (class_getInstanceSize(NSDockTile)+sizeof(pointer)) then
 writeln('size of NSDockTile is wrong: ',class_getInstanceSize(TDerivedNSDockTile),' <> ',class_getInstanceSize(NSDockTile)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSDocument) <> (class_getInstanceSize(NSDocument)+sizeof(pointer)) then
 writeln('size of NSDocument is wrong: ',class_getInstanceSize(TDerivedNSDocument),' <> ',class_getInstanceSize(NSDocument)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSDocumentController) <> (class_getInstanceSize(NSDocumentController)+sizeof(pointer)) then
 writeln('size of NSDocumentController is wrong: ',class_getInstanceSize(TDerivedNSDocumentController),' <> ',class_getInstanceSize(NSDocumentController)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSDrawer) <> (class_getInstanceSize(NSDrawer)+sizeof(pointer)) then
 writeln('size of NSDrawer is wrong: ',class_getInstanceSize(TDerivedNSDrawer),' <> ',class_getInstanceSize(NSDrawer)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSEPSImageRep) <> (class_getInstanceSize(NSEPSImageRep)+sizeof(pointer)) then
 writeln('size of NSEPSImageRep is wrong: ',class_getInstanceSize(TDerivedNSEPSImageRep),' <> ',class_getInstanceSize(NSEPSImageRep)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSEvent) <> (class_getInstanceSize(NSEvent)+sizeof(pointer)) then
 writeln('size of NSEvent is wrong: ',class_getInstanceSize(TDerivedNSEvent),' <> ',class_getInstanceSize(NSEvent)+sizeof(pointer));
 writeln(sizeof(__VFlags));
 if class_getInstanceSize(TDerivedNSFileWrapper) <> (class_getInstanceSize(NSFileWrapper)+sizeof(pointer)) then
 writeln('size of NSFileWrapper is wrong: ',class_getInstanceSize(TDerivedNSFileWrapper),' <> ',class_getInstanceSize(NSFileWrapper)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSFont) <> (class_getInstanceSize(NSFont)+sizeof(pointer)) then
 writeln('size of NSFont is wrong: ',class_getInstanceSize(TDerivedNSFont),' <> ',class_getInstanceSize(NSFont)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSFontDescriptor) <> (class_getInstanceSize(NSFontDescriptor)+sizeof(pointer)) then
 writeln('size of NSFontDescriptor is wrong: ',class_getInstanceSize(TDerivedNSFontDescriptor),' <> ',class_getInstanceSize(NSFontDescriptor)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSFontManager) <> (class_getInstanceSize(NSFontManager)+sizeof(pointer)) then
 writeln('size of NSFontManager is wrong: ',class_getInstanceSize(TDerivedNSFontManager),' <> ',class_getInstanceSize(NSFontManager)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSFontPanel) <> (class_getInstanceSize(NSFontPanel)+sizeof(pointer)) then
 writeln('size of NSFontPanel is wrong: ',class_getInstanceSize(TDerivedNSFontPanel),' <> ',class_getInstanceSize(NSFontPanel)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSFormCell) <> (class_getInstanceSize(NSFormCell)+sizeof(pointer)) then
 writeln('size of NSFormCell is wrong: ',class_getInstanceSize(TDerivedNSFormCell),' <> ',class_getInstanceSize(NSFormCell)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSGlyphGenerator) <> (class_getInstanceSize(NSGlyphGenerator)+sizeof(pointer)) then
 writeln('size of NSGlyphGenerator is wrong: ',class_getInstanceSize(TDerivedNSGlyphGenerator),' <> ',class_getInstanceSize(NSGlyphGenerator)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSGlyphInfo) <> (class_getInstanceSize(NSGlyphInfo)+sizeof(pointer)) then
 writeln('size of NSGlyphInfo is wrong: ',class_getInstanceSize(TDerivedNSGlyphInfo),' <> ',class_getInstanceSize(NSGlyphInfo)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSGradient) <> (class_getInstanceSize(NSGradient)+sizeof(pointer)) then
 writeln('size of NSGradient is wrong: ',class_getInstanceSize(TDerivedNSGradient),' <> ',class_getInstanceSize(NSGradient)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSGraphicsContext) <> (class_getInstanceSize(NSGraphicsContext)+sizeof(pointer)) then
 writeln('size of NSGraphicsContext is wrong: ',class_getInstanceSize(TDerivedNSGraphicsContext),' <> ',class_getInstanceSize(NSGraphicsContext)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSHelpManager) <> (class_getInstanceSize(NSHelpManager)+sizeof(pointer)) then
 writeln('size of NSHelpManager is wrong: ',class_getInstanceSize(TDerivedNSHelpManager),' <> ',class_getInstanceSize(NSHelpManager)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSImage) <> (class_getInstanceSize(NSImage)+sizeof(pointer)) then
 writeln('size of NSImage is wrong: ',class_getInstanceSize(TDerivedNSImage),' <> ',class_getInstanceSize(NSImage)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSImageCell) <> (class_getInstanceSize(NSImageCell)+sizeof(pointer)) then
 writeln('size of NSImageCell is wrong: ',class_getInstanceSize(TDerivedNSImageCell),' <> ',class_getInstanceSize(NSImageCell)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSImageRep) <> (class_getInstanceSize(NSImageRep)+sizeof(pointer)) then
 writeln('size of NSImageRep is wrong: ',class_getInstanceSize(TDerivedNSImageRep),' <> ',class_getInstanceSize(NSImageRep)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSImageView) <> (class_getInstanceSize(NSImageView)+sizeof(pointer)) then
 writeln('size of NSImageView is wrong: ',class_getInstanceSize(TDerivedNSImageView),' <> ',class_getInstanceSize(NSImageView)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSInputManager) <> (class_getInstanceSize(NSInputManager)+sizeof(pointer)) then
 writeln('size of NSInputManager is wrong: ',class_getInstanceSize(TDerivedNSInputManager),' <> ',class_getInstanceSize(NSInputManager)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSInputServer) <> (class_getInstanceSize(NSInputServer)+sizeof(pointer)) then
 writeln('size of NSInputServer is wrong: ',class_getInstanceSize(TDerivedNSInputServer),' <> ',class_getInstanceSize(NSInputServer)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSLayoutManager) <> (class_getInstanceSize(NSLayoutManager)+sizeof(pointer)) then
 writeln('size of NSLayoutManager is wrong: ',class_getInstanceSize(TDerivedNSLayoutManager),' <> ',class_getInstanceSize(NSLayoutManager)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSLevelIndicator) <> (class_getInstanceSize(NSLevelIndicator)+sizeof(pointer)) then
 writeln('size of NSLevelIndicator is wrong: ',class_getInstanceSize(TDerivedNSLevelIndicator),' <> ',class_getInstanceSize(NSLevelIndicator)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSLevelIndicatorCell) <> (class_getInstanceSize(NSLevelIndicatorCell)+sizeof(pointer)) then
 writeln('size of NSLevelIndicatorCell is wrong: ',class_getInstanceSize(TDerivedNSLevelIndicatorCell),' <> ',class_getInstanceSize(NSLevelIndicatorCell)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSMatrix) <> (class_getInstanceSize(NSMatrix)+sizeof(pointer)) then
 writeln('size of NSMatrix is wrong: ',class_getInstanceSize(TDerivedNSMatrix),' <> ',class_getInstanceSize(NSMatrix)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSMenu) <> (class_getInstanceSize(NSMenu)+sizeof(pointer)) then
 writeln('size of NSMenu is wrong: ',class_getInstanceSize(TDerivedNSMenu),' <> ',class_getInstanceSize(NSMenu)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSMenuItem) <> (class_getInstanceSize(NSMenuItem)+sizeof(pointer)) then
 writeln('size of NSMenuItem is wrong: ',class_getInstanceSize(TDerivedNSMenuItem),' <> ',class_getInstanceSize(NSMenuItem)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSMenuItemCell) <> (class_getInstanceSize(NSMenuItemCell)+sizeof(pointer)) then
 writeln('size of NSMenuItemCell is wrong: ',class_getInstanceSize(TDerivedNSMenuItemCell),' <> ',class_getInstanceSize(NSMenuItemCell)+sizeof(pointer));
 {$ifndef cpu64}
 if class_getInstanceSize(TDerivedNSMenuView) <> (class_getInstanceSize(NSMenuView)+sizeof(pointer)) then
 writeln('size of NSMenuView is wrong: ',class_getInstanceSize(TDerivedNSMenuView),' <> ',class_getInstanceSize(NSMenuView)+sizeof(pointer));
 {$endif}
 if class_getInstanceSize(TDerivedNSMovie) <> (class_getInstanceSize(NSMovie)+sizeof(pointer)) then
 writeln('size of NSMovie is wrong: ',class_getInstanceSize(TDerivedNSMovie),' <> ',class_getInstanceSize(NSMovie)+sizeof(pointer));
 {$ifndef cpu64}
 if class_getInstanceSize(TDerivedNSMovieView) <> (class_getInstanceSize(NSMovieView)+sizeof(pointer)) then
 writeln('size of NSMovieView is wrong: ',class_getInstanceSize(TDerivedNSMovieView),' <> ',class_getInstanceSize(NSMovieView)+sizeof(pointer));
 {$endif}
 if class_getInstanceSize(TDerivedNSNib) <> (class_getInstanceSize(NSNib)+sizeof(pointer)) then
 writeln('size of NSNib is wrong: ',class_getInstanceSize(TDerivedNSNib),' <> ',class_getInstanceSize(NSNib)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSObjectController) <> (class_getInstanceSize(NSObjectController)+sizeof(pointer)) then
 writeln('size of NSObjectController is wrong: ',class_getInstanceSize(TDerivedNSObjectController),' <> ',class_getInstanceSize(NSObjectController)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSOpenGLPixelFormat) <> (class_getInstanceSize(NSOpenGLPixelFormat)+sizeof(pointer)) then
 writeln('size of NSOpenGLPixelFormat is wrong: ',class_getInstanceSize(TDerivedNSOpenGLPixelFormat),' <> ',class_getInstanceSize(NSOpenGLPixelFormat)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSOpenGLPixelBuffer) <> (class_getInstanceSize(NSOpenGLPixelBuffer)+sizeof(pointer)) then
 writeln('size of NSOpenGLPixelBuffer is wrong: ',class_getInstanceSize(TDerivedNSOpenGLPixelBuffer),' <> ',class_getInstanceSize(NSOpenGLPixelBuffer)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSOpenGLContext) <> (class_getInstanceSize(NSOpenGLContext)+sizeof(pointer)) then
 writeln('size of NSOpenGLContext is wrong: ',class_getInstanceSize(TDerivedNSOpenGLContext),' <> ',class_getInstanceSize(NSOpenGLContext)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSOpenGLView) <> (class_getInstanceSize(NSOpenGLView)+sizeof(pointer)) then
 writeln('size of NSOpenGLView is wrong: ',class_getInstanceSize(TDerivedNSOpenGLView),' <> ',class_getInstanceSize(NSOpenGLView)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSOpenPanel) <> (class_getInstanceSize(NSOpenPanel)+sizeof(pointer)) then
 writeln('size of NSOpenPanel is wrong: ',class_getInstanceSize(TDerivedNSOpenPanel),' <> ',class_getInstanceSize(NSOpenPanel)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSOutlineView) <> (class_getInstanceSize(NSOutlineView)+sizeof(pointer)) then
 writeln('size of NSOutlineView is wrong: ',class_getInstanceSize(TDerivedNSOutlineView),' <> ',class_getInstanceSize(NSOutlineView)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSPageLayout) <> (class_getInstanceSize(NSPageLayout)+sizeof(pointer)) then
 writeln('size of NSPageLayout is wrong: ',class_getInstanceSize(TDerivedNSPageLayout),' <> ',class_getInstanceSize(NSPageLayout)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSPanel) <> (class_getInstanceSize(NSPanel)+sizeof(pointer)) then
 writeln('size of NSPanel is wrong: ',class_getInstanceSize(TDerivedNSPanel),' <> ',class_getInstanceSize(NSPanel)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSTextTab) <> (class_getInstanceSize(NSTextTab)+sizeof(pointer)) then
 writeln('size of NSTextTab is wrong: ',class_getInstanceSize(TDerivedNSTextTab),' <> ',class_getInstanceSize(NSTextTab)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSParagraphStyle) <> (class_getInstanceSize(NSParagraphStyle)+sizeof(pointer)) then
 writeln('size of NSParagraphStyle is wrong: ',class_getInstanceSize(TDerivedNSParagraphStyle),' <> ',class_getInstanceSize(NSParagraphStyle)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSMutableParagraphStyle) <> (class_getInstanceSize(NSMutableParagraphStyle)+sizeof(pointer)) then
 writeln('size of NSMutableParagraphStyle is wrong: ',class_getInstanceSize(TDerivedNSMutableParagraphStyle),' <> ',class_getInstanceSize(NSMutableParagraphStyle)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSPasteboard) <> (class_getInstanceSize(NSPasteboard)+sizeof(pointer)) then
 writeln('size of NSPasteboard is wrong: ',class_getInstanceSize(TDerivedNSPasteboard),' <> ',class_getInstanceSize(NSPasteboard)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSPathCell) <> (class_getInstanceSize(NSPathCell)+sizeof(pointer)) then
 writeln('size of NSPathCell is wrong: ',class_getInstanceSize(TDerivedNSPathCell),' <> ',class_getInstanceSize(NSPathCell)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSPathComponentCell) <> (class_getInstanceSize(NSPathComponentCell)+sizeof(pointer)) then
 writeln('size of NSPathComponentCell is wrong: ',class_getInstanceSize(TDerivedNSPathComponentCell),' <> ',class_getInstanceSize(NSPathComponentCell)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSPathControl) <> (class_getInstanceSize(NSPathControl)+sizeof(pointer)) then
 writeln('size of NSPathControl is wrong: ',class_getInstanceSize(TDerivedNSPathControl),' <> ',class_getInstanceSize(NSPathControl)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSPDFImageRep) <> (class_getInstanceSize(NSPDFImageRep)+sizeof(pointer)) then
 writeln('size of NSPDFImageRep is wrong: ',class_getInstanceSize(TDerivedNSPDFImageRep),' <> ',class_getInstanceSize(NSPDFImageRep)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSPersistentDocument) <> (class_getInstanceSize(NSPersistentDocument)+sizeof(pointer)) then
 writeln('size of NSPersistentDocument is wrong: ',class_getInstanceSize(TDerivedNSPersistentDocument),' <> ',class_getInstanceSize(NSPersistentDocument)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSPICTImageRep) <> (class_getInstanceSize(NSPICTImageRep)+sizeof(pointer)) then
 writeln('size of NSPICTImageRep is wrong: ',class_getInstanceSize(TDerivedNSPICTImageRep),' <> ',class_getInstanceSize(NSPICTImageRep)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSPopUpButton) <> (class_getInstanceSize(NSPopUpButton)+sizeof(pointer)) then
 writeln('size of NSPopUpButton is wrong: ',class_getInstanceSize(TDerivedNSPopUpButton),' <> ',class_getInstanceSize(NSPopUpButton)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSPopUpButtonCell) <> (class_getInstanceSize(NSPopUpButtonCell)+sizeof(pointer)) then
 writeln('size of NSPopUpButtonCell is wrong: ',class_getInstanceSize(TDerivedNSPopUpButtonCell),' <> ',class_getInstanceSize(NSPopUpButtonCell)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSPredicateEditor) <> (class_getInstanceSize(NSPredicateEditor)+sizeof(pointer)) then
 writeln('size of NSPredicateEditor is wrong: ',class_getInstanceSize(TDerivedNSPredicateEditor),' <> ',class_getInstanceSize(NSPredicateEditor)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSPrinter) <> (class_getInstanceSize(NSPrinter)+sizeof(pointer)) then
 writeln('size of NSPrinter is wrong: ',class_getInstanceSize(TDerivedNSPrinter),' <> ',class_getInstanceSize(NSPrinter)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSPrintInfo) <> (class_getInstanceSize(NSPrintInfo)+sizeof(pointer)) then
 writeln('size of NSPrintInfo is wrong: ',class_getInstanceSize(TDerivedNSPrintInfo),' <> ',class_getInstanceSize(NSPrintInfo)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSPrintOperation) <> (class_getInstanceSize(NSPrintOperation)+sizeof(pointer)) then
 writeln('size of NSPrintOperation is wrong: ',class_getInstanceSize(TDerivedNSPrintOperation),' <> ',class_getInstanceSize(NSPrintOperation)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSPrintPanel) <> (class_getInstanceSize(NSPrintPanel)+sizeof(pointer)) then
 writeln('size of NSPrintPanel is wrong: ',class_getInstanceSize(TDerivedNSPrintPanel),' <> ',class_getInstanceSize(NSPrintPanel)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSProgressIndicator) <> (class_getInstanceSize(NSProgressIndicator)+sizeof(pointer)) then
 writeln('size of NSProgressIndicator is wrong: ',class_getInstanceSize(TDerivedNSProgressIndicator),' <> ',class_getInstanceSize(NSProgressIndicator)+sizeof(pointer));
 {$ifndef cpu64}
 if class_getInstanceSize(TDerivedNSQuickDrawView) <> (class_getInstanceSize(NSQuickDrawView)+sizeof(pointer)) then
 writeln('size of NSQuickDrawView is wrong: ',class_getInstanceSize(TDerivedNSQuickDrawView),' <> ',class_getInstanceSize(NSQuickDrawView)+sizeof(pointer));
 {$endif}
 if class_getInstanceSize(TDerivedNSResponder) <> (class_getInstanceSize(NSResponder)+sizeof(pointer)) then
 writeln('size of NSResponder is wrong: ',class_getInstanceSize(TDerivedNSResponder),' <> ',class_getInstanceSize(NSResponder)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSRuleEditor) <> (class_getInstanceSize(NSRuleEditor)+sizeof(pointer)) then
 writeln('size of NSRuleEditor is wrong: ',class_getInstanceSize(TDerivedNSRuleEditor),' <> ',class_getInstanceSize(NSRuleEditor)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSRulerMarker) <> (class_getInstanceSize(NSRulerMarker)+sizeof(pointer)) then
 writeln('size of NSRulerMarker is wrong: ',class_getInstanceSize(TDerivedNSRulerMarker),' <> ',class_getInstanceSize(NSRulerMarker)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSRulerView) <> (class_getInstanceSize(NSRulerView)+sizeof(pointer)) then
 writeln('size of NSRulerView is wrong: ',class_getInstanceSize(TDerivedNSRulerView),' <> ',class_getInstanceSize(NSRulerView)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSSavePanel) <> (class_getInstanceSize(NSSavePanel)+sizeof(pointer)) then
 writeln('size of NSSavePanel is wrong: ',class_getInstanceSize(TDerivedNSSavePanel),' <> ',class_getInstanceSize(NSSavePanel)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSScreen) <> (class_getInstanceSize(NSScreen)+sizeof(pointer)) then
 writeln('size of NSScreen is wrong: ',class_getInstanceSize(TDerivedNSScreen),' <> ',class_getInstanceSize(NSScreen)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSScroller) <> (class_getInstanceSize(NSScroller)+sizeof(pointer)) then
 writeln('size of NSScroller is wrong: ',class_getInstanceSize(TDerivedNSScroller),' <> ',class_getInstanceSize(NSScroller)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSScrollView) <> (class_getInstanceSize(NSScrollView)+sizeof(pointer)) then
 writeln('size of NSScrollView is wrong: ',class_getInstanceSize(TDerivedNSScrollView),' <> ',class_getInstanceSize(NSScrollView)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSSearchField) <> (class_getInstanceSize(NSSearchField)+sizeof(pointer)) then
 writeln('size of NSSearchField is wrong: ',class_getInstanceSize(TDerivedNSSearchField),' <> ',class_getInstanceSize(NSSearchField)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSSearchFieldCell) <> (class_getInstanceSize(NSSearchFieldCell)+sizeof(pointer)) then
 writeln('size of NSSearchFieldCell is wrong: ',class_getInstanceSize(TDerivedNSSearchFieldCell),' <> ',class_getInstanceSize(NSSearchFieldCell)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSSecureTextField) <> (class_getInstanceSize(NSSecureTextField)+sizeof(pointer)) then
 writeln('size of NSSecureTextField is wrong: ',class_getInstanceSize(TDerivedNSSecureTextField),' <> ',class_getInstanceSize(NSSecureTextField)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSSecureTextFieldCell) <> (class_getInstanceSize(NSSecureTextFieldCell)+sizeof(pointer)) then
 writeln('size of NSSecureTextFieldCell is wrong: ',class_getInstanceSize(TDerivedNSSecureTextFieldCell),' <> ',class_getInstanceSize(NSSecureTextFieldCell)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSSegmentedControl) <> (class_getInstanceSize(NSSegmentedControl)+sizeof(pointer)) then
 writeln('size of NSSegmentedControl is wrong: ',class_getInstanceSize(TDerivedNSSegmentedControl),' <> ',class_getInstanceSize(NSSegmentedControl)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSShadow) <> (class_getInstanceSize(NSShadow)+sizeof(pointer)) then
 writeln('size of NSShadow is wrong: ',class_getInstanceSize(TDerivedNSShadow),' <> ',class_getInstanceSize(NSShadow)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSSlider) <> (class_getInstanceSize(NSSlider)+sizeof(pointer)) then
 writeln('size of NSSlider is wrong: ',class_getInstanceSize(TDerivedNSSlider),' <> ',class_getInstanceSize(NSSlider)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSSliderCell) <> (class_getInstanceSize(NSSliderCell)+sizeof(pointer)) then
 writeln('size of NSSliderCell is wrong: ',class_getInstanceSize(TDerivedNSSliderCell),' <> ',class_getInstanceSize(NSSliderCell)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSSound) <> (class_getInstanceSize(NSSound)+sizeof(pointer)) then
 writeln('size of NSSound is wrong: ',class_getInstanceSize(TDerivedNSSound),' <> ',class_getInstanceSize(NSSound)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSSpeechRecognizer) <> (class_getInstanceSize(NSSpeechRecognizer)+sizeof(pointer)) then
 writeln('size of NSSpeechRecognizer is wrong: ',class_getInstanceSize(TDerivedNSSpeechRecognizer),' <> ',class_getInstanceSize(NSSpeechRecognizer)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSSpeechSynthesizer) <> (class_getInstanceSize(NSSpeechSynthesizer)+sizeof(pointer)) then
 writeln('size of NSSpeechSynthesizer is wrong: ',class_getInstanceSize(TDerivedNSSpeechSynthesizer),' <> ',class_getInstanceSize(NSSpeechSynthesizer)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSSpellChecker) <> (class_getInstanceSize(NSSpellChecker)+sizeof(pointer)) then
 writeln('size of NSSpellChecker is wrong: ',class_getInstanceSize(TDerivedNSSpellChecker),' <> ',class_getInstanceSize(NSSpellChecker)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSSplitView) <> (class_getInstanceSize(NSSplitView)+sizeof(pointer)) then
 writeln('size of NSSplitView is wrong: ',class_getInstanceSize(TDerivedNSSplitView),' <> ',class_getInstanceSize(NSSplitView)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSStatusBar) <> (class_getInstanceSize(NSStatusBar)+sizeof(pointer)) then
 writeln('size of NSStatusBar is wrong: ',class_getInstanceSize(TDerivedNSStatusBar),' <> ',class_getInstanceSize(NSStatusBar)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSStatusItem) <> (class_getInstanceSize(NSStatusItem)+sizeof(pointer)) then
 writeln('size of NSStatusItem is wrong: ',class_getInstanceSize(TDerivedNSStatusItem),' <> ',class_getInstanceSize(NSStatusItem)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSStepper) <> (class_getInstanceSize(NSStepper)+sizeof(pointer)) then
 writeln('size of NSStepper is wrong: ',class_getInstanceSize(TDerivedNSStepper),' <> ',class_getInstanceSize(NSStepper)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSStepperCell) <> (class_getInstanceSize(NSStepperCell)+sizeof(pointer)) then
 writeln('size of NSStepperCell is wrong: ',class_getInstanceSize(TDerivedNSStepperCell),' <> ',class_getInstanceSize(NSStepperCell)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSTableColumn) <> (class_getInstanceSize(NSTableColumn)+sizeof(pointer)) then
 writeln('size of NSTableColumn is wrong: ',class_getInstanceSize(TDerivedNSTableColumn),' <> ',class_getInstanceSize(NSTableColumn)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSTableHeaderCell) <> (class_getInstanceSize(NSTableHeaderCell)+sizeof(pointer)) then
 writeln('size of NSTableHeaderCell is wrong: ',class_getInstanceSize(TDerivedNSTableHeaderCell),' <> ',class_getInstanceSize(NSTableHeaderCell)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSTableHeaderView) <> (class_getInstanceSize(NSTableHeaderView)+sizeof(pointer)) then
 writeln('size of NSTableHeaderView is wrong: ',class_getInstanceSize(TDerivedNSTableHeaderView),' <> ',class_getInstanceSize(NSTableHeaderView)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSTableView) <> (class_getInstanceSize(NSTableView)+sizeof(pointer)) then
 writeln('size of NSTableView is wrong: ',class_getInstanceSize(TDerivedNSTableView),' <> ',class_getInstanceSize(NSTableView)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSTabView) <> (class_getInstanceSize(NSTabView)+sizeof(pointer)) then
 writeln('size of NSTabView is wrong: ',class_getInstanceSize(TDerivedNSTabView),' <> ',class_getInstanceSize(NSTabView)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSTabViewItem) <> (class_getInstanceSize(NSTabViewItem)+sizeof(pointer)) then
 writeln('size of NSTabViewItem is wrong: ',class_getInstanceSize(TDerivedNSTabViewItem),' <> ',class_getInstanceSize(NSTabViewItem)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSText) <> (class_getInstanceSize(NSText)+sizeof(pointer)) then
 writeln('size of NSText is wrong: ',class_getInstanceSize(TDerivedNSText),' <> ',class_getInstanceSize(NSText)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSTextAttachmentCell) <> (class_getInstanceSize(NSTextAttachmentCell)+sizeof(pointer)) then
 writeln('size of NSTextAttachmentCell is wrong: ',class_getInstanceSize(TDerivedNSTextAttachmentCell),' <> ',class_getInstanceSize(NSTextAttachmentCell)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSTextAttachment) <> (class_getInstanceSize(NSTextAttachment)+sizeof(pointer)) then
 writeln('size of NSTextAttachment is wrong: ',class_getInstanceSize(TDerivedNSTextAttachment),' <> ',class_getInstanceSize(NSTextAttachment)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSTextContainer) <> (class_getInstanceSize(NSTextContainer)+sizeof(pointer)) then
 writeln('size of NSTextContainer is wrong: ',class_getInstanceSize(TDerivedNSTextContainer),' <> ',class_getInstanceSize(NSTextContainer)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSTextField) <> (class_getInstanceSize(NSTextField)+sizeof(pointer)) then
 writeln('size of NSTextField is wrong: ',class_getInstanceSize(TDerivedNSTextField),' <> ',class_getInstanceSize(NSTextField)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSTextFieldCell) <> (class_getInstanceSize(NSTextFieldCell)+sizeof(pointer)) then
 writeln('size of NSTextFieldCell is wrong: ',class_getInstanceSize(TDerivedNSTextFieldCell),' <> ',class_getInstanceSize(NSTextFieldCell)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSTextList) <> (class_getInstanceSize(NSTextList)+sizeof(pointer)) then
 writeln('size of NSTextList is wrong: ',class_getInstanceSize(TDerivedNSTextList),' <> ',class_getInstanceSize(NSTextList)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSTextStorage) <> (class_getInstanceSize(NSTextStorage)+sizeof(pointer)) then
 writeln('size of NSTextStorage is wrong: ',class_getInstanceSize(TDerivedNSTextStorage),' <> ',class_getInstanceSize(NSTextStorage)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSTextBlock) <> (class_getInstanceSize(NSTextBlock)+sizeof(pointer)) then
 writeln('size of NSTextBlock is wrong: ',class_getInstanceSize(TDerivedNSTextBlock),' <> ',class_getInstanceSize(NSTextBlock)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSTextTableBlock) <> (class_getInstanceSize(NSTextTableBlock)+sizeof(pointer)) then
 writeln('size of NSTextTableBlock is wrong: ',class_getInstanceSize(TDerivedNSTextTableBlock),' <> ',class_getInstanceSize(NSTextTableBlock)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSTextTable) <> (class_getInstanceSize(NSTextTable)+sizeof(pointer)) then
 writeln('size of NSTextTable is wrong: ',class_getInstanceSize(TDerivedNSTextTable),' <> ',class_getInstanceSize(NSTextTable)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSTextView) <> (class_getInstanceSize(NSTextView)+sizeof(pointer)) then
 writeln('size of NSTextView is wrong: ',class_getInstanceSize(TDerivedNSTextView),' <> ',class_getInstanceSize(NSTextView)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSTokenField) <> (class_getInstanceSize(NSTokenField)+sizeof(pointer)) then
 writeln('size of NSTokenField is wrong: ',class_getInstanceSize(TDerivedNSTokenField),' <> ',class_getInstanceSize(NSTokenField)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSTokenFieldCell) <> (class_getInstanceSize(NSTokenFieldCell)+sizeof(pointer)) then
 writeln('size of NSTokenFieldCell is wrong: ',class_getInstanceSize(TDerivedNSTokenFieldCell),' <> ',class_getInstanceSize(NSTokenFieldCell)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSToolbar) <> (class_getInstanceSize(NSToolbar)+sizeof(pointer)) then
 writeln('size of NSToolbar is wrong: ',class_getInstanceSize(TDerivedNSToolbar),' <> ',class_getInstanceSize(NSToolbar)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSToolbarItem) <> (class_getInstanceSize(NSToolbarItem)+sizeof(pointer)) then
 writeln('size of NSToolbarItem is wrong: ',class_getInstanceSize(TDerivedNSToolbarItem),' <> ',class_getInstanceSize(NSToolbarItem)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSToolbarItemGroup) <> (class_getInstanceSize(NSToolbarItemGroup)+sizeof(pointer)) then
 writeln('size of NSToolbarItemGroup is wrong: ',class_getInstanceSize(TDerivedNSToolbarItemGroup),' <> ',class_getInstanceSize(NSToolbarItemGroup)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSTrackingArea) <> (class_getInstanceSize(NSTrackingArea)+sizeof(pointer)) then
 writeln('size of NSTrackingArea is wrong: ',class_getInstanceSize(TDerivedNSTrackingArea),' <> ',class_getInstanceSize(NSTrackingArea)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSTreeController) <> (class_getInstanceSize(NSTreeController)+sizeof(pointer)) then
 writeln('size of NSTreeController is wrong: ',class_getInstanceSize(TDerivedNSTreeController),' <> ',class_getInstanceSize(NSTreeController)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSTreeNode) <> (class_getInstanceSize(NSTreeNode)+sizeof(pointer)) then
 writeln('size of NSTreeNode is wrong: ',class_getInstanceSize(TDerivedNSTreeNode),' <> ',class_getInstanceSize(NSTreeNode)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSTypesetter) <> (class_getInstanceSize(NSTypesetter)+sizeof(pointer)) then
 writeln('size of NSTypesetter is wrong: ',class_getInstanceSize(TDerivedNSTypesetter),' <> ',class_getInstanceSize(NSTypesetter)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSUserDefaultsController) <> (class_getInstanceSize(NSUserDefaultsController)+sizeof(pointer)) then
 writeln('size of NSUserDefaultsController is wrong: ',class_getInstanceSize(TDerivedNSUserDefaultsController),' <> ',class_getInstanceSize(NSUserDefaultsController)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSView) <> (class_getInstanceSize(NSView)+sizeof(pointer)) then
 writeln('size of NSView is wrong: ',class_getInstanceSize(TDerivedNSView),' <> ',class_getInstanceSize(NSView)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSViewController) <> (class_getInstanceSize(NSViewController)+sizeof(pointer)) then
 writeln('size of NSViewController is wrong: ',class_getInstanceSize(TDerivedNSViewController),' <> ',class_getInstanceSize(NSViewController)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSWindow) <> (class_getInstanceSize(NSWindow)+sizeof(pointer)) then
 writeln('size of NSWindow is wrong: ',class_getInstanceSize(TDerivedNSWindow),' <> ',class_getInstanceSize(NSWindow)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSWindowController) <> (class_getInstanceSize(NSWindowController)+sizeof(pointer)) then
 writeln('size of NSWindowController is wrong: ',class_getInstanceSize(TDerivedNSWindowController),' <> ',class_getInstanceSize(NSWindowController)+sizeof(pointer));
 if class_getInstanceSize(TDerivedNSWorkspace) <> (class_getInstanceSize(NSWorkspace)+sizeof(pointer)) then
 writeln('size of NSWorkspace is wrong: ',class_getInstanceSize(TDerivedNSWorkspace),' <> ',class_getInstanceSize(NSWorkspace)+sizeof(pointer));
 pool.release;
end;
begin
 PrintGlue1;
end.
