.386 ;表示要用到386指令
.model Flat,stdcall ;32位程序，要用flat啦！;stadcall,标准调用
option casemap:none ;区别大小写
include C:\masm32\include\windows.inc ;包括常量及结构定义

include C:\masm32\include\kernel32.inc ;函数原型声明
include C:\masm32\include\user32.inc
include C:\masm32\include\gdi32.inc
include	C:\Users\xz683\Desktop\myproject\pixelstruct.inc

includelib C:\masm32\lib\kernel32.lib ;用到的引入库
includelib C:\masm32\lib\user32.lib
includelib C:\masm32\lib\gdi32.lib

.DATA
MsgBoxName		DB  "INFO",0
MsgBoxTextInDLL		DB	"in dll!",0
MsgBoxTextxAxis		DB	"xAxis is %d",0
MsgBoxTextyAxis		DB	"yAxis is %d",0
MsgBoxTextzAxis		DB	"zAxis is %d",0
MsgBoxTextThickness	DB	"Thickness is %d",0
MsgBoxTextxPos		DB	"xPos is %d",0
MsgBoxTextyPos		DB	"yPos is %d",0
MsgBoxTextInblockxPos		DB	"InblockxPos is %d",0
MsgBoxTextInblockyPos		DB	"InblockyPos is %d",0
MsgBoxTextMemoryAllocDone		DB	"Allocated!",0
MsgBoxTextMemoryAllocError		DB	"Allocation Error!",0
MsgBoxTexthWnd		DB	"hWnd is %d",0
MsgBoxTextPoint		DB	"Point:( %d , %d )",0
MsgBoxTexthHeap		DB	"hHeap is %d",0
MsgBoxTextEmpty		DB	"%d",0
MsgBoxTextEAX		DB	"EAX %d",0
MsgBoxTextEBX		DB	"EBX %d",0
MsgBoxTextEDX		DB	"EDX %d",0
Buffer			DB	30 DUP(?)

.DATA?
hHeap			DD	?
xAxis			DD	?
xAxisSquare		DD	?
xAxisNeg		DD	?
yUpperBound		DD	?
yLowerBound		DD	?

.CODE
DllEntry	PROC	_hInstance,_dwReason,_dwReserved
		MOV		EAX,_dwReason
		.IF		EAX==DLL_PROCESS_ATTACH
			INVOKE	HeapCreate,NULL,10000H,0		;ALLOC 1 MB
			.IF	EAX&&(EAX<0C0000000H)
				MOV		hHeap,EAX
				MOV		EAX,TRUE
				INVOKE	MessageBox,NULL,ADDR MsgBoxTextMemoryAllocDone,ADDR MsgBoxName,MB_OK
			.ELSE	
				MOV		EAX,FALSE
				INVOKE	MessageBox,NULL,ADDR MsgBoxTextMemoryAllocError,ADDR MsgBoxName,MB_OK
			.ENDIF
		.ELSEIF	EAX==DLL_PROCESS_DETACH		
			INVOKE	HeapDestroy,hHeap
			MOV		EAX,TRUE
		.ELSE	
			MOV		EAX,TRUE
		.ENDIF
	RET
DllEntry	ENDP

; RegisterPixelCircle		PROC	Radius:WORD,Thickness:WORD
			; MOV		BL,pixelcirclenum
			; MOV		AX,Radius
			; MOV		pixelcircle[BL].Radius,AX
			; MOV		AX,Thickness
			; MOV		pixelcircle[BL].Thickness,AX
			; INC		pixelcirclenum
			; MOV		AX,Radius								;DETERMINE AMOUNT OF MEMORY NEEDED
			; ADD		AX,AX
			; MOV		DX,Thickness
			; MUL		DX
			; SHL		EDX,16
			; MOV		DX,AX
			; INVOKE	HeapAlloc,hHeap,HEAP_ZERO_MEMORY,EDX
			; .IF		EAX&&(EAX<0C0000000H)
					; MOV		lpmemorycircle[BL],EAX
			; .ENDIF
			; INVOKE	CalPixelCircleOffset,Radius,Thickness,lpmemorycircle[BL]
			; MOV		pixelnumcircle[BL],EAX
			; RET
; RegisterPixelCircle		ENDP
			

;IN PRACTICE, JUST FILL IN ALL PIXELS IN BETWEEN TWO OVALS
;WHOSE AXIS LENGTH ADJUSTED TO ENSURE THERE IS ONLY ONE PIXEL IN A ROW/COLUMN
;FOR GRAPH HAVING THICKNESS OTHER THAN 1, ADJUST LOWBOUND
;ALGORITHM CALCULATING yPos HAS COMPLEXITY:O(AXIS*THICKNESS)

;DRAW A PIXEL GRAPH ACCORDING TO PIXELGRAPH AND RECT
; DrawPixelGraph		PROC	stPixelgraph:PIXELGRAPH,stRect:RECT
		; LOCAL	stCurrentPixelCoord:POINT	;LEFT-TOP CORNER DOT'S COORDINATE OF EVERY RECTANGLE REPRESENTING A PIXEL
	; INVOKE	MessageBox,NULL,ADDR MsgBoxTextInDLL,ADDR MsgBoxName,MB_OK
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextxAxis,stPixelgraph.ShapeInfo.xAxis
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextyAxis,stPixelgraph.ShapeInfo.yAxis
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextzAxis,stPixelgraph.ShapeInfo.zAxis
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextThickness,stPixelgraph.ShapeInfo.Thickness
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	; ;SOME CALCULATION FOR FUTIRE USE
	; MOV		EAX,stPixelgraph.xAxis
	; NEG		EAX
	; MOV		xAxisNeg,EAX
	; NEG		EAX
	; MUL		EAX
	; MOV		xAxisSquare,EAX
	; ;CALCULATE PIXEL POSITION ON LEFT-BOTTOM CORNERS OF THE WINDOW
	; MOV		EAX,stRect.bottom
	; ADD		EAX,stPixelgraph.WinInfo.InblockyCoord
	; SUB		EAX,stPixelgraph.WinInfo.PixelSideLen
	; XOR		EDX,EDX
	; MOV		EBX,stPixelgraph.WinInfo.PixelSideLen
	; DIV		EBX
	; MOV		EDX,stPixelgraph.WinInfo.yPos
	; ADD		EDX,EAX
	; MOV		yUpperBound,EDX
	; ;
	; ;STARTING PIXEL'S COORDINATE
	; ; MOV		EAX,stRect.left
	; ; MOV		stCurrentPixelCoord.x,EAX
	; ; MOV		EAX,stRect.top
	; ; MOV		stCurrentPixelCoord.y,EAX
	; ;QUICKLY GET TO RECT TOP-LEFT CORNER
	; MOV		EAX,stPixelgraph.WinInfo.InblockxCoord
	; ADD		EAX,stRect.left
	; MOV		EDX,stPixelgraph.WinInfo.xPos			;stCurrentPoint.
; RECTSTARTINGPOINTLOOP:
	; CMP		EAX,stPixelgraph.WinInfo.PixelSideLen	;LEFT TO RECT LEFT
	; JB		ATRECTSTARTINGPOINT
	; INC		EDX	
	; SUB		EAX,stPixelgraph.WinInfo.PixelSideLen
	; JMP		RECTSTARTINGPOINTLOOP
; ATRECTSTARTINGPOINT:									;EDX:xPos,EAX:InblockxPos
	
	; ;MOV		stCurrentPixelCoord.x,EDX
	; ;MOV		EAX,stPixelgraph.WinInfo.InblockxPos
	; NEG		EAX
	; ;MOV		EDX,stPixelgraph.WinInfo.xPos
; CALDRAWLOOP:
	; ;CALCULATE AND DRAW EACH PIXEL WHICH HAS A PART SHOWN IN THE WINDOW AREA
	; CMP		EDX,xAxisNeg
	; JL		NEXTXPOS
	; CMP		EDX,xAxis
	; JG		DRAWCOMPLETE
	; ;CALCULATE AND DRAW
	
; NEXTXPOS:	
	; ADD		EAX,stPixelgraph.WinInfo.PixelSideLen
	; INC		EDX
	; CMP		EAX,stRect.right
	; JG		DRAWCOMPLETE
	; JMP		NEXTXPOS
; DRAWCOMPLETE:
	; RET
; DrawPixelGraph		ENDP

; ;RETURNS 0<PixelxCoord(EAX)<stRect.right, 0<PixelyCoord(EDX)<stRect.bottom
; PosToCoord		PROC	PixelxPos:DWORD,PixelyPos:DWORD,WinInfo:WININFO,stRect:RECT;CONFINES DRAWN AREA
	; MOV		EAX,PixelyPos
	; SUB		EAX,WinInfo.yPos
	; MUL		WinInfo.PixelSideLen
	; SUB		EAX,WinInfo.InblockyCoord
	; CMP		EAX,stRect.top
	; JG		PTC_LAGERTHANTOP
	; MOV		EAX,stRect.top
; PTC_LAGERTHANTOP:
	; CMP		EAX,stRect.bottom
	; JL		PTC_SMALLERTHANBOTTOM
	; MOV		EAX,stRect.bottom
; PTC_SMALLERTHANBOTTOM:
	; PUSH	EAX
	; MOV		EAX,PixelxPos
	; SUB		EAX,WinInfo.xPos
	; MUL		WinInfo.PixelSideLen
	; SUB		EAX,WinInfo.InblockxCoord
	; CMP		EAX,stRect.left
	; JG		PTC_LAGERTHANLEFT
	; MOV		EAX,stRect.left
; PTC_LAGERTHANLEFT:
	; CMP		EAX,stRect.right
	; JL		PTC_SMALLERTHANRIGHT
	; MOV		EAX,stRect.right
; PTC_SMALLERTHANRIGHT:
	; POP		EDX
	; RET
; PosToCoord		ENDP

;RETURNS VALIDIFIED COORDINATE. EAX:xCoord, EDX:yCoord
_ValidifyCoord	PROC	_xCoord:DWORD,_yCoord:DWORD,_stRect:RECT
	MOV		EAX,_xCoord
	CMP		EAX,_stRect.left
	JG		VC_LAGERTHANLEFT
	MOV		EAX,_stRect.left
	JMP		VC_SMALLERTHANRIGHT
VC_LAGERTHANLEFT:
	CMP		EAX,_stRect.right
	JL		VC_SMALLERTHANRIGHT
	MOV		EAX,_stRect.right
VC_SMALLERTHANRIGHT:
	MOV		EDX,_yCoord
	CMP		EDX,_stRect.top
	JG		VC_LAGERTHANTOP
	MOV		EDX,_stRect.top
	JMP		VC_SMALLERTHANBOTTOM
VC_LAGERTHANTOP:
	CMP		EDX,_stRect.bottom
	JL		VC_SMALLERTHANBOTTOM
	MOV		EDX,_stRect.bottom
VC_SMALLERTHANBOTTOM:
	RET
_ValidifyCoord	ENDP

_DrawPixel		PROC	_xPos:DWORD,_yPos:DWORD,_WinInfo:WININFO,_stRect:RECT,_hDC:HDC
		LOCAL	@stPointLeftTop:POINT
		LOCAL	@stValidifiedPointLeftTop:POINT
	MOV		EAX,_xPos
	SUB		EAX,_WinInfo.xPos
	MUL		_WinInfo.PixelSideLen
	SUB		EAX,_WinInfo.InblockxCoord
	MOV		@stPointLeftTop.x,EAX
	MOV		EAX,_yPos
	SUB		EAX,_WinInfo.yPos
	MUL		_WinInfo.PixelSideLen
	SUB		EAX,_WinInfo.InblockyCoord
	MOV		@stPointLeftTop.y,EAX
	INVOKE	ValidifyCoord,@stPointLeftTop.x,@stPointLeftTop.y,_stRect
	MOV		@stValidifiedPointLeftTop.x,EAX
	MOV		@stValidifiedPointLeftTop.y,EDX
	MOV		EAX,_WinInfo.PixelSideLen
	ADD		EAX,@stPointLeftTop.x
	MOV		EDX,_WinInfo.PixelSideLen
	ADD		EDX,@stPointLeftTop.y
	INVOKE	ValidifyCoord,EAX,EDX,_stRect
	INVOKE	Rectangle,_hDC,@stValidifiedPointLeftTop.x,@stValidifiedPointLeftTop.y,EAX,EDX
	
	; INVOKE  GetStockObject,BLACK_BRUSH
    ; INVOKE  SelectObject,hDC,EAX
	; INVOKE	Rectangle,hDC,50,50,250,250
	; INVOKE	DeleteObject,EAX
	RET
_DrawPixel		ENDP

;DRAW A PIXEL GRAPH ACCORDING TO PIXELGRAPH AND RECT
DrawPixelGraph		PROC	stPixelgraph:PIXELGRAPH,stRect:RECT,hDC:HDC
		;LOCAL	@PointLeftTop:POINT	;LEFT-TOP CORNER DOT'S COORDINATE OF EVERY RECTANGLE REPRESENTING A PIXEL
		LOCAL	@yUpperBound:DWORD
		LOCAL	@yLowerBound:DWORD
		LOCAL	@xUpperBound:DWORD
	INVOKE	MessageBox,NULL,ADDR MsgBoxTextInDLL,ADDR MsgBoxName,MB_OK
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextxAxis,stPixelgraph.ShapeInfo.xAxis
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextyAxis,stPixelgraph.ShapeInfo.yAxis
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextzAxis,stPixelgraph.ShapeInfo.zAxis
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextThickness,stPixelgraph.ShapeInfo.Thickness
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	;CALCULATE PIXEL POSITION ON LEFT-BOTTOM CORNER OF THE WINDOW
	MOV		EAX,stRect.top
	INC		EAX
	ADD		EAX,stPixelgraph.WinInfo.InblockyCoord
	XOR		EDX,EDX
	MOV		EBX,stPixelgraph.WinInfo.PixelSideLen
	DIV		EBX
	TEST	EDX,EDX
	JNZ		DPG_LW_KEEPEAX
	DEC		EAX
DPG_LW_KEEPEAX:
	MOV		EDX,stPixelgraph.WinInfo.yPos
	ADD		EDX,EAX
	MOV		@yLowerBound,EDX
	
	MOV		EAX,stRect.bottom
	INC		EAX
	ADD		EAX,stPixelgraph.WinInfo.InblockyCoord
	XOR		EDX,EDX
	MOV		EBX,stPixelgraph.WinInfo.PixelSideLen
	DIV		EBX
	TEST	EDX,EDX
	JNZ		DPG_UP_KEEPEAX
	DEC		EAX
DPG_UP_KEEPEAX:
	MOV		EDX,stPixelgraph.WinInfo.yPos
	ADD		EDX,EAX
	MOV		@yUpperBound,EDX
	;CALCULATE PIXEL POSITION ON RIGHT-TOP CORNER OF THE WINDOW
	MOV		EAX,stRect.right
	INC		EAX
	ADD		EAX,stPixelgraph.WinInfo.InblockxCoord
	XOR		EDX,EDX
	MOV		EBX,stPixelgraph.WinInfo.PixelSideLen
	DIV		EBX
	TEST	EDX,EDX
	JNZ		DPG_RT_KEEPEAX
	DEC		EAX
DPG_RT_KEEPEAX:
	MOV		EDX,stPixelgraph.WinInfo.xPos
	ADD		EDX,EAX
	MOV		@xUpperBound,EDX
	
	;DRAW STARTING xPos
	;QUICKLY GET TO RECT TOP-LEFT CORNER
	MOV		EAX,stPixelgraph.WinInfo.InblockxCoord
	ADD		EAX,stRect.left
	MOV		EDX,stPixelgraph.WinInfo.xPos			;stCurrentPoint.
DPG_RECTSTARTINGPOINTLOOP:
	CMP		EAX,stPixelgraph.WinInfo.PixelSideLen	;LEFT TO RECT LEFT
	JB		DPG_ATRECTSTARTINGPOINT
	INC		EDX	
	SUB		EAX,stPixelgraph.WinInfo.PixelSideLen
	JMP		DPG_RECTSTARTINGPOINTLOOP
DPG_ATRECTSTARTINGPOINT:	
	MOV		EDI,stPixelgraph.ShapeInfo.xAxis
	NEG		EDI
	CMP		EDI,EDX
	JGE		DPG_KEEPEDI
	MOV		EDI,EDX		;CHOOSE LARGER ONE
DPG_KEEPEDI:	;EDI:STARTING xPos
	
	MOV		EBX,stPixelgraph.UsedMemoryInfo.lpMemory
	MOV		ESI,stPixelgraph.UsedMemoryInfo.MemoryLen
	SUB		ESI,8
DPG_NEXTESI:	
	CMP		EDI,0
	JGE		DPG_POSITIVEEDIPROCESS
	
DPG_NGNEXTESI:
	MOV		EAX,EBX[ESI]
	NEG		EAX
	CMP		EAX,EDI
	JGE		DPG_VALIDESI
	SUB		ESI,8
	JMP		DPG_NGNEXTESI
DPG_VALIDESI:
	MOV		EAX,EBX[ESI+4]
	CMP		EAX,@yUpperBound
	INVOKE	DrawPixel,DWORD PTR EBX[ESI],DWORD PTR EBX[ESI+4]
	INC		EDI
	SUB		ESI,8
	JMP		DPG_NEXTESI
DPG_POSITIVEEDIPROCESS:

DRAWOVER:
	RET
DrawPixelGraph		ENDP

; IsPixelInWindow		PROC	xPos
			; CMP		
			; RET
; IsPixelInWindow		ENDP
;RETURNS BOUNDS(POSITIVE)
; CalyPos		PROC 	Thickness:DWORD,xPos:DWORD
	
	; RET
; CalyPos		ENDP
;SAVES INFORMATION IN 4TH QUADRANT
;CoeffxLower*xPos^2+CoeffyLower*yPos^2>CoeffRightLower && CoeffxUpper*xPos^2+CoeffyUpper*yPos^2<CoeffRightUpper
;IN USE:CoeffyLower*yPos^2>CoeffRightLower-CoeffxLower*xPos^2 && CoeffyUpper*yPos^2<CoeffRightUpper-CoeffxUpper*xPos^2
;CoeffxUpper:4*(2*yAxis+1)^2,CoeffyUpper:4*(2*xAxis+1)^2,CoeffRightUpper:(2*xAxis+1)^2*(2*yAxis+1)^2
;CoeffxLower:4*(2*yAxis+1-2*Thickness)^2,CoeffyLower:4*(2*xAxis+1-2*Thickness)^2,CoeffRightLower:(2*xAxis+1-2*Thickness)^2*(2*yAxis+1-2*Thickness)^2
CalPixelGraph	PROC	stShapeInfo:SHAPEINFO
		LOCAL	@lpmemory:DWORD
		LOCAL	@MemoryLen:DWORD
		LOCAL	@yPosSearchBound:DWORD
		LOCAL	@CoeffxUpper:DWORD
		LOCAL	@CoeffyUpper:DWORD
		LOCAL	@CoeffRightUpper:DWORD
		LOCAL	@CoeffxLower:DWORD
		LOCAL	@CoeffyLower:DWORD
		LOCAL	@CoeffRightLower:DWORD
		LOCAL	@VarU1:DWORD
		LOCAL	@VarU12:DWORD
		LOCAL	@VarU2:DWORD
		LOCAL	@VarU22:DWORD
		LOCAL	@VarL1:DWORD
		LOCAL	@VarL12:DWORD
		LOCAL	@VarL2:DWORD
		LOCAL	@VarL22:DWORD
		LOCAL	@Var3:DWORD
		LOCAL	@xPos2:DWORD
		LOCAL	@yPos2:DWORD
		LOCAL	@LeftValueUpper:DWORD
		LOCAL	@RightValueUpper:DWORD
		LOCAL	@LeftValueLower:DWORD
		LOCAL	@RightValueLower:DWORD
		;LOCAL	@CurrentLeftValue:DWORD
	INVOKE	MessageBox,NULL,ADDR MsgBoxTextInDLL,ADDR MsgBoxName,MB_OK
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTexthHeap,hHeap
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	;CALCULATE COEFFICIENTS
	MOV		EAX,stShapeInfo.yAxis
	ADD		EAX,EAX
	INC		EAX
	MOV		@VarU1,EAX		;2*yAxis+1
	MUL		EAX
	MOV		@VarU12,EAX		;(2*yAxis+1)^2
	MOV		EBX,4
	MUL		EBX				
	MOV		@CoeffxUpper,EAX;4*(2*yAxis+1)^2
	MOV		EAX,stShapeInfo.xAxis
	ADD		EAX,EAX
	INC		EAX
	MOV		@VarU2,EAX		;2*xAxis+1
	MUL		EAX
	MOV		@VarU22,EAX		;(2*xAxis+1)^2
	MOV		EBX,4
	MUL		EBX				
	MOV		@CoeffyUpper,EAX;4*(2*xAxis+1)^2
	MOV		EAX,@VarU12
	MUL		@VarU22
	MOV		@CoeffRightUpper,EAX;(2*xAxis+1)^2*(2*yAxis+1)^2
	
	MOV		EBX,stShapeInfo.Thickness
	ADD		EBX,EBX
	MOV		@Var3,EBX		;2*Thickness
	MOV		EAX,@VarU1
	SUB		EAX,EBX
	MOV		@VarL1,EAX		;2*yAxis+1-2*Thickness
	MUL		EAX				
	MOV		@VarL12,EAX		;(2*yAxis+1-2*Thickness)^2
	MOV		EBX,4
	MUL		EBX
	MOV		@CoeffxLower,EAX	;4*(2*yAxis+1-2*Thickness)^2
	MOV		EAX,@VarU2
	MOV		EBX,@Var3
	SUB		EAX,EBX
	MOV		@VarL2,EAX		;2*xAxis+1-2*Thickness
	MUL		EAX				
	MOV		@VarL22,EAX		;(2*xAxis+1-2*Thickness)^2
	MOV		EBX,4
	MUL		EBX
	MOV		@CoeffyLower,EAX	;4*(2*xAxis+1-2*Thickness)^2
	MOV		EAX,@VarL12
	MUL		@VarL22
	MOV		@CoeffRightLower,EAX;(2*xAxis+1-2*Thickness)^2*(2*yAxis+1-2*Thickness)^2
	
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextEmpty,@CoeffxUpper
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextEmpty,@CoeffyUpper
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextEmpty,@CoeffRightUpper
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextEmpty,@CoeffxLower
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextEmpty,@CoeffyLower
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextEmpty,@CoeffRightLower
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	;REQUIRED MEMORY LENGTH(POINTS) UPBOUND, ALLOCATE MEMORY IN HEAP
	MOV		EAX,stShapeInfo.xAxis
	ADD		EAX,stShapeInfo.yAxis
	MOV		EBX,stShapeInfo.Thickness
	MUL		EBX
	;TO DWORDS
	ADD		EAX,EAX
	;TO BYTES
	ADD		EAX,EAX
	ADD		EAX,EAX
	
	PUSH	EAX
	INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextEAX,EAX
	INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	POP		EAX
	
	INVOKE	HeapAlloc,hHeap,HEAP_ZERO_MEMORY OR HEAP_NO_SERIALIZE,EAX
	MOV		@lpmemory,EAX
	PUSH	EAX
	MOV		EBX,EAX						;EBX SAVES MEMORY ADDRESS
	
	;BEGIN CALCULATION
	MOV		@yPosSearchBound,0
	MOV		EAX,stShapeInfo.xAxis
	MUL		EAX
	MOV		@xPos2,EAX					;START WITH xAxis^2
	MOV		EDI,stShapeInfo.xAxis
NEXTXPOS:
	;CALCULATE RightValueLower&RightValueUpper
	MOV		EAX,@xPos2
	MUL		@CoeffxLower
	MOV		EDX,@CoeffRightLower
	SUB		EDX,EAX
	MOV		@RightValueLower,EDX
	MOV		EAX,@xPos2
	MUL		@CoeffxUpper
	MOV		EDX,@CoeffRightUpper
	SUB		EDX,EAX
	MOV		@RightValueUpper,EDX	
	
	;GET TO NEAREST POINT SATIFYING CONDITION LOWER
	MOV		ECX,@yPosSearchBound
	MOV		EAX,ECX
	MUL		EAX
	MOV		@yPos2,EAX
STARTPOINTGETLOOP:
	MOV		EAX,@yPos2
	MUL		@CoeffyLower
	CMP		EAX,@RightValueLower
	JG		STARTPOINTGOT
	ADD		@yPos2,ECX
	ADD		@yPos2,ECX
	INC		@yPos2			;(yPos+1)^2=yPos^2+2*yPos2+1
	INC		ECX
	JMP		STARTPOINTGETLOOP
STARTPOINTGOT:
	MOV		@yPosSearchBound,ECX
	
	;;MAKE SURE THERE IS AT LEAST ONE POINT
NEXTPOINT:
	CMP		EAX,@RightValueUpper
	JG		ENDNEXTPOINT
	MOV		[EBX],EDI		;SAVE xPos
	ADD		EBX,4
	MOV		[EBX],ECX		;SAVE yPos
	ADD		EBX,4
	ADD		@yPos2,ECX
	ADD		@yPos2,ECX
	INC		@yPos2			;(yPos+1)^2=yPos^2+2*yPos2+1
	INC		ECX
	MOV		EAX,@yPos2
	MUL		@CoeffyUpper
	JMP		NEXTPOINT
ENDNEXTPOINT:	
	INC		@xPos2
	SUB		@xPos2,EDI
	SUB		@xPos2,EDI		;(xPos-1)^2=xPos^2-2*xPos2+1
	DEC		EDI
	CMP		EDI,0
	JGE		NEXTXPOS
	;lpMemory IN EAX, MemoryLength IN EBX
	POP		EAX
	SUB		EBX,EAX	
	;SUB		EBX,8
	
	; PUSH	EAX
	; PUSH	EBX
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextEAX,EAX
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextEBX,EBX
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	; POP		EBX
	; POP		EAX
	; PUSH	EAX
	; PUSH	EBX
	; MOV		EDX,EBX
	; PUSHAD
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextEDX,EDX
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	; POPAD
	; MOV		EBX,EAX		;START ADDRESS
	; ADD		EDX,EAX		;END ADDRESS
	; PUSHAD
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextEDX,EDX
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	; POPAD
; DISLOOP:
	; CMP		EBX,EDX
	; JE		RETSITE
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextPoint,DWORD PTR [EBX],DWORD PTR [EBX+4]
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	; ADD		EBX,8
	; JMP		DISLOOP
; RETSITE:
	; POP		EBX
	; POP		EAX
	RET
CalPixelGraph	ENDP

; CalPixelCircleOffset	PROC	Radius:WORD,Thickness:WORD,lpmemory:DWORD	;RESULT TO lpmemory
			; LOCAL	@pixelnum:DWORD
			; LOCAL	@lowbound:DWORD
			; LOCAL	@highbound:DWORD
			; MOV		AX,Radius
			; MOV		DX,AX
			; MUL		DX
			; SHL		EDX,16
			; MOV		DX,AX
			; MOV		@lowbound,EDX
			; ADD		AX,Thickness
			; MOV		DX,AX
			; MUL		DX
			; SHL		EDX,16
			; MOV		DX,AX
			; MOV		@highbound,EDX
			
			; MOV		EDI,0
			; MOV		EDX,0
			; CMP		EDX,
			; MOV		EAX,@pixelnum
			; RET
; CalPixelCircleOffset	ENDP

			END		DllEntry