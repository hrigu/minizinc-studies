%Number of different courses
int: n_courses;
set of int: Courses = 1..n_courses;

%Number of students
int: n_students;
set of int: Students = 1..n_students;

%capacity of each courses available
array[Courses] of int: capacity;
array[Courses] of string: c_name;

array[Students] of string: s_name;

% wish
int: n_wish;
set of int: Wish = 1..n_wish;
% Die Wunschlisten der Schüler
array[Students, Wish] of int: wish;


% Die Variablen: Pro Schüler einen Kurs
array[1..n_students] of var 1..n_courses: X;

% Der Kurs für den Schüler x muss aus seiner Wunschliste stammen
constraint forall( student in Students ) (
   X[student]== wish[student,1] \/
   X[student]== wish[student,2] \/
   X[student]== wish[student,3]
);

% Die Kapazität des Kurses dürfen nicht überschritten werden
constraint forall( course in Courses ) (
  sum( student in Students) (
        bool2int(X[student]==course)
  ) <= capacity[course]
);

% Die Summe der Prios der besuchten Kurses muss minimal sein
var 0..4 * n_students: best_prios;
best_prios = sum( student in Students) (
        1 * bool2int(X[student] == wish[student,2])
        + 3 * bool2int(X[student] == wish[student,3])
);

% constraint best_prios <= 25;

solve minimize best_prios;

output
 ["Güte der Lösung: " ++ show(fix(best_prios)) ++ ".\n" ]
  ++
 [s_name[student] ++ ": " ++ c_name[fix(X[student])]
  ++
 " ["++ show(c_name[wish[student,1]]) ++", "++ show(c_name[wish[student,2]]) ++", " ++ show(c_name[wish[student,3]]) ++"]\n" | student in Students];