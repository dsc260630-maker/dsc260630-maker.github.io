-- "DSC 리듬 (개발 중)" 등록 (RPG는 1부 비밀 정리 뒤 따로) (DSC 오리지널)
-- 개발 중인 미완성판, 계속 업데이트됩니다
-- 이 게임들은 다른 게임들과 달리 Storage에 올라간 단일 HTML이 아니라,
-- 레포지토리 안의 독립 페이지(/rhythm/index.html)로 서빙된다.
-- file_path는 not null 제약을 맞추기 위해 실제 경로를 그대로 적어두지만,
-- 프론트(js/app.js의 STANDALONE_GAME_URLS)에서 이 게임들은 Storage getPublicUrl()을
-- 거치지 않고 바로 이동하므로 이 컬럼 값 자체는 실제로 쓰이지 않는다.

insert into public.games (title, category, author_id, file_path, is_original)
values (
  'DSC 리듬 (개발 중)',
  '캐주얼',
  'ca471e54-7900-436a-bdf6-06be423d7070',
  'rhythm/index.html',
  true
);

