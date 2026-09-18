# HTML 키트

새 스타일을 발명하지 않는다. 아래 토큰과 스켈레톤에서 시작한다.

## 토큰

```css
:root {
  --ivory:    #FAF9F5;   /* 배경 */
  --white:    #FFFFFF;   /* 카드 */
  --slate:    #141413;   /* 제목 · 코드 배경 */
  --clay:     #D97757;   /* 강조 1 (현재 · 링크 · 실행 중) */
  --olive:    #788C5D;   /* 성공 · 완료 */
  --rust:     #B04A3F;   /* 실패 · 위험 */
  --oat:      #E3DACC;   /* 배지 바탕 */
  --gray-150: #F0EEE6;
  --gray-300: #D1CFC5;   /* 테두리 */
  --gray-500: #87867F;   /* 보조 텍스트 */
  --gray-700: #3D3D3A;   /* 본문 */

  --serif: ui-serif, Georgia, 'Times New Roman', serif;
  --sans:  system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif;
  --mono:  ui-monospace, 'SF Mono', Menlo, Monaco, monospace;
}
```

역할 고정: **제목 serif · 본문 sans · 식별자/수치/라벨 mono.**
테두리는 `1.5px solid var(--gray-300)`, 반경은 카드 12px · 배지 6~8px.

## 스켈레톤

```html
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>...</title>
<style>
  :root { /* 위 토큰 */ }
  * { margin:0; padding:0; box-sizing:border-box; }
  body {
    font-family: var(--sans); background: var(--ivory); color: var(--gray-700);
    line-height: 1.55; padding: 56px 32px 120px; -webkit-font-smoothing: antialiased;
  }
  .page { max-width: 1120px; margin: 0 auto; }
  .eyebrow { font-size:12px; letter-spacing:.08em; text-transform:uppercase; color:var(--gray-500); }
  h1 { font-family:var(--serif); font-weight:500; font-size:38px; line-height:1.15; color:var(--slate); letter-spacing:-.01em; }
  section { margin-bottom: 64px; }
  .sec-head { display:flex; align-items:baseline; gap:14px; margin-bottom:8px; }
  .sec-head .num { font-family:var(--mono); font-size:12px; background:var(--oat); color:var(--slate); padding:3px 9px; border-radius:8px; }
  .sec-head h2 { font-family:var(--serif); font-weight:500; font-size:26px; color:var(--slate); }
  .card { background:var(--white); border:1.5px solid var(--gray-300); border-radius:12px; padding:18px 20px; }
</style>
</head>
<body>
<div class="page">
  <header class="page-head">
    <div class="eyebrow">문서 종류</div>
    <h1>제목</h1>
  </header>
  <!-- sections -->
</div>
</body>
</html>
```

## 조각

### 요약 스트립 — 첫 화면에서 끝내는 4칸

```css
.summary { display:grid; grid-template-columns:repeat(4,1fr); gap:16px; }
@media (max-width:900px) { .summary { grid-template-columns:repeat(2,1fr); } }
.summary .k { font-family:var(--mono); font-size:11px; text-transform:uppercase; letter-spacing:.06em; color:var(--gray-500); }
.summary .v { font-size:17px; font-weight:600; color:var(--slate); }
.summary .v.accent { color:var(--clay); }
```

### 마일스톤 타임라인

```css
.milestone { display:grid; grid-template-columns:120px 28px 1fr; gap:0 18px; }
.milestone .when { text-align:right; font-family:var(--mono); font-size:12px; color:var(--gray-500); }
.milestone .dot-col { display:flex; flex-direction:column; align-items:center; }
.milestone .dot { width:14px; height:14px; border-radius:50%; background:var(--white); border:3px solid var(--clay); }
.milestone .dot.done { background:var(--olive); border-color:var(--olive); }
.milestone .line { width:2px; flex:1; background:var(--gray-300); margin:4px 0; }
.milestone:last-child .line { display:none; }
```

### 인라인 SVG 흐름도

```html
<svg class="flow" viewBox="0 0 620 920">   <!-- width:100%; height:auto -->
  <defs>
    <marker id="arrow" viewBox="0 0 10 10" refX="9" refY="5"
            markerWidth="6" markerHeight="6" orient="auto-start-reverse">
      <path d="M0,0 L10,5 L0,10 z" fill="#87867F"/>
    </marker>
    <!-- 색마다 marker 를 따로 만든다. marker 는 stroke 색을 상속하지 않는다 -->
  </defs>
  <path class="edge yes" d="M310,326 L310,368"/>
  <g class="node" data-k="build"><rect x="210" y="368" width="200" height="48"/><text …>Build</text></g>
  <g class="node gate" data-k="g1"><path d="M310,262 L352,294 L310,326 L268,294 Z"/></g>
</svg>
```

```css
.edge     { stroke:var(--gray-500); stroke-width:1.5; fill:none; marker-end:url(#arrow); }
.edge.yes { stroke:var(--olive); marker-end:url(#arrow-olive); }
.edge.no  { stroke:var(--rust); stroke-dasharray:4 4; marker-end:url(#arrow-rust); }
.node { cursor:pointer; }
.node.active rect, .node.active path { stroke:var(--clay); stroke-width:2.5; }
```

- 좌표는 손으로 격자에 맞춘다 (세로 간격 84, 노드 높이 48 같은 상수 하나를 정하고 지킨다).
- 가로로 길면 감싼 div 에 `overflow-x:auto` + `svg { min-width: 760px }`.
- 텍스트는 `<text class="m" text-anchor="middle">`, mono 로.

### 클릭 상세 패널

```js
const DETAIL = { build: { title:"…", meta:"~4 min", body:"…<code>x</code>…", code:"…" } };
const nodes = document.querySelectorAll(".node");
nodes.forEach(n => n.addEventListener("click", () => {
  nodes.forEach(x => x.classList.remove("active"));
  n.classList.add("active");
  const d = DETAIL[n.dataset.k]; if (!d) return;
  P_TITLE.textContent = d.title; P_META.textContent = d.meta;
  P_BODY.innerHTML = d.body; P_CODE.textContent = d.code;
}));
document.querySelector('.node[data-k="build"]').classList.add("active");  // 빈 패널로 시작하지 않는다
```

`body` 만 `innerHTML`(인라인 `<code>` 때문), 나머지는 `textContent`.

### 방향키 슬라이드

```js
const slides = [...document.querySelectorAll('.slide')];
let cur = 0;
const go = i => { cur = Math.max(0, Math.min(slides.length-1, i)); slides[cur].scrollIntoView({behavior:'smooth'}); };
addEventListener('keydown', e => {
  if (['ArrowRight','ArrowDown',' '].includes(e.key)) { e.preventDefault(); go(cur+1); }
  if (['ArrowLeft','ArrowUp'].includes(e.key))        { e.preventDefault(); go(cur-1); }
});
new IntersectionObserver(es => es.forEach(en => {
  if (en.isIntersecting) { cur = slides.indexOf(en.target); counter.textContent = `${cur+1} / ${slides.length}`; }
}), { threshold: .6 }).observe;  // slides.forEach(s => obs.observe(s))
```

### 코드 패널

```css
.code { background:var(--slate); border-radius:12px; padding:18px 20px; overflow-x:auto; }
.code pre { font-family:var(--mono); font-size:12.5px; line-height:1.65; color:#E8E6DE; white-space:pre; }
.code .kw { color:var(--clay); }  .code .str { color:var(--olive); }  .code .cm { color:var(--gray-500); }
```

하이라이터를 붙이지 않는다. 강조할 토큰만 손으로 `<span class="kw">` 을 두른다.

### SVG 내보내기 버튼

```js
btn.addEventListener('click', () => {
  const svg = document.getElementById(btn.dataset.target).outerHTML;
  const url = URL.createObjectURL(new Blob([svg], { type: 'image/svg+xml' }));
  Object.assign(document.createElement('a'), { href: url, download: btn.dataset.filename }).click();
  URL.revokeObjectURL(url);
});
```

주의: Artifact 로 게시하면 뷰어 샌드박스가 다운로드를 막는다. 로컬 파일로 열 때만 동작한다.

## 점검

- [ ] 외부 요청 0 (CDN · 폰트 · 이미지 · fetch)
- [ ] 900px 이하에서 다단이 1단으로
- [ ] 흐름도에 실패 경로와 범례가 있다
- [ ] 상세 패널이 로드 시 비어 있지 않다
- [ ] 식별자·수치가 mono 다
- [ ] 접힌 곳에 핵심 정보가 없다
