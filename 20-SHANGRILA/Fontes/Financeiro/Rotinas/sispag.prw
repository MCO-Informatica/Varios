#INCLUDE "RWMAKE.CH"
//
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSISPAG    บAutor  ณWelington           บ Data ณ  04/12/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcoes utilizadas para o sispag                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function SISP003()    
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ SISP003  ณ Autor ณ Alexandre da Silva    ณ Data ณ 06/01/00 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ ExecBlock disparado do 341REM.PAG para retornar vencimento ณฑฑ
ฑฑณ          ณ do codigo de barras.                                       ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
*/

If     Len(Alltrim(SE2->E2_CODBAR)) == 44      
	_cRetSisp3 := Substr(SE2->E2_CODBAR,6,4)
ElseIf Len(Alltrim(SE2->E2_CODBAR)) == 47
	_cRetSisp3 := Substr(SE2->E2_CODBAR,34,4)
ElseIf Len(Alltrim(SE2->E2_CODBAR)) >= 36 .and. Len(Alltrim(SE2->E2_CODBAR)) <= 43
        _cRetSisp3 := "0000"
Else
        _cRetSisp3 := "0000"                         
EndIf	

_cRetSisp3 := Strzero(Val(_cRetSisp3),4)

Return(_cRetSisp3)


User Function SISP001()
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ SISP001  ณ Autor ณ Alexandre da Silva    ณ Data ณ 01/09/00 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ ExecBlock disparado do 341REM.PAG para retornar agencia e  ณฑฑ
ฑฑณ          ณ conta do fornecedor.                                       ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
IF AT("-",SE2->E2_CONTACC) == 0 
	_cReturn :=StrZero(Val(Alltrim(SE2->E2_AGENCIA)),5)+" "+StrZero(Val(SUBS(SE2->E2_CONTACC,1,Len(Alltrim(SE2->E2_CONTACC))-1)),12)
Else
	_cReturn :=StrZero(Val(Alltrim(SE2->E2_AGENCIA)),5)+" "+StrZero(Val(SUBS(SE2->E2_CONTACC,1,AT("-",SE2->E2_CONTACC)-1)),12)
Endif

Return(_cReturn)

User Function SISP002()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma  ณ SISP002  ณ Autor ณ Alexandre da Silva    ณ Data ณ 01/09/00 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ ExecBlock disparado do 341REM.PAG para retornar digito     ณฑฑ
ฑฑณ          ณ da conta corrente do fornecedor.                           ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ SISPAG                                                     ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
IF AT("-",SE2->E2_CONTACC) == 0 
	_cReturn2 :=SUBS(Alltrim(SE2->E2_CONTACC),-1)
Else
	_cReturn2 :=SUBS(SE2->E2_CONTACC,AT("-",SE2->E2_CONTACC)+1,1)
Endif

Return(_cReturn2)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF240TBOR  บAutor  ณWelington           บ Data ณ  04/12/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada que solicita os dados complemetares para บฑฑ
ฑฑบ          ณ pagamento do bordero ( IPTE, Banco, Agencia, Conta )       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

USER FUNCTION F240TBOR()

cCodBar := SE2->E2_CODBAR
cCodBarM:= SE2->E2_CODBAR
//cBanco  := SE2->E2_CODBCO
//cAgencia:= SE2->E2_AGENCIA
//cContaCC:= SE2->E2_CONTACC

@ 000, 000 TO 300,500  DIALOG oDlg TITLE "Complemento do Titulo"
@ 020, 010 SAY "Fornecedor: " + SE2->E2_FORNECE + "/"+SE2->E2_LOJA+ " - "+SE2->E2_NOMFOR
@ 030, 010 SAY "Titulo: "+ SE2->E2_PREFIXO+" - "+SE2->E2_NUM+" "+SE2->E2_PARCELA
@ 040, 010 SAY "Valor Nominal: "+ TRANSFORM( SE2->E2_VALOR, "@E 9,999,999.99") + "    Valor a Pagar:"+TRANSFORM( SE2->E2_SALDO, "@E 9,999,999.99")
@ 055, 010 SAY "Informacao complementar para pagamento"
IF SEA->EA_MODELO $ "30/31"

    @ 100, 010 SAY "Linha Digitavel"
    @ 110, 010 SAY cCodBar PICTURE "@R 99999.99999_99999.999999_99999.999999_9_999999999999999" 

   @ 070, 010 SAY "Leitor Codigo Barras"
   @ 080, 010 GET cCodBarM PICTURE "@R 9999999999999999999999999999999999999999999999999999999"  SIZE 170,10 

   If Empty(cCodBarM)
    @ 100, 010 SAY "Linha Digitavel"
    @ 110, 010 GET cCodBar PICTURE "@R 99999.99999_99999.999999_99999.999999_9_999999999999999"  SIZE 170,10 
   Endif

       If !Empty(cCodBar) .and. Empty(cCodBarM)
          DAC( cCodBar )
       Endif   

ELSEIF SEA->EA_MODELO $ "13"
   @ 070, 010 SAY "Linha Digitavel Concessionaria"
   @ 080, 010 GET cCodBar PICTURE "@9"  SIZE 170,10 
ELSE
//   @ 070, 010 SAY "Cod. Banco:" 
//   @ 070, 060 GET cBanco     SIZE 30,10
//   @ 080, 010 SAY "Agencia:" 
//   @ 080, 060 GET cAgencia   SIZE 60,10
//   @ 090, 010 SAY "Conta Corr.:"
//   @ 090, 060 GET cContaCC   SIZE 80,10
ENDIF

@ 130, 080 BMPBUTTON TYPE 1 ACTION ( lOk := .T., Close( oDlg ) )
@ 130, 120 BMPBUTTON TYPE 2 ACTION ( lOk := .f., Close( oDlg ) )

ACTIVATE DIALOG oDlg CENTER
   
IF lOk 

   If !Empty(cCodbar)
      cCodBarM := "  "
   Endif   
   
   If !Empty(cCodbarM)
      cCodBar := cCodbarM
   Endif   
   
   RECLOCK("SE2", .F. )
   REPLACE E2_CODBAR  WITH cCodBar

/*If Empty(cBanco)
   REPLACE E2_CODBCO  WITH cport240
   REPLACE E2_AGENCIA WITH cagen240
   REPLACE E2_CONTACC WITH cconta240
Else
   REPLACE E2_CODBCO  WITH cBanco
   REPLACE E2_AGENCIA WITH cAgencia
   REPLACE E2_CONTACC WITH cContaCC
Endif
*/
   MSUNLOCK()
   
ENDIF

RETURN .t.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSISPAG    บAutor  ณWelington           บ Data ณ  04/12/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que faz a validacao dos digitos verificadores da    บฑฑ
ฑฑบ          ณ Linha digitavel                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP5                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/


STATIC FUNCTION DAC( cLinha )
LOCAL lRet := .T., cDac
// VERIFICA PRIMEIRO DAC
cDac := U_DACMOD10( SUBS( cLinha , 1, 9 ) )
IF cDac <> SUBS( cLinha, 10, 1 )
   lRet := .F.
ENDIF

// VERIFICA O SEGUNDO DAC
cDac := U_DACMOD10( SUBS( cLinha , 11, 10 ) )
IF cDac <> SUBS( cLinha, 21, 1 )
   lRet := .F.
ENDIF


// VERIFICA O TERCEIRO DAC
cDac := U_DACMOD10( SUBS( cLinha , 22,10 ) )
IF cDac <> SUBS( cLinha, 32, 1 )
   lRet := .F.
ENDIF


RETURN  lRet        


/********************************************************************
* Funcao ....: DACMOD10
* Comentario.: Faz o Calculo do digito no Modulo 10   
* Data.......: 12/04/02
* Autor......: Welington 
*/
USER FUNCTION DACMOD10( cDado )

aMult := { 2,1,2,1,2,1,2,1,2,1 }

total := 0

FOR F := 1 TO LEN( cDado )

    n  :=  ( aMult[f] * VAL( SUBSTR( cDado, LEN( cDado ) - F+1 , 1) ) )
    IF n >= 10 
       c := ALLTRIM( STR( N ) )
       soma := 0
       FOR G := 1 TO LEN( c )
           soma := soma + VAL( SUBSTR( c,g,1 ) )
       NEXT        
       n := soma
    ENDIF
    
    total := total + N

NEXT

n := INT( total / 10 )
n := ( n+1 )* 10

cDigito := ALLTRIM( STR( N - TOTAL ) )                               

IF cDigito ="10"
   cDigito = "0"
ENDIF

RETURN cDigito

/************************************************************************************
* Verifica a Ocorrencia do Sispag e mostra para o usuario caso esteja rejeitado 
*/
USER FUNCTION FA300OCO()

IF LEFT( cRetorno,2 ) = "RJ"
   // se rejeitado mostrar qual o titulo para o usuario.
   MSGSTOP("TITIULO "+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+ " - "+ALLTRIM(SE2->E2_NOMFOR)+" FOI REJEITADO ! OCORRENCIA:"+cRetorno)
ENDIF

RETURN     