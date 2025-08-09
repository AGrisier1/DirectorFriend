-- The Director's Friend — Minimal schema for wallet cards app
create extension if not exists pgcrypto;

create table if not exists public.settings (
  key text primary key,
  value text not null,
  updated_at timestamptz not null default now()
);

create table if not exists public.cases (
  id uuid primary key default gen_random_uuid(),
  status text not null default 'active',
  case_no text,
  decedent_name text,
  fdic text,
  location text,
  visitation_when timestamptz,
  visitation_where text,
  visitation_note text,
  service_when timestamptz,
  service_where text,
  service_type text,
  service_note text,
  cemetery text,
  vault text,
  hearse text,
  clergy text,
  casket text,
  gather text,
  notes text,
  obituary boolean default false,
  veteran boolean default false,
  dc_created boolean default false,
  dc_signed boolean default false,
  dc_filed boolean default false,
  flag boolean default false,
  yellow_sheet boolean default false,
  print_goods boolean default false,
  fingerprints boolean default false,
  photo boolean default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end $$;

drop trigger if exists trg_cases_updated_at on public.cases;
create trigger trg_cases_updated_at before update on public.cases
for each row execute function public.set_updated_at();

alter table public.cases enable row level security;
alter table public.settings enable row level security;

drop policy if exists "anon read cases" on public.cases;
drop policy if exists "anon write cases" on public.cases;
drop policy if exists "anon update cases" on public.cases;
drop policy if exists "anon delete cases" on public.cases;
create policy "anon read cases" on public.cases for select using (true);
create policy "anon write cases" on public.cases for insert with check (true);
create policy "anon update cases" on public.cases for update using (true);
create policy "anon delete cases" on public.cases for delete using (true);

drop policy if exists "anon read settings" on public.settings;
drop policy if exists "anon write settings" on public.settings;
drop policy if exists "anon update settings" on public.settings;
drop policy if exists "anon delete settings" on public.settings;
create policy "anon read settings" on public.settings for select using (true);
create policy "anon write settings" on public.settings for insert with check (true);
create policy "anon update settings" on public.settings for update using (true);
create policy "anon delete settings" on public.settings for delete using (true);

insert into public.cases (status, case_no, decedent_name, fdic, location, service_when, service_where, service_type, visitation_when, visitation_where, clergy, casket, obituary, veteran)
select 'active','24-194','Don Ruffer','AG','GFH-S', now() + interval '4 hours','GFH-S','FSC', now(),'GFH-S','Pastor Alex Ruffer','Rental', true, true
where not exists (select 1 from public.cases);
