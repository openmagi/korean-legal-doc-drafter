# korean-legal-doc-drafter

한국 법률문서 자동 작성 에이전트 스킬 — 149종 문서, 문서별 상세 작성 가이드 내장.
An agent skill that drafts Korean legal documents through guided Q&A — 149 document types, each with its own in-depth drafting guide.

내용증명 · 계약서(NDA, 동업, 투자, 용역) · 근로계약 · 지급명령 신청서 · 합의서 · 고소장 · 부동산 임대차/매매 · 차용증 · 위임장 · 약관/개인정보처리방침 등.

상황 설명 → 적합한 문서 추천 → 단계별 질문(한 번에 2-3개) → 완성 문서 출력 → 전문가 검토 안내.

> ⚠️ **법적 고지 / Legal disclaimer**
> 본 스킬과 생성된 문서는 참고용이며 **법률 자문이 아닙니다**. 작성된 문서는 반드시
> 변호사 등 법률 전문가의 검토 후 사용하십시오. This skill is for reference only and
> does not constitute legal advice. Always have generated documents reviewed by a
> qualified legal professional before use.

## 설치 (Install)

단일 `SKILL.md` 파일 — [Agent Skills](https://agentskills.io) 오픈 포맷이라
Claude Code, Codex CLI, Hermes Agent, Magi Agent에서 **무수정으로 동작**합니다.

### 한 줄 설치 (모든 에이전트 자동 감지)

```bash
curl -fsSL https://raw.githubusercontent.com/openmagi/korean-legal-doc-drafter/main/install.sh | bash
```

`~/.claude` / `~/.agents` / `~/.hermes` / `~/.magi` 중 존재하는 곳을 찾아 전부 설치합니다.

### 에이전트에게 맡기기 (agent self-install)

사용 중인 에이전트에게 이렇게 말하세요:

> https://github.com/openmagi/korean-legal-doc-drafter 의 INSTALL.md를 따라 이 스킬을 설치해줘

### 에이전트별 수동 설치

스킬은 `SKILL.md` + `references/` **폴더 전체**입니다. 폴더째 복사하세요:

```bash
git clone --depth 1 https://github.com/openmagi/korean-legal-doc-drafter.git /tmp/kldd
cp -R /tmp/kldd/skills/korean-legal-doc-drafter <SKILL_DIR>/ && rm -rf /tmp/kldd
```

| 에이전트 | `<SKILL_DIR>` |
|---|---|
| **Claude Code** | `~/.claude/skills/` |
| **Codex CLI** | `~/.agents/skills/` — 또는 `$skill-installer https://github.com/openmagi/korean-legal-doc-drafter` |
| **Hermes Agent** | `~/.hermes/skills/` — 또는 위 한 줄 설치 스크립트 사용 |
| **Magi Agent** | `~/.claude/skills/` 또는 `~/.magi/skills/` 모두 인식 |

## 사용 (Usage)

설치 후 `/korean-legal-doc-drafter`로 호출하거나, 그냥 자연어로 요청하면 됩니다:

- "친구한테 빌려준 500만원을 1년째 못 받고 있어" → 내용증명(대여금) → 지급명령 에스컬레이션
- "주말 알바 뽑았는데 계약서 써야 해" → 5인 미만/단시간 분기 후 알바계약서
- "외주 개발사랑 NDA 필요해" → 일방/상호 확인 후 비밀유지계약서
- "웹서비스 런칭하는데 개인정보처리방침 만들어줘" → 법정 필수항목 12단계 수집

## 특징

- **149종 전 문서에 개별 작성 가이드** (`references/doc-*.md`, 약 2만 줄) — 문서마다 용도·법적 성격, 단계별 질문 위저드(선택지·분기), 필수 기재사항 체크리스트, 바로 쓸 수 있는 출력 템플릿 전문, 법적 함정 안내 수록
- **Progressive disclosure**: 평소엔 가벼운 SKILL.md만 로드, 문서 유형 확정 후 해당 가이드 1개만 읽음 — 컨텍스트 낭비 없음
- 실무 깊이: 지급명령 관할·송달료·인지대, 임금채권 연 20% 이율 특칙, 형사합의 처벌불원서 절차, 부동산 직거래 안전장치(등기부·확정일자), 성명불상 고소, 5인 미만 사업장 분기, 포괄임금 유효 요건, 가맹사업법 필수 절차 등 — 조문·판례 근거 적시
- 변동 수치(법정이율, 송달료, 최저임금)는 최신 확인 안내 포함
- 선택적 연계: `korean-law-research`(법령 조회), `hwpx-canine`(HWPX 내보내기) — 없어도 동작

## License

[Apache 2.0](LICENSE)
