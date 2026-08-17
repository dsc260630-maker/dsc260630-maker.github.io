-- "코스믹 머지 : 블랙홀의 위엄" 등록 (DSC 오리지널 1호작)
-- 이 게임은 다른 게임들과 달리 Storage에 올라간 단일 HTML이 아니라,
-- 레포지토리 안의 독립 페이지(/cosmic-merge/index.html)로 서빙된다.
-- file_path는 not null 제약을 맞추기 위해 실제 경로를 그대로 적어두지만,
-- 프론트(js/app.js의 STANDALONE_GAME_URLS)에서 이 게임은 Storage getPublicUrl()을
-- 거치지 않고 바로 이동하므로 이 컬럼 값 자체는 실제로 쓰이지 않는다.
insert into public.games (title, category, author_id, file_path, is_original)
values (
  '코스믹 머지 : 블랙홀의 위엄',
  '퍼즐',
  'ca471e54-7900-436a-bdf6-06be423d7070',
  'cosmic-merge/index.html',
  true
);
