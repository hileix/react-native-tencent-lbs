import React, { useState } from 'react';
import {
  QMapView,
  setKeys,
  setPrivacyAgreement,
  qCircleContainsCoordinate,
} from 'react-native-tencent-lbs';
import { Button, View } from 'react-native';

setPrivacyAgreement(true);
setKeys(
  'NKDBZ-6UWC4-OM2UL-FUDDI-VHWLS-SDFFL',
  'NKDBZ-6UWC4-OM2UL-FUDDI-VHWLS-SDFFL',
  'NKDBZ-6UWC4-OM2UL-FUDDI-VHWLS-SDFFL'
);

const radius = 1100;
export const QMapIOSExample = () => {
  const [showsCompass, setShowCompass] = useState(true);
  const [logoScale, setLogoScale] = useState(0.7);
  const [center] = useState({
    lat: 27.69935875308075,
    lon: 114.11656353013076,
  });
  const [showsUserLocation, setShowsUserLocation] = useState(true);

  const handleDidUpdateUserLocation = async (event: any) => {
    const { location } = event.nativeEvent;
    // 调用时，所有的数字都改为字符串，不然传给 ios 时，精度会丢失
    const result = await qCircleContainsCoordinate(
      {
        latitude: `${location.latitude}`,
        longitude: `${location.longitude}`,
      },
      {
        latitude: `${center.lat}`,
        longitude: `${center.lon}`,
      },
      `${radius}`
    );
    console.log('handleDidUpdateUserLocation result:', result);
  };

  return (
    <View style={{ flex: 1 }}>
      <>
        <QMapView
          style={{ height: 500 }}
          // @ts-ignore
          showsCompass={showsCompass}
          logoScale={logoScale}
          center={center}
          annotations={[
            {
              lat: 27.69035875308076,
              lon: 114.11656353013076,
              title: '腾讯',
              subTitle: '腾讯北京总部',
            },
          ]}
          circles={[
            {
              ...center,
              radius,
            },
          ]}
          showsUserLocation={showsUserLocation}
          onMapViewWillStartLocatingUser={() =>
            console.log('onMapViewWillStartLocatingUser called')
          }
          onMapViewInitComplete={() =>
            console.log('onMapViewInitComplete called')
          }
          onMapViewAuthenticationDidComplete={() => {
            console.log('onMapViewAuthenticationDidComplete called');
          }}
          onMapViewAuthentication={(event: any) => {
            console.log('onMapViewAuthentication called:', event.nativeEvent);
          }}
          onMapViewDidFailLoadingMap={() => {
            console.log('onMapViewDidFailLoadingMap called');
          }}
          onMapViewDidStopLocatingUser={() => {
            console.log('onMapViewDidStopLocatingUser called');
          }}
          onDidUpdateUserLocation={handleDidUpdateUserLocation}
          onDidFailToLocateUserWithError={(event: any) => {
            console.log(
              'onDidFailToLocateUserWithError called:',
              event.nativeEvent
            );
          }}
          onLocationManagerDidChangeAuthorization={() => {
            console.log('onLocationManagerDidChangeAuthorization called');
          }}
          onDidTapAtCoordinate={(event: any) => {
            console.log('onDidTapAtCoordinate called:', event.nativeEvent);
          }}
        />
        <Button
          title="显示/隐藏 指南针"
          onPress={() => setShowCompass((show) => !show)}
        />
        <Button
          title={`logo 缩放（0.7~1.3），当前 localScale: ${logoScale}`}
          onPress={() =>
            setLogoScale((scale) => {
              if (scale >= 1.3) {
                return 0.7;
              }
              return parseFloat((scale + 0.1).toFixed(1));
            })
          }
        />
        <Button
          title="显示/隐藏 用户定位"
          onPress={() =>
            setShowsUserLocation((showsUserLocation) => !showsUserLocation)
          }
        />
      </>
    </View>
  );
};
