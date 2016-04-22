//
//  ViewController.m
//  WKWebView
//
//  Created by liyang on 16/4/22.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
@interface ViewController ()<UISearchBarDelegate, WKNavigationDelegate>
/// 搜索栏
@property (nonatomic, strong) UISearchBar *searchBar;
/// 网页控制导航栏
@property (weak, nonatomic) UIView *bottomView;

@property (nonatomic, strong) WKWebView *wkWebView;

@property (weak, nonatomic) UIButton *backBtn;
@property (weak, nonatomic) UIButton *forwardBtn;
@property (weak, nonatomic) UIButton *reloadBtn;
@property (weak, nonatomic) UIButton *browserBtn;

@property (weak, nonatomic) NSString *baseURLString;

/** shuzu */
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

// 控件高度
#define kSearchBarH  44
#define kBottomViewH 44

// 屏幕大小尺寸
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

static int countTag = 1100;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSubViews];
    
}

- (void)addSubViews
{
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.wkWebView];
    
    [self refreshBottomButtonState];
    
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.cnblogs.com/mddblog/"]]];
}


/// 刷新按钮是否允许点击
- (void)refreshBottomButtonState {
    if ([self.wkWebView canGoBack]) {
        self.backBtn.enabled = YES;
    } else {
        self.backBtn.enabled = NO;
    }
    
    if ([self.wkWebView canGoForward]) {
        self.forwardBtn.enabled = YES;
    } else {
        self.forwardBtn.enabled = NO;
    }
}


- (void)simpleExampleTest {
    // 1.创建webview，并设置大小，"20"为状态栏高度
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
    // 2.创建请求
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.cnblogs.com/mddblog/"]];
    // 3.加载网页
    [webView loadRequest:request];
    
    // 最后将webView添加到界面
    [self.view addSubview:webView];
}

// 模拟器调试加载mac本地文件
- (void)loadLocalFile {
    // 1.创建webview，并设置大小，"20"为状态栏高度
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20)];
    // 2.创建url  userName：电脑用户名
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"]];
    // 3.加载文件
    [webView loadFileURL:url allowingReadAccessToURL:url];
    // 最后将webView添加到界面
    [self.view addSubview:webView];
}

#pragma mark - 懒加载
- (UIView *)bottomView {
    if (_bottomView == nil) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kBottomViewH, kScreenWidth, kBottomViewH)];
        view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        [self.view addSubview:view];
        
        for (int i = 0; i < 4; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:self.dataArr[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:249 / 255.0 green:102 / 255.0 blue:129 / 255.0 alpha:1.0] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithRed:0.499 green:0.805 blue:0.379 alpha:1.000] forState:UIControlStateHighlighted];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
            btn.tag = countTag + i;
            [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [btn addTarget:self action:@selector(onBottomButtonsClicled:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(((kScreenWidth - 320)/5 + 80)*i + (kScreenWidth - 320)/5, (view.bounds.size.height-30)/2, 80, 30);
            [view addSubview:btn];
        }
        
        _bottomView = view;
    }
    return _bottomView;
}
- (UISearchBar *)searchBar {
    if (_searchBar == nil) {
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kSearchBarH)];
        searchBar.delegate = self;
        searchBar.text = @"http://www.cnblogs.com/mddblog/";
        _searchBar = searchBar;
        
    }
    return _searchBar;
}
- (WKWebView *)wkWebView {
    if (_wkWebView == nil) {
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20 + kSearchBarH, kScreenWidth, kScreenHeight - 20 - kSearchBarH - kBottomViewH)];
        webView.navigationDelegate = self;
        // 允许左右划手势导航，默认允许
        webView.allowsBackForwardNavigationGestures = YES;
        _wkWebView = webView;
    }
    
    return _wkWebView;
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        [_dataArr addObjectsFromArray:@[@"后退", @"前进", @"重新加载", @"Safari"]];
    }
    return _dataArr;
}

#pragma mark - 按钮的点击事件
- (void)onBottomButtonsClicled:(UIButton *)sender
{
    NSInteger number = sender.tag - 1100;
    switch (number) {
        case 0:
        {
            [self.wkWebView goForward];
            [self refreshBottomButtonState];
        }
            break;
        case 1:
        {
            [self.wkWebView goForward];
            [self refreshBottomButtonState];
        }
            break;
        case 2:
        {
            [self.wkWebView reload];
        }
            break;
        case 3:
        {
            [[UIApplication sharedApplication] openURL:self.wkWebView.URL];
        }
            break;
        default:
            break;
    }
}


#pragma mark - WKWebView WKNavigationDelegate 相关
/// 是否允许加载网页 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    
    NSString *urlString = [[navigationAction.request URL] absoluteString];
    
    urlString = [urlString stringByRemovingPercentEncoding];
    //    NSLog(@"urlString=%@",urlString);
    // 用://截取字符串
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    if ([urlComps count]) {
        // 获取协议头
        NSString *protocolHead = [urlComps objectAtIndex:0];
        NSLog(@"protocolHead=%@",protocolHead);
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

/// 网页加载完成之后调用js代码
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {

    [self getImageUrlByJS:self.wkWebView];

    //    static  NSString * const jsGetImages =
//    @"function getImages(){\
//    var objs = document.getElementsByTagName(\"img\");\
//    var imgUrlStr='';\
//    for(var i=0;i<objs.length;i++){\
//    if(i==0){\
//    if(objs[i].alt==''){\
//    imgUrlStr=objs[i].src;\
//    }\
//    }else{\
//    if(objs[i].alt==''){\
//    imgUrlStr+='#'+objs[i].src;\
//    }\
//    }\
//    objs[i].onclick=function(){\
//    if(this.alt==''){\
//    document.location=\"myweb:imageClick:\"+this.src;\
//    }\
//    };\
//    };\
//    return imgUrlStr;\
//    };";
//    
//    JSContext *context = [webView valueForKeyPath:jsGetImages];
//    NSString *alertJS = @"alert('调用成功')";
//    [context evaluateScript:alertJS];
}

- (NSArray *)getImageUrlByJS:(WKWebView *)wkWebView {
    
    // js方法遍历图片添加点击事件返回图片个数
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgUrlStr='';\
    for(var i=0;i<objs.length;i++){\
    if(i==0){\
    if(objs[i].alt==''){\
    imgUrlStr=objs[i].src;\
    }\
    }else{\
    if(objs[i].alt==''){\
    imgUrlStr+='#'+objs[i].src;\
    }\
    }\
    objs[i].onclick=function(){\
    if(this.alt==''){\
    document.location=\"myweb:imageClick:\"+this.src;\
    }\
    };\
    };\
    return imgUrlStr;\
    };";
    
    // webView执行js代码
    [wkWebView evaluateJavaScript:jsGetImages completionHandler:nil];
    
    // 这里执行？？？
    NSString *js2=@"getImages()";
    
    __block NSArray *array=[NSArray array];
    [wkWebView evaluateJavaScript:js2 completionHandler:^(id Result, NSError * error) {
        NSLog(@"js2__Result==%@",Result);
        NSString *resurlt=[NSString stringWithFormat:@"%@",Result];
        
        if([resurlt hasPrefix:@"#"])
        {
            resurlt=[resurlt substringFromIndex:1];
        }
        array=[resurlt componentsSeparatedByString:@"#"];
        NSLog(@"array====%@",array);
    }];
    
    return array;
}


#pragma mark - searchBar代理方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // 创建url
    NSURL *url = nil;
    NSString *urlStr = searchBar.text;
    
    // 如果file://则为打开bundle本地文件，http则为网站，否则只是一般搜索关键字
    if([urlStr hasPrefix:@"file://"]){
        NSRange range = [urlStr rangeOfString:@"file://"];
        NSString *fileName = [urlStr substringFromIndex:range.length];
        url = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
        // 如果是模拟器加载电脑上的文件，则用下面的代码
        //        url = [NSURL fileURLWithPath:fileName];
    }else if(urlStr.length>0){
        if ([urlStr hasPrefix:@"http://"]) {
            url=[NSURL URLWithString:urlStr];
        } else {
            urlStr=[NSString stringWithFormat:@"http://www.baidu.com/s?wd=%@",urlStr];
        }
        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        url=[NSURL URLWithString:urlStr];
        
    }
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    // 加载请求页面
    [self.wkWebView loadRequest:request];
}


























@end
