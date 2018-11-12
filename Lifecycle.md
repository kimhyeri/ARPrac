# Session Lifecycle

공식 문서
> https://developer.apple.com/documentation/arkit/managing_session_lifecycle_and_tracking_quality

## 1. AR Session의 기본적인 라이프 사이클

* Not available  
: session을 시작한 직후 프레임의 상태는 ARCamera.TrackingState.notAvailable 이며 ARKit이 아직 기기의 포즈를 추정하는데 충분한 정보를 얻지 못함.

* Limited  
: 몇 프레임 추적후 상태는 ARCamera.TrackingState.limited(_:) 로 변경되어 장치 포즈가 사용 가능하지만 정확성은 불확실 함. 이 경우 session은 여전히 ARCamera.TrackingState.Reason.initializing 상태

* Normal  
: ARCamera.TrackingState.normal 기기가 포즈를 정확하고 모든  ARKit기능 사용 가능.

***

## 2. 추적 상태 변경에 피드백 제공
> 사용자 상호작용이나 환경 변화로 인해 발생할 수 있는 추적 상태의 변화를 보여줌.

* ARCamera.TrackingState.limited(_:) 의 경우 사용 불가함.  
( ARKit 매핑 의존적 )
1. 평면 탐지가 평면 앵커를 추가하거나 업데이트 하지 않음.
2. hit - testing 메소드 결과를 제공하지 않음.

* Session은 사용자의 로컬 환경 또는 사용자 이동에 따라 언제든지 ARCamera.TrackingState.limited(_:) 상태를 추적할 수 있음. 

* 연관된 ARCamera.TrackingState.Reason값을 사용하여 추적 상태가 ARCamera.TrackingState.normal로 돌아갈 수 있도록 사용자를 안내해 상황을 해결하도록 피드백을 제공해라.

***

## 3. 중단된 session에서 복구
> ARKit은 실행중인 ARSession없이 디바이스의 포즈를 추적할 수 없음.  
기본적으로 session이 중단 되는 경우 - 다른 앱으로 전환. 

* sessionShouldAttemptRelocalization (_ :)메소드에서 true를 반환하면 ARKit는 중단전의 유저 환경에 대한 지식을 현재 카메라 및 센서 데이터와 맞추려함.   이 과정에서 추적 상태는 ARCamera.TrackingState.limited (_ :)임. 
성공하면 짧은 시간 후 ARCamera.TrackingState.normal로 변경.

- limited가 성공하려면 session이 중단되었을때의 위치 및 방향으로 되돌려야 함. (만약 그러지 않으면 계속 그 상태로 유지.)

***

## 4. 지속적인 AR 경험 만들기
> iOS 12 이상에서 ARWorldMap 클래스는 ARKit이 session을 다시 시작하는데 사용하는 정보를 저장함.
world maps 는 앵커를 포함하고 있어 이전 session과 일치하도록 가상 컨텐츠를 대체 가능함.

* normal 추적 상태에서 앱이 종료되기 전에 worldmap을 저장함.

* 앱을 다시 실행하고 저장된 worldmap을 로드하면 추적상태가 notAvailable 에서 limited(initializing)에서 limited(relocalizing)으로 진행된다.

* 사용자가 앱을 종료한 후 동일한 ARSession으로 돌아올 수 있도록 하려면 명시적으로 world map을 저장하거나 applicationDidEnterBackground (_ :)에 자동으로 저장 가능.

* 저장된 world map위치를 다시 지정하려면 session을 실행할때 initalworldMap속성을 사용.  
  중단 -> 재시작  
  ARCamera.TrackingState.limited (_ :) (ARCamera.TrackingState.Reason.relocalizing)에서 시작함.

* ARKit이 기록된 world map을 현재 환경에 조정 불가한 경우.
디바이스가 기록된 곳과 완전히 다른 곳에 있는 경우)  
session은 무기한 ARCamera.TrackingState.Reason.relocalizing 유지 함.


