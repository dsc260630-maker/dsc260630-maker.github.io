-- 코스믹 머지의 진행 데이터(우주먼지/인벤토리/연구소/퀘스트/업적/통계/도감/최고점수)를
-- 계정별로 저장한다. 지금까지는 전부 localStorage였어서 로그인 계정과 무관하게
-- "이 브라우저에 마지막으로 저장된 값"을 공유해서 보여주는 문제가 있었음.
--
-- 오디오 설정(cosmic_audio_settings)은 계정과 무관하게 기기별로 남아도 되는 값이라
-- 동기화 대상에서 제외한다 (사용자 확인함).
--
-- 랭킹(cosmic_leaderboard)과 달리 이 데이터는 본인 것만 조회 가능 — 다른 사람이 남의
-- 코인/연구 진행도를 볼 이유가 없음.
create table public.cosmic_save (
  user_id uuid primary key references public.profiles(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.cosmic_save enable row level security;

create policy "users can view their own cosmic save"
  on public.cosmic_save for select
  to authenticated
  using (auth.uid() = user_id);

create policy "users can insert their own cosmic save"
  on public.cosmic_save for insert
  to authenticated
  with check (auth.uid() = user_id);

create policy "users can update their own cosmic save"
  on public.cosmic_save for update
  to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

notify pgrst, 'reload schema';
