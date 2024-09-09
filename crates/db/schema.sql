SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: basic_auth_method; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.basic_auth_method AS ENUM (
    'environment',
    'basic'
);


--
-- Name: group_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.group_role AS ENUM (
    'owner',
    'member'
);


--
-- Name: organization_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.organization_role AS ENUM (
    'owner',
    'admin',
    'contributor',
    'reader',
    'no-access'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.groups (
    organization_name character varying(255) NOT NULL,
    group_name_slug character varying(255) NOT NULL,
    group_display_name character varying(255),
    role public.organization_role NOT NULL,
    CONSTRAINT well_formatted_name_slug CHECK (((group_name_slug)::text ~* '^[a-z0-9-]+$'::text))
);


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations (
    name_slug character varying(255) NOT NULL,
    display_name character varying(255),
    CONSTRAINT well_formatted_name_slug CHECK (((name_slug)::text ~* '^[a-z0-9-]+$'::text))
);


--
-- Name: repositories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.repositories (
    name character varying(256)
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying(128) NOT NULL
);


--
-- Name: user_basic_auth_methods; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_basic_auth_methods (
    username character varying(255) NOT NULL,
    method public.basic_auth_method NOT NULL,
    value character varying(255)
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    username character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    is_super_user boolean DEFAULT false,
    CONSTRAINT well_formatted_email CHECK (((email)::text ~* '^[a-zA-Z0-9.!#$%&''''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$'::text)),
    CONSTRAINT well_formatted_username CHECK (((username)::text ~* '^[a-z0-9-]+$'::text))
);


--
-- Name: users_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_groups (
    username character varying(255) NOT NULL,
    organization_name character varying(255) NOT NULL,
    group_name_slug character varying(255) NOT NULL,
    role public.organization_role NOT NULL
);


--
-- Name: users_organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_organizations (
    username character varying(255) NOT NULL,
    organization_name character varying(255) NOT NULL,
    role public.organization_role NOT NULL
);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (organization_name, group_name_slug);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (name_slug);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: user_basic_auth_methods user_basic_auth_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_basic_auth_methods
    ADD CONSTRAINT user_basic_auth_methods_pkey PRIMARY KEY (username);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users_groups users_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_groups
    ADD CONSTRAINT users_groups_pkey PRIMARY KEY (username, organization_name, group_name_slug);


--
-- Name: users_organizations users_organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_organizations
    ADD CONSTRAINT users_organizations_pkey PRIMARY KEY (username, organization_name);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (username);


--
-- Name: idx__groups__display_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx__groups__display_name ON public.groups USING btree (group_name_slug);


--
-- Name: idx__organizations__display_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx__organizations__display_name ON public.organizations USING btree (display_name);


--
-- Name: idx__users_groups__username__group_name_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx__users_groups__username__group_name_slug ON public.users_groups USING btree (username, group_name_slug);


--
-- Name: idx__users_groups__username__organization_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx__users_groups__username__organization_name ON public.users_groups USING btree (username, organization_name);


--
-- Name: idx__users_organizations__organization_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx__users_organizations__organization_name ON public.users_organizations USING btree (organization_name);


--
-- Name: groups groups_organization_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_organization_name_fkey FOREIGN KEY (organization_name) REFERENCES public.organizations(name_slug) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_basic_auth_methods user_basic_auth_methods_username_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_basic_auth_methods
    ADD CONSTRAINT user_basic_auth_methods_username_fkey FOREIGN KEY (username) REFERENCES public.users(username) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: users_groups users_groups_organization_name_group_name_slug_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_groups
    ADD CONSTRAINT users_groups_organization_name_group_name_slug_fkey FOREIGN KEY (organization_name, group_name_slug) REFERENCES public.groups(organization_name, group_name_slug);


--
-- Name: users_groups users_groups_username_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_groups
    ADD CONSTRAINT users_groups_username_fkey FOREIGN KEY (username) REFERENCES public.users(username) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: users_organizations users_organizations_organization_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_organizations
    ADD CONSTRAINT users_organizations_organization_name_fkey FOREIGN KEY (organization_name) REFERENCES public.organizations(name_slug) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: users_organizations users_organizations_username_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_organizations
    ADD CONSTRAINT users_organizations_username_fkey FOREIGN KEY (username) REFERENCES public.users(username) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--


--
-- Dbmate schema migrations
--

INSERT INTO public.schema_migrations (version) VALUES
    ('20240908001602'),
    ('20240908182139'),
    ('20240909015359'),
    ('20240909025555');
