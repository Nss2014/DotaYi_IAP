//
//  LoginViewController.m
//  XLS_IAP
//
//  Created by 牛松松 on 16/4/11.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginInputTFView.h"

@interface LoginViewController ()

@property (nonatomic,strong) UIImageView *login_logoImageView;

@property (nonatomic,strong) LoginInputTFView *login_accountInputView;

@property (nonatomic,strong) LoginInputTFView *login_passwordInputView;

@property (nonatomic,strong) UIButton *login_loginButton;

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

    [self initUI];
    
    [self addTapGestureRecognizer];
    
    [self setLeftOnlyTextItem:@"取消"];
}

-(void) initUI
{
    self.navigationItem.title = @"11平台登录";
    
    self.login_logoImageView = [[UIImageView alloc] init];
    
    [self.view addSubview:self.login_logoImageView];
    
    self.login_accountInputView = [[LoginInputTFView alloc] init];
    
    [self.view addSubview:self.login_accountInputView];
    
    self.login_passwordInputView = [[LoginInputTFView alloc] init];
    
    [self.view addSubview:self.login_passwordInputView];
    
    self.login_loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.login_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    
    [self.view addSubview:self.login_loginButton];
    
    WS(ws);
    
    CGFloat padding = 10;
    
    [self.login_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(ws.view.mas_centerX);
        make.top.equalTo(ws.view.mas_top).offset(4 * padding);
        make.width.mas_equalTo(100);
        make.height.equalTo(ws.login_logoImageView.mas_width);
    }];
    
    [self.login_accountInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view.mas_left).offset(INPUTVIEW_DISTANCE);
        make.right.equalTo(ws.view.mas_right).offset(-INPUTVIEW_DISTANCE);
        make.top.equalTo(ws.login_logoImageView.mas_bottom).offset(80);
        make.height.mas_equalTo(50);
    }];
    
    [self.login_passwordInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.login_accountInputView.mas_left);
        make.right.equalTo(ws.login_accountInputView.mas_right);
        make.top.equalTo(ws.login_accountInputView.mas_bottom).offset(padding);
        make.height.equalTo(ws.login_accountInputView.mas_height);
    }];
    
    [self.login_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view.mas_left).offset(40);
        make.right.equalTo(ws.view.mas_right).offset(-40);
        make.top.equalTo(ws.login_passwordInputView.mas_bottom).offset(padding *3);
        make.height.mas_equalTo(44);
    }];
}

-(void) viewTapedDismissKeyboard:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
}

-(void) TextFieldBeginEditing
{
    
}

-(void) keyboardControl
{
    CGFloat tf1_W = 0;
    
    CGFloat tf2_W = 0;
    
    if (IS_IPHONE4S)
    {
        tf1_W = -40;
        
        tf2_W = -70;
    }
    else if (IS_IPHONE5)
    {
        tf1_W = -30;
        
        tf2_W = -60;
    }
    else
    {
        tf1_W = -60;
        
        tf2_W = -90;
    }
    
    //键盘控制  记得在viewdiddisappear中移除self
    
    WS(ws);
    
    [CoreTFManagerVC installManagerForVC:self scrollView:nil tfModels:^NSArray *{
        
        TFModel *tfm1=[TFModel modelWithTextFiled:ws.login_accountInputView.LI_rightTextField inputView:nil insetBottom:tf1_W];
        
        TFModel *tfm2=[TFModel modelWithTextFiled:ws.login_passwordInputView.LI_rightTextField inputView:nil insetBottom:tf2_W];
        
        return @[tfm1,tfm2];
        
    }];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.login_logoImageView.image = [UIImage imageNamed:@"login_logoImage"];
    
    self.login_accountInputView.LI_leftLabel.text = @"账号：";
    
    self.login_accountInputView.LI_rightTextField.placeholder = @"请输入11平台账号";
    
    self.login_passwordInputView.LI_leftLabel.text = @"密码：";
    
    self.login_passwordInputView.LI_rightTextField.placeholder = @"请输入密码";
    
    self.login_loginButton.backgroundColor = XLS_COLOR_MAIN_RED;
    
    self.login_loginButton.layer.cornerRadius = CORNERRADIUS_BUTTON;
    
    self.login_loginButton.clipsToBounds = YES;
    
    [self.login_loginButton setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    
    self.login_loginButton.titleLabel.font = TEXT16_FONT;
    
    [self.login_loginButton addTarget:self action:@selector(loginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
}

-(void) loginButtonPressed
{
    NSLog(@"login_loginButton");
}



@end
