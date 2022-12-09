#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fENDCLI   ºAutor  ³Marcelo Cordeiro    º Data ³  01/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao usada no arquivo de configuracao CNAB MOD2 CEF      º±±
±±º          ³ trata os campos ENDERECO, BAIRRO, CID, EST e CEP           º±±
±±º          ³ retornando "dados endereco cobranca" ou "endereco normal"  º±±
±±º          ³                                                            º±±
±±º          ³ Funcao eh executada no arquivo de configuracao, onde eh    º±±
±±º          ³ passado parametro de acordo com campo que deseja retornar  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION fENDCLI(cCAMPO) 
LOCAL lENDCOB := .T.
LOCAL cRET    := ""
  
IF EMPTY(SA1->A1_ENDCOB)  .OR. ;
   EMPTY(SA1->A1_BAIRROC) .OR. ;
   EMPTY(SA1->A1_CEPC)    .OR. ;
   EMPTY(SA1->A1_MUNC)    .OR. ;
   EMPTY(SA1->A1_ESTC)
   lENDCOB := .F.
ENDIF

IF lENDCOB
   IF cCAMPO="ENDERECO"
      cRET := PADR(ALLTRIM(SA1->A1_ENDCOB),40)
   ELSEIF cCAMPO="BAIRRO"
      cRET := PADR(ALLTRIM(SA1->A1_BAIRROC),40)	  
   ELSEIF cCAMPO="CEP"
      cRET := PADR(ALLTRIM(SUBSTR(SA1->A1_CEPC,1,5)),5,'0')
   ELSEIF cCAMPO="SUFIXO"
      cRET := PADR(ALLTRIM(SUBSTR(SA1->A1_CEPC,6)),3,'0')
   ELSEIF cCAMPO="MUNICIPIO"
      cRET := PADR(SA1->A1_MUNC,15," ")
   ELSEIF cCAMPO="ESTADO"
      cRET := LEFT(SA1->A1_ESTC,2)
   ENDIF
ELSE
   IF cCAMPO="ENDERECO"
      cRET := PADR(ALLTRIM(SA1->A1_END),40)
   ELSEIF cCAMPO="BAIRRO"
      cRET := PADR(ALLTRIM(SA1->A1_BAIRRO),40)	  
   ELSEIF cCAMPO="CEP"
      cRET := PADR(ALLTRIM(SUBSTR(SA1->A1_CEP,1,5)),5,'0')
   ELSEIF cCAMPO="SUFIXO"
      cRET := PADR(ALLTRIM(SUBSTR(SA1->A1_CEP,6)),3,'0')
   ELSEIF cCAMPO="MUNICIPIO"
      cRET := PADR(SA1->A1_MUN,15," ")
   ELSEIF cCAMPO="ESTADO"
      cRET := LEFT(SA1->A1_EST,2)
   ENDIF
ENDIF

cRET := LIMPA(cRET)

RETURN cRET
          
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LIMPA     ºAutor  ³Marcelo Cordeiro    º Data ³  02/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao usada pela fENDCLI, essa remove qualquer caractere  º±±
±±º          ³ que nao fassa parte da lista contida na variavel cLISTA    º±±
±±º          ³                                                            º±±
±±º          ³ CNAB da CEF rejeitou caractere especiais, incluindo ponto  º±±
±±º          ³ e virgula                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION LIMPA(cDADO)             
LOCAL cLISTA := "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
LOCAL cRET   := ""
cDADO := UPPER(ALLTRIM(cDADO))

FOR I:=1 TO LEN(cDADO)
   cATU := SUBSTR(cDADO,I,1)
   IF cATU $ cLISTA
      cRET += cATU
   ELSE
      cRET += " "
   ENDIF
NEXT

RETURN cRET
          
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QTITCALC  ºAutor  ³Marcelo Cordeiro    º Data ³  02/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao usada retornar e gravar no arquivo CNAB a quantidadeº±±
±±º          ³ de titulos no bordero                                      º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION QTITCALC()
LOCAL cQUERY := ""
LOCAL cRET   := ""
cQUERY += "SELECT COUNT(*) QUANT"+CRLF
cQUERY += "  FROM "+RETSQLNAME("SE1")+CRLF
cQUERY += " WHERE D_E_L_E_T_=' '"+CRLF
cQUERY += "   AND E1_NUMBOR='"+MV_PAR01+"'"+CRLF
cQUERY += "   AND E1_FILIAL='"+XFILIAL("SE1")+"'"+CRLF
IF SELECT("TRB") > 0
   TRB->(DBCLOSEAREA())
ENDIF
TCQUERY cQUERY NEW ALIAS "TRB"
cRET := STRZERO(TRB->QUANT,6)
TRB->(DBCLOSEAREA())
RETURN cRET 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VTITCALC  ºAutor  ³Marcelo Cordeiro    º Data ³  02/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao usada retornar e gravar no arquivo CNAB a soma      º±±
±±º          ³ do E1_SALDO de todos titulos do bordero                    º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION VTITCALC()
LOCAL cQUERY := ""
LOCAL cRET   := ""
cQUERY += "SELECT SUM(E1_SALDO) VALOR"+CRLF
cQUERY += "  FROM "+RETSQLNAME("SE1")+CRLF
cQUERY += " WHERE D_E_L_E_T_=' '"+CRLF
cQUERY += "   AND E1_NUMBOR='"+MV_PAR01+"'"+CRLF
cQUERY += "   AND E1_FILIAL='"+XFILIAL("SE1")+"'"+CRLF
IF SELECT("TRB") > 0
   TRB->(DBCLOSEAREA())
ENDIF
TCQUERY cQUERY NEW ALIAS "TRB"
cRET := STRZERO(TRB->VALOR*100,15)
TRB->(DBCLOSEAREA())
RETURN cRET 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SLTSEQ    ºAutor  ³Marcelo Cordeiro    º Data ³  02/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao usada para criar e atualiar a variavel nSLTSEQ, essaº±±
±±º          ³ que grava a sequencai de registros dentro do arquivo CNAB  º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION SLTSEQ(X)
PUBLIC nSLTSEQ := IF( TYPE("nSLTSEQ")="U",0,nSLTSEQ)
nSLTSEQ ++
RETURN nSLTSEQ

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FIN150_3  ºAutor  ³Marcelo Cordeiro    º Data ³  06/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ P.E. executado no final da geracao do arquivo, esse ira    º±±
±±º          ³ zerar a variavel nSLTSEQ, quando usuario gera outro arq    º±±
±±º          ³ na a sequencia era mantiva, danificando o prox arquivo     º±±
±±º          ³ gerado                                                     º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION FIN150_3()
nSLTSEQ := 0
RETURN

        
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ DESC1    ºAutor  ³Marcelo Cordeiro    º Data ³  16/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION DESC1( cTIPO )
LOCAL cRET

IF cTIPO=="CODIGO"
	cRET = "0"
ELSEIF cTIPO=="DATA"
	cRET = REPLICATE("0",8)
ELSEIF cTIPO=="VALOR"
	cRET = REPLICATE("0",15)
ENDIF
	
IF SE1->E1_DECRESC <> 0
	IF cTIPO=="CODIGO"
		cRET = "1" // valor fixo ate a data informada
	ELSEIF cTIPO=="DATA"
		cRET = GRAVADATA(SE1->E1_VENCTO,.F.,5)
	ELSEIF cTIPO=="VALOR"
		cRET = STRZERO(SE1->E1_DECRESC*100,15)
	ENDIF
ENDIF

RETURN cRET
    