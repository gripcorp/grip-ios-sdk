# GripSDK

## 목차
- [SDK 설치](#sdk-설치)
- [SDK 초기화](#sdk-초기화)
- [홈 피드 연동](#홈-피드-연동)
- [커머스 탭 웹뷰 연동](#커머스-탭-웹뷰-연동)
- [인앱 브라우저 연동](#인앱브라우저-연동)

## SDK 설치

### 요구 사항
- minimum deployment target iOS 14.0 이상
- Xcode 15.0 이상 

### CocoaPods 사용

1. `Podfile`에 다음 줄을 추가하세요.
    ```ruby
    pod 'GripFramework'
    ```

2. 터미널에서 다음 명령어를 실행하세요.
    ```sh
    pod install
    ```


## SDK 초기화

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