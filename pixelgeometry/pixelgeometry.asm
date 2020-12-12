.386 ;表示要用到386指令
.model Flat,stdcall ;32位程序，要用flat啦！;stadcall,标准调用
option casemap:none ;区别大小写
include C:\masm32\include\windows.inc ;包括常量及结构定义

include C:\masm32\include\kernel32.inc ;函数原型声明
include C:\masm32\include\user32.inc
include	C:\Users\xz683\Desktop\myproject\pixelstruct.inc
include	C:\Users\xz683\Desktop\myproject\pixelgraph.inc

includelib 	C:\masm32\lib\kernel32.lib ;用到的引入库
includelib 	C:\masm32\lib\user32.lib
includelib	C:\Users\xz683\Desktop\myproject\pixelgraph.lib

;EXTRN 

;EQUS
IDM_MAIN                EQU 4000    ;MAIN MENU
IDM_MAIN_CIRCLE              EQU 4001
IDM_MAIN_OVAL                EQU 4002
IDM_MAIN_SPHERE              EQU 4003
IDM_MAIN_ELLIPSOID           EQU 4004
IDM_MAIN_STATISTIC           EQU 4005
IDM_MAIN_FILEOUT             EQU 4006
IDM_MAIN_CURDEFAULT          EQU 4007
IDM_MAIN_CURDEFINED          EQU 4008
IDM_MAIN_ICONDEFAULT         EQU 4009
IDM_MAIN_ICONDEFINED         EQU 4010

IDM_MAIN_RBUTTONDOWN    EQU 4100    ;RIGHT CLICK MENU
IDM_MAIN_UP                  EQU 4101    
IDM_MAIN_DOWN                EQU 4102
IDM_MAIN_LEFT                EQU 4103
IDM_MAIN_RIGHT               EQU 4104
IDM_MAIN_UPPER               EQU 4105
IDM_MAIN_LOWER               EQU 4106
IDM_MAIN_ZOOMIN              EQU 4107
IDM_MAIN_ZOOMOUT             EQU 4108

IDM_GDI				    EQU 4200    ;WIN GDI MAIN MENU
; IDM_UP                  EQU 4201    
; IDM_DOWN                EQU 4202
; IDM_LEFT                EQU 4203
; IDM_RIGHT               EQU 4204
; IDM_UPPER               EQU 4205
; IDM_LOWER               EQU 4206
; IDM_ZOOMIN              EQU 4207
; IDM_ZOOMOUT             EQU 4208

IDM_GDI_RBUTTONDOWN    EQU 4300    ;WIN GDI RIGHT CLICK MENU
IDM_GDI_UP                  EQU 4301    
IDM_GDI_DOWN                EQU 4302
IDM_GDI_LEFT                EQU 4303
IDM_GDI_RIGHT               EQU 4304
IDM_GDI_UPPER               EQU 4305
IDM_GDI_LOWER               EQU 4306
IDM_GDI_ZOOMIN              EQU 4307
IDM_GDI_ZOOMOUT             EQU 4308
IDM_GDI_INITIALIZE			EQU 4309

IDA_MAIN                EQU 4000    ;ACCELERATOR FOR MAIN WINDOW

IDA_GDI					EQU 4200	;ACCELERATOR FOR GDI WINDOW

IDI_DEFINED             EQU 1000    ;USER-DEFINED ICON

IDC_DEFINED             EQU 2000    ;USER-DEFINED CURSOR

IDB_MAIN_CREATECIRCLE			EQU	3		;CHILD WINDOW IDS OF MAIN WINDOW
IDB_MAIN_CREATEADDOVAL			EQU	4
IDB_MAIN_CREATEADDSPHERE		EQU	5
IDB_MAIN_CREATEELLIPSOID		EQU	6
IDB_MAIN_OVERLAP				EQU	7

IDD_CIRCLE              EQU 1       ;DIALOG BOXES
IDD_OVAL                EQU 2
IDD_SPHERE              EQU 3
IDD_ELLIPSOID           EQU 4

IDET_CIRCLE_RADIUS      EQU 3       ;DIALOG BOX FOR CIRCLE
IDACB_CIRCLE_THICK      EQU 4
IDET_CIRCLE_THICK       EQU 5

IDET_OVAL_LONGAXIS  	EQU	3		;DIALOG BOX FOR OVAL
IDET_OVAL_SHORTAXIS  	EQU	4
IDACB_OVAL_THICK  		EQU	5
IDET_OVAL_THICK   		EQU	6


WinMain         PROTO :DWORD,:DWORD,:DWORD,:DWORD
CircleDlgProc   PROTO :DWORD,:DWORD,:DWORD,:DWORD 
OvalDlgProc		PROTO :DWORD,:DWORD,:DWORD,:DWORD 
_SearchGraph	PROTO :HWND
.DATA
MainWinClassName    DB  "WndMain",0
GDIWinClassName		DB	"WndGDI",0
AppName         DB  "Pixel Geometry",0
ButtonClassName DB  "Button",0
ButtonText      DB  "Button Text",0
EditClassName   DB  "Edit",0
MDIClassName    DB  "MDI",0

; MessageBoxName  DB  "BOX",0
; MessageBoxText  DB  "MsgCmd",0
MsgBoxName		DB  "INFO",0
MsgBoxTextxAxis		DB	"xAxis is %d",0
MsgBoxTextyAxis		DB	"yAxis is %d",0
MsgBoxTextzAxis		DB	"zAxis is %d",0
MsgBoxTextxPos		DB	"xPos is %d",0
MsgBoxTextyPos		DB	"yPos is %d",0
MsgBoxTextInblockxPos		DB	"InblockxPos is %d",0
MsgBoxTextInblockyPos		DB	"InblockyPos is %d",0
MsgBoxTextPixelSideLen		DB	"PixelSideLen is %d",0
MsgBoxTexthWnd		DB	"hWnd is %d",0
MsgBoxTexthCmdUp		DB	"CmdUp!",0
MsgBoxTextID		DB	"ID = %d",0
MsgBoxTextThickness	DB	"Thickness is %d",0
MsgBoxTextCircle	DB	"Circle created!",0
MsgBoxTextOval		DB	"Oval created!",0
MsgBoxTextSphere	DB	"Sphere created!",0
MsgBoxTextEllipsoid	DB	"Ellipsoid created!",0
MsgBoxTextNotFoundError	DB	"Error,no such window!",0
MsgBoxTextEAX		DB	"EAX %d",0
MsgBoxTextEBX		DB	"EBX %d",0
MsgBoxTextOutDLL		DB	"out dll!",0
MsgBoxTextFill		DB	"FILLED",0
MsgBoxTextOPP		DB	"IN _OPP",0
MsgBoxTextSearchGraph	DB	"SEARCHED ESI: %d",0
MsgBoxTexttop		DB	"TOP: %d",0
MsgBoxTextbottom	DB	"BOTTOM: %d",0
MsgBoxTextleft		DB	"LEFT: %d",0
MsgBoxTextright		DB	"RIGHT: %d",0
MsgBoxTextZoomIn	DB	"InZoomIn",0
MsgBoxTextZoomOut	DB	"InZoomOut",0
MsgBoxTextxCoord	DB	"xCoord %d",0
MsgBoxTextyCoord	DB	"yCoord %d",0
MsgBoxTextMenuWidth	DB	"MenuWidth %d",0
MsgBoxTextEdgeWidth	DB	"EdgeWidth %d",0
MsgBoxTextlParam	DB	"lParam %#lx",0
MsgBoxTextwParam	DB	"wParam %#lx",0
MsgBoxTextErrorCode	DB	"ErrorCode %#lx %d",0
MsgBoxTextFromCoord	DB	"FromCoord ( %d , %d )",0
MsgBoxTextToCoord	DB	"ToCoord ( %d , %d )",0
MsgBoxTextAddress	DB	"Address %d",0
MsgBoxTextOp	DB	"op %d",0
Buffer			DB	128 DUP(?)

;DlgExistFlags   DB      0
;PIXEL GRAPH INFORMATION SAVED
GraphNum		DD		0
Pixelgraphs		PIXELGRAPH	10	DUP(<>)
StepLen			DD		3
ZoomPercentage	DD		120
IsDragging		DD		0
LastMousexCoord		DD	0
LastMouseyCoord		DD	0

.DATA?
hInstance   HINSTANCE   ?
CommandLine LPSTR       ?
hWinMain    HWND        ?
hMenuMain       HMENU       ?
hSubmenuMain    HMENU       ?
hMenuGDI        HMENU       ?
hSubmenuGDI     HMENU       ?
hIcon_defined   DD      ?
hCursor_defined DD      ?
hCursor_default DD      ?
hIcon_default   DD      ?
hAcceleratorMain    DD      ?
hAcceleratorGDI     DD      ?

;MAIN WINDOW
EditID      HINSTANCE   ?
ButtonID    HINSTANCE   ?
hEdit       HINSTANCE   ?
hButton     HINSTANCE   ?
MDIID       HINSTANCE   ?
hMDI        HINSTANCE   ?

;DIALOG BOX FOR CIRCLE
hDlgCircle      DD      ?
hDlgOval        DD      ?
hDlgSphere      DD      ?
hDlgEllipsoid   DD      ?



.CODE ;代码开始执行处
START:

INVOKE  GetModuleHandle,NULL
MOV     hInstance,EAX
INVOKE  GetCommandLine
MOV     CommandLine,EAX

INVOKE  WinMain,hInstance,NULL,CommandLine,SW_SHOWDEFAULT

INVOKE  ExitProcess,EAX ;程序退出

WinMain     PROC    hInst:HINSTANCE,hPreInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
        LOCAL   @wc:WNDCLASSEX
        LOCAL   @msg:MSG
        LOCAL   @hwnd:HWND
    
    MOV     @wc.cbSize,SIZEOF WNDCLASSEX
    MOV     @wc.style,CS_HREDRAW OR CS_VREDRAW
    MOV     @wc.cbClsExtra,NULL
    MOV     @wc.cbWndExtra,NULL
    MOV     EAX,hInstance
    MOV     @wc.hInstance,EAX
    MOV     @wc.hbrBackground,COLOR_WINDOW+1
    MOV     @wc.lpszMenuName,NULL
    
    
    ;LOAD RESOURCES
    INVOKE  LoadIcon,NULL,IDI_APPLICATION               ;WINDOWS DEFAULT ICON
    MOV     hIcon_default,EAX
    MOV     @wc.hIcon,EAX
    MOV     @wc.hIconSm,EAX
    INVOKE  LoadIcon,hInstance,IDI_DEFINED              ;USER DEFINED ICON
    MOV     hIcon_defined,EAX
    
    INVOKE  LoadCursor,NULL,IDC_ARROW                   ;WINDOWS DEFAULT CURSOR
    MOV     hCursor_default,EAX
    MOV     @wc.hCursor,EAX
    INVOKE  LoadCursor,hInstance,IDC_DEFINED            ;USER DEFINED CURSOR
    MOV     hCursor_defined,EAX
    ;MAIN WINDOW
    INVOKE  LoadMenu,hInstance,IDM_MAIN
    MOV     hMenuMain,EAX                                   ;MAIN MENU
    INVOKE  LoadMenu,hInstance,IDM_MAIN_RBUTTONDOWN
    MOV     EBX,EAX
    INVOKE  GetSubMenu,EBX,0
    MOV     hSubmenuMain,EAX                                ;RIGHTCLICK POPUP MENU
    INVOKE  LoadAccelerators,hInstance,IDA_MAIN         ;ACCELERATOR FOR MAIN WINDOW
    MOV     hAcceleratorMain,EAX
	;GDI WINDOW
	INVOKE  LoadMenu,hInstance,IDM_GDI
    MOV     hMenuGDI,EAX                                   ;MAIN MENU
    INVOKE  LoadMenu,hInstance,IDM_GDI_RBUTTONDOWN
    MOV     EBX,EAX
    INVOKE  GetSubMenu,EBX,0
    MOV     hSubmenuGDI,EAX                                ;RIGHTCLICK POPUP MENU
    INVOKE  LoadAccelerators,hInstance,IDA_GDI         ;ACCELERATOR FOR MAIN WINDOW
    MOV     hAcceleratorGDI,EAX
	
	;REGISTER MAIN WINDOW TYPE
	MOV     @wc.lpszClassName,OFFSET MainWinClassName
	MOV     @wc.lpfnWndProc,OFFSET MainWndProc
    INVOKE  RegisterClassEx,ADDR @wc
	;REGISTER GDI WINDOW TYPE
	MOV     @wc.lpszClassName,OFFSET GDIWinClassName
	MOV     @wc.lpfnWndProc,OFFSET GDIWndProc
	MOV		@wc.lpszMenuName,IDM_GDI
	INVOKE  RegisterClassEx,ADDR @wc
	;CREATE MAIN WINDOW
    INVOKE  CreateWindowEx,NULL,\
                    ADDR    MainWinClassName,\
                    ADDR    AppName,\
                    WS_OVERLAPPEDWINDOW,\
                    CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,\
                    NULL,\
                    hMenuMain,\
                    hInstance,\
                    NULL
    MOV @hwnd,EAX
    ;REFRESH THE CLIENT RECT OF WINDOW
    INVOKE  ShowWindow,@hwnd,SW_SHOWNORMAL
    INVOKE  UpdateWindow,@hwnd
    
    ;ENTER MESSAGE LOOP
    .WHILE  TRUE
            INVOKE  GetMessage,ADDR @msg,NULL,0,0
            .BREAK .IF EAX==0
			MOV		EAX,@msg.hwnd
			.IF	EAX==@hwnd
				INVOKE  TranslateAccelerator,@msg.hwnd,hAcceleratorMain,ADDR @msg
			.ELSE
				INVOKE  TranslateAccelerator,@msg.hwnd,hAcceleratorGDI,ADDR @msg
			.ENDIF
            .IF EAX==0
				INVOKE  TranslateMessage,ADDR @msg
				INVOKE  DispatchMessage,ADDR @msg
            .ENDIF
    .ENDW
    
    MOV     EAX,@msg.wParam
    RET
WinMain ENDP

MainWndProc PROC    hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
            LOCAL   @stPos:POINT
    MOV     EAX,uMsg
    .IF EAX==WM_COMMAND
        .IF lParam==0
            MOV     EAX,wParam
            MOVZX   EAX,AX
            
            ;MAIN MENU MESSAGES
            ;DRAWING COMMANDS
            .IF EAX==IDM_MAIN_CIRCLE
                INVOKE  CreateDialogParam,hInstance,IDD_CIRCLE,hWinMain,OFFSET CircleDlgProc,0
                MOV     hDlgCircle,EAX
			.ELSEIF	EAX==IDM_MAIN_OVAL
				INVOKE	CreateDialogParam,hInstance,IDD_OVAL,hWinMain,OFFSET OvalDlgProc,0
            ;SET CURSOR AND ICON COMMANDS
            .ELSEIF EAX==IDM_MAIN_CURDEFAULT
                INVOKE  SetClassLong,hWinMain,GCL_HCURSOR,hCursor_default
                INVOKE  CheckMenuRadioItem,hMenuMain,\
                        IDM_MAIN_CURDEFAULT,IDM_MAIN_CURDEFINED,IDM_MAIN_CURDEFAULT,MF_BYCOMMAND
            .ELSEIF EAX==IDM_MAIN_CURDEFINED
                INVOKE  SetClassLong,hWinMain,GCL_HCURSOR,hCursor_defined   
                INVOKE  CheckMenuRadioItem,hMenuMain,\
                        IDM_MAIN_CURDEFAULT,IDM_MAIN_CURDEFINED,IDM_MAIN_CURDEFINED,MF_BYCOMMAND
            .ELSEIF EAX==IDM_MAIN_ICONDEFAULT
                INVOKE  SendMessage,hWinMain,WM_SETICON,ICON_BIG,hIcon_default
                INVOKE  CheckMenuRadioItem,hMenuMain,\
                        IDM_MAIN_ICONDEFAULT,IDM_MAIN_ICONDEFINED,IDM_MAIN_ICONDEFAULT,MF_BYCOMMAND
            .ELSEIF EAX==IDM_MAIN_ICONDEFINED
                INVOKE  SendMessage,hWinMain,WM_SETICON,ICON_BIG,hIcon_defined
                INVOKE  CheckMenuRadioItem,hMenuMain,\
                        IDM_MAIN_ICONDEFAULT,IDM_MAIN_ICONDEFINED,IDM_MAIN_ICONDEFINED,MF_BYCOMMAND
            .ENDIF
        .ENDIF
    ; .ELSEIF EAX==WM_RBUTTONDOWN
        ; INVOKE  GetCursorPos,ADDR @stPos
        ; INVOKE  TrackPopupMenu,hSubmenuMain,TPM_LEFTALIGN,\
                ; @stPos.x,@stPos.y,NULL,hWnd,NULL
    .ELSEIF EAX==WM_DESTROY
		MOV		ECX,GraphNum
		XOR		ESI,ESI
CLOSEGDIWINDOWS:
		INVOKE	DestroyWindow,Pixelgraphs[ESI].WinInfo.hWnd
		ADD		ESI,SIZEOF PIXELGRAPH
		LOOP	CLOSEGDIWINDOWS
        INVOKE  PostQuitMessage,NULL
    .ELSEIF EAX==WM_CREATE
        MOV     EAX,hWnd
        MOV     hWinMain,EAX
        CALL    _WinMainInit
	.ELSE
        INVOKE  DefWindowProc,hWnd,uMsg,wParam,lParam
        RET
    .ENDIF
    
    XOR     EAX,EAX
    RET
MainWndProc ENDP

_WinMainInit PROC   
    ; INVOKE CreateWindowEx, NULL,\
                ; ADDR    ButtonClassName, \
                ; ADDR    ButtonText, \
                ; WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON, \
                ; 10, 50, 80, 30,\
                ; hWinMain, \
                ; ButtonID, \
                ; hInstance, \
                ; NULL
    ; MOV hButton, EAX
    ;INITIALIZE USING USER-DEFINED CURSOR AND ICON
    INVOKE  SendMessage,hWinMain,WM_COMMAND,IDM_MAIN_CURDEFAULT,NULL
    INVOKE  SendMessage,hWinMain,WM_COMMAND,IDM_MAIN_ICONDEFAULT,NULL
    RET
_WinMainInit ENDP

;RETURNS EAX:xCoord, EDX:yCoord
_ScreenCoordToClientCoord	PROC	hWnd:HWND,xCoord:DWORD,yCoord:DWORD,lpstPoint:DWORD
		LOCAL	@stRectWindow:RECT
		LOCAL	@stRectClient:RECT
		LOCAL	@EdgeWidth:DWORD
		LOCAL	@MenuWidth:DWORD
	INVOKE	GetWindowRect,hWnd,ADDR @stRectWindow
	INVOKE	GetClientRect,hWnd,ADDR @stRectClient
	MOV		EAX,@stRectWindow.right
	SUB		EAX,@stRectWindow.left
	MOV		EDX,@stRectClient.right
	SUB		EDX,@stRectClient.left
	SUB		EAX,EDX
	SHR		EAX,1						;DIVIDED BY 2
	MOV		@EdgeWidth,EAX
	MOV		EAX,@stRectWindow.bottom
	SUB		EAX,@stRectWindow.top
	MOV		EDX,@stRectClient.bottom
	SUB		EDX,@stRectClient.top
	SUB		EAX,EDX
	SUB		EAX,@EdgeWidth
	MOV		@MenuWidth,EAX
	; PUSHAD
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextMenuWidth,@MenuWidth
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextEdgeWidth,@EdgeWidth
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	; POPAD
	MOV		EAX,xCoord
	SUB		EAX,@stRectWindow.left
	SUB		EAX,@EdgeWidth
	MOV		[lpstPoint],EAX
	MOV		EDX,yCoord
	SUB		EDX,@stRectWindow.top
	SUB		EDX,@MenuWidth
	MOV		[lpstPoint+4],EDX
	RET
_ScreenCoordToClientCoord	ENDP

_OperationUp		PROC	hWnd:HWND
	INVOKE	_SearchGraph,hWnd		;ESI IS GRAPH OFFSET
	MOV		EAX,StepLen
	.WHILE	EAX>=Pixelgraphs[ESI].WinInfo.PixelSideLen
		SUB		EAX,Pixelgraphs[ESI].WinInfo.PixelSideLen
		DEC		Pixelgraphs[ESI].WinInfo.yPos
	.ENDW
	.IF EAX>Pixelgraphs[ESI].WinInfo.InblockyCoord
		DEC		Pixelgraphs[ESI].WinInfo.yPos
		SUB		EAX,Pixelgraphs[ESI].WinInfo.PixelSideLen
	.ENDIF
	SUB		Pixelgraphs[ESI].WinInfo.InblockyCoord,EAX
	INVOKE	InvalidateRect,hWnd,NULL,TRUE
	RET
_OperationUp		ENDP

_OperationDown		PROC	hWnd:HWND
	INVOKE	_SearchGraph,hWnd		;ESI IS GRAPH OFFSET
	MOV		EAX,StepLen
	.WHILE	EAX>=Pixelgraphs[ESI].WinInfo.PixelSideLen
		SUB		EAX,Pixelgraphs[ESI].WinInfo.PixelSideLen
		INC		Pixelgraphs[ESI].WinInfo.yPos
	.ENDW
	ADD		EAX,Pixelgraphs[ESI].WinInfo.InblockyCoord
	.IF	EAX>=Pixelgraphs[ESI].WinInfo.PixelSideLen
		INC		Pixelgraphs[ESI].WinInfo.yPos
		SUB		EAX,Pixelgraphs[ESI].WinInfo.PixelSideLen
	.ENDIF
	MOV		Pixelgraphs[ESI].WinInfo.InblockyCoord,EAX
	INVOKE	InvalidateRect,hWnd,NULL,TRUE
	RET
_OperationDown		ENDP

_OperationLeft		PROC	hWnd:HWND
	INVOKE	_SearchGraph,hWnd		;ESI IS GRAPH OFFSET
	MOV		EAX,StepLen
	.WHILE	EAX>=Pixelgraphs[ESI].WinInfo.PixelSideLen
		SUB		EAX,Pixelgraphs[ESI].WinInfo.PixelSideLen
		DEC		Pixelgraphs[ESI].WinInfo.xPos
	.ENDW
	.IF EAX>Pixelgraphs[ESI].WinInfo.InblockxCoord
		DEC		Pixelgraphs[ESI].WinInfo.xPos
		SUB		EAX,Pixelgraphs[ESI].WinInfo.PixelSideLen
	.ENDIF
	SUB		Pixelgraphs[ESI].WinInfo.InblockxCoord,EAX
	INVOKE	InvalidateRect,hWnd,NULL,TRUE
	RET
_OperationLeft		ENDP

_OperationRight		PROC	hWnd:HWND
	INVOKE	_SearchGraph,hWnd		;ESI IS GRAPH OFFSET
	MOV		EAX,StepLen
	.WHILE	EAX>=Pixelgraphs[ESI].WinInfo.PixelSideLen
		SUB		EAX,Pixelgraphs[ESI].WinInfo.PixelSideLen
		INC		Pixelgraphs[ESI].WinInfo.xPos
	.ENDW
	ADD		EAX,Pixelgraphs[ESI].WinInfo.InblockxCoord
	.IF	EAX>=Pixelgraphs[ESI].WinInfo.PixelSideLen
		INC		Pixelgraphs[ESI].WinInfo.xPos
		SUB		EAX,Pixelgraphs[ESI].WinInfo.PixelSideLen
	.ENDIF
	MOV		Pixelgraphs[ESI].WinInfo.InblockxCoord,EAX
	INVOKE	InvalidateRect,hWnd,NULL,TRUE
	RET
_OperationRight		ENDP

_OperationDrag	PROC	hWnd:HWND,FromxCoord:DWORD,FromyCoord:DWORD,ToxCoord:DWORD,ToyCoord:DWORD
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextFromCoord,FromxCoord,FromyCoord
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextToCoord,ToxCoord,ToyCoord
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	INVOKE	_SearchGraph,hWnd		;ESI IS GRAPH OFFSET
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextxPos,Pixelgraphs[ESI].WinInfo.xPos
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextyPos,Pixelgraphs[ESI].WinInfo.yPos
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextInblockxPos,Pixelgraphs[ESI].WinInfo.InblockxCoord
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextInblockyPos,Pixelgraphs[ESI].WinInfo.InblockyCoord
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	MOV		EAX,FromxCoord
	SUB		EAX,ToxCoord
	ADD		EAX,Pixelgraphs[ESI].WinInfo.InblockxCoord
	;MOV		ESI,0
	MOV		EAX,FromxCoord
	SUB		EAX,ToxCoord
	ADD		EAX,Pixelgraphs[ESI].WinInfo.InblockxCoord
	; PUSHAD
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextEAX,EAX
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	; POPAD
OPG_CMPXCOORDTOZERO:
	CMP		EAX,0
	JGE		OPG_CMPXCOORDTOPIXELSIDELEN
	ADD		EAX,Pixelgraphs[ESI].WinInfo.PixelSideLen
	DEC		Pixelgraphs[ESI].WinInfo.xPos
	JMP		OPG_CMPXCOORDTOZERO
OPG_CMPXCOORDTOPIXELSIDELEN:
	; PUSHAD
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextEAX,EAX
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	; POPAD
	CMP		EAX,Pixelgraphs[ESI].WinInfo.PixelSideLen
	JL		OPG_VALIDXCOORD
	SUB		EAX,Pixelgraphs[ESI].WinInfo.PixelSideLen
	INC		Pixelgraphs[ESI].WinInfo.xPos
	JMP		OPG_CMPXCOORDTOPIXELSIDELEN
OPG_VALIDXCOORD:
	; PUSHAD
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextEAX,EAX
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	; POPAD
	
	MOV		Pixelgraphs[ESI].WinInfo.InblockxCoord,EAX
	
	MOV		EAX,FromyCoord
	SUB		EAX,ToyCoord
	ADD		EAX,Pixelgraphs[ESI].WinInfo.InblockyCoord
	; PUSHAD
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextEAX,EAX
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	; POPAD
OPG_CMPYCOORDTOZERO:
	CMP		EAX,0
	JGE		OPG_CMPYCOORDTOPIXELSIDELEN
	ADD		EAX,Pixelgraphs[ESI].WinInfo.PixelSideLen
	DEC		Pixelgraphs[ESI].WinInfo.yPos
	JMP		OPG_CMPYCOORDTOZERO
OPG_CMPYCOORDTOPIXELSIDELEN:
	; PUSHAD
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextEAX,EAX
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	; POPAD
	CMP		EAX,Pixelgraphs[ESI].WinInfo.PixelSideLen
	JL		OPG_VALIDYCOORD
	SUB		EAX,Pixelgraphs[ESI].WinInfo.PixelSideLen
	INC		Pixelgraphs[ESI].WinInfo.yPos
	JMP		OPG_CMPYCOORDTOPIXELSIDELEN
OPG_VALIDYCOORD:
	MOV		Pixelgraphs[ESI].WinInfo.InblockyCoord,EAX
	
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextxPos,Pixelgraphs[ESI].WinInfo.xPos
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextyPos,Pixelgraphs[ESI].WinInfo.yPos
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextInblockxPos,Pixelgraphs[ESI].WinInfo.InblockxCoord
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextInblockyPos,Pixelgraphs[ESI].WinInfo.InblockyCoord
	; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	INVOKE	InvalidateRect,hWnd,NULL,TRUE
	RET
_OperationDrag	ENDP

_OperationZoomIn	PROC	hWnd:HWND,xCoord:DWORD,yCoord:DWORD
		LOCAL	@MousexPos
		LOCAL	@MouseyPos
		LOCAL	@MouseInblockxCoord
		LOCAL	@MouseInblockyCoord
	INVOKE	_SearchGraph,hWnd		;ESI IS GRAPH OFFSET
	;GET xPos&yPos&InblockxPos&InblockyPos OF THE MOUSE'S POSIITON
	INVOKE	GetPosFromCoord,xCoord,yCoord,Pixelgraphs[ESI].WinInfo
	MOV		@MousexPos,EAX
	MOV		@MouseyPos,ECX
	;NEW InblockxPos&InblockyPos OF THE MOUSE'S POSIITON
	MOV		EAX,EDX
	MUL		ZoomPercentage
	XOR		EDX,EDX
	MOV		ECX,100
	DIV		ECX
	MOV		@MouseInblockxCoord,EAX
	MOV		EAX,EBX
	MUL		ZoomPercentage
	XOR		EDX,EDX
	MOV		ECX,100
	DIV		ECX
	MOV		@MouseInblockyCoord,EAX
	;NEW PixelSideLen
	MOV		EAX,Pixelgraphs[ESI].WinInfo.PixelSideLen
	MUL		ZoomPercentage
	XOR		EDX,EDX
	MOV		EBX,100
	DIV		EBX
	CMP		EAX,Pixelgraphs[ESI].WinInfo.PixelSideLen	;AT LEAST ADD 1 TO PixelSideLen
	JA		OPZI_SATISFACTORYPIXELSIDELEN
	INC		EAX
OPZI_SATISFACTORYPIXELSIDELEN:
	MOV		Pixelgraphs[ESI].WinInfo.PixelSideLen,EAX
	;GET xPos&yPos&InblockxPos&InblockyPos OF THE NEW LEFT-TOP CORNER DOT
	MOV		EAX,xCoord
	SUB		EAX,@MouseInblockxCoord
	ADD		EAX,Pixelgraphs[ESI].WinInfo.PixelSideLen
	XOR		EDX,EDX
	DIV		Pixelgraphs[ESI].WinInfo.PixelSideLen
	MOV		ECX,@MousexPos
	SUB		ECX,EAX
	MOV		Pixelgraphs[ESI].WinInfo.xPos,ECX
	MOV		EAX,Pixelgraphs[ESI].WinInfo.PixelSideLen
	DEC		EAX
	SUB		EAX,EDX
	MOV		Pixelgraphs[ESI].WinInfo.InblockxCoord,EAX
	
	MOV		EAX,yCoord
	SUB		EAX,@MouseInblockyCoord
	ADD		EAX,Pixelgraphs[ESI].WinInfo.PixelSideLen
	XOR		EDX,EDX
	DIV		Pixelgraphs[ESI].WinInfo.PixelSideLen
	MOV		ECX,@MouseyPos
	SUB		ECX,EAX
	MOV		Pixelgraphs[ESI].WinInfo.yPos,ECX
	MOV		EAX,Pixelgraphs[ESI].WinInfo.PixelSideLen
	DEC		EAX
	SUB		EAX,EDX
	MOV		Pixelgraphs[ESI].WinInfo.InblockyCoord,EAX
	INVOKE	InvalidateRect,hWnd,NULL,TRUE
	RET		
_OperationZoomIn	ENDP

_OperationZoomOut	PROC	hWnd:HWND,xCoord:DWORD,yCoord:DWORD
		LOCAL	@MousexPos
		LOCAL	@MouseyPos
		LOCAL	@MouseInblockxCoord
		LOCAL	@MouseInblockyCoord
	INVOKE	_SearchGraph,hWnd		;ESI IS GRAPH OFFSET
	;GET xPos&yPos&InblockxPos&InblockyPos OF THE MOUSE'S POSIITON
	INVOKE	GetPosFromCoord,xCoord,yCoord,Pixelgraphs[ESI].WinInfo
	MOV		@MousexPos,EAX
	MOV		@MouseyPos,ECX
	;NEW InblockxPos&InblockyPos OF THE MOUSE'S POSIITON
	MOV		EAX,EDX
	MOV		ECX,100
	MUL		ECX
	XOR		EDX,EDX
	DIV		ZoomPercentage
	INC		EAX
	MOV		@MouseInblockxCoord,EAX
	MOV		EAX,EBX
	MOV		ECX,100
	MUL		ECX
	XOR		EDX,EDX
	DIV		ZoomPercentage
	INC		EAX
	MOV		@MouseInblockyCoord,EAX
	;NEW PixelSideLen
	MOV		EAX,Pixelgraphs[ESI].WinInfo.PixelSideLen
	MOV		ECX,100
	MUL		ECX
	XOR		EDX,EDX
	DIV		ZoomPercentage
	CMP		EAX,Pixelgraphs[ESI].WinInfo.PixelSideLen	;AT LEAST SUB 1 FROM PixelSideLen
	JB		OPZO_SATISFACTORYPIXELSIDELEN
	DEC		EAX
OPZO_SATISFACTORYPIXELSIDELEN:
	MOV		Pixelgraphs[ESI].WinInfo.PixelSideLen,EAX
	;GET xPos&yPos&InblockxPos&InblockyPos OF THE NEW LEFT-TOP CORNER DOT
	MOV		EAX,xCoord
	SUB		EAX,@MouseInblockxCoord
	ADD		EAX,Pixelgraphs[ESI].WinInfo.PixelSideLen
	XOR		EDX,EDX
	DIV		Pixelgraphs[ESI].WinInfo.PixelSideLen
	MOV		ECX,@MousexPos
	SUB		ECX,EAX
	MOV		Pixelgraphs[ESI].WinInfo.xPos,ECX
	MOV		EAX,Pixelgraphs[ESI].WinInfo.PixelSideLen
	DEC		EAX
	SUB		EAX,EDX
	MOV		Pixelgraphs[ESI].WinInfo.InblockxCoord,EAX
	
	MOV		EAX,yCoord
	SUB		EAX,@MouseInblockyCoord
	ADD		EAX,Pixelgraphs[ESI].WinInfo.PixelSideLen
	XOR		EDX,EDX
	DIV		Pixelgraphs[ESI].WinInfo.PixelSideLen
	MOV		ECX,@MouseyPos
	SUB		ECX,EAX
	MOV		Pixelgraphs[ESI].WinInfo.yPos,ECX
	MOV		EAX,Pixelgraphs[ESI].WinInfo.PixelSideLen
	DEC		EAX
	SUB		EAX,EDX
	MOV		Pixelgraphs[ESI].WinInfo.InblockyCoord,EAX
	INVOKE	InvalidateRect,hWnd,NULL,TRUE
	RET		
_OperationZoomOut	ENDP
	
_OperationInitialize	PROC	hWnd:HWND
		LOCAL	@stRect:RECT
	INVOKE	_SearchGraph,hWnd		;ESI IS GRAPH OFFSET
	INVOKE	GetClientRect,hWnd,ADDR @stRect
	;CHOOSE SMALLER PixelSideLen
	MOV		EAX,@stRect.right
	XOR		EDX,EDX
	MOV		ECX,Pixelgraphs[ESI].ShapeInfo.xAxis
	ADD		ECX,ECX
	INC		ECX
	DIV		ECX
	MOV		EBX,EAX
	MOV		EAX,@stRect.bottom
	XOR		EDX,EDX
	MOV		ECX,Pixelgraphs[ESI].ShapeInfo.yAxis
	ADD		ECX,ECX
	INC		ECX
	DIV		ECX
	CMP		EBX,EAX
	JA		OPI_CHOOSESMALLERPIXELSIDELEN
	MOV		EAX,EBX
OPI_CHOOSESMALLERPIXELSIDELEN:
	TEST	EAX,EAX					;PixelSideLen SHOULD BE AT LEAST 1
	JNZ		OPI_PIXELSIDELENNOTZERO
	INC		EAX
OPI_PIXELSIDELENNOTZERO:
	MOV		Pixelgraphs[ESI].WinInfo.PixelSideLen,EAX
	
	MOV		EAX,Pixelgraphs[ESI].ShapeInfo.xAxis
	NEG		EAX
	MOV		Pixelgraphs[ESI].WinInfo.xPos,EAX
	MOV		EAX,Pixelgraphs[ESI].ShapeInfo.yAxis
	NEG		EAX
	MOV		Pixelgraphs[ESI].WinInfo.yPos,EAX
	MOV		Pixelgraphs[ESI].WinInfo.InblockxCoord,0
	MOV		Pixelgraphs[ESI].WinInfo.InblockyCoord,0
	INVOKE	InvalidateRect,hWnd,NULL,TRUE
	RET
_OperationInitialize	ENDP

_OperationPaint		PROC	_hWnd:HWND,_hDC:HDC,_stRect:RECT
	;INVOKE	MessageBox,NULL,ADDR MsgBoxTextOPP,ADDR MsgBoxName,MB_OK
	INVOKE	_SearchGraph,_hWnd
	;INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextSearchGraph,ESI
	;INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	MOV		EBX,OFFSET Pixelgraphs
	INVOKE	DrawPixelGraph,PIXELGRAPH PTR [EBX+ESI],_stRect,_hDC
	RET
_OperationPaint		ENDP

_SetLastMouseCoord	PROC	xCoord:DWORD,yCoord:DWORD
	MOV		EAX,xCoord
	MOV		LastMousexCoord,EAX
	MOV		EAX,yCoord
	MOV		LastMouseyCoord,EAX
	RET
_SetLastMouseCoord	ENDP

_GetMiddlePointCoord	PROC	hWnd:HWND,lpstPoint:DWORD
		LOCAL	@stRect:RECT
				; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextAddress,lpstPoint
				; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	INVOKE	GetClientRect,hWnd,ADDR @stRect
				; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextright,@stRect.right
				; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
				; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextbottom,@stRect.bottom
				; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	MOV		EAX,@stRect.bottom
	SHR		EAX,1
	MOV		[lpstPoint+4],EAX	
	MOV		EDX,EAX		
	MOV		EAX,@stRect.right
	SHR		EAX,1
	MOV		[lpstPoint],EAX
				; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextxCoord,DWORD PTR [lpstPoint]
				; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
				; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextyCoord,DWORD PTR [lpstPoint+4]
				; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
	;MOV		EBX,lpstPoint
	;MOV		EDX,EAX
	RET
_GetMiddlePointCoord	ENDP

GDIWndProc		PROC	hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
				LOCAL	@stMiddlePoint:POINT
				LOCAL   @stCoord:POINT
				LOCAL	@stPaintStruct:PAINTSTRUCT
	;INVOKE		_GetMiddlePointCoord,hWnd,ADDR	@stMiddlePoint
    MOV     EAX,uMsg
	.IF EAX==WM_PAINT
		INVOKE	BeginPaint,hWnd,ADDR @stPaintStruct
		INVOKE	_OperationPaint,hWnd,EAX,@stPaintStruct.rcPaint
		INVOKE	EndPaint,hWnd,ADDR @stPaintStruct
    .ELSEIF EAX==WM_COMMAND
        .IF lParam==0
			;GDI MAIN MENU MESSAGES
			MOV     EAX,wParam
            MOVZX   EAX,AX
			; PUSH	EAX
			; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextID,EAX
			; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
			; POP		EAX
            .IF	EAX==IDM_GDI_INITIALIZE
				INVOKE _OperationInitialize,hWnd
			.ELSEIF	EAX==IDM_GDI_UP
				INVOKE _OperationUp,hWnd
			.ELSEIF	EAX==IDM_GDI_DOWN
				INVOKE	_OperationDown,hWnd
			.ELSEIF	EAX==IDM_GDI_LEFT
				INVOKE _OperationLeft,hWnd
			.ELSEIF	EAX==IDM_GDI_RIGHT
				INVOKE	_OperationRight,hWnd
			.ELSEIF	EAX==IDM_GDI_ZOOMIN
				;INVOKE	_ScreenCoordToClientCoord,hWnd,LastMousexCoord,LastMouseyCoord,ADDR	@stCoord
				; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextAddress,ADDR @stMiddlePoint
				; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
				INVOKE	_GetMiddlePointCoord,hWnd,ADDR	@stMiddlePoint
				;LEA		EBX,@stMiddlePoint
				INVOKE	_OperationZoomIn,hWnd,EAX,EDX
				; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextAddress,ADDR @stMiddlePoint
				; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
				; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextxCoord,@stMiddlePoint.x
				; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
				; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextyCoord,@stMiddlePoint.x
				; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
				
			.ELSEIF	EAX==IDM_GDI_ZOOMOUT
				;INVOKE	_ScreenCoordToClientCoord,hWnd,LastMousexCoord,LastMouseyCoord,ADDR	@stCoord
				INVOKE	_GetMiddlePointCoord,hWnd,ADDR	@stMiddlePoint
				; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextxCoord,@stMiddlePoint.x
				; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
				; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextyCoord,@stMiddlePoint.y
				; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
				INVOKE	_OperationZoomOut,hWnd,EAX,EDX
			.ENDIF
        .ENDIF
	.ELSEIF	EAX==WM_MOUSEMOVE 
		.IF	wParam==MK_LBUTTON
			.IF IsDragging==1
			; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextOp,10
			; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
			INVOKE  GetCursorPos,ADDR @stCoord
			INVOKE	_ScreenCoordToClientCoord,hWnd,@stCoord.x,@stCoord.y,ADDR @stCoord
			INVOKE	_OperationDrag,hWnd,LastMousexCoord,LastMouseyCoord,@stCoord.x,@stCoord.y
			INVOKE	_SetLastMouseCoord,@stCoord.x,@stCoord.y
			.ENDIF
		.ENDIF
	.ELSEIF	EAX==WM_LBUTTONDOWN
		; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextOp,15
		; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
		MOV		IsDragging,1
		INVOKE  GetCursorPos,ADDR @stCoord
		INVOKE	_ScreenCoordToClientCoord,hWnd,@stCoord.x,@stCoord.y,ADDR @stCoord
		INVOKE	_SetLastMouseCoord,@stCoord.x,@stCoord.y
		; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextxCoord,EAX
		; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
		
	.ELSEIF	EAX==WM_LBUTTONUP
		; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextOp,25
		; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
		MOV		IsDragging,0
    .ELSEIF EAX==WM_RBUTTONDOWN
        INVOKE  GetCursorPos,ADDR @stCoord
		; INVOKE	_ScreenCoordToClientCoord,hWnd,@stCoord.x,@stCoord.y,ADDR @stCoord
		; INVOKE	_SetLastMouseCoord,@stCoord.x,@stCoord.y
				; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextxCoord,@stCoord.x
				; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
				; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextyCoord,@stCoord.y
				; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
        INVOKE  TrackPopupMenu,hSubmenuGDI,TPM_LEFTALIGN,\
                @stCoord.x,@stCoord.y,NULL,hWnd,NULL
	.ELSEIF	EAX==WM_MOUSEWHEEL
		INVOKE  GetCursorPos,ADDR @stCoord
		INVOKE	_ScreenCoordToClientCoord,hWnd,@stCoord.x,@stCoord.y,ADDR @stCoord
		TEST	wParam,80000000H			;WHETHER ROTATED FORWARD OR BACKWARD 
		.IF	ZERO?
			INVOKE	_OperationZoomIn,hWnd,EAX,EDX
		.ELSE
			INVOKE	_OperationZoomOut,hWnd,EAX,EDX
		.ENDIF
		
    .ELSEIF EAX==WM_CLOSE
		INVOKE	_SearchGraph,hWnd
		MOV		Pixelgraphs[ESI].WinInfo.hWnd,NULL
        INVOKE  DestroyWindow,hWnd
		
    ;.ELSEIF EAX==WM_CREATE
        ;INVOKE SendMessage,hWnd,WM_COMMAND,IDM_GDI_INITIALIZE,NULL
    .ELSE
        INVOKE  DefWindowProc,hWnd,uMsg,wParam,lParam
        RET
    .ENDIF
    XOR     EAX,EAX
    RET
GDIWndProc		ENDP

_RegisterGraph		PROC	xAxis:DWORD,yAxis:DWORD,zAxis:DWORD,Thickness:DWORD;USES EAX,EBX,EDX,ESI
			;FILL IN SHAPEINFO
			MOV	ESI,GraphNum
			MOV	EAX,SIZEOF PIXELGRAPH
			MUL	ESI
			MOV	ESI,EAX												;GET OFFSET IN SET
			MOV	EAX,xAxis
			MOV	Pixelgraphs[ESI].ShapeInfo.xAxis,EAX					;CIRCLE HAS ONLY RADIUS(xAxis), yAxis AND zAxis = 0, ETC
			MOV	EAX,yAxis
			MOV	Pixelgraphs[ESI].ShapeInfo.yAxis,EAX
			MOV	EAX,zAxis
			MOV	Pixelgraphs[ESI].ShapeInfo.zAxis,EAX
			MOV	EAX,Thickness
			MOV	Pixelgraphs[ESI].ShapeInfo.Thickness,EAX
			;INVOKE	MessageBox,NULL,ADDR MsgBoxTextFill,ADDR MsgBoxName,MB_OK
			;FILL IN WININFO, ONLY FILLS hWnd
			INVOKE  CreateWindowEx,NULL,\							;CREATE NEW WINDOW FOR DRAWING
                    ADDR    GDIWinClassName,\
                    ADDR    AppName,\
                    WS_OVERLAPPEDWINDOW,\
                    CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,\
                    NULL,\
                    NULL,\
                    hInstance,\
                    NULL
			; PUSHAD
			; INVOKE	GetLastError
			; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTextErrorCode,EAX,EAX
			; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
			; POPAD
			MOV	Pixelgraphs[ESI].WinInfo.hWnd,EAX
			
			; INVOKE	wsprintf,ADDR Buffer,ADDR MsgBoxTexthWnd,Pixelgraphs[ESI].WinInfo.hWnd
			; INVOKE	MessageBox,NULL,ADDR Buffer,ADDR MsgBoxName,MB_OK
			;REFRESH THE CLIENT RECT OF WINDOW
			INC		GraphNum
			MOV		EBX,OFFSET Pixelgraphs
			INVOKE 	CalPixelGraph,SHAPEINFO PTR [EBX+ESI+PIXELGRAPH.ShapeInfo]
			MOV		Pixelgraphs[ESI].UsedMemoryInfo.lpMemory,EAX
			MOV		Pixelgraphs[ESI].UsedMemoryInfo.MemoryLen,EBX
			;GET AN INITIAL WININFO
			MOV		Pixelgraphs[ESI].WinInfo.xPos,0
			MOV		Pixelgraphs[ESI].WinInfo.yPos,0
			MOV		Pixelgraphs[ESI].WinInfo.InblockxCoord,0
			MOV		Pixelgraphs[ESI].WinInfo.InblockyCoord,0
			MOV		Pixelgraphs[ESI].WinInfo.PixelSideLen,1
			INVOKE  ShowWindow,Pixelgraphs[ESI].WinInfo.hWnd,SW_SHOWNORMAL
			;INVOKE	MessageBox,NULL,ADDR MsgBoxTextFill,ADDR MsgBoxName,MB_OK
			INVOKE  UpdateWindow,Pixelgraphs[ESI].WinInfo.hWnd
			INVOKE  SendMessage,Pixelgraphs[ESI].WinInfo.hWnd,WM_COMMAND,IDM_GDI_INITIALIZE,NULL
			
			RET
_RegisterGraph		ENDP

;WINDOW PROCEDURE FOR DIALOG BOX FOR CIRCLE
CircleDlgProc   PROC    hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
	LOCAL	@GDIMsg:MSG
	LOCAL	@xAxis
	LOCAL	@Thickness
    MOV     EAX,uMsg
    .IF EAX==WM_CLOSE
        INVOKE  DestroyWindow,hWnd
    .ELSEIF EAX==WM_COMMAND
        MOV     EAX,wParam
        MOVZX   EAX,AX
        .IF EAX==IDCANCEL
            INVOKE  SendMessage,hWnd,WM_CLOSE,NULL,NULL
        .ELSEIF EAX==IDOK											;SET OVER
			;FILL IN SHAPEINFO
            INVOKE  IsDlgButtonChecked,hWnd,IDACB_CIRCLE_THICK
			MOV		EDX,1												;DEFAULT THICKNESS = 1
            .IF EAX==BST_CHECKED
                INVOKE  GetDlgItemInt,hWnd,IDET_CIRCLE_THICK,NULL,FALSE
				MOV		EDX,EAX
            .ENDIF
			MOV		@Thickness,EDX
			INVOKE	GetDlgItemInt,hWnd,IDET_CIRCLE_RADIUS,NULL,FALSE
			MOV		@xAxis,EAX
			INVOKE	_RegisterGraph,@xAxis,@xAxis,NULL,@Thickness
            INVOKE  SendMessage,hWnd,WM_CLOSE,NULL,NULL
        .ELSEIF EAX==IDACB_CIRCLE_THICK
            INVOKE  IsDlgButtonChecked,hWnd,IDACB_CIRCLE_THICK
            .IF EAX==BST_CHECKED
                MOV     EBX,TRUE
            .ELSE
				INVOKE	SetDlgItemInt,hWnd,IDET_CIRCLE_THICK,1,FALSE
                XOR     EBX,EBX
            .ENDIF
            INVOKE  GetDlgItem,hWnd,IDET_CIRCLE_THICK 
            INVOKE  EnableWindow,EAX,EBX
        .ENDIF
    .ELSE
        XOR     EAX,EAX
        RET
    .ENDIF
    MOV     EAX,TRUE     
    RET
CircleDlgProc   ENDP

;WINDOW PROCEDURE FOR DIALOG BOX FOR CIRCLE
OvalDlgProc   PROC    hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
	LOCAL	@GDIMsg:MSG
	LOCAL	@xAxis
	LOCAL	@yAxis
	LOCAL	@Thickness
    MOV     EAX,uMsg
    .IF EAX==WM_CLOSE
        INVOKE  DestroyWindow,hWnd
    .ELSEIF EAX==WM_COMMAND
        MOV     EAX,wParam
        MOVZX   EAX,AX
        .IF EAX==IDCANCEL
            INVOKE  SendMessage,hWnd,WM_CLOSE,NULL,NULL
        .ELSEIF EAX==IDOK											;SET OVER
			;FILL IN SHAPEINFO
            INVOKE  IsDlgButtonChecked,hWnd,IDACB_OVAL_THICK
			MOV		EDX,1												;DEFAULT THICKNESS = 1
            .IF EAX==BST_CHECKED
                INVOKE  GetDlgItemInt,hWnd,IDET_OVAL_THICK,NULL,FALSE
				MOV		EDX,EAX
            .ENDIF
			MOV		@Thickness,EDX
			INVOKE	GetDlgItemInt,hWnd,IDET_OVAL_LONGAXIS,NULL,FALSE
			MOV		@xAxis,EAX
			INVOKE	GetDlgItemInt,hWnd,IDET_OVAL_SHORTAXIS,NULL,FALSE
			MOV		@yAxis,EAX
			INVOKE	_RegisterGraph,@xAxis,@yAxis,NULL,@Thickness
            INVOKE  SendMessage,hWnd,WM_CLOSE,NULL,NULL
        .ELSEIF EAX==IDACB_OVAL_THICK
            INVOKE  IsDlgButtonChecked,hWnd,IDACB_OVAL_THICK
            .IF EAX==BST_CHECKED
                MOV     EBX,TRUE
            .ELSE
				INVOKE	SetDlgItemInt,hWnd,IDET_OVAL_THICK,1,FALSE
                XOR     EBX,EBX
            .ENDIF
            INVOKE  GetDlgItem,hWnd,IDET_OVAL_THICK 
            INVOKE  EnableWindow,EAX,EBX
        .ENDIF
    .ELSE
        XOR     EAX,EAX
        RET
    .ENDIF
    MOV     EAX,TRUE     
    RET
OvalDlgProc   ENDP

_SearchGraph	PROC	hWnd:HWND			;RETURN ESI, OFFSET IN SET
	MOV		ECX,GraphNum
	XOR		ESI,ESI
	MOV		EAX,hWnd
SEARCHLOOP:
	CMP		Pixelgraphs[ESI].WinInfo.hWnd,EAX
	JZ		FOUND
	ADD		ESI,SIZEOF PIXELGRAPH
	LOOP	SEARCHLOOP
	INVOKE	MessageBox,NULL,ADDR MsgBoxTextNotFoundError,ADDR MsgBoxName,MB_OK
	XOR		ESI,ESI
FOUND:
	RET
_SearchGraph	ENDP

END START;结束
