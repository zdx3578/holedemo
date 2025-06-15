% ---- search limits ----
max_body(1).
max_vars(3).
max_clauses(1).

% ---- head predicate ----
head_pred(transform, 2).
type(transform, (id, color)).

% ---- body predicates ----
body_pred(has_hole, 1).
type(has_hole, (id)).

% ---- constant we want to learn (yellow = 4) ----
constant(color, 4).