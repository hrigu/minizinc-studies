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

constraint forall( course in Courses ) (
  sum( student in Students) (
        bool2int(X[student]==course)
  ) <= capacity[course]
);

% Alle Schüler müssen genau einen Kurs besuchen
% Die Kapazität des Kurses dürfen nicht überschritten werden
% Die Summe der Prios der besuchten Kurses muss minimal sein



solve satisfy;
%output [show(X)];

output [
    show(s_name[student]) ++ ": " ++ show(X[student]) ++ "\n" | student in Students];