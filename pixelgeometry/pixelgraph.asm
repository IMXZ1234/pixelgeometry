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
MsgBoxTextInDPG		DB	"in DPG!",0
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
			INVOKE	HeapCreate,NULL,2000H,0		;ALLOC 1/8 MB
			.IF	EAX&&(EAX<0C0000000H)
				MOV		hHeap,EAX
				MOV		EAX,TRUE
				;INVOKE	MessageBox,NULL,ADDR MsgBoxTextMemoryAllocDone,ADDR MsgBoxName,MB_OK
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

;RETURNS EAX:xPos,ECX:yPos,EDX:InblockxPos,EBX:InblockyPos
GetPosFromCoord	PROC	_xCoord:DWORD,_yCoord:DWORD,_WinInfo:WININFO
	MOV		EAX,_yCoord
	ADD		EAX,_WinInfo.InblockyCoord
	XOR		EDX,EDX
	DIV		_WinInfo.PixelSideLen
	MOV		ECX,EAX
	ADD		ECX,_WinInfo.yPos
	MOV		EBX,EDX
	MOV		EAX,_xCoord
	ADD		EAX,_WinInfo.InblockxCoord
	XOR		EDX,EDX
	DIV		_WinInfo.PixelSideLen
	ADD		EAX,_WinInfo.xPos
	RET		
GetPosFromCoord	ENDP


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
	PUSH	EAX
	PUSH	EDX
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
	INVOKE	_ValidifyCoord,@stPointLeftTop.x,@stPointLeftTop.y,_stRect
	MOV		@stValidifiedPointLeftTop.x,EAX
	MOV		@stValidifiedPointLeftTop.y,EDX
	MOV		EAX,_WinInfo.PixelSideLen
	ADD		EAX,@stPointLeftTop.x
	MOV		EDX,_WinInfo.PixelSideLen
	ADD		EDX,@stPointLeftTop.y
	INVOKE	_ValidifyCoord,EAX,EDX,_stRect
	INVOKE	Rectangle,_hDC,@stValidifiedPointLeftTop.x,@stValidifiedPointLeftTop.y,EAX,EDX
	
	; INVOKE  GetStockObject,BLACK_BRUSH
    ; INVOKE  SelectObject,hDC,EAX
	; INVOKE	Rectangle,hDC,50,50,250,250
	; INVOKE	DeleteObject,EAX
	POP		EDX
	POP		EAX
	RET
_DrawPixel		ENDP

;DRAW A PIXEL GRAPH ACCORDING TO PIXELGRAPH AND RECT
DrawPixelGraph		PROC	stPixelgraph:PIXELGRAPH,stRect:RECT,hDC:HDC
		LOCAL	@yUpperBound:DWORD
		LOCAL	@yLowerBound:DWORD
		LOCAL	@xUpperBound:DWORD
		LOCAL	@xLowerBound:DWORD
	;INVOKE	MessageBox,NULL,ADDR MsgBoxTextInDPG,ADDR MsgBoxName,MB_OK
	;CALCULATE yPos BOUNDS
	MOV		EAX,stRect.top
	INC		EAX
	ADD		EAX,stPixelgraph.WinInfo.InblockyCoord
	XOR		EDX,EDX
	MOV		EBX,stPixelgraph.WinInfo.PixelSideLen
	DIV		EBX
	TEST	EDX,EDX
	JNZ		DPG_YLW_KEEPEAX
	DEC		EAX
DPG_YLW_KEEPEAX:
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
	JNZ		DPG_YUP_KEEPEAX
	DEC		EAX
DPG_YUP_KEEPEAX:
	MOV		EDX,stPixelgraph.WinInfo.yPos
	ADD		EDX,EAX
	MOV		@yUpperBound,EDX
	;CALCULATE xPos BOUNDS
	MOV		EAX,stRect.right
	INC		EAX
	ADD		EAX,stPixelgraph.WinInfo.InblockxCoord
	XOR		EDX,EDX
	MOV		EBX,stPixelgraph.WinInfo.PixelSideLen
	DIV		EBX
	TEST	EDX,EDX
	JNZ		DPG_XUP_KEEPEAX
	DEC		EAX
DPG_XUP_KEEPEAX:
	MOV		EDX,stPixelgraph.WinInfo.xPos
	ADD		EDX,EAX
	MOV		@xUpperBound,EDX
	MOV		EAX,stRect.left
	INC		EAX
	ADD		EAX,stPixelgraph.WinInfo.InblockxCoord
	XOR		EDX,EDX
	MOV		EBX,stPixelgraph.WinInfo.PixelSideLen
	DIV		EBX
	TEST	EDX,EDX
	JNZ		DPG_XLW_KEEPEAX
	DEC		EAX
DPG_XLW_KEEPEAX:
	MOV		EDX,stPixelgraph.WinInfo.xPos
	ADD		EDX,EAX
	MOV		@xLowerBound,EDX
	
	MOV		EBX,stPixelgraph.UsedMemoryInfo.lpMemory
	MOV		EDI,stPixelgraph.UsedMemoryInfo.MemoryLen
	XOR		ESI,ESI
	.WHILE	ESI<EDI
		MOV		EAX,[EBX+ESI]
		MOV		EDX,[EBX+ESI+4]
		CMP		EAX,@xLowerBound
		JL		DPG_QD4_NOTINWINDOW
		CMP		EAX,@xUpperBound
		JG		DPG_QD4_NOTINWINDOW
		CMP		EDX,@yLowerBound
		JL		DPG_QD4_NOTINWINDOW
		CMP		EDX,@yUpperBound
		JG		DPG_QD4_NOTINWINDOW
		INVOKE	_DrawPixel,EAX,EDX,stPixelgraph.WinInfo,stRect,hDC
DPG_QD4_NOTINWINDOW:
		NEG		EAX
		CMP		EAX,@xLowerBound
		JL		DPG_QD3_NOTINWINDOW
		CMP		EAX,@xUpperBound
		JG		DPG_QD3_NOTINWINDOW
		CMP		EDX,@yLowerBound
		JL		DPG_QD3_NOTINWINDOW
		CMP		EDX,@yUpperBound
		JG		DPG_QD3_NOTINWINDOW
		INVOKE	_DrawPixel,EAX,EDX,stPixelgraph.WinInfo,stRect,hDC
DPG_QD3_NOTINWINDOW:
		NEG		EDX
		CMP		EAX,@xLowerBound
		JL		DPG_QD2_NOTINWINDOW
		CMP		EAX,@xUpperBound
		JG		DPG_QD2_NOTINWINDOW
		CMP		EDX,@yLowerBound
		JL		DPG_QD2_NOTINWINDOW
		CMP		EDX,@yUpperBound
		JG		DPG_QD2_NOTINWINDOW
		INVOKE	_DrawPixel,EAX,EDX,stPixelgraph.WinInfo,stRect,hDC
DPG_QD2_NOTINWINDOW:
		NEG		EAX
		CMP		EAX,@xLowerBound
		JL		DPG_QD1_NOTINWINDOW
		CMP		EAX,@xUpperBound
		JG		DPG_QD1_NOTINWINDOW
		CMP		EDX,@yLowerBound
		JL		DPG_QD1_NOTINWINDOW
		CMP		EDX,@yUpperBound
		JG		DPG_QD1_NOTINWINDOW
		INVOKE	_DrawPixel,EAX,EDX,stPixelgraph.WinInfo,stRect,hDC
DPG_QD1_NOTINWINDOW:
		
		ADD	ESI,8
	.ENDW
DRAWOVER:
	RET
DrawPixelGraph		ENDP

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
	;INVOKE	MessageBox,NULL,ADDR MsgBoxTextInDLL,ADDR MsgBoxName,MB_OK
			; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextxAxis,stShapeInfo.xAxis
			; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
			; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextyAxis,stShapeInfo.yAxis
			; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
			; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextzAxis,stShapeInfo.zAxis
			; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
			; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextThickness,stShapeInfo.Thickness
			; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	;CALCULATE COEFFICIENTS
	MOV		EAX,stShapeInfo.yAxis
	ADD		EAX,EAX
	INC		EAX
	MOV		@VarU1,EAX		;2*yAxis+1
	MUL		EAX
	MOV		@VarU12,EAX		;(2*yAxis+1)^2
	SHL		EAX,2			
	MOV		@CoeffxUpper,EAX;4*(2*yAxis+1)^2
	MOV		EAX,stShapeInfo.xAxis
	ADD		EAX,EAX
	INC		EAX
	MOV		@VarU2,EAX		;2*xAxis+1
	MUL		EAX
	MOV		@VarU22,EAX		;(2*xAxis+1)^2
	SHL		EAX,2			
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
	SHL		EAX,2
	MOV		@CoeffxLower,EAX	;4*(2*yAxis+1-2*Thickness)^2
	MOV		EAX,@VarU2
	MOV		EBX,@Var3
	SUB		EAX,EBX
	MOV		@VarL2,EAX		;2*xAxis+1-2*Thickness
	MUL		EAX				
	MOV		@VarL22,EAX		;(2*xAxis+1-2*Thickness)^2
	SHL		EAX,2
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
	RET
CalPixelGraph	ENDP

			END		DllEntry