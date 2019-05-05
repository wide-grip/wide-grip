--
-- SQL edited by https://hasura-edit-pg-dump.now.sh
--

COMMENT ON SCHEMA public IS 'standard public schema';

CREATE TABLE public.exercises (
    id integer NOT NULL,
    name text NOT NULL,
    "workoutId" integer NOT NULL
);

CREATE SEQUENCE public.exercises_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.exercises_id_seq OWNED BY public.exercises.id;

CREATE TABLE public.sets (
    id integer NOT NULL,
    reps integer NOT NULL,
    weight numeric NOT NULL,
    "userId" integer NOT NULL,
    "exerciseId" integer NOT NULL,
    date date NOT NULL
);

CREATE SEQUENCE public.sets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.sets_id_seq OWNED BY public.sets.id;

CREATE TABLE public.users (
    id integer NOT NULL,
    name text NOT NULL,
    email text NOT NULL
);

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;

CREATE TABLE public.workouts (
    id integer NOT NULL,
    category text NOT NULL
);

CREATE SEQUENCE public.workouts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.workouts_id_seq OWNED BY public.workouts.id;

ALTER TABLE ONLY public.exercises ALTER COLUMN id SET DEFAULT nextval('public.exercises_id_seq'::regclass);

ALTER TABLE ONLY public.sets ALTER COLUMN id SET DEFAULT nextval('public.sets_id_seq'::regclass);

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);

ALTER TABLE ONLY public.workouts ALTER COLUMN id SET DEFAULT nextval('public.workouts_id_seq'::regclass);

ALTER TABLE ONLY public.exercises
    ADD CONSTRAINT exercises_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public.sets
    ADD CONSTRAINT sets_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public.workouts
    ADD CONSTRAINT workouts_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public.exercises
    ADD CONSTRAINT exercises_workoutid_fkey FOREIGN KEY ("workoutId") REFERENCES public.workouts(id) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY public.sets
    ADD CONSTRAINT "sets_exerciseId_fkey" FOREIGN KEY ("exerciseId") REFERENCES public.exercises(id) ON UPDATE RESTRICT ON DELETE RESTRICT;

ALTER TABLE ONLY public.sets
    ADD CONSTRAINT "sets_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;

