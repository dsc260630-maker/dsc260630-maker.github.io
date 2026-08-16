-- "DSC 오리지널" 카테고리용 플래그. 테마 카테고리(액션/퍼즐/...)와는 별개로,
-- DSC GAMES가 직접 만든 게임인지 여부를 표시한다. 프론트에서 "DSC 오리지널" 필터를
-- 고를 때는 category와 무관하게 is_original=true인 게임만 보여주고, 평소 테마별
-- 필터에서는 원래대로 category로만 걸러지므로 오리지널 게임도 그대로 노출된다.
alter table public.games add column is_original boolean not null default false;

-- 지금까지 등록된 18개 게임은 전부 DSC GAMES가 직접 만든 오리지널이므로 일괄 표시.
-- (이후 커뮤니티 업로드가 열리면 새 게임은 기본값 false로 들어간다)
update public.games set is_original = true;
