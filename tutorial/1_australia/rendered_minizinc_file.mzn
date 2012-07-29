% Colouring Australia using nc colours

% the variables of the model.
% parameter
% specifies a parameter in the problem which is the number of colours to be used.
int: nc = 3;


% Decision variables:
% variables in the sense of mathematical or logical
% variables. Unlike parameters and variables in a standard programming language,
% the modeller does not need to give them a value. Rather the value of a decision
% variable is unknown and it is only when the MiniZinc model is executed that
% the solving system determines if the decision variable can be assigned a value
% that satifies the constraints in the model and if so what this is.

var 1..nc: wa;
var 1..nc: nt;
var 1..nc: sa;
var 1..nc: q;
var 1..nc: nsw;
var 1..nc: v;
var 1..nc: t;

constraint wa != nt;
constraint wa != sa;
constraint nt != sa;
constraint nt != q;
constraint sa != q;
constraint sa != nsw;
constraint sa != v;
constraint q != nsw;
constraint nsw != v;

solve satisfy;

output ["wa=", show(wa), "\n", "nt=", show(nt), "\n", "sa=", show(sa), "\n", "q=", show(q), "\n", "nsw=", show(nsw), "\n", "v=", show(v), "\n", "t=", show(t), "\n", ]