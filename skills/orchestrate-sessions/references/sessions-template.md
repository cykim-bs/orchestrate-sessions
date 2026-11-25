# 진행표 틀 (`<작업 폴더>/sessions.md`)

지휘 세션이 만들고 고친다. 세션을 띄울 때 행을 더하고, 깨어나 확인할 때 상태·확인 칸을 채운다.
대화가 요약된 뒤에는 이 표와 산출물 경로로 이어 간다. 상태는 `대기`·`진행`·`끝`·`막힘(사유)` 중 하나.

```markdown
# <작업명> 세션 진행표

- 요청(YYYY-MM-DD): 「원문」
- 사용자 결정: push <예·아니오> · 발행 <안 함> · 다운로드 <허락한 파일> · 외부 보고 <없음·채널> · 계획 확인 <받음·안 받음>
- 지휘 세션: <제목> (<모델·수준>)

| # | 단계 | 세션 이름 | 모델·추론 | 상태 | 산출물·커밋 | 지휘 확인 |
|---|---|---|---|---|---|---|
| 1 | 코드 조사 | <name> | Sonnet medium | 끝 | research/code-survey.md | 줄 수·목차 확인 |
| 2 | 외부 조사 | <name> | Opus medium | 끝 | research/external.md | 추천안 절 확인 |
| 3 | 계획 | <name> | Opus xhigh | 끝 | plan.md | 구현 단위·완료 기준 |
| 4 | 구현 A | <name> | Opus high | 끝 | <해시>·<해시> | git log·status |
| 5 | 구현 B | <name> | Opus medium | 끝 | <해시>·<해시> | 빌드 결과 |
| 6 | 검증·보고·push | <name> | Sonnet medium | 끝 | <결과 경로>, push <범위> | ls-remote |

## 사용자 허락 기록

- YYYY-MM-DD 「원문」 → 범위

## 남은 일

- 
```
