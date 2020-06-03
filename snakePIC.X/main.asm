;*******************************************************************************
;                                                                              *
;    Filename: Snake PIC                                                       *
;    Date: 27/maio/2020 - 10/junho/2020                                        *
;    File Version: 1.0.0                                                       *
;    Author: Lucas Rezende , Riccardo Cafagna                                  *
;    Company: Senai Cimatec                                                    *
;    Description: Por meio das teclas 2, 4, 6 e 8 do teclado matricial,        *
;    controle uma cobrinha que passeia pelos 4 displays de 7 segmentos         *
;                                                                              *
;*******************************************************************************

#include    "p16f877a.inc"
    
;*******************************************************************************
; Configuration Word Setup
;*******************************************************************************
    
 __CONFIG _FOSC_HS & _WDTE_OFF & _PWRTE_OFF & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _WRT_OFF & _CP_OFF

    
;*******************************************************************************
; Variable Definitions
;*******************************************************************************

DSP1E	EQU	B'00100000'
DSP2E	EQU	B'00010000'
DSP3E	EQU	B'00001000'
DSP4E	EQU	B'00000100'
	
UDIR	EQU	D'0'
DDIR	EQU	D'1'
RDIR	EQU	D'2'
LDIR	EQU	D'3'
	
VER	EQU	D'0'
HOR	EQU	D'1'
	
_N	EQU	D'0'
_NE	EQU	D'1'
_SE	EQU	D'2'
_S	EQU	D'3'
_SW	EQU	D'4'
_NW	EQU	D'5'
_C	EQU	D'6'
_DOT	EQU	D'7'
 
GPR_VAR	UDATA
DSP1	RES	1
DSP2	RES	1
DSP3	RES	1
DSP4	RES	1
DSPIT	RES	1
KBRDIT	RES	1
_1MS	RES	1
SNKPOS	RES	1
SNKDSP	RES	1
DIR	RES	1
HEAD	RES	1
VALUE	RES	1
	
;*******************************************************************************
; Reset Vector
;*******************************************************************************

RES_VECT  CODE    0x0000
    GOTO    START

;*******************************************************************************
; Interrupt Service Routines
;*******************************************************************************

ISR       CODE    0x0004
    RETFIE

;*******************************************************************************
; Functions
;*******************************************************************************
    
BANK0	MACRO ; 00
    BCF	    STATUS, RP1
    BCF	    STATUS, RP0
    ENDM
    
BANK1	MACRO ; 01
    BCF	    STATUS, RP1
    BSF	    STATUS, RP0
    ENDM
    
BANK2	MACRO ; 10
    BSF	    STATUS, RP1
    BCF	    STATUS, RP0
    ENDM
    
BANK3	MACRO ; 11
    BSF	    STATUS, RP1
    BSF	    STATUS, RP0
    ENDM
    
SNK_RST MACRO
    ;MOVLW   B'00000000'
    ;MOVWF   SNKPOS
    CLRF    SNKPOS
    BSF	    SNKPOS, _C
    MOVLW   DSP3E
    MOVWF   SNKDSP
    BCF	    HEAD, HOR
    BSF	    HEAD, VER
    ENDM

SET_VALUE MACRO POS
    CLRF    VALUE
    BSF	    VALUE, POS
    ENDM
;*******************************************************************************

UP_MANAGER
    CLRF    VALUE
    
    BTFSC   SNKPOS, _N
    GOTO    KBRD_LOOP
    BTFSC   SNKPOS, _NE
    GOTO    KBRD_LOOP
    BTFSC   SNKPOS, _SE
    GOTO    UP_SE
    BTFSC   SNKPOS, _S
    GOTO    UP_S
    BTFSC   SNKPOS, _SW
    GOTO    UP_SW
    BTFSC   SNKPOS, _NW
    GOTO    KBRD_LOOP
    BTFSC   SNKPOS, _C
    GOTO    UP_C
END_UP
    BSF	    HEAD, VER
    MOVFW   VALUE
    MOVWF   SNKPOS
    RETURN

UP_SE	    ; quer ir p cima, estando em sudeste (OK)
    BTFSC   HEAD, VER	; se olha p cima
    BSF	    VALUE, _NE	; vai p nordeste
    BTFSS   HEAD, VER	; se olha p baixo
    GOTO    KBRD_LOOP	; n se move
    GOTO    END_UP
UP_S	    ; quer ir p cima, estando em sul (OK)
    BTFSC   HEAD, HOR	; se olha p direita
    BSF	    VALUE, _SE	; vai p sudeste
    BTFSS   HEAD, HOR	; se olha p esquerda
    BSF	    VALUE, _SW	; vai p sudoeste
    GOTO    END_UP
UP_SW	    ; quer ir p cima, estando em sudoeste (OK)
    BTFSC   HEAD, VER	; se olha p cima
    BSF	    VALUE, _NW	; vai p noroeste
    BTFSS   HEAD, VER	; se olha p baixo
    GOTO    KBRD_LOOP	; n se move
    GOTO    END_UP
UP_C	    ; quer ir p cima, estando em centro (OK)
    BTFSC   HEAD, HOR	; se olha p direita
    BSF	    VALUE, _NE	; vai p nordeste
    BTFSS   HEAD, HOR	; se olha p esquerda
    BSF	    VALUE, _NW	; vai p noroeste
    GOTO    END_UP
 
DOWN_MANAGER
    CLRF    VALUE
    
    BTFSC   SNKPOS, _N
    GOTO    DOWN_N
    BTFSC   SNKPOS, _NE
    GOTO    DOWN_NE
    BTFSC   SNKPOS, _SE
    GOTO    KBRD_LOOP
    BTFSC   SNKPOS, _S
    GOTO    KBRD_LOOP
    BTFSC   SNKPOS, _SW
    GOTO    KBRD_LOOP
    BTFSC   SNKPOS, _NW
    GOTO    DOWN_NW
    BTFSC   SNKPOS, _C
    GOTO    DOWN_C
END_DOWN
    BCF	    HEAD, VER
    MOVFW   VALUE
    MOVWF   SNKPOS
    RETURN

DOWN_N	    ; quer ir p baixo, estando em norte
    BTFSC   HEAD, HOR	; se olha p direita
    BSF	    VALUE, _NE	; vai p nordeste
    BTFSS   HEAD, HOR	; se olha p esquerda
    BSF	    VALUE, _NW	; vai p noroeste
    GOTO    END_DOWN
DOWN_NE	    ; quer ir p baixo, estando em nordeste
    BTFSC   HEAD, VER	; se olha p cima
    GOTO    KBRD_LOOP	; n se move
    BTFSS   HEAD, VER	; se olha p baixo
    BSF	    VALUE, _SE	; vai p sudeste
    GOTO    END_DOWN
DOWN_NW	    ; quer ir p baixo, estando em noroeste
    BTFSC   HEAD, VER	; se olha p cima
    GOTO    KBRD_LOOP	; n se move
    BTFSS   HEAD, VER	; se olha p baixo
    BSF	    VALUE, _SW	; vai p sudoeste
    GOTO    END_DOWN
DOWN_C	    ; quer ir p baixo, estando em centro
    BTFSC   HEAD, HOR	; se olha p direita
    BSF	    VALUE, _SE	; vai p sudeste
    BTFSS   HEAD, HOR	; se olha p esquerda
    BSF	    VALUE, _SW	; vai p sudoeste
    GOTO    END_DOWN

RIGHT_MANAGER
    CLRF    VALUE
    
    BTFSC   SNKPOS, _N
    GOTO    JUST_RIGHT
    BTFSC   SNKPOS, _NE
    GOTO    RIGHT_NE
    BTFSC   SNKPOS, _SE
    GOTO    RIGHT_SE
    BTFSC   SNKPOS, _S
    GOTO    JUST_RIGHT
    BTFSC   SNKPOS, _SW
    GOTO    RIGHT_SW
    BTFSC   SNKPOS, _NW
    GOTO    RIGHT_NW
    BTFSC   SNKPOS, _C
    GOTO    JUST_RIGHT
END_RIGHT
    BSF	    HEAD, HOR
    MOVFW   VALUE
    MOVWF   SNKPOS
    RETURN

RR_DSP	    ; vai p display a direita
    BTFSS   HEAD, HOR	; se olha p esquerda
    RETURN		; n se move
    BTFSC   SNKDSP, 5
    MOVLW   DSP4E
    BTFSS   SNKDSP, 5
    RLF	    SNKDSP, W
    MOVWF   SNKDSP
    GOTO    END_RIGHT

RIGHT_NE    ; quer ir p direita, estando em nordeste
    BTFSC   HEAD, VER	; se olha p cima
    BSF	    VALUE, _N	; vai p norte
    BTFSS   HEAD, VER	; se olha p baixo
    BSF	    VALUE, _C	; vai p centro
    GOTO    RR_DSP	; vai p display a direita
RIGHT_SE    ; quer ir p direita, estando em sudeste
    BTFSC   HEAD, VER	; se olha p cima
    BSF	    VALUE, _C	; vai p centro
    BTFSS   HEAD, VER	; se olha p baixo
    BSF	    VALUE, _S	; vai p sul
    GOTO    RR_DSP	; vai p display a direita
RIGHT_SW    ; quer ir p direita, estando em sudoeste
    BTFSC   HEAD, VER	; se olha p cima
    BSF	    VALUE, _C	; vai p centro
    BTFSS   HEAD, VER	; se olha p baixo
    BSF	    VALUE, _S	; vai p sul
    GOTO    END_RIGHT
RIGHT_NW    ; quer ir p direita, estando em noroeste
    BTFSC   HEAD, VER	; se olha p cima
    BSF	    VALUE, _N	; vai p norte
    BTFSS   HEAD, VER	; se olha p baixo
    BSF	    VALUE, _C	; vai p centro
    GOTO    END_RIGHT
JUST_RIGHT
    MOVFW   SNKPOS
    MOVWF   VALUE
    GOTO    RR_DSP

LEFT_MANAGER
    CLRF   VALUE
    
    BTFSC   SNKPOS, _N
    GOTO    JUST_LEFT
    BTFSC   SNKPOS, _NE
    GOTO    LEFT_NE
    BTFSC   SNKPOS, _SE
    GOTO    LEFT_SE
    BTFSC   SNKPOS, _S
    GOTO    JUST_LEFT
    BTFSC   SNKPOS, _SW
    GOTO    LEFT_SW
    BTFSC   SNKPOS, _NW
    GOTO    LEFT_NW
    BTFSC   SNKPOS, _C
    GOTO    JUST_LEFT
END_LEFT
    BCF	    HEAD, HOR
    MOVFW   VALUE
    MOVWF   SNKPOS
    RETURN

RL_DSP	    ; vai p display a esquerda
    BTFSC   HEAD, HOR	; se olha p direita
    RETURN		; n se move
    BTFSC   SNKDSP, 2
    MOVLW   DSP1E
    BTFSS   SNKDSP, 2
    RRF	    SNKDSP, W
    MOVWF   SNKDSP
    GOTO    END_LEFT

LEFT_NE    ; quer ir p esquerda, estando em nordeste
    BTFSC   HEAD, VER	; se olha p cima
    BSF	    VALUE, _N	; vai p norte
    BTFSS   HEAD, VER	; se olha p baixo
    BSF	    VALUE, _C	; vai p centro
    GOTO    END_LEFT
LEFT_SE    ; quer ir p esquerda, estando em sudeste
    BTFSC   HEAD, VER	; se olha p cima
    BSF	    VALUE, _C	; vai p centro
    BTFSS   HEAD, VER	; se olha p baixo
    BSF	    VALUE, _S	; vai p sul
    GOTO    END_LEFT
LEFT_SW    ; quer ir p esquerda, estando em sudoeste
    BTFSC   HEAD, VER	; se olha p cima
    BSF	    VALUE, _C	; vai p centro
    BTFSS   HEAD, VER	; se olha p baixo
    BSF	    VALUE, _S	; vai p sul
    GOTO    RL_DSP	; vai p display a esquerda
LEFT_NW    ; quer ir p esquerda, estando em noroeste
    BTFSC   HEAD, VER	; se olha p cima
    BSF	    VALUE, _N	; vai p norte
    BTFSS   HEAD, VER	; se olha p baixo
    BSF	    VALUE, _C	; vai p centro
    GOTO    RL_DSP	; vai p display a esquerda
JUST_LEFT
    MOVFW   SNKPOS
    MOVWF   VALUE
    GOTO    RL_DSP
    
SNKMOV
    ; UP
    BTFSC   DIR, UDIR
    CALL    UP_MANAGER
    
    ; DOWN
    BTFSC   DIR, DDIR
    CALL    DOWN_MANAGER
    
    ; RIGHT
    BTFSC   DIR, RDIR
    CALL    RIGHT_MANAGER
    
    ; LEFT
    BTFSC   DIR, LDIR
    CALL    LEFT_MANAGER

    MOVFW   SNKPOS
    
    CLRF    DSP1
    CLRF    DSP2
    CLRF    DSP3
    CLRF    DSP4
    
    BTFSC   SNKDSP, 5
    MOVWF   DSP1
    
    BTFSC   SNKDSP, 4
    MOVWF   DSP2
    
    BTFSC   SNKDSP, 3
    MOVWF   DSP3
    
    BTFSC   SNKDSP, 2
    MOVWF   DSP4
    
    RETURN
    
DISPLAY
    BANK1
    CLRF    TRISA
    CLRF    TRISD
    BANK0
    
    MOVLW   DSP1E
    MOVWF   PORTA
    MOVFW   DSP1
    MOVWF   PORTD
    CALL    DELAY_2MS
    
    MOVLW   DSP2E
    MOVWF   PORTA
    MOVFW   DSP2
    MOVWF   PORTD
    CALL    DELAY_2MS
    
    MOVLW   DSP3E
    MOVWF   PORTA
    MOVFW   DSP3
    MOVWF   PORTD
    CALL    DELAY_2MS
    
    MOVLW   DSP4E
    MOVWF   PORTA
    MOVFW   DSP4
    MOVWF   PORTD
    CALL    DELAY_2MS
    RETURN
    
KBRD_READ
    CALL    KBRD_CONFIG
    
    BCF	    PORTB, RB0
    CALL    DELAY_2MS
    BTFSS   TRISD, RD2	; left
    CALL    PRESS_LEFT
    CALL    DELAY_2MS
    BSF	    PORTB, RB0
    CALL    DELAY_2MS
    
    BCF	    PORTB, RB1
    CALL    DELAY_2MS
    BTFSS   TRISD, RD1	; down
    CALL    PRESS_DOWN
    CALL    DELAY_2MS
    BTFSS   TRISD, RD3	; up
    CALL    PRESS_UP
    BSF	    PORTB, RB1
    CALL    DELAY_2MS
    
    BCF	    PORTB, RB2
    CALL    DELAY_2MS
    BTFSS   TRISD, RD2	; right
    CALL    PRESS_RIGHT
    BSF	    PORTB, RB2
    CALL    DELAY_2MS
    RETURN

PRESS_UP
    CLRF    DIR
    BSF	    DIR, UDIR
    CALL    SNKMOV
    RETURN
PRESS_DOWN
    CLRF    DIR
    BSF	    DIR, DDIR
    CALL    SNKMOV
    RETURN
PRESS_RIGHT
    CLRF    DIR
    BSF	    DIR, RDIR
    CALL    SNKMOV
    RETURN
PRESS_LEFT
    CLRF    DIR
    BSF	    DIR, LDIR
    CALL    SNKMOV
    RETURN
    
KBRD_CONFIG
    BANK1
    CLRF    TRISB
    MOVLW   B'00001111'
    MOVWF   TRISD
    MOVLW   B'00001111'
    MOVWF   TRISA
    BANK0
    RETURN
    
DELAY_2MS
    CALL    DELAY_1MS
    CALL    DELAY_1MS
    RETURN
DELAY_1MS
    MOVLW   D'165'
    MOVWF   _1MS
DELAY_LOOP
    DECFSZ  _1MS, 1
    GOTO    DELAY_LOOP
    RETURN
    
;*******************************************************************************
; MAIN PROGRAM
;*******************************************************************************

MAIN_PROG CODE

START
    SNK_RST
    
    CLRF    DSP1
    CLRF    DSP2
    CLRF    DSP3
    CLRF    DSP4
    
    MOVFW   SNKPOS
    
    BTFSC   SNKDSP, 5
    MOVWF   DSP1
    
    BTFSC   SNKDSP, 4
    MOVWF   DSP2
    
    BTFSC   SNKDSP, 3
    MOVWF   DSP3
    
    BTFSC   SNKDSP, 2
    MOVWF   DSP4
    
    MOVLW   D'1'
    MOVWF   KBRDIT
    MOVLW   D'16'
    MOVWF   DSPIT
 
KBRD_LOOP
    CALL    KBRD_READ
    DECFSZ  KBRDIT
    GOTO    KBRD_LOOP
    MOVLW   D'1'
    MOVWF   KBRDIT
    GOTO    DSP_LOOP
    
DSP_LOOP
    CALL    DISPLAY
    DECFSZ  DSPIT
    GOTO    DSP_LOOP
    MOVLW   D'16'
    MOVWF   DSPIT
    GOTO    KBRD_LOOP
    
    END