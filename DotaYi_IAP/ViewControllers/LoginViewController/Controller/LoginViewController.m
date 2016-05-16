//
//  LoginViewController.m
//  XLS_IAP
//
//  Created by 牛松松 on 16/4/11.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginInputTFView.h"
#import "Register1_3View.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UILabel *login_loginPlatformLabel;

@property (nonatomic,strong) RegisteFrontView *R13_frontView;

@end

@implementation LoginViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self keyboardControl];//必须在viewWillAppear中添加，若在viewDidLoad中添加，页面返回时已移除，会导致崩溃
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextFieldBeginEditing) name:@"TextFieldBeginEditing" object:nil];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TextFieldBeginEditing" object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [CoreTFManagerVC uninstallManagerForVC:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initMyUI];
    
    [self envalueSubViews];
    
    [self addTapGestureRecognizer];
    
    [self setLeftOnlyTextItem:@"取消"];
}

-(void) initMyUI
{
    self.navigationItem.title = @"登录";
    
    self.login_loginPlatformLabel = [[UILabel alloc] init];
    
    self.R13_frontView = [[RegisteFrontView alloc] init];
    
    [self.view addSubview:self.login_loginPlatformLabel];
    
    [self.view addSubview:self.R13_frontView];
    
    WS(ws);
    
    [self.login_loginPlatformLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view.mas_top).offset(PADDING_WIDTH);
        make.centerX.equalTo(ws.view.mas_centerX);
        make.width.mas_equalTo(SCREEN_WIDTH/4);
        make.height.mas_equalTo(SCREEN_WIDTH/4);
    }];
    
    [self.R13_frontView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.login_loginPlatformLabel.mas_bottom).offset(PADDING_WIDTH);
        make.centerX.equalTo(ws.view.mas_centerX);
        make.width.equalTo(ws.view.mas_width).multipliedBy(0.85);
        make.bottom.equalTo(ws.view.mas_bottom).offset(-PADDING_WIDTH);
    }];
    
    
}

-(void) keyboardControl
{
    CGFloat tf1_W = 0;
    
    CGFloat tf2_W = 0;
    
    CGFloat tf3_W = 0;
    
    if (IS_IPHONE4S)
    {
        tf1_W = -40;
        
        tf2_W = -70;
        
        tf3_W = -120;
    }
    else if (IS_IPHONE5)
    {
        tf1_W = -30;
        
        tf2_W = -60;
        
        tf3_W = -100;
    }
    else
    {
        tf2_W = -20;
        
        tf3_W = -50;
    }
    
    //键盘控制  记得在viewdiddisappear中移除self
    
    WS(ws);
    
    [CoreTFManagerVC installManagerForVC:self scrollView:nil tfModels:^NSArray *{

        
        TFModel *tfm1 = [TFModel modelWithTextFiled:ws.R13_frontView.RF_textField1 inputView:nil insetBottom:tf1_W];;
        
        TFModel *tfm2=[TFModel modelWithTextFiled:ws.R13_frontView.RF_textField2 inputView:nil insetBottom:tf2_W];
        
        TFModel *tfm3=[TFModel modelWithTextFiled:ws.R13_frontView.RF_textField3 inputView:nil insetBottom:tf3_W];
        
        return @[tfm1,tfm2,tfm3];
        
    }];
}

-(void) envalueSubViews
{
    UIImage *tempImage = [UIImage imageNamed:@"long_button_background_image"];
    
    self.R13_frontView.RF_doneButton.backgroundColor = CLEAR_COLOR;
    
    [self.R13_frontView.RF_doneButton setTitle:@"登录" forState:UIControlStateNormal];
    
    [self.R13_frontView.RF_doneButton setBackgroundImage:tempImage forState:UIControlStateNormal];
    
    [self.R13_frontView.RF_doneButton setBackgroundImage:tempImage forState:UIControlStateHighlighted];
    
    [self.R13_frontView.RF_doneButton addTarget:self action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    self.R13_frontView.RF_textField1.delegate = self;
    
    self.R13_frontView.RF_textField2.delegate = self;
    
    self.R13_frontView.RF_textField3.delegate = self;
    
    self.R13_frontView.RF_textField1.placeholder = @"手机号／邮箱／用户名";
    
    self.R13_frontView.RF_textField2.placeholder = @"密码";
    
    self.R13_frontView.RF_textField3.placeholder = @"验证码";
    
    self.R13_frontView.RF_textField2.secureTextEntry = YES;
    
//    UIImage *verifyImage = [Tools imageFromURLString:[self getVerifyCode]];
    
    [self.R13_frontView.RF_verifyCodeImageView sd_setImageWithURL:[NSURL URLWithString:[self getVerifyCode]] placeholderImage:nil];
    
    self.R13_frontView.RF_verifyCodeImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *verifyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(verifyCOdeImageViewTaped)];
    
    [self.R13_frontView.RF_verifyCodeImageView addGestureRecognizer:verifyTap];
    
    self.login_loginPlatformLabel.text = @"11平台登录";
    
    self.login_loginPlatformLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    
    self.login_loginPlatformLabel.textColor = COLOR_TITLE_BLACK;
    
    self.login_loginPlatformLabel.textAlignment = NSTextAlignmentCenter;
    
    
    //测试代码
    self.R13_frontView.RF_textField1.text = @"15814036226";
    self.R13_frontView.RF_textField2.text = @"19900618";
}

-(void) verifyCOdeImageViewTaped
{
    UIImage *verifyImage = [Tools imageFromURLString:[self getVerifyCode]];
    
    self.R13_frontView.RF_verifyCodeImageView.image = verifyImage;
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    return YES;
}

-(void) viewTapedDismissKeyboard:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

-(void) TextFieldBeginEditing
{
    
}

-(void) loginButtonPressed
{
    //登录共四个串行接口 最后一个登录成功获取utoken  用于其他接口验证
    NSString *body = [NSString stringWithFormat:@"user=%@&password=%@&code=%@",
                      self.R13_frontView.RF_textField1.text,
                      self.R13_frontView.RF_textField2.text,
                      self.R13_frontView.RF_textField3.text
                      ];
    
    NSLog(@"body %@",body);
    
    NSLog(@"getVerifyCode %@",[self getVerifyCode]);
    
    CoreSVPLoading(nil, nil);
    
    
    //登录第一步
    [Tools platform11LoginRequest:DT_LOGIN_URL ParamsBody:body target:self action:@selector(LoginPlatform11CallBack:)];
}

-(void) LoginPlatform11CallBack:(NSDictionary *) responseDic
{
    CoreSVPDismiss;
    
    //登录回调
    if (responseDic && ![responseDic isKindOfClass:[NSNull class]])
    {
        NSNumber *responseRet = responseDic[@"Code"];
        
        if ([responseRet isEqualToNumber:[NSNumber numberWithInteger:1]])
        {
            //登录成功  获取数据
            
            //Data 暂不清楚 可能是返回token
            NSString *loginResponseDataStr = responseDic[@"Data"];
            
            //Info 用户ID
            NSString *loginResponseInfoStr = responseDic[@"Info"];
            
            //User 用户名字
            NSString *loginResponseUserStr = responseDic[@"User"];
            
            [Tools setStr:loginResponseDataStr key:LOGIN_RESPONSE_TOKEN];
            
            [Tools setStr:loginResponseInfoStr key:LOGIN_RESPONSE_USERID];
            
            [Tools setStr:loginResponseUserStr key:LOGIN_RESPONSE_USERNAME];
            
            //登录第二步  Post请求
            NSString *loginSecondUrlString = [NSString stringWithFormat:@"http://app.5211game.com/sso/login?returnurl=http://www.5211game.com/?logout=1&st=%@",loginResponseDataStr];
            
            NSString *body = [NSString stringWithFormat:@"returnurl=http://www.5211game.com/?logout=1&st=%@",loginResponseDataStr];
            
            NSLog(@"loginSecondUrlString %@",loginSecondUrlString);
            
            NSLog(@"body %@",body);

            CoreSVPLoading(nil, nil);
            
            [Tools platform11SecondPostRequest:loginSecondUrlString body:body target:self action:@selector(loginSecondCallBack:)];
        }
        else
        {
            NSString *errorString = responseDic[@"Msg"];
            
            CoreSVPError(errorString, nil);
        }
    }
}

-(void) loginSecondCallBack:(NSString *) responseValueString
{
    CoreSVPDismiss;
    
    NSLog(@"responseValueString %@",responseValueString);
    
    if (responseValueString)
    {
        NSArray *sepArray1 = [responseValueString componentsSeparatedByString:@"siteid"];
        
        if (sepArray1.count > 1)
        {
            NSArray *sepArray2 = [sepArray1[1] componentsSeparatedByString:@"&returnurl="];
            
            NSString *getSiteId;
            
            NSString *getReturnUrl;
            
            if (sepArray2.count > 0)
            {
                getSiteId = sepArray2[0];
            }
            
            if (sepArray2.count > 1)
            {
                getReturnUrl = sepArray2[1];
            }
            
            NSString *body = [NSString stringWithFormat:@"siteid=%@&returnurl=%@",getSiteId,getReturnUrl];
            
            [Tools platform11SecondPostRequest:responseValueString body:body target:self action:@selector(loginThirdCallBack:)];

        }
    }
}

-(void) loginThirdCallBack:(NSString *) thirdResponseStr
{
    NSLog(@"thirdResponseStr %@",thirdResponseStr);
    
    if (thirdResponseStr)
    {
        NSArray *sepArray1 = [thirdResponseStr componentsSeparatedByString:@"&st="];
        
        if (sepArray1.count > 1)
        {
            NSArray *sepArray2 = [sepArray1[1] componentsSeparatedByString:@"&sid="];
            
            NSString *getSt;
            
            NSString *getSid;
            
            if (sepArray2.count > 0)
            {
                getSt = sepArray2[0];
            }
            
            if (sepArray2.count > 1)
            {
                getSid = sepArray2[1];
            }
            
            NSString *body = [NSString stringWithFormat:@"returnurl=http://www.5211game.com/?logout=1&st=%@&sid=%@",getSt,getSid];
            
            [Tools platform11FourthPostRequest:thirdResponseStr body:body target:sepArray2 action:@selector(loginFouthCallBack:)];
            
        }

    }
}

-(void) loginFouthCallBack:(NSString *) fourthResponse
{
    NSLog(@"fourthResponse %@",fourthResponse);
    
    if (fourthResponse)
    {
        //登录成功 跳转页面
    }
}

-(NSString *) getVerifyCode
{
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://register.5211game.com/11/register"]];
    
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
    
    NSArray *mainElements = [xpathParser searchWithXPathQuery:@"//div[@class='reg-rcon']"];
    
    NSString *verifyString = @"";
    
    for (TFHppleElement *tfElement in mainElements)
    {
        //物品图片
        NSString *getverifyPicString = [Tools getHtmlValueWithXPathParser:tfElement XPathQuery:@"//p[@class='row row-code clearfix']" DetailXPathQuery:@"//img" DetailKey:@"src"];
        
        NSLog(@"getverifyPicString %@",getverifyPicString);
        
        verifyString = [NSString stringWithFormat:@"http://register.5211game.com%@",getverifyPicString];
    }
    
    return verifyString;
}

@end
