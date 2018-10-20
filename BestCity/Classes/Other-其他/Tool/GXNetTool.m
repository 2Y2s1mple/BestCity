//
//  GXNetTool.m
//  GXAtlanticOceanCar
//  Copyright © 2016年 LGX. All rights reserved.
//

#import "GXNetTool.h"

@interface GXNetTool()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSString *urlPath;
@property (nonatomic, strong) id bodyParam;
@end


@implementation GXNetTool
+(AFHTTPSessionManager *)GetNetWithUrl:(NSString *)url
                 body:(id)body
               header:(NSDictionary *)headers
             response:(GXResponseStyle)response
              success:(blockOfSuccess)success
              failure:(blockOfFailure)failure
{
    //(1)获取网络管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
    //(2)请求头的设置
    if (headers) {
        for (NSString *key in headers.allKeys) {
            [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    //(3)设置返回数据的类型
    switch (response) {
        case GXResponseStyleJSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case GXResponseStyleXML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        case GXResponseStyleDATA:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
            
        default:
            break;
    }
    //(4)设置数据响应类型
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"image/jpeg", @"text/vnd.wap.wml", nil]];
    //(5)IOS9--UTF-8转码
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    //(6)发送请求
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:body];
    param[@"userId"] = @"7d67892cb02f4766aa72fd5b08b8d8d1"; //USERINFO[@"userId"];
    [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        NSLog(@"%@", error);
    }];
    
    return manager;
}


+(void)PostNetWithUrl:(NSString *)url
                  body:(id)body
             bodySytle:(GXRequsetStyle)bodyStyle
                header:(NSDictionary *)headers
              response:(GXResponseStyle)response
               success:(blockOfSuccess)success
               failure:(blockOfFailure)failure
{
    //(1)获取网络管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager  manager];
    
    //设置body数据类型
    switch (bodyStyle) {
        case GXRequsetStyleBodyJSON:
             manager.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        case GXRequsetStyleBodyString:
            [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable * _Nullable error) {
                return parameters;
            }];
            break;
        case GXRequsetStyleBodyHTTP:
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;

        default:
            break;
    }
    
    //(2)请求头的设置
    if (headers) {
        for (NSString *key in headers.allKeys) {
            [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    
    
    //(3)设置返回数据的类型
    switch (response) {
        case GXResponseStyleJSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case GXResponseStyleXML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        case GXResponseStyleDATA:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
            
        default:
            break;
    }
    //(4)设置数据响应类型
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"image/jpeg", @"text/vnd.wap.wml",@"application/xml", @"text/xml", nil]];
    //(5)IOS9--UTF-8转码
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //请求HTTPS
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    
    //加载菊花
//    [CZProgressHUD showProgressHUDWithText:nil];
    //(6)发送请求
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:body];
    param[@"userId"] = @"7d67892cb02f4766aa72fd5b08b8d8d1"; //USERINFO[@"userId"];
    
    [manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        success(responseObject);
        //隐藏菊花
//        [CZProgressHUD hideAfterDelay:0];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        NSLog(@"%@", error);
        [CZProgressHUD showProgressHUDWithText:@"网络出错"];
        [CZProgressHUD hideAfterDelay:2];
    }];
}

#pragma mark - 上传文件
+ (void)uploadNetWithUrl:(NSString *)url fileSource:(id)fileSource success:(blockOfSuccess)success failure:(blockOfFailure)failure
{
    // 获取管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //IOS9--UTF-8转码
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if ([fileSource isKindOfClass:[UIImage class]]) {
            NSData *imageData = [UIImagePNGRepresentation(fileSource) length] > 102400 ?UIImageJPEGRepresentation(fileSource, 0.7) : UIImagePNGRepresentation(fileSource);
            [formData appendPartWithFileData:imageData name:@"importFile" fileName:@"imageFile.png" mimeType:@"image/png"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}





- (AFHTTPSessionManager *)manager
{
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager  manager];
    }
    return _manager;
}

- (GXNetTool *(^)(NSString *))url
{
    return ^(NSString *url){
        self.urlPath = url;
        return self;
    };
}

- (GXNetTool *(^)(NSDictionary *))header
{
    return ^(NSDictionary *headers){
        if (headers) {
            for (NSString *key in headers.allKeys) {
                [self.manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
            }
        }
        return self;
    };
}

- (GXNetTool *(^)(id))body
{
    return ^(id object){
        self.bodyParam = object;
        return self;
    };
}

- (GXNetTool *(^)(GXRequsetStyle))bodySytle
{
    return ^(GXRequsetStyle type) {
        //设置body数据类型
        switch (type) {
            case GXRequsetStyleBodyJSON:
                self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
                break;
            case GXRequsetStyleBodyString:
                [self.manager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable * _Nullable error) {
                    return parameters;
                }];
                break;
            case GXRequsetStyleBodyHTTP:
                self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                break;
                
            default:
                break;
        }
        return self;
    };
}

- (GXNetTool *(^)(GXResponseStyle))responseStyle
{
    return ^(GXResponseStyle type) {
        //(3)设置返回数据的类型
        switch (type) {
            case GXResponseStyleJSON:
                self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
                break;
            case GXResponseStyleXML:
                self.manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
                break;
            case GXResponseStyleDATA:
                self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                break;
                
            default:
                break;
        }
        return self;
    };
}


+ (void)netWorkMaker:(void (^)(GXNetTool *))maker success:(blockOfSuccess)success failure:(blockOfFailure)failure
{
    GXNetTool *tool = [[self alloc] init];
    maker(tool);
    [tool.manager POST:tool.urlPath parameters:tool.bodyParam progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        NSLog(@"%@", error);
    }];
}

@end
