## 박스오피스 프로젝트 저장소

이 저장소를 자신의 저장소로 fork하여 프로젝트를 진행합니다!

# 박스오피스 리드미 


## 팀원 소개
| <img src="https://github.com/hemil0102/ios-contact-manager-ui/assets/149054154/a88ee4a3-2981-4b60-bb6d-47138f6a0dc9" width="200"> | <img src="https://github.com/suojae3/ios-box-office/assets/126137760/ab91d3bb-6bcb-480c-a2b0-74b8e8e35bd5" width="200"> |
|:----------:|:---------:|
| **Sajae** | **Harry** |
| [@suojae3](https://github.com/suojae3) |  [@hemil0102](https://github.com/hemil0102)|

## 과제 소개

영화진흥위원회의 일별 박스오피스 API 문서의 데이터 형식을 고려하여 모델 타입을 구현합니다.제공된 JSON 데이터를 위에서 구현한 Model 타입으로 Parsing 할 수 있는지에 대한 단위 테스트(Unit Test)를 진행합니다.네트워크 통신을 담당할 타입을 설계하고 구현합니다.영화진흥위원회의 일별 박스오피스 API 문서의 데이터 형식을 고려하여 서버와 실제로 데이터를 주고받도록 구현합니다.

### Step 1
- 파싱한 JSON 데이터와 매핑할 모델 설계
- CodingKeys 프로토콜의 활용
- 단위 테스트(Unit Test)를 통한 설계의 검증

### Step 2
- URL Session을 활용한 서버와의 통신
- CodingKeys 프로토콜의 활용

### Step 3
- Safe Area을 고려한 오토 레이아웃 구현
- Collection View의 활용
- Mordern Collection View 활용


## 구동 화면
구동화면 | ![Simulator Screen Recording - iPhone 15 Pro Max - 2024-01-18 at 16 20 53](https://github.com/suojae3/ios-box-office/assets/126137760/7e26c4ab-9b83-4544-98bd-5c029b6cbdf8) |


## 학습 요약 
**1. 네트워크 구현**
- URLSession을 활용한 네트워크 구현 
- 재사용성과 범용성을 고려하여 네트워크 레이어를 설계 
- URL(Endpoint)생성, Request, Session, Decode 등을 POP 의존성 주입 형태로 Testable 설계 구현

**2. Async/Await를 통한 네트워크 비동기 처리** 
- Completion Handler 비동기 처리 방식에서 Async/Await를 통해 URLSession.data async 메서드를 활용하여 네트워크를 구현

**3. 데이터 플로우에 대한 고민**

**문제상황**: Repository의 낮은 재사용성 
- 레포지토리 객체가 DTO -> Entity 맵핑 책임을 맡음
- 이로인해 레포지토리 메서드들이 엔티티와 1대1 관계가 되어 경직된 코드가 되어버림

**해결방법**: 
- 레포지토리의 본래역할, 네트워크 객체들을 이용해 DTO를 가져오는 역할만 남기기위해 리턴타입을 **Result<Data, NetworkError>** 로 넘겨 인풋과 아웃풋의 Context는 유지
- 맵핑 객체를 따로 둠으로써 레포지토리의 리턴값을 받아 도메인레이어로 맵핑된 값을 보냄. 이를통해  레포지토리의 느슨한 객체관계를 확보


**4. 캐싱 방법에 대한 고민**

**문제상황**: 
- 박스오피스는 하루단위로 업데이트되는 데이터였음 
- 따라서 한 번 받아온 데이터를 몇분내로 새로고침할 때 불필요한 네트워크 통신이 발생했음


**해결방법**: 
- 네트워크 관련 캐시 관리이기 때문에 NSCache 보다 디테일한 캐시정책을 설정할 수 있는 URLCache 선택
- 개별 Cache 에 대한 설정도 부여(http일 경우에는 디스크에 저장못하도록 제한)
