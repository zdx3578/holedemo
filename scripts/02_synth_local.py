"""Dummy synthesiser: outputs fixed lambda for demo."""
import json, sys
# fixed S‑expr representing recolor to 4 if holes>0
program=['map-objects',['lambda',['o'],['if',['>',['holes','o'],0],['set-color','o',4],'o']]]
obj={'program':program}
print(json.dumps(program))