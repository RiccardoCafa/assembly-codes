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
#include    "snake_pic.inc"
;*******************************************************************************
; Configuration Word Setup
;*******************************************************************************
    
 __CONFIG _FOSC_HS & _WDTE_OFF & _PWRTE_OFF & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _WRT_OFF & _CP_OFF

    
;*******************************************************************************
; Variable Definitions
;*******************************************************************************

GPR_VAR	    UDATA
SNKDSP1	    RES	    1
SNKDSP2	    RES	    1
SNKDSP3	    RES	    1
SNKDSP4	    RES	    1
DSPIT	    RES	    1
KBRDIT	    RES	    1
_1MS	    RES	    1
_SNKPOS	    RES	    1
_SNKDIS	    RES	    1
_DIR	    RES	    1

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
    
SET_PORTD MACRO VALUE
    MOVFW VALUE
    MOVWF PORTD
    ENDM
    
SNAKE_RESET MACRO
    MOVLW B'00000010'
    MOVWF _SNKPOS
    MOVLW B'00000100'
    MOVWF _SNKDIS
    ENDM
    
SNAKE_GO_DIS4 MACRO
    MOVLW B'00001000'
    MOVWF _SNKDIS
    ENDM
SNAKE_GO_DIS3 MACRO
    MOVLW B'00000100'
    MOVWF _SNKDIS
    ENDM
SNAKE_GO_DIS2 MACRO
    MOVLW B'00000010'
    MOVWF _SNKDIS
    ENDM
SNAKE_GO_DIS1 MACRO
    MOVLW B'00000001'
    MOVWF _SNKDIS
    ENDM
    
UP_MANAGER
    
    BTFSC _SNKPOS, 0 ; A
    GOTO KBRD_LOOP ; NAO DA PRA IR PRA CIMA
    BTFSC _SNKPOS, 1 ; B
    MOVLW B'00000001'
    BTFSC _SNKPOS, 2 ; C
    MOVLW B'00000010'
    BTFSC _SNKPOS, 3 ; D
    MOVLW B'00010000'
    BTFSC _SNKPOS, 4 ; E
    MOVLW B'00100000'
    BTFSC _SNKPOS, 5 ; F
    MOVLW B'00000001'
    BTFSC _SNKPOS, 6 ; G
    MOVLW B'00000010'
    
    MOVWF _SNKPOS
    RETURN
    
DOWN_MANAGER
    BTFSC _SNKPOS, 0 ; A
    MOVLW B'00000010'
    BTFSC _SNKPOS, 1 ; B 
    MOVLW B'00000100'
    BTFSC _SNKPOS, 2 ; C
    MOVLW B'00001000'
    BTFSC _SNKPOS, 3 ; D 
    GOTO KBRD_LOOP ; NAO DA PRA IR BAIXO
    BTFSC _SNKPOS, 4 ; E
    MOVLW B'00001000'
    BTFSC _SNKPOS, 5 ; F
    MOVLW B'00010000'
    BTFSC _SNKPOS, 6 ; G
    MOVLW B'00000100'
    
    MOVWF _SNKPOS
    RETURN
    
LEFT_MANAGER
    BTFSC _SNKPOS, 0 ; A
    GOTO LEFT_MANAGER_DIS
    BTFSC _SNKPOS, 1 ; B 
    MOVLW B'01000000'
    BTFSC _SNKPOS, 2 ; C
    MOVLW B'00001000'
    BTFSC _SNKPOS, 3 ; D 
    GOTO LEFT_MANAGER_DIS
    BTFSC _SNKPOS, 4 ; E
    GOTO LEFT_MANAGER_DIS
    BTFSC _SNKPOS, 5 ; F
    GOTO LEFT_MANAGER_DIS
    BTFSC _SNKPOS, 6 ; G
    GOTO LEFT_MANAGER_DIS
    
    MOVWF _SNKPOS
    RETURN
    
LEFT_MANAGER_DIS
    BTFSC _SNKDIS, 3
    GOTO KBRD_LOOP
    
    RLF _SNKDIS, 1
    
    BTFSC _SNKPOS, 0 ; A
    RETURN
    BTFSC _SNKPOS, 3 ; D
    RETURN
    BTFSC _SNKPOS, 4 ; E
    MOVLW B'00001000'
    BTFSC _SNKPOS, 5 ; F
    MOVLW B'01000000'
    BTFSC _SNKPOS, 6 ; G
    RETURN
    
    MOVWF _SNKPOS
    
    RETURN
    
RIGHT_MANAGER
    BTFSC _SNKPOS, 0 ; A
    GOTO RIGHT_MANAGER_DIS
    BTFSC _SNKPOS, 1 ; B 
    GOTO RIGHT_MANAGER_DIS
    BTFSC _SNKPOS, 2 ; C
    GOTO RIGHT_MANAGER_DIS
    BTFSC _SNKPOS, 3 ; D 
    GOTO RIGHT_MANAGER_DIS
    BTFSC _SNKPOS, 4 ; E
    MOVLW B'00001000'
    BTFSC _SNKPOS, 5 ; F
    MOVLW B'01000000'
    BTFSC _SNKPOS, 6 ; G
    GOTO RIGHT_MANAGER_DIS
    
    MOVWF _SNKPOS
    RETURN
    
RIGHT_MANAGER_DIS
    BTFSC _SNKDIS, 0
    GOTO KBRD_LOOP
    
    RRF _SNKDIS, 1
    
    BTFSC _SNKPOS, 0 ; A
    RETURN
    BTFSC _SNKPOS, 1 ; B 
    MOVLW B'01000000'
    BTFSC _SNKPOS, 2 ; C
    MOVLW B'00001000'
    BTFSC _SNKPOS, 3 ; D 
    RETURN
    BTFSC _SNKPOS, 6 ; G
    RETURN
    
    MOVWF _SNKPOS
    
    RETURN
    
SNAKE_MOVE
    
    ; QUAL DIRECAO ELE TA QUERENDO IR
    ; CHECAR ONDE ELE ESTÁ
	; VERIFICAR SE É POSSIVEL
	    ; CASO SIM, MOVER
	    ; CASO NAO, RETORNE
    
    ; UP
    BTFSC _DIR, 0
    CALL UP_MANAGER
    
    ; DOWN
    BTFSC _DIR, 1
    CALL DOWN_MANAGER
    
    ; RIGHT
    BTFSC _DIR, 2
    CALL RIGHT_MANAGER
    
    ; LEFT
    BTFSC _DIR, 3
    CALL LEFT_MANAGER

    MOVFW _SNKPOS
    
    CLRF SNKDSP1
    CLRF SNKDSP2
    CLRF SNKDSP3
    CLRF SNKDSP4
    
    BTFSC _SNKDIS, 0
    MOVWF SNKDSP1
    
    BTFSC _SNKDIS, 1
    MOVWF SNKDSP2
    
    BTFSC _SNKDIS, 2
    MOVWF SNKDSP3
    
    BTFSC _SNKDIS, 3
    MOVWF SNKDSP4
    
    RETURN
    
DISPLAY
    BANK1
    CLRF    TRISA
    CLRF    TRISD
    BANK0
    
    MOVLW   DSP1E
    MOVWF   PORTA
    MOVFW   SNKDSP1
    MOVWF   PORTD
    CALL    DELAY_2MS
    
    MOVLW   DSP2E
    MOVWF   PORTA
    MOVFW   SNKDSP2
    MOVWF   PORTD
    CALL    DELAY_2MS
    
    MOVLW   DSP3E
    MOVWF   PORTA
    MOVFW   SNKDSP3
    MOVWF   PORTD
    CALL    DELAY_2MS
    
    MOVLW   DSP4E
    MOVWF   PORTA
    SET_PORTD   SNKDSP4
    CALL    DELAY_2MS
    
    
    RETURN
    ;     RB0 RB1 RB2
    ; RD3  1   2   3
    ; RD2  4   5   6
    ; RD1  7   8   9
    ; RD0  *   0   #
KBRD_READ
    CALL    KBRD_CONFIG
    
    BCF	    PORTB, RB0
    CALL    DELAY_2MS
    BTFSS   TRISD, RD2	; left
    CALL    LEFT
    CALL    DELAY_2MS
    BSF	    PORTB, RB0
    CALL    DELAY_2MS
    
    BCF	    PORTB, RB1
    CALL    DELAY_2MS
    BTFSS   TRISD, RD1	; down
    CALL    DOWN
    CALL    DELAY_2MS
    BTFSS   TRISD, RD3	; up
    CALL    UP
    BSF	    PORTB, RB1
    CALL    DELAY_2MS
    
    BCF	    PORTB, RB2
    CALL    DELAY_2MS
    BTFSS   TRISD, RD2	; right
    CALL    RIGHT
    BSF	    PORTB, RB2
    CALL    DELAY_2MS
    RETURN

UP
    MOVLW B'00000001'
    MOVWF _DIR
    CALL SNAKE_MOVE
    RETURN
    
DOWN
    MOVLW B'00000010'
    MOVWF _DIR
    CALL SNAKE_MOVE
    RETURN
    
RIGHT
    MOVLW B'00000100'
    MOVWF _DIR
    CALL SNAKE_MOVE
    RETURN
    
LEFT
    MOVLW B'00001000'
    MOVWF _DIR
    CALL SNAKE_MOVE
    RETURN
    
KBRD_CONFIG
    BANK1
    CLRF TRISB
    MOVLW B'00001111'
    MOVWF TRISD
    MOVLW B'00001111'
    MOVWF TRISA
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
    
    SNAKE_RESET
    
    CLRF    SNKDSP1
    CLRF    SNKDSP2
    CLRF    SNKDSP3
    CLRF    SNKDSP4
    
    MOVFW   _SNKPOS
    MOVWF   SNKDSP3
    
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
