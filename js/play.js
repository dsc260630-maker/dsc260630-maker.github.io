// ============================================
// 게임 상세 페이지(/play/*.html) 공용 스크립트
// body의 data-game-id / data-file-path 값을 읽어 해당 게임 하나만 재생/채점한다.
// ============================================

const GAME_ID = Number(document.body.dataset.gameId);
const GAME_FILE_PATH = document.body.dataset.filePath;

let myBestScore = null;
let currentGameBlobUrl = null;
let currentScoreHandler = null;

function getGamePublicUrl(filePath) {
  const { data } = sb.storage.from('game-files').getPublicUrl(filePath);
  return data.publicUrl;
}

function renderBestScoreLine() {
  const el = document.getElementById('playStartScore');
  if (!el) return;
  el.textContent = myBestScore
    ? `내 최고 점수: ${myBestScore.toLocaleString()}`
    : '아직 플레이 기록이 없어요';
}

// auth.js의 로그인 상태 변경 콜백이 이 이름을 찾아 자동으로 호출한다 (index.html과 동일한 훅)
async function loadMyScores() {
  if (!currentUser) {
    myBestScore = null;
    renderBestScoreLine();
    return;
  }
  const { data, error } = await sb
    .from('high_scores')
    .select('score')
    .eq('game_id', GAME_ID)
    .maybeSingle();
  if (!error) myBestScore = data ? data.score : null;
  renderBestScoreLine();
}

async function submitScore(score) {
  if (!currentUser) return;
  if (myBestScore && score <= myBestScore) return;

  const { error } = await sb.rpc('submit_score', { p_game_id: GAME_ID, p_score: score });
  if (error) {
    console.error('점수 기록 실패:', error.message);
    return;
  }
  myBestScore = score;
  renderBestScoreLine();
  showToast(`최고 점수 갱신: ${score.toLocaleString()}`);
}

async function startGame() {
  document.getElementById('playStartScreen').hidden = true;
  document.getElementById('playLoading').hidden = false;
  const frame = document.getElementById('playFrame');

  if (currentScoreHandler) window.removeEventListener('message', currentScoreHandler);
  currentScoreHandler = (event) => {
    if (event.source !== frame.contentWindow) return;
    if (!event.data || event.data.type !== 'gamebox:score') return;
    const score = Math.floor(Number(event.data.score));
    if (!Number.isFinite(score) || score < 0) return;
    submitScore(score);
  };
  window.addEventListener('message', currentScoreHandler);

  // Supabase Storage가 공개 버킷의 HTML을 text/plain으로 강제 서빙하기 때문에
  // <iframe src="게임파일URL">로는 실행이 안 됨 → fetch로 원문을 받아온 뒤 blob URL을 만들어 그걸 src로 넣는다.
  let blobUrl;
  try {
    const res = await fetch(getGamePublicUrl(GAME_FILE_PATH));
    if (!res.ok) throw new Error(`파일을 불러오지 못했습니다 (${res.status})`);
    const html = await res.text();
    blobUrl = URL.createObjectURL(new Blob([html], { type: 'text/html' }));
  } catch (err) {
    document.getElementById('playLoading').hidden = true;
    document.getElementById('playStartScreen').hidden = false;
    showToast(`게임을 불러오지 못했습니다: ${err.message}`);
    return;
  }

  document.getElementById('playLoading').hidden = true;
  frame.hidden = false;
  if (currentGameBlobUrl) URL.revokeObjectURL(currentGameBlobUrl);
  currentGameBlobUrl = blobUrl;
  frame.src = blobUrl;

  sb.rpc('increment_plays', { game_id: GAME_ID }).then(({ error }) => {
    if (error) console.error('플레이 수 반영 실패:', error.message);
  });
}

function showToast(message) {
  let toast = document.getElementById('toast');
  if (!toast) {
    toast = document.createElement('div');
    toast.id = 'toast';
    toast.className = 'toast';
    document.body.appendChild(toast);
  }
  toast.textContent = message;
  toast.classList.add('show');
  clearTimeout(showToast._timer);
  showToast._timer = setTimeout(() => toast.classList.remove('show'), 2200);
}

document.getElementById('startGameBtn').addEventListener('click', startGame);
loadMyScores();
