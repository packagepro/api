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
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: artifact_storage_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.artifact_storage_type AS ENUM (
    'file-system',
    's3',
    'azure-blob-storage'
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


--
-- Name: repository_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.repository_role AS ENUM (
    'owner',
    'admin',
    'contributor',
    'reader',
    'no-access'
);


--
-- Name: repository_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.repository_type AS ENUM (
    'raw'
);


--
-- Name: package_pro_update_modtime(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.package_pro_update_modtime() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: artifact_licenses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.artifact_licenses (
    organization_name character varying(255) NOT NULL,
    repository_name_slug character varying(255) NOT NULL,
    version_name character varying(255) NOT NULL,
    spdx_identifier character varying(255) NOT NULL,
    spdx_full_name character varying(255) NOT NULL
);


--
-- Name: artifact_storage_configuration; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.artifact_storage_configuration (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    organization_name character varying(255) NOT NULL,
    type public.artifact_storage_type NOT NULL,
    configuration json NOT NULL,
    notes text
);


--
-- Name: artifacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.artifacts (
    organization_name character varying(255) NOT NULL,
    repository_name_slug character varying(255) NOT NULL,
    version_name character varying(255) NOT NULL,
    storage_configuration uuid NOT NULL,
    storage_location text NOT NULL,
    author character varying(255) NOT NULL,
    uncompressed_byte_count bigint NOT NULL,
    compressed_byte_count bigint NOT NULL,
    digest_sha1 character varying(255) NOT NULL,
    digest_sha256 character varying(255) NOT NULL,
    digest_sha512 character varying(255) NOT NULL,
    digest_md5 character varying(255) NOT NULL,
    digest_blake2b_256 character varying(255) NOT NULL,
    published_at date DEFAULT now() NOT NULL
);


--
-- Name: groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.groups (
    organization_name character varying(255) NOT NULL,
    group_name_slug character varying(255) NOT NULL,
    group_display_name character varying(255),
    role public.organization_role NOT NULL,
    created_at date DEFAULT now() NOT NULL,
    updated_at date DEFAULT now() NOT NULL,
    CONSTRAINT well_formatted_name_slug CHECK (((group_name_slug)::text ~* '^[a-z0-9-]+$'::text))
);


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations (
    name_slug character varying(255) NOT NULL,
    display_name character varying(255),
    created_at date DEFAULT now() NOT NULL,
    updated_at date DEFAULT now() NOT NULL,
    CONSTRAINT well_formatted_name_slug CHECK (((name_slug)::text ~* '^[a-z0-9-]+$'::text))
);


--
-- Name: repositories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.repositories (
    organization_name character varying(255) NOT NULL,
    repository_name_slug character varying(255) NOT NULL,
    type public.repository_type NOT NULL,
    description character varying(255),
    scm_repository_url character varying(255),
    created_at date DEFAULT now() NOT NULL,
    updated_at date DEFAULT now() NOT NULL,
    CONSTRAINT well_formatted_name_slug CHECK (((repository_name_slug)::text ~* '^[a-z0-9-]+$'::text))
);


--
-- Name: repositories_groups_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.repositories_groups_permissions (
    organization_name character varying(255) NOT NULL,
    group_name_slug character varying(255) NOT NULL,
    repository_name_slug character varying(255) NOT NULL,
    role public.repository_role NOT NULL,
    created_at date DEFAULT now() NOT NULL,
    updated_at date DEFAULT now() NOT NULL
);


--
-- Name: repositories_users_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.repositories_users_permissions (
    username character varying(255) NOT NULL,
    organization_name character varying(255) NOT NULL,
    repository_name_slug character varying(255) NOT NULL,
    role public.repository_role NOT NULL,
    created_at date DEFAULT now() NOT NULL,
    updated_at date DEFAULT now() NOT NULL
);


--
-- Name: repository_labels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.repository_labels (
    organization_name character varying(255) NOT NULL,
    repository_name_slug character varying(255) NOT NULL,
    label character varying(255) NOT NULL,
    created_at date DEFAULT now() NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying(128) NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    username character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(256) NOT NULL,
    is_super_user boolean DEFAULT false NOT NULL,
    created_at date DEFAULT now() NOT NULL,
    updated_at date DEFAULT now() NOT NULL,
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
    role public.group_role NOT NULL,
    created_at date DEFAULT now() NOT NULL,
    updated_at date DEFAULT now() NOT NULL
);


--
-- Name: users_organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_organizations (
    username character varying(255) NOT NULL,
    organization_name character varying(255) NOT NULL,
    role public.organization_role NOT NULL,
    created_at date DEFAULT now() NOT NULL,
    updated_at date DEFAULT now() NOT NULL
);


--
-- Name: artifact_licenses artifact_licenses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artifact_licenses
    ADD CONSTRAINT artifact_licenses_pkey PRIMARY KEY (organization_name, repository_name_slug, version_name, spdx_identifier);


--
-- Name: artifact_storage_configuration artifact_storage_configuration_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artifact_storage_configuration
    ADD CONSTRAINT artifact_storage_configuration_pkey PRIMARY KEY (id);


--
-- Name: artifacts artifacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artifacts
    ADD CONSTRAINT artifacts_pkey PRIMARY KEY (organization_name, repository_name_slug, version_name);


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
-- Name: repositories_groups_permissions repositories_groups_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repositories_groups_permissions
    ADD CONSTRAINT repositories_groups_permissions_pkey PRIMARY KEY (organization_name, group_name_slug, repository_name_slug);


--
-- Name: repositories repositories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repositories
    ADD CONSTRAINT repositories_pkey PRIMARY KEY (organization_name, repository_name_slug);


--
-- Name: repositories_users_permissions repositories_users_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repositories_users_permissions
    ADD CONSTRAINT repositories_users_permissions_pkey PRIMARY KEY (username, organization_name, repository_name_slug);


--
-- Name: repository_labels repository_labels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repository_labels
    ADD CONSTRAINT repository_labels_pkey PRIMARY KEY (organization_name, repository_name_slug, label);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


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
-- Name: idx__repositories_users_permissions__username__organization_nam; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx__repositories_users_permissions__username__organization_nam ON public.repositories_users_permissions USING btree (username, organization_name);


--
-- Name: idx__repositories_users_permissions__username__repository_name_; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx__repositories_users_permissions__username__repository_name_ ON public.repositories_users_permissions USING btree (username, repository_name_slug);


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
-- Name: groups groups_update_modtime; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER groups_update_modtime BEFORE UPDATE ON public.groups FOR EACH ROW EXECUTE FUNCTION public.package_pro_update_modtime();


--
-- Name: organizations organizations_update_modtime; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER organizations_update_modtime BEFORE UPDATE ON public.organizations FOR EACH ROW EXECUTE FUNCTION public.package_pro_update_modtime();


--
-- Name: repositories_groups_permissions repositories_groups_permissions_update_modtime; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER repositories_groups_permissions_update_modtime BEFORE UPDATE ON public.repositories_groups_permissions FOR EACH ROW EXECUTE FUNCTION public.package_pro_update_modtime();


--
-- Name: repositories repositories_update_modtime; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER repositories_update_modtime BEFORE UPDATE ON public.repositories FOR EACH ROW EXECUTE FUNCTION public.package_pro_update_modtime();


--
-- Name: repositories_users_permissions repositories_users_permissions_update_modtime; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER repositories_users_permissions_update_modtime BEFORE UPDATE ON public.repositories_users_permissions FOR EACH ROW EXECUTE FUNCTION public.package_pro_update_modtime();


--
-- Name: users_groups users_groups_update_modtime; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER users_groups_update_modtime BEFORE UPDATE ON public.users_groups FOR EACH ROW EXECUTE FUNCTION public.package_pro_update_modtime();


--
-- Name: users_organizations users_organizations_update_modtime; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER users_organizations_update_modtime BEFORE UPDATE ON public.users_organizations FOR EACH ROW EXECUTE FUNCTION public.package_pro_update_modtime();


--
-- Name: users users_update_modtime; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER users_update_modtime BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.package_pro_update_modtime();


--
-- Name: artifact_licenses artifact_licenses_organization_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artifact_licenses
    ADD CONSTRAINT artifact_licenses_organization_name_fkey FOREIGN KEY (organization_name) REFERENCES public.organizations(name_slug) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: artifact_licenses artifact_licenses_organization_name_repository_name_slug_v_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artifact_licenses
    ADD CONSTRAINT artifact_licenses_organization_name_repository_name_slug_v_fkey FOREIGN KEY (organization_name, repository_name_slug, version_name) REFERENCES public.artifacts(organization_name, repository_name_slug, version_name);


--
-- Name: artifact_storage_configuration artifact_storage_configuration_organization_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artifact_storage_configuration
    ADD CONSTRAINT artifact_storage_configuration_organization_name_fkey FOREIGN KEY (organization_name) REFERENCES public.organizations(name_slug) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: artifacts artifacts_author_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artifacts
    ADD CONSTRAINT artifacts_author_fkey FOREIGN KEY (author) REFERENCES public.users(username) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: artifacts artifacts_organization_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artifacts
    ADD CONSTRAINT artifacts_organization_name_fkey FOREIGN KEY (organization_name) REFERENCES public.organizations(name_slug) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: artifacts artifacts_organization_name_repository_name_slug_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artifacts
    ADD CONSTRAINT artifacts_organization_name_repository_name_slug_fkey FOREIGN KEY (organization_name, repository_name_slug) REFERENCES public.repositories(organization_name, repository_name_slug) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: artifacts artifacts_storage_configuration_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artifacts
    ADD CONSTRAINT artifacts_storage_configuration_fkey FOREIGN KEY (storage_configuration) REFERENCES public.artifact_storage_configuration(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: groups groups_organization_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_organization_name_fkey FOREIGN KEY (organization_name) REFERENCES public.organizations(name_slug) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: repositories_groups_permissions repositories_groups_permissio_organization_name_group_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repositories_groups_permissions
    ADD CONSTRAINT repositories_groups_permissio_organization_name_group_name_fkey FOREIGN KEY (organization_name, group_name_slug) REFERENCES public.groups(organization_name, group_name_slug) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: repositories_groups_permissions repositories_groups_permissio_organization_name_repository_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repositories_groups_permissions
    ADD CONSTRAINT repositories_groups_permissio_organization_name_repository_fkey FOREIGN KEY (organization_name, repository_name_slug) REFERENCES public.repositories(organization_name, repository_name_slug) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: repositories_groups_permissions repositories_groups_permissions_organization_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repositories_groups_permissions
    ADD CONSTRAINT repositories_groups_permissions_organization_name_fkey FOREIGN KEY (organization_name) REFERENCES public.organizations(name_slug) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: repositories repositories_organization_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repositories
    ADD CONSTRAINT repositories_organization_name_fkey FOREIGN KEY (organization_name) REFERENCES public.organizations(name_slug) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: repositories_users_permissions repositories_users_permission_organization_name_repository_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repositories_users_permissions
    ADD CONSTRAINT repositories_users_permission_organization_name_repository_fkey FOREIGN KEY (organization_name, repository_name_slug) REFERENCES public.repositories(organization_name, repository_name_slug) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: repositories_users_permissions repositories_users_permissions_organization_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repositories_users_permissions
    ADD CONSTRAINT repositories_users_permissions_organization_name_fkey FOREIGN KEY (organization_name) REFERENCES public.organizations(name_slug) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: repositories_users_permissions repositories_users_permissions_username_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repositories_users_permissions
    ADD CONSTRAINT repositories_users_permissions_username_fkey FOREIGN KEY (username) REFERENCES public.users(username) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: repository_labels repository_labels_organization_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repository_labels
    ADD CONSTRAINT repository_labels_organization_name_fkey FOREIGN KEY (organization_name) REFERENCES public.organizations(name_slug) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: repository_labels repository_labels_organization_name_repository_name_slug_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repository_labels
    ADD CONSTRAINT repository_labels_organization_name_repository_name_slug_fkey FOREIGN KEY (organization_name, repository_name_slug) REFERENCES public.repositories(organization_name, repository_name_slug) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: users_groups users_groups_organization_name_group_name_slug_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_groups
    ADD CONSTRAINT users_groups_organization_name_group_name_slug_fkey FOREIGN KEY (organization_name, group_name_slug) REFERENCES public.groups(organization_name, group_name_slug) ON UPDATE CASCADE ON DELETE CASCADE;


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
    ('20240909025555'),
    ('20240909230054'),
    ('20240910015829');
