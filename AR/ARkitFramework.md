# ARKit 프레임워크에 대해서 
> iOS 기기 카메라 및 모션 기능을 통합하여 앱 또는 게임에서 증강 현실 체험을 제작합니다.

## 개요
AR은 기기의 카메라, 라이브 뷰 에서 2D 또는 3D 요소를 추가하여 사용자가 실제 세상에 존재하는 것처럼 보이게 만드는 사용자 경험을 나타냅니다.

ARKit는 기기 모션 추적, 카메라 씬 캡쳐, 고급 장면 처리 및 편의성을 고려해 AR 경험 구축 작업을 단순화 합니다.  

이러한 기술을 사용해 iOS 기기 후면 전면 카메라를 사용해 다양한 종류의 AR을 경험할 수 있도록 합니다.

### 후면 카메라의 AR
가장 일반적인 종류의 AR은 iOS 기기의 후면 카메라에서 표시하며 사용자가 주변세게를 보고 상호 작용할 수 있는 새로운 방법을 제공합니다.

ARWorldTrackingConfiguration의 여러 경험의 종류 : 
ARKit는 사용자가 실제로 거주하는 공간을 매핑하고 추적해 가상 공간을 배치할 수 있는 좌표 공간과 일치화 시킵니다.

또한 World Tracking은 사용자 환경에서 물체와 이미지를 인식하고 실제 조명 조건에 반응하는 AR경험을 조금 더 몰입하게 만드는 기능을 제공합니다.

NOTE:
* 사용자 정의 AR환경을 구축하지 않고도 사용자의 실제 환경에서 3D 객체를 표시 할 수 있습니다. 
* iOS12에서는 앱에서 USDZ파일과함께 QLPreviewController를 사용하거나 웹 콘텐츠에서 USDZ 파일과 함께 Safari또는 Webkit을 사용할 때 시스템에서 3D 개체에 대한 AR보기를 제공합니다. 

### 전면 카메라의 AR
iPhoneX에서 ARFaceTrackingConfiguration은 전면을 향한 TrueDepth 카메라를 사용해 가상 컨텐츠 렌더링에 사용할 사용자 얼굴의 자세 및 표현에 대한 실시간 정보를 제공합니다.

예를 들어 사용자의 얼굴을 카메라에 표시하면 현실성있는 가상 마스크를 제공합니다. 

또한 iMessage용 Animoji앱에서 볼수 있듯이 카메라 보기를 생략하고 ARKit표정 데이터를 사용하여 가상 문자를 애니메이션 할 수 있습니다. 

### 1) 첫 단계

장치 지원 및 사용자 권한 확인
: 앱이 ARKit을 사용할 수 있고 사용자의 개인 정보를 존중해야 합니다.

ARSession클래스
: 증강 현실 경험에 필요한 장치 카메라 및 모션 처리를 관리하는 공유 객체 입니다.

ARConfiguration클래스
: AR세션 구성을 위한 기본적인 추상 클래스입니다.

### 2) 디스플레이

ARSCNView 클래스
: 카메라 뷰와 함께 3D Scenekit 컨텐츠로 AR 경험을 디스플레이하는 뷰입니다.

ARSKView클래스
: 카메라 뷰와 함께 2D SpriteKit 컨텐츠로 AR 경험을 디스플레이하는 뷰입니다.

Metal로 AR체험하기
: 카메라 이미지를 렌더링하고 위취 추적 정보를 사용하여 오버레이 컨텐츠를 표시하여 커스텀한 AR뷰를 만들어 보세요.

### 3) WorldTracking
> 사용자가 기기의 후면 카메라로 주변의 가상 컨텐츠를 탐색 할 수 있는 AR 경험을 만듭니다.

첫 번째 AR 경험 구축
: AR 세션을 실행하고 비행기 탐지를 사용하여 Scenekit을 사용하여 3D 컨텐츠를 배치하는 앱을 만듭니다.

ARKit에서 world tracking이해하기
: 뛰어난 AR 경험을 구축하기위한 지원 개념, 기능 및 모범 사례를 찾아보세요.

ARWorldTrackingConfiguration 클래스
: 후면 카메라를 사용하고 장치의 방향과 위치를 추적하며 실제 표면과 알려진 이미지 또는 개체를 감지하는 구성입니다. 

ARPlaneAnchor 클래스
: world tracking AR 세션에서 감지된 실제 평면의 위치와 방향에 대한 정보입니다.

### 4) 사용자 경험
> 이 예제와 Human Interface Guidelines AR을 따라하면 강력하고 직관적인 AR경험을 구축 할 수 있습니다.

세션 생명주기와 트래킹의 품질을 관리하세요.

명확한 피드백을 제공하고 중단을 복구하고 이전 세션을 다시 시작하여 AR경험을 더욱 강력하게 만듭니다.

확대 / 축소 된 현실에서 3D 상호 작용 및 UI컨트롤 처리.

AR 경험에서 시각적 피드백, 동작 상호 작용 및 현실적인 렌더링을 위한 모범 사례를 따르세요.

Swiftshot 증강현실을 위한 게임 만들기 -  Apple이 WWDC18의 주요 데모를 어떻게 제작했는지 확인하고 ARKit, SceneKit및 Swift를 사용하여 멀티 플레이어 게임을 제작하는 방법에 대한 팁을 얻으세요.

### 5) AR세계 공유성 그리고 지속성

다중 사용자 AR경험 만들기
: MultipeerConnectivity 프레임워크를 사용해 인접 장치 간 ARkit세계 매핑 데이터를 전송해 AR 경험에 대해서 공유할수 있는 기반을 만듭니다.

지속적인 AR경험 만들기
: 사용자가 동일한 실제 환경에서 이전의 AR경험으로 돌아갈 수 있도록 ARKit세계 매핑 데이터를 저장하고 로드하세요.

ARWorldMap 클래스
: worldtrackingAR 세션의 엥커의 세트들의 space mapping 상태

### 6) 환경 텍스처링

AR 경험에 사실적인 반영 추가
: ARKit를 사용해 카메라 이미지에서 환경 프로브텍스처를 생성하고 반사 가상 객체를 렌더링 합니다.

AREnvironmentProbeAnchor 클래스
: world tracking AR 세션에서 특정 공간 영역에 대한 환경 조명 정보를 제공하는 객체입니다. 

### 7) Image Detection and Tracking 
> 사용자의 환경에서 알려진 2D 이미지를 사용하여 world tracking AR 세션을 향상 시킵니다.

AR경험에서 이미지 인식하기
: 사용자 환경에서 알려진 2D 이미지를 감지하고 위치를 사용하여 AR 컨텐츠를 배치합니다.

ARReferenceImage 클래스
: world tracking AR 세션중에 실제 환경에서 인식할 이미지.

ARImageAnchor 클래스
: world tracking AR 세션에서 감지된 이미지의 위치와 방향에 대한 정보.

### 8) Obejct Dection
> 사용자의 환경에서 알려진 3D 객체를 사용해 world tracking AR 세션을 향상 시킵니다.

3D 개체 스캔 및 검색
: 실제 개체의 공간적 특징을 기록한 다음 결과를 사용하여 사용자 환경의 개체를 찾고 AR 컨텐츠를 트리거 합니다.
ARReferenceObject 클래스
: world tracking AR 세션중에 실제 환경에서 인식되는 3D 객체입니다.

ARObjectAnchor 클래스
: world tracking AR 세션에서 탐지된 실제 3D 객체의 위치와 방향에 대한 정보.

ARObjectScanningConfiguration 클래스
: 후면 카메라를 사용하여 나중에 탐지 할 수 있도록 3D 물체를 스캔 할 때 사용하기 위해 high-fidelity spatial (공간에 대한 높은 퀄) 데이터를 모으는 구성.

### 9) Hit Testing and Real-world positions 

ARHitTestResult 클래스
: AR 세션의 디바이스의 카메라에서 한 지점을 검사하여 실제 표면에 대한 정보를 찾을 수 있습니다.

ARAnchor 클래스
: AR 장면에 물체를 배치하는데 사용할 수 있는 실제 위치 및 방향.

ARAnchorCopying 프로토콜
: 커스텀 ARAnchor 서브클래스 지원

ARTrackable프로토콜
: ARKit이 위치한 방향을 추적하는 실제 세계의 물체입니다. 

### 10) camera and scene details

ARFrame 클래스
: AR session의 부분으로 캡처된 위치 추적 정보가 있는 비디오 이미지.

ARCamera 클래스
: AR session에서 캡쳐된 비디오 프레임의 카메라 위치 및 이미지 특성에 대한 정보.

ARLightEstimate 클래스
: AR session에서 캡쳐된 비디오 프레임과 관련된 조명 정보.

### 11) Face Tracking
> iphone X의 TrueDepth 카메라를 사용하여 사용자의 얼굴과 표정에 반응하는 AR 경험을 만드세요.

얼굴기반 AR 경험 만들기
Face Tracking AR session에서 제공하는 정보를 사용하여 3D 컨텐츠를 배치하고 애니메이션을 만듭니다.

ARFaceTrackingConfiguration 클래스
: TrueDepth 카메라로 사용자 얼굴의 움직임과 표현을 추적하는 구성.

ARFaceAnchor 클래스
: face tracking AR session 에서 감지 된 얼굴의 포즈, 위상 및 표현에 대한 정보.

ARDirectionalLightEstimate 클래스
: face tracking AR session에서 캡쳐된 비디오 프레임과 관련된 환경 조명 정보.

### 12) 전문화 된 구성

AROrientaionTrackingConfiguration 클래스
: 후면 카메라를 사용하고 디바이스 방향만 추적하는 구성입니다. 

ARImageTrackingConfiguration 클래스
: 후면 카메라를 사용하여 알려진 이미지를 탐지하고 추적하는 구성입니다.

### 13) 관련 기술
오디오로 몰입형 AR 경험 만들기
음향 효과 및 효과 사운드 레이어를 사용하여 매력적인 AR 경험을 만드세요.

ARKit으로 실시간 Vision 사용하기
CoreML 이미지 분류 프로그램을 효율적으로 실행하기 위한 Vision 리소스를 관리하고 SpriteKit을 사용하여 이미지 분류 프로그램에 출력을 AR로 표시합니다. 
