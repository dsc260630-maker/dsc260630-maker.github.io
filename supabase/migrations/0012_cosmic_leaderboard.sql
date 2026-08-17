-- 코스믹 머지 게임 자체의 랭킹(오늘/주간/월간/명예의 전당/완성시간)을 실제로
-- 기기 간에 공유되는 테이블로 옮긴다. 지금까지는 localStorage에만 저장돼서
-- 기기/브라우저마다 서로 다른 순위가 보이는 문제가 있었음.
--
-- 사이트 메인 랭킹(high_scores, game_id=31)과는 완전히 별개 — 코스믹 머지는
-- 자체적으로 오늘/주간/월간/전체/완성시간 다중 카테고리를 제공하는데, 그건
-- 이 테이블이 담당하고 site 쪽 high_scores는 지금처럼 최고점수 1개만 유지한다.
create table public.cosmic_leaderboard (
  id bigint generated always as identity primary key,
  user_id uuid not null references public.profiles(id) on delete cascade,
  category text not null check (category in ('score', 'bhtime')),
  value integer not null check (value > 0),
  created_at timestamptz not null default now()
);

alter table public.cosmic_leaderboard enable row level security;

-- 조회는 로그인 여부와 무관하게 누구나 가능 (게임 자체는 비로그인으로도 플레이 가능하므로)
create policy "cosmic leaderboard viewable by everyone"
  on public.cosmic_leaderboard for select
  using (true);

-- 등록은 로그인한 사용자가 본인 이름으로만 가능
create policy "authenticated users can submit their own cosmic leaderboard record"
  on public.cosmic_leaderboard for insert
  to authenticated
  with check (auth.uid() = user_id);

-- 오늘/주간/월간 필터링 + 정렬용 인덱스
create index cosmic_leaderboard_category_value_idx
  on public.cosmic_leaderboard (category, value, created_at desc);

notify pgrst, 'reload schema';
