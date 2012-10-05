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



var {1, 2, 3}: XS1;
var {4, 2, 1}: XS2;
var {1, 3, 4}: XS3;
var {3, 4, 1}: XS4;
var {4, 3, 2}: XS5;
var {2, 4, 1}: XS6;

% Die Kapazität des Kurses dürfen nicht überschritten werden
constraint forall( course in Courses ) (

  bool2int(XS1==course)
+ bool2int(XS2==course)
+ bool2int(XS3==course)
+ bool2int(XS4==course)
+ bool2int(XS5==course)
+ bool2int(XS6==course)
   <= capacity[course]
);

% Die Summe der Prios der besuchten Kurses muss minimal sein
% var 1..3 * n_students: best_prios;
% best_prios = sum( student in Students) (
%         1 * bool2int(X[student]==wish[student,1])
%         + 2 * bool2int(X[student]==wish[student,2])
%         + 3 * bool2int(X[student]==wish[student,3])
% );

solve minimize best_prios;

output
 ["Güte der Lösung: " ++ show(fix(best_prios)) ++ ".\n" ]
  ++
 [s_name[student] ++ ": " ++ c_name[fix(X[student])]  ++ "\n" | student in Students];