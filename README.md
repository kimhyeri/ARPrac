# ARPrac
Get to know 'ARKit'

## AR - augmented reality
introducing ARKit
>
:iOS 11 introduces ARKit, a new framework that allows you to easily create unparalleled augmented reality experience for iphone and ipad. By blending digital objects and information with the environment around you. ARKit takes apps beyond the screen, freeing them to interact with the real world in entirely new ways.

## Why 'AR' is important?
증강현실은 인공적인 환경을 만들어 내지는 않지만 기존의 환경과 함께 할 수 있으며 그것위에 특징을 오버레이 할 수 있습니다.   
Augmented reality does not create artificial environment, but it can play with the existing environment and also overlays feature on it. 

### 개념
- SceneKit  
: Create 3D games and add 3D content to apps using high-level scene descriptions. Easily add animations, physics simulation, particle effects, and realistic physically based rendering.
Language
- SpriteKit  
: Create 2D sprite-based games using an optimized animation system, physics simulation, and event-handling support.
- metal  
: Render advanced 3D graphics and perform data-parallel computations using graphics processors.

### 목표
* World Tracking  
* World Sharing  
* Image/Object Detection  
* Face Tracking  
* Real-World Positions 등  

### 렌더링  
SceneKit, SpriteKit, Metal 사용

###
ARWorldTrackingConfiguration  
ARConfiguration

#### ARKit 2에서 새롭게 등장한 기능  
얼굴 표정 추적 개선
사실적인 렌더링  
3D 물체 감지  
지속적인 경험  
경험 공유  

#### Required
*A9 chip
*devices 
*SE, 6S (plus), 7 (plus) , pro , 9.7-inch ipad ++

### BUT 
베터리가 많이 소모되는 단점이 존재


#### 사용되는 앱
인스타그램 스냅챗 포켓몬고 이케아 등

#### 링크 
https://developer.apple.com/kr/arkit/

#### ARKit프로젝트 생성시 달라지는 점 

1) art scnassets 
= it’s seperate from Asset.xcassets

2) ViewController변화
= import SceneKit
= import ARKit
= IBOutlet ARSCNView
= ARSCNViewDelegate implement (delegate = self)
= session did fail, session interrupted, interrupted Ended
= showStatistic
:frame per second, timing information

#### Configuration 비교 

ARWorldTrackingConfiguraion
: 실제로 존재하는것 처럼 포지션 유지 
: A9 chip에서 가능함
>
ARConfiguration
: 포지션 유지 안됨
: A8 chip에서 가능함

#### 사용가능한 configuration 확인할 때

```
if ARWorldTrackingConfiguration.isSupported {
   configuration = ARWorldTrackingConfiguration()
}
else  {
   configuration = AROrientationTrackingConfiguration()
} 
```

####
* SCNBox
면이 모두 직사각형 인 6면 다각형 기하학.

* SCNMaterial
렌더링 될 때 지오메트리 표면의 모양을 정의하는 음영 속성 집합
diffuse ) 라이팅에 대한 응답 관리하는 오브젝트 

* SCNNode
기하 도형, 조명 카메라 등 내용을 첨부 할 수 있는 3D 좌표 공간에서 위치와 변형을 나타내는 장면 그래프 구조 요소

* ARHitTest
카메라의 스팟을 잡아 실제 표면에 대한 정보를 얻을 수 있다.

* ARanchor 
AR이 실제 위치 방향

