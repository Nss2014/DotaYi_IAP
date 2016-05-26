//
//  cnvUILabel.m
//  Label
//
//  Created by xiong xiongwenjie on 11-8-2.
//  Copyright 2011 CareLand. All rights reserved.
//

#import "cnvUILabel.h"
#import <CoreText/CoreText.h>

@implementation cnvUILabel

@synthesize stringColor;
@synthesize keywordColor;
@synthesize list,attributedString;

-(id) init
{
    if (self = [super init]) {
        self.text = nil;
        stringColor = nil;
        keywordColor = nil;
        list = [[NSMutableArray alloc] init];
        lineInfoForTap = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.text = nil;
        stringColor = nil;
        keywordColor = nil;
        list = [[NSMutableArray alloc] init];
        lineInfoForTap = [[NSMutableArray alloc] init];
        // Initialization code.
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [list release];
    [super dealloc];
}

//设置字体颜色和关键字的颜色
- (void) cnv_setUIlabelTextColor:(UIColor *) strColor 
                 andKeyWordColor: (UIColor *) keyColor
{
    self.stringColor = strColor;
    self.keywordColor = keyColor;
}
//设置关键字，并且调用保存关键字函数将关键字的Range存再list中。
- (void) cnv_setUILabelText:(NSString *)string andKeyWord:(NSString *)keyword
{
    if (self.text != string) {
        self.text = string;
        textString = string;
    }
    [self saveKeywordRangeOfText:keyword];
}

//设置多个关键字，并且调用保存关键字函数将关键字的Range存再list中。
- (void) cnv_setUILabelText:(NSString *)string andKeyWord1:(NSString *)keyword1  andKeyWord2:(NSString *)keyword2  andKeyWord3:(NSString *)keyword3
{
    NSLog(@"string %@  %@  %@  %@",string,keyword1,keyword2,keyword3);
    
    if (self.text != string) {
        self.text = string;
        textString = string;
    }
    [self saveKeywordRangeOfText:keyword1];
    [self saveKeywordRangeOfText:keyword2];
    [self saveKeywordRangeOfText:keyword3];
}


//保存关键字再Text中的位置信息
- (void) saveKeywordRangeOfText:(NSString *)keyWord
{
    //有效性校验
    if (nil == keyWord) {
        return;
    }
    
    //将所有的字符位置存在list中
    
    // modify by wi ---
    //
    NSRange range = [textString rangeOfString:keyWord];
    NSValue *value = [NSValue valueWithRange:range];
    if (range.length > 0) {
        [list addObject:value];
    }
    //
    // modify by wi ---
    
}


//设置颜色属性和字体属性
- (NSAttributedString *)illuminatedString:(NSString *)text 
                                     font:(UIFont *)AtFont{
	
    NSLog(@"attributedString %@", self.attributedString);
    NSUInteger len = [text length];
    if (self.attributedString) {
        self.attributedString = nil;
    }
    self.attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    //改变字符串 从1位 长度为1 这一段的前景色，即字的颜色。
/*    [mutaString addAttribute:(NSString *)(kCTForegroundColorAttributeName) 
                       value:(id)[UIColor darkGrayColor].CGColor 
                       range:NSMakeRange(1, 1)]; */
    NSLog(@"stringColor %@",self.stringColor);
    if (!self.stringColor || [self.stringColor isKindOfClass:[NSNull class]])
    {
        self.stringColor = [UIColor blackColor];
    }
    [self.attributedString addAttribute:(NSString *)(kCTForegroundColorAttributeName)
                       value:(id)self.stringColor.CGColor
                       range:NSMakeRange(0, len)];
    
  
    //设置是否使用连字属性，这里设置为0，表示不使用连字属性。标准的英文连字有FI,FL.默认值为1，既是使用标准连字。也就是当搜索到f时候，会把fl当成一个文字。
    int nNumType = 0;
    //    float fNum = 3.0;
    CFNumberRef cfNum = CFNumberCreate(NULL, kCFNumberIntType, &nNumType);
    //    CFNumberRef cfNum2 = CFNumberCreate(NULL, kCFNumberFloatType, &fNum);
    [self.attributedString addAttribute:(NSString *)kCTLigatureAttributeName
                                  value:(id)cfNum
                                  range:NSMakeRange(0, len)];
    
    
    //空心字
    //    [mutaString addAttribute:(NSString *)kCTStrokeWidthAttributeName value:(id)cfNum2 range:NSMakeRange(0, len)];
    
    
    CTFontRef ctFont2 = CTFontCreateWithName((CFStringRef)AtFont.fontName, 
                                             AtFont.pointSize,
                                             NULL);
    [self.attributedString addAttribute:(NSString *)(kCTFontAttributeName) 
                                  value:(id)ctFont2 
                                  range:NSMakeRange(0, len)];
    //   CFRelease(ctFont);
    CFRelease(ctFont2);
    if (self.keywordColor != nil)
    {
        for (NSValue *value in list) 
        {
            //   NSValue *value = [list objectAtIndex:i];
            NSRange keyRange = [value rangeValue];
            
//            //移除设定属性
//            [self.attributedString removeAttribute:@"option" range:keyRange];
         
            //========================Add by 飞远 =======================
            
            [self.attributedString addAttribute:(NSString *)(kCTForegroundColorAttributeName)
                                                    value:(id)self.keywordColor.CGColor
                                                    range:keyRange];
//            int nUnderLineType = kCTUnderlineStyleSingle;
//            CFNumberRef cfUnderLine = CFNumberCreate(NULL, kCTUnderlineStyleThick, &nUnderLineType);
//            [self.attributedString addAttribute:(NSString *)kCTUnderlineStyleAttributeName 
//                               value:(id)cfUnderLine
//                               range:keyRange];
            [self.attributedString addAttribute:@"option" value:[[self.attributedString string] substringWithRange:keyRange] range:keyRange];
            
            //=====================

        }
    }

    return [[self.attributedString copy] autorelease];
}

//重绘Text
- (void)drawRect:(CGRect)rect 
{
    //获取当前label的上下文以便于之后的绘画，这个是一个离屏。
	CGContextRef context = UIGraphicsGetCurrentContext();
    //压栈，压入图形状态栈中.每个图形上下文维护一个图形状态栈，并不是所有的当前绘画环境的图形状态的元素都被保存。图形状态中不考虑当前路径，所以不保存
    //保存现在得上下文图形状态。不管后续对context上绘制什么都不会影响真正得屏幕。
	CGContextSaveGState(context);
    
    NSString *textTitleString = self.text;
    
    CGSize labeSize = [Tools getAdaptionSizeWithText:textTitleString AndFont:[UIFont systemFontOfSize:17] andLabelHeight:30];

    //x，y轴方向移动
	CGContextTranslateCTM(context, self.bounds.size.width/2 - labeSize.width/2, labeSize.height/2);/*self.bounds.size.height*/
    
    //缩放x，y轴方向缩放，－1.0为反向1.0倍,坐标系转换,沿x轴翻转180度
	CGContextScaleCTM(context, 1, -1);
	
	NSArray *fontArray = [UIFont familyNames];
	NSString *fontName;
	if ([fontArray count]) {
		fontName = [fontArray objectAtIndex:0];
	}
    //创建一个文本行对象，此对象包含一个字符
	//CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)[self illuminatedString:self.text font:self.font]);	//[UIFont fontWithName:fontName size:60]
    //设置文字绘画的起点坐标。由于前面沿x轴翻转了（上面那条边）所以要移动到与此位置相同，也可以只改变CGContextSetTextPosition函数y的坐标，效果是一样的只是意义不一样
          CGContextTranslateCTM(context, 0.0, - ceill(self.bounds.size.height));//加8是稍微调整一下位置，让字体完全现实，有时候y，j下面一点点会被遮盖
	CGContextSetTextPosition(context, 0.0, 0.0); /*ceill(self.bounds.size.height) + 8*/
    //在离屏上绘制line
	//CTLineDraw(line, context);
    //将离屏上得内容覆盖到屏幕。此处得做法很像windows绘制中的双缓冲。
	//CGContextRestoreGState(context);	
    
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef) [self illuminatedString:self.text font:self.font]);
    CGMutablePathRef leftColumnPath = CGPathCreateMutable();
    CGPathAddRect(leftColumnPath, NULL,
                  CGRectMake(0, 0,
                             self.bounds.size.width,
                             self.bounds.size.height));
    CTFrameRef leftFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), leftColumnPath, NULL);
    
    CTFrameDraw(leftFrame, context);
    CGContextRestoreGState(context);    
    CGPathRelease(leftColumnPath);
    CFRelease(framesetter);
    UIGraphicsPushContext(context);
    
    
    
	//CFRelease(line);
	//CGContextRef	myContext = UIGraphicsGetCurrentContext();
	//CGContextSaveGState(myContext);
	//[self MyColoredPatternPainting:myContext rect:self.bounds];
	//CGContextRestoreGState(myContext);
}

//========================Add by 飞远 =======================
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [super touchesEnded:touches withEvent:event];
    
    CGPoint tapLocation = [[touches anyObject] locationInView:self];
    int total_height = [self getAttributedStringHeightWithString:self.attributedString WidthValue:self.frame.size.width];//width为自身宽度
    //判断点击是否超出范围
    if (tapLocation.y >= total_height) {
        return;
    }
    
    /** 1. Setup CTFramesetter **/
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedString);
    /** 2. Create CTFrame **/
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, self.frame.size.width, 1000));//height越大越好，   
    
    CTFrameRef textFrameForKey = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    //[self drawFrame:textFrameForKey inContext:nil forString:nil];
    CFRelease (path);
    CFRelease (framesetter);
    //CTFrameGetLineOrigins
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrameForKey);
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrameForKey, CFRangeMake(0, 0), origins);
    CFArrayRef lines = CTFrameGetLines(textFrameForKey);

    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = (CTLineRef) [linesArray objectAtIndex:0];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    //CFIndex linesCount = CFArrayGetCount(lines);
    
    int line_y = 1000- (int)origins[0].y;  //第一行line的原点y坐标
    int line_height = line_y + (int)descent +1; //每行的高度
    
    int current_line = tapLocation.y/line_height;

    CFIndex curentIndex = CTLineGetStringIndexForPosition((CTLineRef)CFArrayGetValueAtIndex(lines, current_line),tapLocation);
    
    //判断超出范围
    if (curentIndex >[self.attributedString length]) {
        return;
    }
    NSRange currentRange = NSMakeRange(0, [self.attributedString length]);
    //curentIndex
    NSDictionary *dic = [self.attributedString attributesAtIndex:curentIndex-1 effectiveRange:&currentRange];
    id option = [dic valueForKey:@"option"];
    if (option) {
        
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"notice"
                                                        message:[dic valueForKey:@"option"] 
                                                       delegate:self 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
}

//获取coretext高度
- (int)getAttributedStringHeightWithString:(NSAttributedString *)string  WidthValue:(int) width
{
    int total_height = 0;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);    //string 为要计算高度的NSAttributedString
    CGRect drawingRect = CGRectMake(0, 0, width, 1000);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    int line_y = (int) origins[[linesArray count] -1].y;  //最后一行line的原点y坐标
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = (CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    
    total_height = 1000 - line_y + (int) descent +1;    //+1为了纠正descent转换成int小数点后舍去的值
    
    CFRelease(textFrame);
    
    return total_height;
    
}
//========================
@end
