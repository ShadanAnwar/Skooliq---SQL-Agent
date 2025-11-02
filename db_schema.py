schema = """
USERS: id (bigint, Primary key; unique user ID), username (character varying, User's unique login name), role (character varying, User's role), school_id (bigint, Foreign key to the school)

SCHOOL: id (bigint, Primary key; unique school ID), name (character varying, School's official name), address (character varying, School's physical address), city (character varying, School's city location), state (character varying, School's state location), contact_email (character varying, Official contact email), contact_number (character varying, Official contact phone number)

ACADEMIC_YEAR: id (bigint, Primary key; unique academic year ID), value (character varying, Name of the academic year), start_date (date, Start date of the academic year), end_date (date, End date of the academic year), is_active (boolean, Flag if currently active)

CLASSROOM: id (bigint, Primary key; unique classroom ID), class_name (character varying, Name of the class), class_teacher_id (bigint, ID of the class teacher), school_id (bigint, Foreign key to the school), academic_year_id (bigint, Foreign key to the academic year)

STUDENT: id (bigint, Primary key; unique student record ID), user_id (bigint, Foreign key to user account), school_id (bigint, Foreign key to the school), first_name (character varying, Student's first name), last_name (character varying, Student's last name), date_of_birth (date, Date of birth), gender (character varying, Student's gender), class_id (bigint, Foreign key to the classroom), roll_number (character varying, Class roll number), email (character varying, Student's email), mobile_number (character varying, Student's mobile number), total_points (integer, Total reward points), total_questions_solved (integer, Total questions solved)

TEACHER: id (bigint, Primary key; unique teacher record ID), user_id (bigint, Foreign key to user account), school_id (bigint, Foreign key to the school), first_name (character varying, Teacher's first name), last_name (character varying, Teacher's last name), email (character varying, Teacher's email), mobile_number (character varying, Teacher's mobile number), joining_date (date, Date joined), academic_year_id (bigint, Foreign key to the academic year)

PRINCIPAL: id (bigint, Primary key; unique principal record ID), user_id (bigint, Foreign key to user account), school_id (bigint, Foreign key to the school), first_name (character varying, Principal's first name), last_name (character varying, Principal's last name), email (character varying, Principal's email), mobile_number (character varying, Principal's mobile number), joining_date (date, Date joined), academic_year_id (bigint, Foreign key to the academic year)

SUBJECT: id (bigint, Primary key; unique subject ID), name (character varying, Name of the subject), class_id (bigint, Foreign key to the class), school_id (bigint, Foreign key to the school), academic_year_id (bigint, Foreign key to the academic year)

EXAM: id (bigint, Primary key; unique exam ID), name (character varying, Name of the exam), class_id (bigint, Foreign key to the class), school_id (bigint, Foreign key to the school), start_date (date, Start date of exam period), end_date (date, End date of exam period), academic_year_id (bigint, Foreign key to the academic year)

EXAM_RESULT: id (bigint, Primary key; unique result record ID), exam_id (bigint, Foreign key to the exam), student_id (bigint, Foreign key to the student), subject_id (bigint, Foreign key to the subject), marks_obtained (double precision, Marks achieved), total_marks (double precision, Maximum possible marks), grade (character varying, Letter grade), remarks (text, Specific comments)

ATTENDANCE_LOG: id (bigint, Primary key; unique log ID), student_id (bigint, Foreign key to the student), class_id (bigint, Foreign key to the class), date (date, Date of attendance), status (boolean, Present/Absent status)

STUDENT_LEAVES: leave_id (bigint, Primary key; unique leave ID), student_id (bigint, Foreign key to the student), start_date (date, First day of leave), end_date (date, Last day of leave), description (text, Reason for leave), status (character varying, Approval status), leave_type_id (bigint, Foreign key to leave type), school_id (bigint, Foreign key to the school)

TEACHER_LEAVES: leave_id (bigint, Primary key; unique leave ID), teacher_id (bigint, Foreign key to the teacher), start_date (date, First day of leave), end_date (date, Last day of leave), description (text, Reason for leave), status (character varying, Approval status), leave_type_id (bigint, Foreign key to leave type), school_id (bigint, Foreign key to the school)

TIMETABLE: id (bigint, Primary key; unique timetable entry ID), day (character varying, Day of the week), time_from (time without time zone, Start time), time_to (time without time zone, End time), class_id (bigint, Foreign key to the class), subject_id (bigint, Foreign key to the subject), teacher_id (bigint, Foreign key to the teacher), academic_year_id (bigint, Foreign key to the academic year)

EVENTS: id (bigint, Primary key; unique event ID), school_id (bigint, Foreign key to the school), event_name (character varying, Name of the event), description (text, Full description), event_date (date, Date of the event), event_start_time (time without time zone, Start time), event_end_time (time without time zone, End time), created_by (bigint, User ID of creator), academic_year_id (bigint, Foreign key to the academic year)

HOLIDAY: id (bigint, Primary key; unique holiday ID), school_id (bigint, Foreign key to the school), date (date, Date of the holiday), name (character varying, Name of the holiday), only_for_students (boolean, Flag if student-only), academic_year_id (bigint, Foreign key to the academic year)

NOTIFICATION: id (bigint, Primary key; unique notification ID), title (character varying, Short title), type_id (bigint, Foreign key to notification type), description (text, Full message), created_at (timestamp without time zone, Creation date/time), send_to (bigint, ID of recipient user/role), send_all (boolean, Flag if sent to all), action_taken (boolean, Flag if action completed)
"""