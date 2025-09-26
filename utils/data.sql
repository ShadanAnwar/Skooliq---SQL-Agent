--
-- PostgreSQL database dump
--

-- Dumped from database version 14.18 (Homebrew)
-- Dumped by pg_dump version 14.18 (Homebrew)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: academic_year; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.academic_year (
    id bigint NOT NULL,
    value character varying(20) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    is_active boolean DEFAULT false
);


ALTER TABLE public.academic_year OWNER TO akashthakare;

--
-- Name: academic_year_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.academic_year_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.academic_year_id_seq OWNER TO akashthakare;

--
-- Name: academic_year_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.academic_year_id_seq OWNED BY public.academic_year.id;


--
-- Name: attendance_log; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.attendance_log (
    id bigint NOT NULL,
    student_id bigint NOT NULL,
    class_id bigint NOT NULL,
    date date NOT NULL,
    status boolean,
    student_class_history_id bigint
);


ALTER TABLE public.attendance_log OWNER TO akashthakare;

--
-- Name: attendance_log_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.attendance_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.attendance_log_id_seq OWNER TO akashthakare;

--
-- Name: attendance_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.attendance_log_id_seq OWNED BY public.attendance_log.id;


--
-- Name: chapter; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.chapter (
    id bigint NOT NULL,
    name character varying(150) NOT NULL,
    subject_id bigint NOT NULL
);


ALTER TABLE public.chapter OWNER TO akashthakare;

--
-- Name: chapter_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.chapter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.chapter_id_seq OWNER TO akashthakare;

--
-- Name: chapter_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.chapter_id_seq OWNED BY public.chapter.id;


--
-- Name: classroom; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.classroom (
    id bigint NOT NULL,
    class_name character varying(100) NOT NULL,
    class_teacher_id bigint,
    school_id bigint NOT NULL,
    academic_year_id bigint
);


ALTER TABLE public.classroom OWNER TO akashthakare;

--
-- Name: classroom_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.classroom_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.classroom_id_seq OWNER TO akashthakare;

--
-- Name: classroom_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.classroom_id_seq OWNED BY public.classroom.id;


--
-- Name: difficulty_level; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.difficulty_level (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    image_url text
);


ALTER TABLE public.difficulty_level OWNER TO akashthakare;

--
-- Name: difficulty_level_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.difficulty_level_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.difficulty_level_id_seq OWNER TO akashthakare;

--
-- Name: difficulty_level_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.difficulty_level_id_seq OWNED BY public.difficulty_level.id;


--
-- Name: event_class_mapping; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.event_class_mapping (
    id bigint NOT NULL,
    event_id bigint NOT NULL,
    class_id bigint NOT NULL
);


ALTER TABLE public.event_class_mapping OWNER TO akashthakare;

--
-- Name: event_class_mapping_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.event_class_mapping_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.event_class_mapping_id_seq OWNER TO akashthakare;

--
-- Name: event_class_mapping_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.event_class_mapping_id_seq OWNED BY public.event_class_mapping.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.events (
    id bigint NOT NULL,
    school_id bigint NOT NULL,
    event_name character varying(255) NOT NULL,
    description text,
    event_date date NOT NULL,
    event_start_time time without time zone NOT NULL,
    event_end_time time without time zone NOT NULL,
    created_by bigint NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    academic_year_id bigint
);


ALTER TABLE public.events OWNER TO akashthakare;

--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.events_id_seq OWNER TO akashthakare;

--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: exam; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.exam (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    class_id bigint NOT NULL,
    school_id bigint NOT NULL,
    start_date date,
    end_date date,
    academic_year_id bigint
);


ALTER TABLE public.exam OWNER TO akashthakare;

--
-- Name: exam_guidelines; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.exam_guidelines (
    id bigint NOT NULL,
    school_id bigint NOT NULL,
    rule_type character varying(10) NOT NULL,
    rule_text text NOT NULL,
    created_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT exam_guidelines_rule_type_check CHECK (((rule_type)::text = ANY (ARRAY[('DO'::character varying)::text, ('DONOT'::character varying)::text])))
);


ALTER TABLE public.exam_guidelines OWNER TO akashthakare;

--
-- Name: exam_guidelines_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.exam_guidelines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.exam_guidelines_id_seq OWNER TO akashthakare;

--
-- Name: exam_guidelines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.exam_guidelines_id_seq OWNED BY public.exam_guidelines.id;


--
-- Name: exam_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.exam_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.exam_id_seq OWNER TO akashthakare;

--
-- Name: exam_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.exam_id_seq OWNED BY public.exam.id;


--
-- Name: exam_result; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.exam_result (
    id bigint NOT NULL,
    exam_id bigint NOT NULL,
    student_id bigint NOT NULL,
    subject_id bigint NOT NULL,
    marks_obtained double precision,
    total_marks double precision,
    grade character varying(10),
    remarks text,
    student_class_history_id bigint
);


ALTER TABLE public.exam_result OWNER TO akashthakare;

--
-- Name: exam_result_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.exam_result_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.exam_result_id_seq OWNER TO akashthakare;

--
-- Name: exam_result_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.exam_result_id_seq OWNED BY public.exam_result.id;


--
-- Name: exam_subjects; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.exam_subjects (
    id bigint NOT NULL,
    exam_id bigint NOT NULL,
    subject_id bigint NOT NULL,
    exam_date date NOT NULL,
    exam_time time without time zone NOT NULL,
    total_marks integer NOT NULL,
    syllabus text
);


ALTER TABLE public.exam_subjects OWNER TO akashthakare;

--
-- Name: exam_subjects_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.exam_subjects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.exam_subjects_id_seq OWNER TO akashthakare;

--
-- Name: exam_subjects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.exam_subjects_id_seq OWNED BY public.exam_subjects.id;


--
-- Name: holiday; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.holiday (
    id bigint NOT NULL,
    school_id bigint NOT NULL,
    date date NOT NULL,
    name character varying(255),
    only_for_students boolean DEFAULT false,
    academic_year_id bigint
);


ALTER TABLE public.holiday OWNER TO akashthakare;

--
-- Name: holiday_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.holiday_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.holiday_id_seq OWNER TO akashthakare;

--
-- Name: holiday_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.holiday_id_seq OWNED BY public.holiday.id;


--
-- Name: leave_types; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.leave_types (
    leave_type_id bigint NOT NULL,
    name character varying(50) NOT NULL,
    description text
);


ALTER TABLE public.leave_types OWNER TO akashthakare;

--
-- Name: leave_types_leave_type_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.leave_types_leave_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.leave_types_leave_type_id_seq OWNER TO akashthakare;

--
-- Name: leave_types_leave_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.leave_types_leave_type_id_seq OWNED BY public.leave_types.leave_type_id;


--
-- Name: mcq_question; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.mcq_question (
    id bigint NOT NULL,
    chapter_id bigint NOT NULL,
    question_text text,
    option1 text,
    option2 text,
    option3 text,
    option4 text,
    answer text,
    created_by bigint,
    created_ts timestamp without time zone,
    status character varying(50) NOT NULL,
    explanation text
);


ALTER TABLE public.mcq_question OWNER TO akashthakare;

--
-- Name: mcq_question_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.mcq_question_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mcq_question_id_seq OWNER TO akashthakare;

--
-- Name: mcq_question_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.mcq_question_id_seq OWNED BY public.mcq_question.id;


--
-- Name: milestone; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.milestone (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    points_required integer NOT NULL,
    reward_item character varying(100) NOT NULL,
    is_active boolean DEFAULT true,
    academic_year_id bigint
);


ALTER TABLE public.milestone OWNER TO akashthakare;

--
-- Name: milestone_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.milestone_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.milestone_id_seq OWNER TO akashthakare;

--
-- Name: milestone_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.milestone_id_seq OWNED BY public.milestone.id;


--
-- Name: notification; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.notification (
    id bigint NOT NULL,
    title character varying(100) NOT NULL,
    type_id bigint NOT NULL,
    description text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    send_to bigint,
    send_all boolean DEFAULT false NOT NULL,
    action_taken boolean DEFAULT false
);


ALTER TABLE public.notification OWNER TO akashthakare;

--
-- Name: notification_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.notification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_id_seq OWNER TO akashthakare;

--
-- Name: notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.notification_id_seq OWNED BY public.notification.id;


--
-- Name: notification_type; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.notification_type (
    id bigint NOT NULL,
    type character varying(50) NOT NULL,
    is_actionable boolean DEFAULT false NOT NULL,
    validity_days integer NOT NULL
);


ALTER TABLE public.notification_type OWNER TO akashthakare;

--
-- Name: notification_type_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.notification_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_type_id_seq OWNER TO akashthakare;

--
-- Name: notification_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.notification_type_id_seq OWNED BY public.notification_type.id;


--
-- Name: principal; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.principal (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    school_id bigint NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    mobile_number character varying(50),
    photo_path character varying(255),
    joining_date date,
    academic_year_id bigint
);


ALTER TABLE public.principal OWNER TO akashthakare;

--
-- Name: principal_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.principal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.principal_id_seq OWNER TO akashthakare;

--
-- Name: principal_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.principal_id_seq OWNED BY public.principal.id;


--
-- Name: puzzle; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.puzzle (
    id bigint NOT NULL,
    student_class integer NOT NULL,
    question text,
    image_base64 text,
    answer text,
    explanation text,
    type character varying(20) NOT NULL,
    created_at timestamp without time zone NOT NULL
);


ALTER TABLE public.puzzle OWNER TO akashthakare;

--
-- Name: puzzle_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.puzzle_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.puzzle_id_seq OWNER TO akashthakare;

--
-- Name: puzzle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.puzzle_id_seq OWNED BY public.puzzle.id;


--
-- Name: registration_key; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.registration_key (
    id bigint NOT NULL,
    reg_key character varying(100) NOT NULL,
    role character varying(20) NOT NULL,
    school_id bigint NOT NULL,
    serial_number bigint NOT NULL,
    is_used boolean DEFAULT false,
    issued_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    used_at timestamp without time zone
);


ALTER TABLE public.registration_key OWNER TO akashthakare;

--
-- Name: registration_key_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.registration_key_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.registration_key_id_seq OWNER TO akashthakare;

--
-- Name: registration_key_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.registration_key_id_seq OWNED BY public.registration_key.id;


--
-- Name: school; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.school (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    address character varying(255),
    city character varying(100),
    state character varying(100),
    pincode character varying(20),
    academic_year_start date,
    academic_year_end date,
    contact_email character varying(255),
    contact_number character varying(50)
);


ALTER TABLE public.school OWNER TO akashthakare;

--
-- Name: school_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.school_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.school_id_seq OWNER TO akashthakare;

--
-- Name: school_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.school_id_seq OWNED BY public.school.id;


--
-- Name: school_teacher_leave_policy; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.school_teacher_leave_policy (
    id bigint NOT NULL,
    school_id bigint NOT NULL,
    leave_type_id bigint NOT NULL,
    total_allocated integer NOT NULL,
    allocated boolean DEFAULT true
);


ALTER TABLE public.school_teacher_leave_policy OWNER TO akashthakare;

--
-- Name: school_teacher_leave_policy_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.school_teacher_leave_policy_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.school_teacher_leave_policy_id_seq OWNER TO akashthakare;

--
-- Name: school_teacher_leave_policy_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.school_teacher_leave_policy_id_seq OWNED BY public.school_teacher_leave_policy.id;


--
-- Name: student; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.student (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    school_id bigint NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    date_of_birth date,
    gender character varying(20),
    class_id bigint NOT NULL,
    roll_number character varying(50),
    photo_path character varying(255),
    admission_date date,
    mobile_number character varying(50),
    email character varying(255),
    address text,
    languages character varying(300),
    hobby text,
    dream_destination character varying(100),
    subject character varying(100),
    blood_group character varying(10),
    favourite_subject character varying(100),
    total_points integer DEFAULT 0,
    total_questions_solved integer DEFAULT 0
);


ALTER TABLE public.student OWNER TO akashthakare;

--
-- Name: student_class_history; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.student_class_history (
    id bigint NOT NULL,
    student_id bigint NOT NULL,
    class_id bigint NOT NULL,
    academic_year_id bigint NOT NULL,
    is_current boolean DEFAULT false,
    joined_on date DEFAULT CURRENT_DATE
);


ALTER TABLE public.student_class_history OWNER TO akashthakare;

--
-- Name: student_class_history_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.student_class_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_class_history_id_seq OWNER TO akashthakare;

--
-- Name: student_class_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.student_class_history_id_seq OWNED BY public.student_class_history.id;


--
-- Name: student_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.student_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_id_seq OWNER TO akashthakare;

--
-- Name: student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.student_id_seq OWNED BY public.student.id;


--
-- Name: student_leaves; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.student_leaves (
    leave_id bigint NOT NULL,
    student_id bigint NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    description text,
    document_path text,
    applied_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(20) DEFAULT 'PENDING'::character varying,
    approved_by bigint,
    approved_on timestamp without time zone,
    leave_type_id bigint,
    school_id bigint,
    applying_to bigint,
    student_class_history_id bigint,
    CONSTRAINT student_leaves_status_check CHECK (((status)::text = ANY (ARRAY[('PENDING'::character varying)::text, ('APPROVED'::character varying)::text, ('REJECTED'::character varying)::text])))
);


ALTER TABLE public.student_leaves OWNER TO akashthakare;

--
-- Name: student_leaves_leave_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.student_leaves_leave_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_leaves_leave_id_seq OWNER TO akashthakare;

--
-- Name: student_leaves_leave_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.student_leaves_leave_id_seq OWNED BY public.student_leaves.leave_id;


--
-- Name: student_mcq_answer; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.student_mcq_answer (
    id bigint NOT NULL,
    student_id bigint NOT NULL,
    question_id bigint NOT NULL,
    selected_option integer,
    is_correct boolean,
    points_awarded integer,
    submitted_at timestamp without time zone,
    student_class_history_id bigint
);


ALTER TABLE public.student_mcq_answer OWNER TO akashthakare;

--
-- Name: student_mcq_answer_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.student_mcq_answer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_mcq_answer_id_seq OWNER TO akashthakare;

--
-- Name: student_mcq_answer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.student_mcq_answer_id_seq OWNED BY public.student_mcq_answer.id;


--
-- Name: student_milestone; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.student_milestone (
    id bigint NOT NULL,
    student_id bigint NOT NULL,
    milestone_id bigint NOT NULL,
    status character varying(20) NOT NULL,
    completed_at timestamp without time zone,
    student_class_history_id bigint
);


ALTER TABLE public.student_milestone OWNER TO akashthakare;

--
-- Name: student_milestone_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.student_milestone_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_milestone_id_seq OWNER TO akashthakare;

--
-- Name: student_milestone_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.student_milestone_id_seq OWNED BY public.student_milestone.id;


--
-- Name: student_puzzle_solve; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.student_puzzle_solve (
    id bigint NOT NULL,
    student_id bigint NOT NULL,
    puzzle_id bigint NOT NULL,
    status character varying(32) NOT NULL,
    points_awarded integer NOT NULL,
    solved_at timestamp without time zone NOT NULL,
    student_class_history_id bigint
);


ALTER TABLE public.student_puzzle_solve OWNER TO akashthakare;

--
-- Name: student_puzzle_solve_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.student_puzzle_solve_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_puzzle_solve_id_seq OWNER TO akashthakare;

--
-- Name: student_puzzle_solve_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.student_puzzle_solve_id_seq OWNED BY public.student_puzzle_solve.id;


--
-- Name: subject; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.subject (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    class_id bigint NOT NULL,
    school_id bigint NOT NULL,
    academic_year_id bigint
);


ALTER TABLE public.subject OWNER TO akashthakare;

--
-- Name: subject_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.subject_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subject_id_seq OWNER TO akashthakare;

--
-- Name: subject_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.subject_id_seq OWNED BY public.subject.id;


--
-- Name: teacher; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.teacher (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    school_id bigint NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    mobile_number character varying(50),
    joining_date date,
    photo_path character varying(255),
    academic_year_id bigint
);


ALTER TABLE public.teacher OWNER TO akashthakare;

--
-- Name: teacher_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.teacher_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teacher_id_seq OWNER TO akashthakare;

--
-- Name: teacher_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.teacher_id_seq OWNED BY public.teacher.id;


--
-- Name: teacher_leaves; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.teacher_leaves (
    leave_id bigint NOT NULL,
    teacher_id bigint NOT NULL,
    leave_type_id bigint NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    description text,
    document_path text,
    applied_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    approved_by bigint,
    approved_on timestamp without time zone,
    status character varying(20) DEFAULT 'PENDING'::character varying,
    applying_to bigint,
    school_id bigint,
    academic_year_id bigint,
    CONSTRAINT teacher_leaves_status_check CHECK (((status)::text = ANY (ARRAY[('PENDING'::character varying)::text, ('APPROVED'::character varying)::text, ('REJECTED'::character varying)::text])))
);


ALTER TABLE public.teacher_leaves OWNER TO akashthakare;

--
-- Name: teacher_leaves_leave_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.teacher_leaves_leave_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teacher_leaves_leave_id_seq OWNER TO akashthakare;

--
-- Name: teacher_leaves_leave_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.teacher_leaves_leave_id_seq OWNED BY public.teacher_leaves.leave_id;


--
-- Name: timetable; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.timetable (
    id bigint NOT NULL,
    day character varying(10) NOT NULL,
    time_from time without time zone NOT NULL,
    time_to time without time zone NOT NULL,
    class_id bigint NOT NULL,
    subject_id bigint NOT NULL,
    teacher_id bigint NOT NULL,
    academic_year_id bigint,
    CONSTRAINT timetable_day_check CHECK (((day)::text = ANY (ARRAY[('MONDAY'::character varying)::text, ('TUESDAY'::character varying)::text, ('WEDNESDAY'::character varying)::text, ('THURSDAY'::character varying)::text, ('FRIDAY'::character varying)::text, ('SATURDAY'::character varying)::text, ('SUNDAY'::character varying)::text])))
);


ALTER TABLE public.timetable OWNER TO akashthakare;

--
-- Name: timetable_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.timetable_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.timetable_id_seq OWNER TO akashthakare;

--
-- Name: timetable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.timetable_id_seq OWNED BY public.timetable.id;


--
-- Name: timetable_notes; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.timetable_notes (
    id bigint NOT NULL,
    class_id bigint NOT NULL,
    day character varying(10) NOT NULL,
    notes text NOT NULL,
    academic_year_id bigint,
    CONSTRAINT timetable_notes_day_check CHECK (((day)::text = ANY (ARRAY[('MONDAY'::character varying)::text, ('TUESDAY'::character varying)::text, ('WEDNESDAY'::character varying)::text, ('THURSDAY'::character varying)::text, ('FRIDAY'::character varying)::text, ('SATURDAY'::character varying)::text, ('SUNDAY'::character varying)::text])))
);


ALTER TABLE public.timetable_notes OWNER TO akashthakare;

--
-- Name: timetable_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.timetable_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.timetable_notes_id_seq OWNER TO akashthakare;

--
-- Name: timetable_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.timetable_notes_id_seq OWNED BY public.timetable_notes.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: akashthakare
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    username character varying(100) NOT NULL,
    password_hash character varying(255) NOT NULL,
    role character varying(100),
    school_id bigint
);


ALTER TABLE public.users OWNER TO akashthakare;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: akashthakare
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO akashthakare;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akashthakare
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: academic_year id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.academic_year ALTER COLUMN id SET DEFAULT nextval('public.academic_year_id_seq'::regclass);


--
-- Name: attendance_log id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.attendance_log ALTER COLUMN id SET DEFAULT nextval('public.attendance_log_id_seq'::regclass);


--
-- Name: chapter id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.chapter ALTER COLUMN id SET DEFAULT nextval('public.chapter_id_seq'::regclass);


--
-- Name: classroom id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.classroom ALTER COLUMN id SET DEFAULT nextval('public.classroom_id_seq'::regclass);


--
-- Name: difficulty_level id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.difficulty_level ALTER COLUMN id SET DEFAULT nextval('public.difficulty_level_id_seq'::regclass);


--
-- Name: event_class_mapping id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.event_class_mapping ALTER COLUMN id SET DEFAULT nextval('public.event_class_mapping_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: exam id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.exam ALTER COLUMN id SET DEFAULT nextval('public.exam_id_seq'::regclass);


--
-- Name: exam_guidelines id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.exam_guidelines ALTER COLUMN id SET DEFAULT nextval('public.exam_guidelines_id_seq'::regclass);


--
-- Name: exam_result id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.exam_result ALTER COLUMN id SET DEFAULT nextval('public.exam_result_id_seq'::regclass);


--
-- Name: exam_subjects id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.exam_subjects ALTER COLUMN id SET DEFAULT nextval('public.exam_subjects_id_seq'::regclass);


--
-- Name: holiday id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.holiday ALTER COLUMN id SET DEFAULT nextval('public.holiday_id_seq'::regclass);


--
-- Name: leave_types leave_type_id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.leave_types ALTER COLUMN leave_type_id SET DEFAULT nextval('public.leave_types_leave_type_id_seq'::regclass);


--
-- Name: mcq_question id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.mcq_question ALTER COLUMN id SET DEFAULT nextval('public.mcq_question_id_seq'::regclass);


--
-- Name: milestone id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.milestone ALTER COLUMN id SET DEFAULT nextval('public.milestone_id_seq'::regclass);


--
-- Name: notification id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.notification ALTER COLUMN id SET DEFAULT nextval('public.notification_id_seq'::regclass);


--
-- Name: notification_type id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.notification_type ALTER COLUMN id SET DEFAULT nextval('public.notification_type_id_seq'::regclass);


--
-- Name: principal id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.principal ALTER COLUMN id SET DEFAULT nextval('public.principal_id_seq'::regclass);


--
-- Name: puzzle id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.puzzle ALTER COLUMN id SET DEFAULT nextval('public.puzzle_id_seq'::regclass);


--
-- Name: registration_key id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.registration_key ALTER COLUMN id SET DEFAULT nextval('public.registration_key_id_seq'::regclass);


--
-- Name: school id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.school ALTER COLUMN id SET DEFAULT nextval('public.school_id_seq'::regclass);


--
-- Name: school_teacher_leave_policy id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.school_teacher_leave_policy ALTER COLUMN id SET DEFAULT nextval('public.school_teacher_leave_policy_id_seq'::regclass);


--
-- Name: student id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.student ALTER COLUMN id SET DEFAULT nextval('public.student_id_seq'::regclass);


--
-- Name: student_class_history id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.student_class_history ALTER COLUMN id SET DEFAULT nextval('public.student_class_history_id_seq'::regclass);


--
-- Name: student_leaves leave_id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.student_leaves ALTER COLUMN leave_id SET DEFAULT nextval('public.student_leaves_leave_id_seq'::regclass);


--
-- Name: student_mcq_answer id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.student_mcq_answer ALTER COLUMN id SET DEFAULT nextval('public.student_mcq_answer_id_seq'::regclass);


--
-- Name: student_milestone id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.student_milestone ALTER COLUMN id SET DEFAULT nextval('public.student_milestone_id_seq'::regclass);


--
-- Name: student_puzzle_solve id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.student_puzzle_solve ALTER COLUMN id SET DEFAULT nextval('public.student_puzzle_solve_id_seq'::regclass);


--
-- Name: subject id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.subject ALTER COLUMN id SET DEFAULT nextval('public.subject_id_seq'::regclass);


--
-- Name: teacher id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.teacher ALTER COLUMN id SET DEFAULT nextval('public.teacher_id_seq'::regclass);


--
-- Name: teacher_leaves leave_id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.teacher_leaves ALTER COLUMN leave_id SET DEFAULT nextval('public.teacher_leaves_leave_id_seq'::regclass);


--
-- Name: timetable id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.timetable ALTER COLUMN id SET DEFAULT nextval('public.timetable_id_seq'::regclass);


--
-- Name: timetable_notes id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.timetable_notes ALTER COLUMN id SET DEFAULT nextval('public.timetable_notes_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: academic_year; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.academic_year (id, value, start_date, end_date, is_active) FROM stdin;
1	2025-2026	2025-06-26	2026-05-01	t
\.


--
-- Data for Name: attendance_log; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.attendance_log (id, student_id, class_id, date, status, student_class_history_id) FROM stdin;
1	1	1	2025-07-05	\N	1
3	1	1	2025-07-19	t	1
4	1	1	2025-07-18	t	1
\.


--
-- Data for Name: chapter; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.chapter (id, name, subject_id) FROM stdin;
1	Numbers and Numeration	1
2	Parts of Speech	2
3	States of Matter	3
4	Ancient Civilizations	4
5	Grammar Basics	2
\.


--
-- Data for Name: classroom; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.classroom (id, class_name, class_teacher_id, school_id, academic_year_id) FROM stdin;
1	1A	\N	1	\N
2	1B	\N	1	\N
3	2A	\N	1	\N
4	2B	\N	1	\N
5	3	\N	1	\N
\.


--
-- Data for Name: difficulty_level; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.difficulty_level (id, name, image_url) FROM stdin;
1	Beginner	https://example.com/images/beginner.png
2	Intermediate	https://example.com/images/intermediate.png
3	Hard	https://example.com/images/hard.png
\.


--
-- Data for Name: event_class_mapping; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.event_class_mapping (id, event_id, class_id) FROM stdin;
1	1	1
2	2	1
3	3	1
4	4	1
5	5	1
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.events (id, school_id, event_name, description, event_date, event_start_time, event_end_time, created_by, created_on, academic_year_id) FROM stdin;
1	1	Annual Sports Day	Various sports activities and competitions	2025-12-10	09:00:00	16:00:00	4	2025-07-06 00:44:40.876659	\N
2	1	Science Exhibition	Exhibition of student science projects and models	2025-11-20	10:00:00	14:00:00	4	2025-07-06 00:44:40.876659	\N
3	1	Parent Teacher Meeting	Discussion on student progress with parents	2025-08-30	11:00:00	13:00:00	4	2025-07-06 00:44:40.876659	\N
4	1	Cultural Fest	Music, dance, and drama performances by students	2025-10-05	09:30:00	15:00:00	4	2025-07-06 00:44:40.876659	\N
5	1	Workshop on Robotics	Hands-on robotics session for senior classes	2025-09-15	10:30:00	13:30:00	4	2025-07-06 00:44:40.876659	\N
\.


--
-- Data for Name: exam; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.exam (id, name, class_id, school_id, start_date, end_date, academic_year_id) FROM stdin;
1	Mid Term Exam	1	1	2025-06-10	2025-06-15	\N
2	Final Exam	1	1	2025-10-20	2025-10-21	\N
\.


--
-- Data for Name: exam_guidelines; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.exam_guidelines (id, school_id, rule_type, rule_text, created_on) FROM stdin;
1	1	DO	Carry your school ID card and admit card to the exam hall.	2025-07-06 00:50:06.597158
2	1	DONOT	Do not use mobile phones or any electronic devices during the exam.	2025-07-06 00:50:06.597158
3	1	DO	Reach the exam center at least 30 minutes before the exam starts.	2025-07-06 00:50:06.597158
4	1	DONOT	Do not talk or communicate with other students during the exam.	2025-07-06 00:50:06.597158
5	1	DO	Use only black or blue ink pens for writing the answers.	2025-07-06 00:50:06.597158
\.


--
-- Data for Name: exam_result; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.exam_result (id, exam_id, student_id, subject_id, marks_obtained, total_marks, grade, remarks, student_class_history_id) FROM stdin;
2	1	1	2	85	100	A	Good work, improve writing skills	\N
3	1	1	3	78	100	B+	Needs revision in chemistry	\N
4	1	2	1	65	100	B	Can do better with practice	\N
5	1	2	2	72	100	B+	Good comprehension, grammar needs work	\N
6	1	2	3	88	100	A	Strong in science concepts	\N
1	1	1	1	95	100	A+	Very Good	\N
7	2	1	1	99	100	A+	Very Good	\N
\.


--
-- Data for Name: exam_subjects; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.exam_subjects (id, exam_id, subject_id, exam_date, exam_time, total_marks, syllabus) FROM stdin;
1	1	1	2025-09-10	09:00:00	100	Chapters 1 to 5 - Algebra and Geometry
2	1	2	2025-09-11	09:00:00	100	Grammar, Essay Writing, Comprehension
3	1	3	2025-09-12	09:00:00	100	Physics: Motion & Force; Chemistry: Matter
4	2	1	2025-10-20	10:00:00	100	Algebra and Geometry
5	2	5	2025-10-21	10:00:00	100	Chapter 1 to Chapter 4
\.


--
-- Data for Name: holiday; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.holiday (id, school_id, date, name, only_for_students, academic_year_id) FROM stdin;
1	1	2025-08-15	Independence Day	f	\N
2	1	2025-10-02	Gandhi Jayanti	f	\N
3	1	2025-12-25	Christmas	f	\N
4	1	2025-09-05	Teachers Day Celebration Holiday	t	\N
5	1	2025-11-14	Childrens Day	t	\N
6	1	2025-08-14	Pateti	f	\N
\.


--
-- Data for Name: leave_types; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.leave_types (leave_type_id, name, description) FROM stdin;
1	Sick	Leave taken due to illness or medical reasons
2	Casual	Leave taken for personal or urgent matters
\.


--
-- Data for Name: mcq_question; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.mcq_question (id, chapter_id, question_text, option1, option2, option3, option4, answer, created_by, created_ts, status, explanation) FROM stdin;
\.


--
-- Data for Name: milestone; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.milestone (id, name, points_required, reward_item, is_active, academic_year_id) FROM stdin;
\.


--
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.notification (id, title, type_id, description, created_at, send_to, send_all, action_taken) FROM stdin;
1	Tuition Fee Due	1	Your tuition fee for July is pending. Please pay before 10th.	2025-07-04 09:00:00	2	f	f
2	Attendance Alert	2	You were marked absent for today.	2025-07-04 18:00:00	2	f	f
3	Mid-Term Results Declared	3	Your results for the Mid-Term Exam are now available.	2025-07-03 10:30:00	2	f	f
4	Leave Request Update	4	Your recent leave request has been approved.	2025-07-02 12:00:00	2	f	f
5	Daily Puzzle Challenge	5	Solve today’s puzzle to earn points!	2025-07-05 08:00:00	2	f	f
6	Important Fee Reminder for All	1	All students must clear fees before the due date.	2025-07-01 09:00:00	\N	t	f
7	System Maintenance Notice	2	Attendance system will be down for maintenance on Saturday.	2025-07-04 14:00:00	\N	t	f
8	Exam Results Out!	3	All students can now check their results on the portal.	2025-07-03 11:00:00	\N	t	f
9	Leave Policy Reminder	4	Review the updated leave policy shared with all.	2025-07-02 09:30:00	\N	t	f
10	Puzzle of the Week	5	This week’s puzzle is live now — play and win!	2025-07-05 07:30:00	\N	t	f
\.


--
-- Data for Name: notification_type; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.notification_type (id, type, is_actionable, validity_days) FROM stdin;
1	FEE_REMINDER	t	7
2	ATTENDANCE	f	1
3	RESULT_PUBLISHED	f	30
4	LEAVE_STATUS	f	15
5	PUZZLE_REMINDER	t	5
\.


--
-- Data for Name: principal; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.principal (id, user_id, school_id, first_name, last_name, email, mobile_number, photo_path, joining_date, academic_year_id) FROM stdin;
1	5	1	John	Cena	principal@gmail.com	0123456789	\N	\N	\N
\.


--
-- Data for Name: puzzle; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.puzzle (id, student_class, question, image_base64, answer, explanation, type, created_at) FROM stdin;
\.


--
-- Data for Name: registration_key; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.registration_key (id, reg_key, role, school_id, serial_number, is_used, issued_at, used_at) FROM stdin;
1	UntzhK-abXJu8VaxOPrQBRRNpYOfFbcKaAjQU_hcofaAoetZy7QcLA	STUDENT	1	1	f	2025-07-05 18:24:40.572961	\N
2	veRMSg1f0fjJUTMzbHcG1tWBdpUG2e0ddtL8NrjKFKbNaF520OGdjw	STUDENT	1	2	f	2025-07-05 18:42:18.830868	\N
3	evRiTlF8G43ycWI8WD5zNoUg4538DXFnJK6lS3vvOncEr3QHxBwqjg	TEACHER	1	1	f	2025-07-06 00:36:11.376758	\N
4	n4JgX82--QxPNuMzaN91O-Qj1VSaXFUs7MvfzP8jpl2-sVw0NVcrFQ	PRINCIPAL	1	1	t	2025-07-19 16:07:15.365794	2025-07-19 16:09:45.484007
\.


--
-- Data for Name: school; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.school (id, name, address, city, state, pincode, academic_year_start, academic_year_end, contact_email, contact_number) FROM stdin;
1	Modern School	Shivaji Chowk	Amravati	MH	444604	2025-07-05	2026-07-05	abc@gmail.com	1234567890
\.


--
-- Data for Name: school_teacher_leave_policy; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.school_teacher_leave_policy (id, school_id, leave_type_id, total_allocated, allocated) FROM stdin;
1	1	1	12	t
2	1	2	12	t
\.


--
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.student (id, user_id, school_id, first_name, last_name, date_of_birth, gender, class_id, roll_number, photo_path, admission_date, mobile_number, email, address, languages, hobby, dream_destination, subject, blood_group, favourite_subject, total_points, total_questions_solved) FROM stdin;
1	2	1	Akash	Thakare	1997-10-27	MALE	1	01	\N	\N	1234567890	abc@gmail.com	\N	\N	\N	\N	\N	\N	\N	0	0
2	3	1	Pankaj	Jadhao	1999-08-12	MALE	5	01	\N	\N	1234567890	abc@gmail.com	\N	\N	\N	\N	\N	\N	\N	0	0
\.


--
-- Data for Name: student_class_history; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.student_class_history (id, student_id, class_id, academic_year_id, is_current, joined_on) FROM stdin;
1	1	1	1	t	2025-05-01
\.


--
-- Data for Name: student_leaves; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.student_leaves (leave_id, student_id, start_date, end_date, description, document_path, applied_on, status, approved_by, approved_on, leave_type_id, school_id, applying_to, student_class_history_id) FROM stdin;
2	1	2025-06-20	2025-06-21	Family function	/docs/leave_002.pdf	2025-07-06 00:54:25.487656	APPROVED	4	2025-06-19 10:30:00	\N	1	1	\N
3	1	2025-06-10	2025-06-10	Personal reason	\N	2025-07-06 00:54:25.487656	REJECTED	4	2025-06-09 16:45:00	\N	1	1	\N
4	1	2025-05-15	2025-05-18	Attending cousin’s wedding out of town	/docs/leave_004.pdf	2025-07-06 00:54:25.487656	APPROVED	4	2025-05-14 09:00:00	\N	1	1	\N
5	1	2025-07-20	2025-07-20	Dental appointment	\N	2025-07-06 00:54:25.487656	PENDING	\N	\N	\N	1	1	\N
1	1	2025-07-10	2025-07-11	Medical leave for fever	/docs/leave_001.pdf	2025-07-06 00:54:25.487656	APPROVED	4	2025-07-19 11:19:47.84565	\N	1	1	\N
6	1	2025-07-19	2025-07-19	Sickness	leave-documents/dummy-proof.pdf	2025-07-19 13:01:39.149741	PENDING	\N	\N	1	1	1	\N
7	1	2025-08-19	2025-08-19	Sickness	leave-documents/dummy-proof.pdf	2025-07-19 13:02:35.124771	PENDING	\N	\N	1	1	1	\N
8	1	2025-08-19	2025-08-19	Sickness	leave-documents/dummy-proof.pdf	2025-07-19 13:11:22.832987	PENDING	\N	\N	1	1	1	\N
9	1	2025-08-19	2025-08-19	Sickness	leave-documents/dummy-proof.pdf	2025-07-19 13:12:39.628341	PENDING	\N	\N	1	1	1	\N
10	1	2025-08-19	2025-08-19	Sick with fever	\N	2025-07-19 15:51:52.601692	PENDING	\N	\N	1	1	1	\N
11	1	2025-08-19	2025-08-19	Sick with fever	leave-documents/11.bin	2025-07-19 15:52:46.242639	PENDING	\N	\N	1	1	1	\N
\.


--
-- Data for Name: student_mcq_answer; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.student_mcq_answer (id, student_id, question_id, selected_option, is_correct, points_awarded, submitted_at, student_class_history_id) FROM stdin;
\.


--
-- Data for Name: student_milestone; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.student_milestone (id, student_id, milestone_id, status, completed_at, student_class_history_id) FROM stdin;
\.


--
-- Data for Name: student_puzzle_solve; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.student_puzzle_solve (id, student_id, puzzle_id, status, points_awarded, solved_at, student_class_history_id) FROM stdin;
\.


--
-- Data for Name: subject; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.subject (id, name, class_id, school_id, academic_year_id) FROM stdin;
1	Mathematics	1	1	\N
2	English	1	1	\N
3	Science	1	1	\N
4	Social Studies	1	1	\N
5	Marathi	1	1	\N
\.


--
-- Data for Name: teacher; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.teacher (id, user_id, school_id, first_name, last_name, email, mobile_number, joining_date, photo_path, academic_year_id) FROM stdin;
1	4	1	MS	Dhoni	ms@gmail.com	1234567890	\N	\N	\N
\.


--
-- Data for Name: teacher_leaves; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.teacher_leaves (leave_id, teacher_id, leave_type_id, start_date, end_date, description, document_path, applied_on, approved_by, approved_on, status, applying_to, school_id, academic_year_id) FROM stdin;
1	1	1	2025-07-19	2025-07-19	Sickness	leave-documents/teacher-1.bin	2025-07-19 16:16:33.570882	\N	\N	PENDING	1	1	\N
2	1	1	2025-07-19	2025-07-19	Sickness	leave-documents/teacher-2.bin	2025-07-19 16:26:44.648313	\N	\N	APPROVED	1	1	\N
\.


--
-- Data for Name: timetable; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.timetable (id, day, time_from, time_to, class_id, subject_id, teacher_id, academic_year_id) FROM stdin;
6	TUESDAY	09:00:00	09:45:00	1	2	1	\N
7	TUESDAY	09:50:00	10:35:00	1	3	1	\N
8	TUESDAY	10:40:00	11:25:00	1	4	1	\N
9	TUESDAY	11:30:00	12:15:00	1	5	1	\N
10	TUESDAY	12:20:00	13:05:00	1	1	1	\N
11	WEDNESDAY	09:00:00	09:45:00	1	3	1	\N
12	WEDNESDAY	09:50:00	10:35:00	1	4	1	\N
13	WEDNESDAY	10:40:00	11:25:00	1	5	1	\N
14	WEDNESDAY	11:30:00	12:15:00	1	1	1	\N
15	WEDNESDAY	12:20:00	13:05:00	1	2	1	\N
16	THURSDAY	09:00:00	09:45:00	1	4	1	\N
17	THURSDAY	09:50:00	10:35:00	1	5	1	\N
18	THURSDAY	10:40:00	11:25:00	1	1	1	\N
19	THURSDAY	11:30:00	12:15:00	1	2	1	\N
20	THURSDAY	12:20:00	13:05:00	1	3	1	\N
21	FRIDAY	09:00:00	09:45:00	1	5	1	\N
22	FRIDAY	09:50:00	10:35:00	1	1	1	\N
23	FRIDAY	10:40:00	11:25:00	1	2	1	\N
24	FRIDAY	11:30:00	12:15:00	1	3	1	\N
25	FRIDAY	12:20:00	13:05:00	1	4	1	\N
26	SATURDAY	09:00:00	09:45:00	1	1	1	\N
27	SATURDAY	09:50:00	10:35:00	1	2	1	\N
28	SATURDAY	10:40:00	11:25:00	1	3	1	\N
29	SATURDAY	11:30:00	12:15:00	1	4	1	\N
30	SATURDAY	12:20:00	13:05:00	1	5	1	\N
33	MONDAY	12:00:00	13:15:00	1	1	1	\N
34	MONDAY	09:15:00	10:05:00	1	1	1	\N
\.


--
-- Data for Name: timetable_notes; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.timetable_notes (id, class_id, day, notes, academic_year_id) FROM stdin;
1	1	MONDAY	Maths test on Chapter 2	\N
2	1	TUESDAY	Submit English homework	\N
3	1	WEDNESDAY	Bring lab coat for Science	\N
4	1	THURSDAY	Group discussion in Social Studies	\N
5	1	FRIDAY	Practice worksheet for Math due	\N
6	1	SATURDAY	Fun quiz and puzzle session	\N
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: akashthakare
--

COPY public.users (id, username, password_hash, role, school_id) FROM stdin;
1	admin	$2a$10$qJbrr7yhlH/JUEqr2kyTkuPEq89FneZkzDsYakQA3oNJvkWd65XsC	ADMIN	\N
2	MS-1A-01	$2a$10$OYZwTaoed9xKY7r.3mS0FunXyDC7gXCZi2GE8zFVb1QGj9S03NA/i	STUDENT	1
3	MS-3-01	$2a$10$oZbiDtNy5AGwkR5DIiNTAuI2u5ygjhdp6tZbO7Bq47cqCjrfyZQp6	STUDENT	1
4	teacher1	$2a$10$TVav63cBEFExeV1dzJ75Y.4yfK1pFpKgUKA0agqQjX2VtBKJV2ZY.	TEACHER	1
5	pricipal	$2a$10$Yticj/luPY5GnOcWFi6jn.rw8VWPwUTFJDRuAMyRJfh6Za368w.Iu	PRINCIPAL	1
\.


--
-- Name: academic_year_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.academic_year_id_seq', 1, true);


--
-- Name: attendance_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.attendance_log_id_seq', 4, true);


--
-- Name: chapter_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.chapter_id_seq', 5, true);


--
-- Name: classroom_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.classroom_id_seq', 5, true);


--
-- Name: difficulty_level_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.difficulty_level_id_seq', 3, true);


--
-- Name: event_class_mapping_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.event_class_mapping_id_seq', 5, true);


--
-- Name: events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.events_id_seq', 5, true);


--
-- Name: exam_guidelines_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.exam_guidelines_id_seq', 5, true);


--
-- Name: exam_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.exam_id_seq', 2, true);


--
-- Name: exam_result_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.exam_result_id_seq', 7, true);


--
-- Name: exam_subjects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.exam_subjects_id_seq', 5, true);


--
-- Name: holiday_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.holiday_id_seq', 6, true);


--
-- Name: leave_types_leave_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.leave_types_leave_type_id_seq', 3, true);


--
-- Name: mcq_question_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.mcq_question_id_seq', 1, false);


--
-- Name: milestone_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.milestone_id_seq', 1, false);


--
-- Name: notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.notification_id_seq', 10, true);


--
-- Name: notification_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.notification_type_id_seq', 5, true);


--
-- Name: principal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.principal_id_seq', 1, true);


--
-- Name: puzzle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.puzzle_id_seq', 1, false);


--
-- Name: registration_key_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.registration_key_id_seq', 4, true);


--
-- Name: school_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.school_id_seq', 1, true);


--
-- Name: school_teacher_leave_policy_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.school_teacher_leave_policy_id_seq', 2, true);


--
-- Name: student_class_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.student_class_history_id_seq', 1, true);


--
-- Name: student_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.student_id_seq', 2, true);


--
-- Name: student_leaves_leave_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.student_leaves_leave_id_seq', 11, true);


--
-- Name: student_mcq_answer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.student_mcq_answer_id_seq', 1, false);


--
-- Name: student_milestone_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.student_milestone_id_seq', 1, false);


--
-- Name: student_puzzle_solve_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.student_puzzle_solve_id_seq', 1, false);


--
-- Name: subject_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.subject_id_seq', 5, true);


--
-- Name: teacher_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.teacher_id_seq', 1, true);


--
-- Name: teacher_leaves_leave_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.teacher_leaves_leave_id_seq', 2, true);


--
-- Name: timetable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.timetable_id_seq', 35, true);


--
-- Name: timetable_notes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.timetable_notes_id_seq', 6, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akashthakare
--

SELECT pg_catalog.setval('public.users_id_seq', 5, true);


--
-- Name: academic_year academic_year_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.academic_year
    ADD CONSTRAINT academic_year_pkey PRIMARY KEY (id);


--
-- Name: academic_year academic_year_value_key; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.academic_year
    ADD CONSTRAINT academic_year_value_key UNIQUE (value);


--
-- Name: attendance_log attendance_log_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.attendance_log
    ADD CONSTRAINT attendance_log_pkey PRIMARY KEY (id);


--
-- Name: chapter chapter_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.chapter
    ADD CONSTRAINT chapter_pkey PRIMARY KEY (id);


--
-- Name: classroom classroom_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.classroom
    ADD CONSTRAINT classroom_pkey PRIMARY KEY (id);


--
-- Name: difficulty_level difficulty_level_name_key; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.difficulty_level
    ADD CONSTRAINT difficulty_level_name_key UNIQUE (name);


--
-- Name: difficulty_level difficulty_level_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.difficulty_level
    ADD CONSTRAINT difficulty_level_pkey PRIMARY KEY (id);


--
-- Name: event_class_mapping event_class_mapping_event_id_class_id_key; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.event_class_mapping
    ADD CONSTRAINT event_class_mapping_event_id_class_id_key UNIQUE (event_id, class_id);


--
-- Name: event_class_mapping event_class_mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.event_class_mapping
    ADD CONSTRAINT event_class_mapping_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: exam_guidelines exam_guidelines_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.exam_guidelines
    ADD CONSTRAINT exam_guidelines_pkey PRIMARY KEY (id);


--
-- Name: exam exam_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.exam
    ADD CONSTRAINT exam_pkey PRIMARY KEY (id);


--
-- Name: exam_result exam_result_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.exam_result
    ADD CONSTRAINT exam_result_pkey PRIMARY KEY (id);


--
-- Name: exam_subjects exam_subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.exam_subjects
    ADD CONSTRAINT exam_subjects_pkey PRIMARY KEY (id);


--
-- Name: holiday holiday_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.holiday
    ADD CONSTRAINT holiday_pkey PRIMARY KEY (id);


--
-- Name: leave_types leave_types_name_key; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.leave_types
    ADD CONSTRAINT leave_types_name_key UNIQUE (name);


--
-- Name: leave_types leave_types_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.leave_types
    ADD CONSTRAINT leave_types_pkey PRIMARY KEY (leave_type_id);


--
-- Name: mcq_question mcq_question_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.mcq_question
    ADD CONSTRAINT mcq_question_pkey PRIMARY KEY (id);


--
-- Name: milestone milestone_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.milestone
    ADD CONSTRAINT milestone_pkey PRIMARY KEY (id);


--
-- Name: notification notification_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- Name: notification_type notification_type_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.notification_type
    ADD CONSTRAINT notification_type_pkey PRIMARY KEY (id);


--
-- Name: notification_type notification_type_type_key; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.notification_type
    ADD CONSTRAINT notification_type_type_key UNIQUE (type);


--
-- Name: principal principal_email_key; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.principal
    ADD CONSTRAINT principal_email_key UNIQUE (email);


--
-- Name: principal principal_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.principal
    ADD CONSTRAINT principal_pkey PRIMARY KEY (id);


--
-- Name: puzzle puzzle_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.puzzle
    ADD CONSTRAINT puzzle_pkey PRIMARY KEY (id);


--
-- Name: registration_key registration_key_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.registration_key
    ADD CONSTRAINT registration_key_pkey PRIMARY KEY (id);


--
-- Name: registration_key registration_key_reg_key_key; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.registration_key
    ADD CONSTRAINT registration_key_reg_key_key UNIQUE (reg_key);


--
-- Name: school school_name_key; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.school
    ADD CONSTRAINT school_name_key UNIQUE (name);


--
-- Name: school school_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.school
    ADD CONSTRAINT school_pkey PRIMARY KEY (id);


--
-- Name: school_teacher_leave_policy school_teacher_leave_policy_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.school_teacher_leave_policy
    ADD CONSTRAINT school_teacher_leave_policy_pkey PRIMARY KEY (id);


--
-- Name: school_teacher_leave_policy school_teacher_leave_policy_school_id_leave_type_id_key; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.school_teacher_leave_policy
    ADD CONSTRAINT school_teacher_leave_policy_school_id_leave_type_id_key UNIQUE (school_id, leave_type_id);


--
-- Name: student_class_history student_class_history_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.student_class_history
    ADD CONSTRAINT student_class_history_pkey PRIMARY KEY (id);


--
-- Name: student_leaves student_leaves_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.student_leaves
    ADD CONSTRAINT student_leaves_pkey PRIMARY KEY (leave_id);


--
-- Name: student_mcq_answer student_mcq_answer_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.student_mcq_answer
    ADD CONSTRAINT student_mcq_answer_pkey PRIMARY KEY (id);


--
-- Name: student_milestone student_milestone_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.student_milestone
    ADD CONSTRAINT student_milestone_pkey PRIMARY KEY (id);


--
-- Name: student student_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (id);


--
-- Name: student_puzzle_solve student_puzzle_solve_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.student_puzzle_solve
    ADD CONSTRAINT student_puzzle_solve_pkey PRIMARY KEY (id);


--
-- Name: subject subject_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.subject
    ADD CONSTRAINT subject_pkey PRIMARY KEY (id);


--
-- Name: teacher teacher_email_key; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.teacher
    ADD CONSTRAINT teacher_email_key UNIQUE (email);


--
-- Name: teacher_leaves teacher_leaves_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.teacher_leaves
    ADD CONSTRAINT teacher_leaves_pkey PRIMARY KEY (leave_id);


--
-- Name: teacher teacher_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.teacher
    ADD CONSTRAINT teacher_pkey PRIMARY KEY (id);


--
-- Name: timetable_notes timetable_notes_class_id_day_key; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.timetable_notes
    ADD CONSTRAINT timetable_notes_class_id_day_key UNIQUE (class_id, day);


--
-- Name: timetable_notes timetable_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.timetable_notes
    ADD CONSTRAINT timetable_notes_pkey PRIMARY KEY (id);


--
-- Name: timetable timetable_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.timetable
    ADD CONSTRAINT timetable_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: attendance_log attendance_log_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.attendance_log
    ADD CONSTRAINT attendance_log_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classroom(id);


--
-- Name: attendance_log attendance_log_student_class_history_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.attendance_log
    ADD CONSTRAINT attendance_log_student_class_history_id_fkey FOREIGN KEY (student_class_history_id) REFERENCES public.student_class_history(id);


--
-- Name: attendance_log attendance_log_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.attendance_log
    ADD CONSTRAINT attendance_log_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id);


--
-- Name: classroom classroom_academic_year_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.classroom
    ADD CONSTRAINT classroom_academic_year_id_fkey FOREIGN KEY (academic_year_id) REFERENCES public.academic_year(id);


--
-- Name: classroom classroom_class_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.classroom
    ADD CONSTRAINT classroom_class_teacher_id_fkey FOREIGN KEY (class_teacher_id) REFERENCES public.teacher(id);


--
-- Name: classroom classroom_school_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.classroom
    ADD CONSTRAINT classroom_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.school(id);


--
-- Name: event_class_mapping event_class_mapping_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.event_class_mapping
    ADD CONSTRAINT event_class_mapping_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classroom(id) ON DELETE CASCADE;


--
-- Name: event_class_mapping event_class_mapping_event_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.event_class_mapping
    ADD CONSTRAINT event_class_mapping_event_id_fkey FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE;


--
-- Name: events events_academic_year_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_academic_year_id_fkey FOREIGN KEY (academic_year_id) REFERENCES public.academic_year(id);


--
-- Name: events events_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- Name: events events_school_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.school(id);


--
-- Name: exam exam_academic_year_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.exam
    ADD CONSTRAINT exam_academic_year_id_fkey FOREIGN KEY (academic_year_id) REFERENCES public.academic_year(id);


--
-- Name: exam exam_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.exam
    ADD CONSTRAINT exam_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classroom(id);


--
-- Name: exam_result exam_result_exam_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.exam_result
    ADD CONSTRAINT exam_result_exam_id_fkey FOREIGN KEY (exam_id) REFERENCES public.exam(id);


--
-- Name: exam_result exam_result_student_class_history_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.exam_result
    ADD CONSTRAINT exam_result_student_class_history_id_fkey FOREIGN KEY (student_class_history_id) REFERENCES public.student_class_history(id);


--
-- Name: exam_result exam_result_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.exam_result
    ADD CONSTRAINT exam_result_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id);


--
-- Name: exam_result exam_result_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.exam_result
    ADD CONSTRAINT exam_result_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subject(id);


--
-- Name: exam_guidelines exam_rules_school_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.exam_guidelines
    ADD CONSTRAINT exam_rules_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.school(id);


--
-- Name: exam exam_school_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.exam
    ADD CONSTRAINT exam_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.school(id);


--
-- Name: exam_subjects exam_subjects_exam_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.exam_subjects
    ADD CONSTRAINT exam_subjects_exam_id_fkey FOREIGN KEY (exam_id) REFERENCES public.exam(id);


--
-- Name: chapter fk_chapter_subject; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.chapter
    ADD CONSTRAINT fk_chapter_subject FOREIGN KEY (subject_id) REFERENCES public.subject(id) ON DELETE CASCADE;


--
-- Name: student_puzzle_solve fk_puzzle; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.student_puzzle_solve
    ADD CONSTRAINT fk_puzzle FOREIGN KEY (puzzle_id) REFERENCES public.puzzle(id);


--
-- Name: student_puzzle_solve fk_student; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.student_puzzle_solve
    ADD CONSTRAINT fk_student FOREIGN KEY (student_id) REFERENCES public.student(id);


--
-- Name: attendance_log fk_student_class_history; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.attendance_log
    ADD CONSTRAINT fk_student_class_history FOREIGN KEY (student_class_history_id) REFERENCES public.student_class_history(id);


--
-- Name: student_leaves fk_student_leaves_leave_type; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.student_leaves
    ADD CONSTRAINT fk_student_leaves_leave_type FOREIGN KEY (leave_type_id) REFERENCES public.leave_types(leave_type_id);


--
-- Name: student_milestone fk_student_milestone_milestone; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.student_milestone
    ADD CONSTRAINT fk_student_milestone_milestone FOREIGN KEY (milestone_id) REFERENCES public.milestone(id);


--
-- Name: student_milestone fk_student_milestone_student; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.student_milestone
    ADD CONSTRAINT fk_student_milestone_student FOREIGN KEY (student_id) REFERENCES public.student(id);


--
-- Name: teacher_leaves fk_teacher_leaves_school; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.teacher_leaves
    ADD CONSTRAINT fk_teacher_leaves_school FOREIGN KEY (school_id) REFERENCES public.school(id);


--
-- Name: holiday holiday_academic_year_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.holiday
    ADD CONSTRAINT holiday_academic_year_id_fkey FOREIGN KEY (academic_year_id) REFERENCES public.academic_year(id);


--
-- Name: holiday holiday_school_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.holiday
    ADD CONSTRAINT holiday_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.school(id);


--
-- Name: milestone milestone_academic_year_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.milestone
    ADD CONSTRAINT milestone_academic_year_id_fkey FOREIGN KEY (academic_year_id) REFERENCES public.academic_year(id);


--
-- Name: notification notification_send_to_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_send_to_fkey FOREIGN KEY (send_to) REFERENCES public.users(id);


--
-- Name: notification notification_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.notification_type(id);


--
-- Name: principal principal_academic_year_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.principal
    ADD CONSTRAINT principal_academic_year_id_fkey FOREIGN KEY (academic_year_id) REFERENCES public.academic_year(id);


--
-- Name: principal principal_school_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.principal
    ADD CONSTRAINT principal_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.school(id);


--
-- Name: principal principal_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.principal
    ADD CONSTRAINT principal_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: registration_key registration_key_school_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.registration_key
    ADD CONSTRAINT registration_key_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.school(id);


--
-- Name: school_teacher_leave_policy school_teacher_leave_policy_leave_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.school_teacher_leave_policy
    ADD CONSTRAINT school_teacher_leave_policy_leave_type_id_fkey FOREIGN KEY (leave_type_id) REFERENCES public.leave_types(leave_type_id);


--
-- Name: school_teacher_leave_policy school_teacher_leave_policy_school_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.school_teacher_leave_policy
    ADD CONSTRAINT school_teacher_leave_policy_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.school(id);


--
-- Name: student_class_history student_class_history_academic_year_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.student_class_history
    ADD CONSTRAINT student_class_history_academic_year_id_fkey FOREIGN KEY (academic_year_id) REFERENCES public.academic_year(id);


--
-- Name: student_class_history student_class_history_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.student_class_history
    ADD CONSTRAINT student_class_history_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classroom(id);


--
-- Name: student_class_history student_class_history_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.student_class_history
    ADD CONSTRAINT student_class_history_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id);


--
-- Name: student student_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classroom(id);


--
-- Name: student_leaves student_leaves_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.student_leaves
    ADD CONSTRAINT student_leaves_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id);


--
-- Name: student_leaves student_leaves_student_class_history_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.student_leaves
    ADD CONSTRAINT student_leaves_student_class_history_id_fkey FOREIGN KEY (student_class_history_id) REFERENCES public.student_class_history(id);


--
-- Name: student_leaves student_leaves_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.student_leaves
    ADD CONSTRAINT student_leaves_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id);


--
-- Name: student_mcq_answer student_mcq_answer_student_class_history_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.student_mcq_answer
    ADD CONSTRAINT student_mcq_answer_student_class_history_id_fkey FOREIGN KEY (student_class_history_id) REFERENCES public.student_class_history(id);


--
-- Name: student_milestone student_milestone_student_class_history_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.student_milestone
    ADD CONSTRAINT student_milestone_student_class_history_id_fkey FOREIGN KEY (student_class_history_id) REFERENCES public.student_class_history(id);


--
-- Name: student_puzzle_solve student_puzzle_solve_student_class_history_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.student_puzzle_solve
    ADD CONSTRAINT student_puzzle_solve_student_class_history_id_fkey FOREIGN KEY (student_class_history_id) REFERENCES public.student_class_history(id);


--
-- Name: student student_school_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.school(id);


--
-- Name: student student_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: subject subject_academic_year_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.subject
    ADD CONSTRAINT subject_academic_year_id_fkey FOREIGN KEY (academic_year_id) REFERENCES public.academic_year(id);


--
-- Name: subject subject_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.subject
    ADD CONSTRAINT subject_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classroom(id);


--
-- Name: subject subject_school_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.subject
    ADD CONSTRAINT subject_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.school(id);


--
-- Name: teacher teacher_academic_year_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.teacher
    ADD CONSTRAINT teacher_academic_year_id_fkey FOREIGN KEY (academic_year_id) REFERENCES public.academic_year(id);


--
-- Name: teacher_leaves teacher_leaves_academic_year_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.teacher_leaves
    ADD CONSTRAINT teacher_leaves_academic_year_id_fkey FOREIGN KEY (academic_year_id) REFERENCES public.academic_year(id);


--
-- Name: teacher_leaves teacher_leaves_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.teacher_leaves
    ADD CONSTRAINT teacher_leaves_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.users(id);


--
-- Name: teacher_leaves teacher_leaves_leave_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.teacher_leaves
    ADD CONSTRAINT teacher_leaves_leave_type_id_fkey FOREIGN KEY (leave_type_id) REFERENCES public.leave_types(leave_type_id);


--
-- Name: teacher_leaves teacher_leaves_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.teacher_leaves
    ADD CONSTRAINT teacher_leaves_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.teacher(id);


--
-- Name: teacher teacher_school_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.teacher
    ADD CONSTRAINT teacher_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.school(id);


--
-- Name: teacher teacher_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.teacher
    ADD CONSTRAINT teacher_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: timetable timetable_academic_year_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.timetable
    ADD CONSTRAINT timetable_academic_year_id_fkey FOREIGN KEY (academic_year_id) REFERENCES public.academic_year(id);


--
-- Name: timetable timetable_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.timetable
    ADD CONSTRAINT timetable_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classroom(id);


--
-- Name: timetable_notes timetable_notes_academic_year_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.timetable_notes
    ADD CONSTRAINT timetable_notes_academic_year_id_fkey FOREIGN KEY (academic_year_id) REFERENCES public.academic_year(id);


--
-- Name: timetable_notes timetable_notes_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.timetable_notes
    ADD CONSTRAINT timetable_notes_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classroom(id);


--
-- Name: timetable timetable_subject_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.timetable
    ADD CONSTRAINT timetable_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES public.subject(id);


--
-- Name: timetable timetable_teacher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: akashthakare
--

ALTER TABLE ONLY public.timetable
    ADD CONSTRAINT timetable_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.teacher(id);


--
-- PostgreSQL database dump complete
--

