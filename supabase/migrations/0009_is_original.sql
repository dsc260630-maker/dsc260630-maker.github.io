-- "DSC 오리지널" 카테고리용 플래그. 테마 카테고리(액션/퍼즐/...)와는 별개로,
-- 이후 별도로 지정해서 새로 올리는 고퀄리티 게임인지 여부를 표시한다. 프론트에서
-- "DSC 오리지널" 필터를 고를 때는 category와 무관하게 is_original=true인 게임만
-- 보여주고, 평소 테마별 필터에서는 원래대로 category로만 걸러지므로 오리지널
-- 게임도 그대로 노출된다.
-- 기존에 있던 18개 게임은 대상이 아니므로 기본값 false 그대로 둔다 (일괄 update 없음).
alter table public.games add column is_original boolean not null default false;
