-- ============================================================
-- ULTI-MED Complete Database Schema
-- Run this entire script in Supabase SQL Editor
-- ============================================================

-- VIDEOS TABLE
create table if not exists videos (
  id uuid default gen_random_uuid() primary key,
  title text not null,
  description text,
  youtube_url text,
  category text default 'Overview',
  duration text,
  thumb_emoji text default '🏥',
  published boolean default true,
  sort_order integer default 0,
  created_at timestamp with time zone default now()
);

-- DOWNLOADS TABLE
create table if not exists downloads (
  id uuid default gen_random_uuid() primary key,
  title text not null,
  description text,
  file_url text,
  file_type text default 'pdf',
  file_icon text default '📄',
  file_size text,
  visibility text default 'public',
  sort_order integer default 0,
  download_count integer default 0,
  created_at timestamp with time zone default now()
);

-- FEATURES TABLE
create table if not exists features (
  id uuid default gen_random_uuid() primary key,
  icon text default '⭐',
  title text not null,
  description text,
  category text default 'safety',
  tag_label text default 'Feature',
  tag_class text default 'tag-safety',
  published boolean default true,
  sort_order integer default 0,
  created_at timestamp with time zone default now()
);

-- TESTIMONIALS TABLE
create table if not exists testimonials (
  id uuid default gen_random_uuid() primary key,
  quote text not null,
  author_name text not null,
  author_role text,
  hospital text,
  author_initials text,
  published boolean default false,
  sort_order integer default 0,
  created_at timestamp with time zone default now()
);

-- LEADS / CRM TABLE
create table if not exists leads (
  id uuid default gen_random_uuid() primary key,
  first_name text,
  last_name text,
  hospital text not null,
  role text,
  phone text,
  email text,
  bed_count text,
  current_system text,
  stage text default 'New Lead',
  pipeline_value text,
  source text default 'Website',
  notes text,
  priority text default 'Normal',
  -- Infrastructure fields from questionnaire
  consulting_rooms text,
  lan_needed text,
  wifi_needed text,
  computers_needed text,
  power_backup text,
  radiology_integration text,
  radiology_station text,
  radiology_count text,
  infra_notes text,
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);

-- PROPOSALS TABLE
create table if not exists proposals (
  id uuid default gen_random_uuid() primary key,
  ref_number text unique,
  lead_id uuid references leads(id),
  hospital text not null,
  contact_name text,
  modules text,
  bed_count text,
  proposed_value text,
  valid_until date,
  status text default 'Draft',
  notes text,
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);

-- SUPPORT TICKETS TABLE
create table if not exists tickets (
  id uuid default gen_random_uuid() primary key,
  ticket_number text unique,
  title text not null,
  description text,
  hospital text,
  module_affected text,
  priority text default 'Medium',
  status text default 'Open',
  assigned_to text,
  resolution text,
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);

-- TICKET REPLIES TABLE
create table if not exists ticket_replies (
  id uuid default gen_random_uuid() primary key,
  ticket_id uuid references tickets(id) on delete cascade,
  message text not null,
  author text default 'Support Team',
  created_at timestamp with time zone default now()
);

-- AUDIT REQUESTS TABLE
create table if not exists audit_requests (
  id uuid default gen_random_uuid() primary key,
  first_name text,
  last_name text,
  hospital text not null,
  role text,
  phone text,
  email text,
  current_system text,
  challenge text,
  status text default 'New',
  created_at timestamp with time zone default now()
);

-- SITE SETTINGS TABLE
create table if not exists settings (
  id uuid default gen_random_uuid() primary key,
  key text unique not null,
  value text,
  updated_at timestamp with time zone default now()
);

-- ============================================================
-- SEED DEFAULT SETTINGS
-- ============================================================
insert into settings (key, value) values
  ('phone1', '+234 803 776 6592'),
  ('phone2', '+234 907 485 8480'),
  ('whatsapp', '2348037766592'),
  ('email', 'sales@ultimed.com.ng'),
  ('hero_headline', 'Your Hospital Is Losing Money Every Single Day. ULTI-MED Has Fixed That.'),
  ('hero_subtext', 'ULTI-MED is the only HIS in Nigeria with a built-in Service Gate, ICD-11 claims engine, drug interaction alerts, AI speech recognition, complete NHIS automation, and HMO policy management.')
on conflict (key) do nothing;

-- ============================================================
-- SEED DEFAULT VIDEOS
-- ============================================================
insert into videos (title, description, youtube_url, category, duration, thumb_emoji, sort_order) values
  ('ULTI-MED Full System Overview', 'A complete walkthrough of all major modules — from patient registration to final billing and claims submission.', '', 'Overview', '12:34', '🏥', 1),
  ('The Service Gate Explained', 'See exactly how the Service Gate blocks unbilled services at pharmacy, lab, theatre, and OPD — in real time.', '', 'Revenue', '6:22', '🚪', 2),
  ('Drug Interaction Alert System', 'Watch the system flag a dangerous drug combination before it reaches the patient — live, unscripted demo.', '', 'Safety', '4:15', '💊', 3),
  ('NHIS Claims — End to End', 'From patient enrolment to claim submission and approval — zero manual steps, ICD-11 coded automatically.', '', 'Compliance', '8:47', '📋', 4),
  ('HMO Policy Engine Setup', 'How to configure different tariff policies for multiple HMOs, retainers, and State Health Schemes simultaneously.', '', 'Compliance', '7:30', '⚙️', 5),
  ('AI Speech Recognition in Clinic', 'A clinician dictates consultation notes; the system transcribes and structures the data — no typing needed.', '', 'AI', '5:08', '🗣️', 6);

-- ============================================================
-- SEED DEFAULT DOWNLOADS
-- ============================================================
insert into downloads (title, description, file_url, file_type, file_icon, file_size, sort_order) values
  ('ULTI-MED Product Brochure', 'Full overview of all modules, features, and key differentiators. Ideal for sharing with your leadership team.', '#', 'pdf', '📄', '2.4 MB', 1),
  ('Executive Presentation Deck', 'A boardroom-ready slide deck covering the ROI case for switching to ULTI-MED.', '#', 'ppt', '📊', '5.1 MB', 2),
  ('NHIS Compliance Checklist', 'A detailed audit checklist covering all current NHIS regulations and how your system should be configured.', '#', 'pdf', '📋', '1.1 MB', 3),
  ('Revenue Leak Calculator (Excel)', 'Download the full Excel model to calculate your hospital specific revenue leakage across all categories.', '#', 'xls', '💰', '890 KB', 4),
  ('Implementation Roadmap Template', 'A week-by-week implementation guide showing exactly how the ULTI-MED rollout process works.', '#', 'doc', '📝', '1.3 MB', 5),
  ('Data Security & NDPR Compliance Guide', 'How ULTI-MED handles patient data under Nigeria NDPR regulations and HIPAA international best practices.', '#', 'pdf', '🔒', '980 KB', 6);

-- ============================================================
-- SEED DEFAULT FEATURES
-- ============================================================
insert into features (icon, title, description, category, tag_label, tag_class, sort_order) values
  ('💊', 'Drug Interaction Alerting', 'Real-time cross-checking of every prescription against a complete drug interaction database. Alerts clinicians before a dangerous combination is dispensed.', 'safety', 'Patient Safety', 'tag-safety', 1),
  ('🚨', 'Vital Sign Alerts & Escalation', 'Automated alerts trigger when patient vitals cross critical thresholds. The right team member is notified instantly before a crisis becomes a catastrophe.', 'safety', 'Patient Safety', 'tag-safety', 2),
  ('🚪', 'Service Gate — Revenue Lock', 'No service is rendered without payment verification or approved credit. Prevents revenue leakage at every touchpoint — OPD, pharmacy, lab, theatre.', 'revenue', 'Revenue', 'tag-revenue', 3),
  ('📋', 'ICD-11 Coding Engine', 'Automatic ICD-11 code assignment for all diagnoses and procedures. Dramatically increases claims approval rates and supports accurate epidemiological reporting.', 'compliance', 'Compliance', 'tag-compliance', 4),
  ('🤝', 'Full NHIS Module', 'Complete NHIS workflows from enrolment to capitation claims, pre-authorization, and dispute resolution — aligned with current NHIS regulations.', 'compliance', 'Compliance', 'tag-compliance', 5),
  ('⚙️', 'HMO Policy Engine', 'Configure and automate tariff policies for every HMO, retainer, or state health scheme. Each agreement is applied precisely — zero confusion, zero disputes.', 'revenue', 'Revenue', 'tag-revenue', 6),
  ('🗣️', 'AI Speech Recognition', 'Clinicians speak; the system transcribes. Structured clinical data captured by voice — reducing keyboard fatigue and improving documentation completeness.', 'ai', 'AI Technology', 'tag-ai', 7),
  ('✅', 'Data Validation Engine', 'Every field, every form, every entry is validated in real time. Mandatory fields, format checks, and logical rules ensure your data is always audit-ready.', 'data', 'Data Integrity', 'tag-data', 8),
  ('🔏', 'HIPAA & NDPR Compliance Framework', 'ULTI-MED is architected to meet HIPAA privacy and security rules alongside Nigeria NDPR. Audit trails, encryption at rest, role-based access, and breach notification workflows are all built in.', 'compliance', 'Compliance', 'tag-compliance', 9),
  ('📊', 'Statistical & Epidemiological Reports', 'Generate WHO-standard morbidity reports, occupancy analytics, and disease burden statistics — powered by clean, ICD-11 coded data.', 'data', 'Data Integrity', 'tag-data', 10),
  ('🔄', 'Private HMO Claims Automation', 'Build custom claim templates per HMO. The system populates, validates, and submits claims automatically — reducing billing workload by up to 70%.', 'compliance', 'Compliance', 'tag-compliance', 11),
  ('📱', 'Patient Portal & Mobile Access', 'Patients view their records, results, and appointment history. Clinicians access records securely from any device, anywhere in the facility.', 'ai', 'AI Technology', 'tag-ai', 12),
  ('🏦', 'Retainerships & Corporate Billing', 'Manage corporate retainer clients with credit limits, monthly statements, and automatic billing cycles — without manual reconciliation.', 'revenue', 'Revenue', 'tag-revenue', 13),
  ('🔐', 'Role-Based Access Control', 'Every user sees only what their role permits. Granular permissions protect patient privacy and prevent financial fraud.', 'data', 'Data Integrity', 'tag-data', 14),
  ('📅', 'Appointment & Theatre Scheduling', 'Intelligent scheduling across OPD, specialists, and theatres. Conflict detection, automated reminders, and utilisation reports included.', 'revenue', 'Revenue', 'tag-revenue', 15);

-- ============================================================
-- ENABLE ROW LEVEL SECURITY (public read, authenticated write)
-- ============================================================
alter table videos enable row level security;
alter table downloads enable row level security;
alter table features enable row level security;
alter table testimonials enable row level security;
alter table leads enable row level security;
alter table proposals enable row level security;
alter table tickets enable row level security;
alter table ticket_replies enable row level security;
alter table audit_requests enable row level security;
alter table settings enable row level security;

-- Public can READ videos, downloads, features, testimonials, settings
create policy "Public read videos" on videos for select using (true);
create policy "Public read downloads" on downloads for select using (true);
create policy "Public read features" on features for select using (true);
create policy "Public read testimonials" on testimonials for select using (published = true);
create policy "Public read settings" on settings for select using (true);

-- Anyone can INSERT leads, proposals, tickets, audit_requests (form submissions)
create policy "Public insert leads" on leads for insert with check (true);
create policy "Public insert proposals" on proposals for insert with check (true);
create policy "Public insert tickets" on tickets for insert with check (true);
create policy "Public insert ticket_replies" on ticket_replies for insert with check (true);
create policy "Public insert audit_requests" on audit_requests for insert with check (true);

-- Anyone can READ tickets (for portal view)
create policy "Public read leads" on leads for select using (true);
create policy "Public read proposals" on proposals for select using (true);
create policy "Public read tickets" on tickets for select using (true);
create policy "Public read ticket_replies" on ticket_replies for select using (true);
create policy "Public read audit_requests" on audit_requests for select using (true);

-- Anyone can UPDATE leads, proposals, tickets (for portal status updates)
create policy "Public update leads" on leads for update using (true);
create policy "Public update proposals" on proposals for update using (true);
create policy "Public update tickets" on tickets for update using (true);

-- Anyone can write videos, downloads, features, testimonials (CMS)
create policy "Public write videos" on videos for all using (true);
create policy "Public write downloads" on downloads for all using (true);
create policy "Public write features" on features for all using (true);
create policy "Public write testimonials" on testimonials for all using (true);
create policy "Public write settings" on settings for all using (true);

-- ============================================================
-- AUTO-GENERATE TICKET NUMBERS
-- ============================================================
create or replace function generate_ticket_number()
returns trigger as $$
begin
  new.ticket_number := 'TK-' || to_char(now(), 'YYYY') || '-' || lpad(cast(floor(random() * 9000 + 1000) as text), 4, '0');
  return new;
end;
$$ language plpgsql;

create trigger set_ticket_number
before insert on tickets
for each row execute function generate_ticket_number();

-- AUTO-GENERATE PROPOSAL REFERENCE NUMBERS
create or replace function generate_proposal_ref()
returns trigger as $$
begin
  new.ref_number := 'PRO-' || to_char(now(), 'YYYY') || '-' || lpad(cast(floor(random() * 900 + 100) as text), 3, '0');
  return new;
end;
$$ language plpgsql;

create trigger set_proposal_ref
before insert on proposals
for each row execute function generate_proposal_ref();

-- ============================================================
-- Done! All tables created and seeded.
-- ============================================================
