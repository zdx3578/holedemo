%%%%%%%%%%%%  Predicate catalogue  %%%%%%%%%%%%

% head predicate
head_pred(transform,2).            % transform(+Obj,#Color)

% —— BK 谓词 ——
body_pred(color,2).                % color(+Obj,#Color)
body_pred(holes,2).                % holes(+Obj,#Int)
body_pred(has_hole,1).             % has_hole(+Obj)
body_pred(object,1).               % object(+Obj)

%%%%%%%%%%%%  Type system  %%%%%%%%%%%%

type(obj).
type(color).
type(int).

type(transform,(obj,color)).
type(color,    (obj,color)).
type(holes,    (obj,int)).
type(has_hole, (obj,)).
type(object,   (obj,)).

%%%%%%%%%%%%  Constants  %%%%%%%%%%%%

constant(color,4).                 % 黄色常量，Popper 才能绑定 4

%%%%%%%%%%%%  Search limits  %%%%%%%%%%%%

max_body(2).
max_vars(3).
max_clauses(1).
non_datalog.
