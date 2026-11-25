---
paths:
  - "**/*.{ts,js,py}"
---

# 레이어: controller / service / repository

| 레이어 | 하는 일 | 하지 않는 일 |
|---|---|---|
| controller | 라우트 선언 · DTO 바인딩 · service 호출 · 반환 | 비즈니스 로직 · try/catch · IO |
| service | 비즈니스 로직 · 검증 · 에러 판정 · 트랜잭션 순서 | HTTP 개념(Request · status) · 경로 문자열 조립 |
| repository | DB · 스토리지 IO · 쿼리 · 직렬화 | 규칙 판단 · 분기 |

- controller 본문은 service 호출 1~3줄
- 에러는 service 에서 도메인 에러로 던지고 전역 예외 필터가 응답으로 바꾼다. controller 는 잡지 않는다
- repository 는 저장소 하나 = 파일 하나. DB 와 스토리지 IO 를 한 클래스에 섞지 않는다
- 외부 API 어댑터는 repository 와 동급이고, service 가 주입받아 쓴다
- DTO 와 ORM 모델을 섞지 않는다. 변환은 repository 가 한다
- 사용자 데이터 조회 메서드는 `user_id` 를 필수 인자로 받는다. 기본값 · nullable 금지. 전체 스캔은 `list_all_for_*` 처럼 눈에 띄는 이름을 준다. 유출은 거의 항상 `WHERE user_id` 누락이다
- 여러 테이블에 걸친 상태 전이(차감 + 큐 삽입 등)는 트랜잭션 하나 안에서
