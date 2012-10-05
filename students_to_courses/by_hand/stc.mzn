%Number of different courses
int: n_courses = 4;
set of int: Courses = 1..n_courses;

%Number of students
int: n_students = 6;
set of int: Students = 1..n_students;

%capacity of each courses available
array[Courses] of int: capacity = [1, 2, 1, 2];
array[Courses] of string: c_name = ["a", "b", "c", "d"];

array[Students] of string: s_name = ["A","B","C","D","E","F"];

% wish
int: n_wish = 3;
set of int: Wish = 1..n_wish;
% Die Wunschlisten der Schüler
array[Students, Wish] of int: wish = [|1, 2, 3,   % A => a, b, c
                                  |4, 2, 1,       % B => d, b, a
                                  |1, 3, 4,       % C => a, c, d
                                  |3, 4, 1,       % D => c, d, a
                                  |4, 3, 2,       % E => d, c, b
                                  |2, 4, 1|];     % F => b, d, a


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
var 1..3 * n_students: best_prios;
best_prios = sum( student in Students) (
        1 * bool2int(X[student]==wish[student,1])
        + 2 * bool2int(X[student]==wish[student,2])
        + 3 * bool2int(X[student]==wish[student,3])
);

solve minimize best_prios;

output
 ["Güte der Lösung: " ++ show(fix(best_prios)) ++ ".\n" ]
  ++
 [s_name[student] ++ ": " ++ c_name[fix(X[student])]  ++ "\n" | student in Students];