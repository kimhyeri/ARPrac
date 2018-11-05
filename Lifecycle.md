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
