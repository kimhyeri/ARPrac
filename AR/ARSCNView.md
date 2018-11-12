
# ARSCNView
> AR경험을 보여주는 뷰 (3D SceneKit 컨텐츠)

## 개요
ARSCNView 클래스는 가상 3D 컨텐츠를 실제 세계의 디바이스 카메라 뷰와 증강현실 경험을 생성하는 가장 쉬운 방법을 제공합니다.  
뷰에 제공되는 ARSession객체를 실행할 때:  
1. 뷰는 디바이스의 카메라에서 실시간 비디오 피드 장면을 배경으로 자동 렌더링 합니다.  
2. 뷰의 SceneKit 씬의 현실 좌표계 시스템(world coordinate system)은 session configuration에 의해 설정된 AR 세계 좌표에 직접 응답합니다.  
3. 뷰는 자동으로 Scenekit카메라와 실제 기기의 움직임과 일치시킵니다.  

ARKit는 자동으로  SceneKit공간을 실제 세계와 일치시키기 때문에 실제 위치를 유지하는 것처럼 보이는 가상 객체를 배치하면 해당 객체의SceneKit 위치만 적절히 설정하면 됩니다. 

ARAnchor클래스를 사용하면 장면에 추가하는 객체의 위치를 추적 할 필요는 없지만 ARSCNViewDelegate메소드를 구현하면 ARKit에 의해 자동으로 감지 된 모든 앵커에 SceneKit 내용을 추가 할 수 있습니다. 

### 1) 첫 단계
> SceneKit을 사용해 AR 경험에 3D객체를 추가하세요.

var session : ARSession  
뷰 내용에 대한 모션 추적 및 카메라의 이미지를 처리하고 관리하는 ARSession  

var scene : SCNScene  
뷰에 표시 할 SceneKit장면

### 2) Responding to AR updates

var delegate : ARSCNViewDelegate?  
뷰의 AR scene 정보와 SceneKit 내용의 동기화를 위해 제공하는 객체

protocol ARSCNViewDelegate  
AR session에서 SceneKit 컨텐츠의 자동 동기화를 위해 구현할 수 있는 메소드 

### 3) Hit testing for Real - world Surfaces

- func hitTest(CGPoint, types: ARHitTestResult.ResultType) -> [ARHitTestResult]
SceneKit 뷰의 한 지점에 해당하는 카메라 이미지에서 현실 세계 객체 또는 AR 앵커를 검색합니다.

### 4) 컨텐츠를 실제 위치에 매핑

- func anchor(for: SCNNode) -> ARAnchor?  
지정된 SceneKit 노드와 연관된 AR 앵커가 있으면 반환함.

- func node(for: ARAnchor) -> SCNNode?  
지정된 AR 앵커와 관련된 SceneKit노드가 있으면 반환홤.

- func unprojectPoint(CGPoint, ontoPlane: simd_float4x4) -> simd_float3?  
2D 뷰에서 ARKit에 의해 감지된 3D 세계 공간으로 반환함.

### 5) Mapping scene lighting
- var automaticallyUpdatesLighting : Bool  
ARKit 뷰의 장면에서 SceneKit 라이트를 만들고 업데이트 하는지 여부를 지정하는 불 값

### 6) AR 디스플레이 디버깅
- typealias ARSCNDebugOptions  
SceneKit뷰에서 AR 추적 디버깅을 돕기 위해 오버레이 내용을 그리는 옵션

### SCNView 의 상속
