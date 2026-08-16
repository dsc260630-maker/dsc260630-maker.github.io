// 실제 게임 목록은 Supabase DB에서 불러옵니다 (app.js의 loadGames 참고).
// 서버에서 데이터가 도착하기 전까지는 빈 배열로 시작합니다.
let GAMES = [];

// 필터/업로드에서 사용할 고정 카테고리 목록
// 'DSC 오리지널'은 테마가 아니라 games.is_original 플래그로 걸러지는 특수 필터라서
// 업로드 폼의 테마 선택지에서는 제외해야 한다 (app.js의 gameCategories 참고).
const CATEGORIES = ['전체', 'DSC 오리지널', '액션', '퍼즐', '캐주얼', '전략', '레이싱', '슈팅'];
