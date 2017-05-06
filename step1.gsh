#name step1.gsh
pipes 2
fork
push 0
push 1
dup 3
push 0
push 0
dup 0
exec graphics-fb
krof 

fork
push 1
push 1
dup 1
exec1st test-render
krof 

fork
push 1
push 0
dup 1
exec1st test-fb
krof 

