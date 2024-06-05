# GripSDK

## 목차
- [SDK 설치](#sdk-설치)
- [SDK 초기화](#sdk-초기화)
- [홈 피드 연동](#홈-피드-연동)
- [커머스 탭 웹뷰 연동](#커머스-탭-웹뷰-연동)
- [인앱 브라우저 연동](#인앱브라우저-연동)

## 요구사항
- iOS Deployment Target 14.0 이상
- Xcode 15.0 이상 
- Swift 5.0 이상

## SDK 설치
### CocoaPods 사용

1. `Podfile`에 다음 줄을 추가하세요.
    ```ruby
    pod 'GripFramework'
    ```

2. 터미널에서 다음 명령어를 실행하세요.
    ```sh
    pod install
    ```

#### 참고: 외부 라이브러리 의존성
Grip SDK는 다음과 같은 외부라이브러리를 사용합니다. 
- iOS SDK: Moya, Alamofire, SnapKit, SDWebImage
- ReactiveX iOS SDK: RxSwift, RxCocoa, RxAppState, RxMoya

## 프로젝트 설정
### 커스텀 URL 스킴
그립앱 실행을 위해 커스텀 URL 스킴 설정을 합니다.
1. App Target > Info > URL Types 추가
2. URL Schemes 란에 `gripshow` 추가

![예시이미지](.DocumentResources/gripshow_url_scheme.png)


위 설정은 Info.plist 파일을 직접 수정해 적용할 수도 있습니다. 
```
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>gripshow</string>
        </array>
    </dict>
</array>
```

## 초기화

### 1. GripSDK 초기화
AppDelegate 또는 SceneDelegate에서 초기화합니다.

```swift
import GripSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // TODO: @성준
        return true
    }
}
```

### 2.  다크 모드 설정
TBU @솔

### 3. 동영상 자동 재생 설정
TBU @솔


## 홈 피드 연동
TBU @현욱

## 커머스 탭 웹뷰 연동
TBU @현욱

## 인앱 브라우저 연동
TBU @현욱