# ARPrac
Get to know 'ARKit'

## AR - augmented reality

> iOS 11 introduces ARKit, a new framework that allows you to easily create unparalleled augmented reality experience for iphone and ipad. By blending digital objects and information with the environment around you. ARKit takes apps beyond the screen, freeing them to interact with the real world in entirely new ways.

## Why 'AR' is important?
> Augmented reality does not create artificial environment, but it can play with the existing environment and also overlays feature on it. 


## Content technology
> rendering 

-SceneKit  
: Create 3D games and add 3D content to apps using high-level scene descriptions. Easily add animations, physics simulation, particle effects, and realistic physically based rendering.

-SpriteKit  
: Create 2D sprite-based games using an optimized animation system, physics simulation, and event-handling support.

-Metal    
: Render advanced 3D graphics and perform data-parallel computations using graphics processors.

* * *

## ARKit2 추가된 사항

1. 끊김 없는 AR 경험
: 이제 세션 간에 끊김 없는 AR 경험을 제공하고 이후에 다시 실행될 수 있다. 사용자는 테이블에서 AR 퍼즐을 시작하고 이후에 동일한 상태로 돌아오거나 , 매번 처음부터 다시 시작하지 않고 여러 날에 걸쳐 인테리어 꾸미기 프로젝트를 진행할 수 있습니다.

2. 함께하는 AR 경험
: 더 이상 AR 앱에서 AR 경험에 참여할 수 있는 사람이 1명 또는 기기1대로 제한되지 않습니다. 여러 사용자가 각자의 iOS 기기를 사용해 AR 경험을 동시에 보거나 멀티플레이어 게임을 즐길 수 있게 되었다. 또한 여러 명이 플레이하는 AR 게임을 주변 사람들이 관전할 수도 있다.

3. 물체 인식 및 추적
: ARKit 1.5에서는 2D 이미지 인식 기능이 추가되어 포스터, 아트워크, 표지판과 같은 2D 이지미를 기반으로 AR경험을 구현할 수 있었다. ARKit2에서는 이 기능을 확장해 완전한 2D 이미지 추적을 지원하므로 제품 상자나 잡지처럼 이동 가능한 사물을 AR 경험 속으로 가져올 수 있다. 또한 ARKit2에서는 조각품, 장난감, 가구와 같은 알려진 3D 물체를 감지할 수 있는 기능도 추가되었다.

### ARKit 2에서 새롭게 등장한 기능  
1)얼굴 표정 추적 개선  
2)사실적인 렌더링  
3)3D 물체 감지  
4)지속적인 경험  
5)경험 공유  

### 사용
* World Tracking  
* World Sharing  
* Image/Object Detection  
* Face Tracking  
* Real-World Positions 등  

### ARKit프로젝트 생성시 달라지는 점 

1) art scnassets 
= it’s seperate from Asset.xcassets

2) ViewController변화
* import SceneKit
* import ARKit
* IBOutlet ARSCNView
* ARSCNViewDelegate implement (delegate = self)
* session did fail, session interrupted, interrupted Ended
* showStatistic

### Configuration 비교 하기

ARWorldTrackingConfiguraion
: 실제로 존재하는것 처럼 포지션 유지 
: A9 chip에서 가능함
>
ARConfiguration
: 포지션 유지 안됨
: A8 chip에서 가능함

* 사용가능한 configuration 확인할 때
```
if ARWorldTrackingConfiguration.isSupported {
   configuration = ARWorldTrackingConfiguration()
} else {
   configuration = AROrientationTrackingConfiguration()
} 
```

### Coordinate System
- Origin  
: AR session이 시작했을때 기기의 위치

- Position  
: Origin을 기준으로 한 공간상의 위치

- Orientation  
: 어떤 각도로 x 축, y 축 및 z 축 연관 기울기

### Scene graph
- root node
- root's child nodes (Action)

### 유저 요구사항

* A9 chip devices: SE, 6S (plus), 7 (plus) , pro , 9.7-inch ipad ++  
  
* iOS11 - ARKit 지원  
* 허가 승인 permission to use the camera.  
* 빛이 있어야함.

### 개발자 요구사항

* User requirements  

* Xcode9.3 이상   
* SpriteKit , SceneKit    


### 단점
베터리가 많이 소모되는 단점이 존재

### 사용되는 앱
인스타그램   
스냅챗  
포켓몬고  
이케아 등

#### ARkit 프레임워크 공부
 > <https://github.com/kimhyeri/ARPrac/blob/develop/AR/ARkitFramework.md>
 
#### 개발자 공식 문서 링크 
 > <https://developer.apple.com/kr/arkit/>
 > <https://developer.apple.com/augmented-reality/arkit/>
