-- ============================================================
-- CORRIDA UVA 26-27 · Script de creación de tablas en Supabase
-- Ejecutar en: Supabase → SQL Editor → New query → pegar → Run
-- Todas las tablas usan el prefijo corrida_ para no chocar con
-- las tablas de tus otras apps en el mismo proyecto.
-- ============================================================

-- 1) LOTES: datos maestros + fechas manuales + fórmulas + labores excluidas
create table if not exists corrida_lotes (
  lote text primary key,
  fundo text not null,
  area numeric not null default 0,
  variedad text,
  fenologia integer,
  poda date,
  cianamida date,
  formulas jsonb not null default '{}'::jsonb,
  excluidas jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now()
);

-- 2) FECHAS REALES por lote y labor
create table if not exists corrida_reales (
  lote text not null,
  labor text not null,
  fecha date not null,
  primary key (lote, labor)
);

-- 3) PAUTAS con valores de parámetros, precio por turno y ev. de calidad
create table if not exists corrida_pautas (
  id uuid primary key default gen_random_uuid(),
  labor text not null,
  lote text not null default '',
  pauta text not null default '',
  pauta_val jsonb not null default '{}'::jsonb,
  precio jsonb not null default '{}'::jsonb,
  ev jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

-- 4) PARÁMETROS por labor (tipo: 'pauta' o 'ev')
create table if not exists corrida_parametros (
  tipo text not null,
  labor text not null,
  lista jsonb not null default '[]'::jsonb,
  primary key (tipo, labor)
);

-- 5) MATERIALES (EPPs e insumos) con labores asignadas
create table if not exists corrida_materiales (
  id uuid primary key default gen_random_uuid(),
  nombre text not null default '',
  tipo text not null default 'Insumo',
  unidad text not null default '',
  duracion_dias text not null default '',
  cantidad_ha text not null default '',
  labores jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now()
);

-- ============================================================
-- SEGURIDAD (RLS): acceso abierto con la anon key.
-- Nota: cualquiera que tenga el link de la app puede ver y editar.
-- Si más adelante quieres login como en tu app POS, se puede agregar.
-- ============================================================
alter table corrida_lotes enable row level security;
alter table corrida_reales enable row level security;
alter table corrida_pautas enable row level security;
alter table corrida_parametros enable row level security;
alter table corrida_materiales enable row level security;

drop policy if exists corrida_lotes_todo on corrida_lotes;
create policy corrida_lotes_todo on corrida_lotes for all using (true) with check (true);

drop policy if exists corrida_reales_todo on corrida_reales;
create policy corrida_reales_todo on corrida_reales for all using (true) with check (true);

drop policy if exists corrida_pautas_todo on corrida_pautas;
create policy corrida_pautas_todo on corrida_pautas for all using (true) with check (true);

drop policy if exists corrida_parametros_todo on corrida_parametros;
create policy corrida_parametros_todo on corrida_parametros for all using (true) with check (true);

drop policy if exists corrida_materiales_todo on corrida_materiales;
create policy corrida_materiales_todo on corrida_materiales for all using (true) with check (true);

-- ============================================================
-- COLUMNAS DE AUDITORÍA: quién y cuándo hizo cada cambio
-- (ejecutar también si ya habías corrido el script antes)
-- ============================================================
alter table corrida_lotes      add column if not exists modificado_por text;
alter table corrida_lotes      add column if not exists modificado_en timestamptz;
alter table corrida_reales     add column if not exists modificado_por text;
alter table corrida_reales     add column if not exists modificado_en timestamptz;
alter table corrida_pautas     add column if not exists modificado_por text;
alter table corrida_pautas     add column if not exists modificado_en timestamptz;
alter table corrida_materiales add column if not exists modificado_por text;
alter table corrida_materiales add column if not exists modificado_en timestamptz;

-- Bitácora de cambios: historial completo de quién cambió qué
create table if not exists corrida_bitacora (
  id bigint generated always as identity primary key,
  usuario text not null,
  fundo text,
  accion text not null,
  detalle text,
  creado_en timestamptz not null default now()
);
alter table corrida_bitacora enable row level security;
drop policy if exists corrida_bitacora_todo on corrida_bitacora;
create policy corrida_bitacora_todo on corrida_bitacora for all using (true) with check (true);

-- ============================================================
-- PROGRAMA SEMANAL: N.P (personas) y lote por día/labor/fundo
-- Se identifica por la fecha del lunes de esa semana (semana_lunes)
-- ============================================================
create table if not exists corrida_semanal (
  id text primary key,          -- "semana_lunes|fundo|labor|dia"
  semana_lunes date not null,
  fundo text not null,
  labor text not null,
  dia integer not null,         -- 0=lunes ... 6=domingo
  lotes text default '',        -- ej. "A13/A6" (autollenado, editable)
  np text default '',           -- número de personas
  modificado_por text,
  modificado_en timestamptz
);
alter table corrida_semanal enable row level security;
drop policy if exists corrida_semanal_todo on corrida_semanal;
create policy corrida_semanal_todo on corrida_semanal for all using (true) with check (true);
