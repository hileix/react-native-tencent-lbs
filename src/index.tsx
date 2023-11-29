import {
  requireNativeComponent,
  UIManager,
  Platform,
  type ViewStyle,
  NativeModules,
} from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-tencent-lbs' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

type TencentLbsProps = {
  color: string;
  style: ViewStyle;
};

const ComponentName = 'RNTQMap';

export const QMapView =
  UIManager.getViewManagerConfig(ComponentName) != null
    ? requireNativeComponent<TencentLbsProps>(ComponentName)
    : () => {
        throw new Error(LINKING_ERROR);
      };

const { QMapModule } = NativeModules;

const { setKeys, setPrivacyAgreement, qCircleContainsCoordinate } = QMapModule;

export { setKeys, setPrivacyAgreement, qCircleContainsCoordinate };
