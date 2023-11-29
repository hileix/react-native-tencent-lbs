//
//  RCTQMapModule.m
//  newColleagueLatest
//
//  Created by 肖磊 on 2023/9/3.
//


#import "RCTQMapModule.h"
#import <React/RCTLog.h>
#import <QMapKit/QMapKit.h>
#import <QMapKit/QMSSearchKit.h>
#import <React/RCTBridgeModule.h>



@implementation RCTQMapModule


RCT_EXPORT_MODULE(QMapModule);


// 初始化设置 apiKey
RCT_EXPORT_METHOD(setKeys:(NSString *)mapServiceApiKey :(NSString *)searchServiceApiKey :(NSString *)locationServiceApiKey)
{
  [QMapServices sharedServices].APIKey = mapServiceApiKey;
  [QMSSearchServices sharedServices].apiKey = searchServiceApiKey;
  RCTLogInfo(@"Native: apiKey 设置成功 %@, %@", mapServiceApiKey, searchServiceApiKey);
}

// 隐私协议开关，since 4.5.6
RCT_EXPORT_METHOD(setPrivacyAgreement:(BOOL)isAgree)
{
  [[QMapServices sharedServices] setPrivacyAgreement:isAgree];
  RCTLogInfo(@"Native: 调用 setPrivacyAgreement 成功");
}

// 判断点是否在圆内
RCT_EXPORT_METHOD(
  qCircleContainsCoordinate:(NSDictionary *)point
  :(NSDictionary *)center
  :(NSString *)radius
  resolver:(RCTPromiseResolveBlock)resolve
  rejecter:(RCTPromiseRejectBlock)reject
)
{
  CLLocationCoordinate2D pointCoord;
  pointCoord.latitude = [point[@"latitude"] doubleValue];
  pointCoord.longitude = [point[@"longitude"] doubleValue];
    
  CLLocationCoordinate2D centerCoord;
  centerCoord.latitude = [center[@"latitude"] doubleValue];
  centerCoord.longitude = [center[@"longitude"] doubleValue];
  
  double _radius = [radius doubleValue];

  BOOL result = QCircleContainsCoordinate(pointCoord, centerCoord, _radius);
    
  if (result) {
    resolve(@YES);
  } else {
    resolve(@NO);
  }
}



@end

