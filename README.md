# 📚 WebToonProject (AppToon)

모바일 웹툰서비스 스타일의 iOS 앱 프로젝트입니다.  
주요 기능으로는 최근 업데이트된 웹툰 추천, 웹툰 검색, 세로/가로 뷰어 전환, 로컬 저장 기반 즐겨찾기 기능이 있으며,
**비공식 웹툰 API**를 통해 리스트를 불러온 뒤 해당 키워드를 사용하여 **네이버 오픈 API**에서 이미지 데이터를 랜덤 수량으로 가져오는 구조로 구현되어 있습니다.
Kingfisher, SnapKit, Toast-Swift, Realm 등 외부 라이브러리를 활용하여 UI와 데이터 흐름을 구현하고 있습니다.

---
## 📼 Preview

업데이트 예정

---

## 🔧 Tech Stack

- **UIKit / Storyboard(Xib)**
- **RxSwift / RxCocoa**: MVVM 패턴 구성 및 Input/Outu 패턴, 반응형 바인딩 처리
- **SnapKit**: 레이아웃 제약 조건 설정
- **Kingfisher**: 이미지 다운로드 및 캐싱
- **Realm**: 로컬 데이터 영속화 (즐겨찾기 기능)
- **Toast-Swift**: 유저 피드백 토스트 메시지
- **Localization**: 한국어 / 영어 / 일본어 지원

---

## ✅ Feature List

### 🔁 공통 기능

- **네트워크 에러 처리**  
  - Alamofire의 response 상태코드 + NetworkStatus 기반 커스텀 에러 분기 처리  
  - 비정상 요청시 사용자에게 Alert 안내  

- **이미지 비동기 처리**  
  - `UICollectionView`의 `prefetchDataSource`로 스크롤 성능 최적화  
  - Kingfisher의 캐싱 기능으로 이미지 로드 속도 향상  

- Shimmer 뷰를 통한 로딩 UI
  - Network 통신 대기 중 로딩 상태 표현
  
- **다국어 지원**  
  - 한국어 / 영어 / 일본어 로컬라이징  
  - NSLocalizedString 및 enum 기반 리소스 처리  

---

### 🏠 [탭1] 추천화면

- 서비스 광고 **배너 뷰** (이미지 자동 슬라이드)
- 요일별 웹툰 버튼 → **요일 탭 화면으로 이동**
- 최근 업데이트 된 웹툰 리스트 확인 가능

### 🔍 [탭2] 검색화면

- 웹툰 제목 또는 작가명 기반 검색
- 조건 필터 (`업데이트된`, `무료`)
- Rx 기반 서치바 + 리스트 UI 연동
- 페이징 처리 (`prefetchRows` 사용)

### 📓 검색결과화면

- 검색 조건에 맞는 결과 출력
- 조건 변경 및 버튼 선택 시 자동 검색 실행

### 📖 작품회차화면

- 작품 제목으로 관련 이미지 API 호출 (Naver Image API)
- 기본 좌우 슬라이드 뷰어 + 세로 스크롤 뷰어 전환 기능
- 좋아요 버튼으로 즐겨찾기에 저장 가능 (Realm에 저장)

### 👀 작품감상화면

- 이미지 전체 화면 감상 기능
- 상단 / 하단 바 toggle
- 공유 버튼 (현재 컷 공유 기능)

### ❤️ [탭3] 즐겨찾기 화면

- Realm 기반 즐겨찾기 CRUD 구현
- 정렬 기능 (제목순, 등록순)
- 선택한 항목 클릭 → 감상화면 이동

<!-- ---

## 🛠 트러블슈팅 & 인사이트

### ❗️ 다국어 값 지연 적용 이슈
- `UIButton`의 `.setTitle(...)` 호출 시점이 viewDidLoad보다 빨라서, 초기 locale이 반영되지 않는 현상이 있었음  
→ ViewModel이 아닌 ViewController 내에서 초기 localized 값을 세팅하여 해결

### ❗️ 캡처 방지 기능 구현 (시도)
- UITextField의 `secureTextEntry`를 활용한 접근 방식 시도  
→ 일부 디바이스/빌드에서 레이어 오류 발생 → 현재는 Alert 방식으로 대체

### ❗️ CollectionView Height 업데이트 문제
- Shimmer가 들어간 6개 셀만 먼저 렌더링되어 높이 제한됨  
→ `collectionViewContentSize.height`를 활용하여 레이아웃 업데이트 로직 별도 작성

---
-->

## 📦 향후 개선 사항

- Network 최적화
- 다운로드 기능

---

## 🧑‍💻 Author

> 홍규희 (Kyuhee Hong)  
> iOS Developer  
> GitHub: [github.com/norang00](https://github.com/norang00)  
