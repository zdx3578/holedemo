%%%%%%%%%%%%  Predicate catalogue  %%%%%%%%%%%%

% head predicate
head_pred(transform,2).

body_pred(color,2).
body_pred(holes,2).
body_pred(has_hole,1).
body_pred(object,1).

type(obj).
type(color).
type(int).

type(transform,(obj,color)).
type(color,    (obj,color)).
type(holes,    (obj,int)).
type(has_hole, (obj,)).
type(object,   (obj,)).

constant(color,4).

direction(transform/2,(in,out)).
direction(color/2,(in,out)).
direction(holes/2,(in,out)).
direction(has_hole/1,(in)).
direction(object/1,(in)).


body_pred(my_geq,2).      type(my_geq,(int,int)).
body_pred(my_leq,2).      type(my_leq,(int,int)).
body_pred(my_gt,2).       type(my_gt,(int,int)).
body_pred(my_lt,2).       type(my_lt,(int,int)).
body_pred(my_add,3).      type(my_add,(int,int,int)).
body_pred(my_mult,3).     type(my_mult,(int,int,int)).
body_pred(my_subtract,3). type(my_subtract,(int,int,int)).

constant(int,0).          % 至少要有一个 int 常量

max_body(2).
max_vars(3).
max_clauses(1).
non_datalog.
