%%%%%%%%%%%%  Predicate catalogue  %%%%%%%%%%%%

% head predicate
%%%%%%%%%%%%  搜索空间  %%%%%%%%%%%%

head_pred(transform,2).            % transform(+Obj,+Color)

body_pred(color,2).                % color(+Obj,+Color)
body_pred(holes,2).                % holes(+Obj,+Int)
body_pred(has_hole,1).             % has_hole(+Obj)
body_pred(target_color,1).         % <— 新增一元常量谓词

%%%%%%%%%%%%  类型  %%%%%%%%%%%%

type(obj).     type(color).     type(int).

type(transform,(obj,color)).
type(color,    (obj,color)).
type(holes,    (obj,int)).
type(has_hole, (obj,)).
type(target_color,(color)).      % <— 类型只有一个 color

constant(color,4).

%%%%%%%%%%%%  限制  %%%%%%%%%%%%

max_body(2).   max_vars(3).   max_clauses(1).

