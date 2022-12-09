#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch" 
#INCLUDE "Rwmake.CH" 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³ A415TDOK ³ Ponto de entrada para tratar se tudo esta ok                 º±±
±±º             ³          ³ caso nao exista.                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Solicitante ³ 20.03.07 ³ Robson                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor       ³ 20.03.07 ³ Osmil Squarcine                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Produção    ³ ??.??.?? ³ Ignorado                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Parâmetros  ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno     ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observações ³ 1. VALIDAR NO REGISTRO DE ENTRADA OS VALORES E REGRAS DA NECODIACAO     º±±
±±º             ³    NO ORCAMENTO                                                         º±±
±±º             ³                                                                         º±±
±±º             ³                                                                         º±±
±±º             ³                                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Alterações  ³ ??.??.?? - Nome - Descrição                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A415TDOK()
Local aSaveArea := GetArea()
Local lRetorno := .T.
Local cLoja:=""
Local lConPadOk := .F.
Local nEndereco		:= 0
Local nTotAnt:=0
Local X:=0
Local nTotAtu:=0
Local nSaldo:=0 
Local lMotivo1:=.f.
Local lmotivo2:=.f.
Local lmotivo3:=.f.
// rotina de avaliacao de credito do cliente
Local lPode:=GETMV("MV_BLOVEND")
Local lBarrou:=.F.

//Alteração 10/09/2015 - BZO - Incluso validação da data prevista quando for orçamento de Custo ou Projeto
	If SCJ->(FieldPos("CJ_XDTPREV")) != 0
		If M->CJ_CLASSI $ '1|2'
			If Empty(M->CJ_XDTPREV)
				Aviso(OEMTOANSI("Atenção"),OEMTOANSI("Campo obrigatório [Data Prevista] se encontra em branco. Favor verificar!"),{"Ok"},2)
				Return(.F.)
			EndIf
		EndIF
	EndIf

//EXTRAINDO DO SISTEMA O VALOR ATUAL DO PROCESSO 
dbSelectArea("TMP1")
TMP1->(dbGoTop())
While TMP1->(!Eof())
	if Posicione("SF4",1,xFilial("SF4")+TMP1->CK_TES,"F4_DUPLIC")="S"
      nTotAtu:=nTotAtu+TMP1->CK_VALOR
    ENDIF
	dbSkip()
EndDo
dbgotop()
//EXTRAINDO DO SISTEMA O VALOR ANTERIOR DO PROCESSO
DbSelectArea("SCJ")
dbSetOrder(1)
MsSeek(xfilial("SCJ")+M->CJ_NUM)
if Posicione("SF4",1,xFilial("SF4")+TMP1->CK_TES,"F4_DUPLIC")="S"
  DBSELECTAREA("SA1")
  DBSETORDER(1)
  IF MsSeek(xfilial("SA1")+M->CJ_CLIENTE+M->CJ_LOJA)
    //DESCOBRINDO O LIMITE UTILIZADO
  endif  
endif
// rotina de atualizacao do registro de entrada
DbSelectArea("SZQ")
dbSetOrder(1)
if MsSeek(xfilial("SZQ")+M->CJ_NUM)
RecLock("SZQ",.F.)
SZQ->ZQ_CLIENTE	:=M->CJ_CLIENTE
SZQ->ZQ_LOJA	:=M->CJ_LOJA
SZQ->ZQ_CNPJ	:=SA1->A1_CGC
SZQ->ZQ_NOME	:=SA1->A1_NREDUZ
SZQ->ZQ_REFCLI	:=M->CJ_NUMCOT
SZQ->ZQ_NEGOCIA	:=M->CJ_NOMUSR
SZQ->ZQ_VLALFR	:=NTOTATU
SZQ->ZQ_D_DIGIT :=M->CJ_EMISSAO
if M->CJ_CLASSI="1"
  SZQ->ZQ_TIPO	:="2"
  SZQ->ZQ_STATUS	:="05"
ELSE
  IF M->CJ_CLASSI="2"
    SZQ->ZQ_TIPO	:="3"
    SZQ->ZQ_STATUS	:="05"
    SZQ->ZQ_D_FOLLO :=M->CJ_VALIDA-1
  ELSE
    SZQ->ZQ_TIPO	:="1"
    SZQ->ZQ_STATUS	:="04"
    SZQ->ZQ_D_FOLLO :=M->CJ_VALIDA-1
  ENDIF  
ENDIF
MSUNLOCK()
//U_HCTE004(M->CJ_NUM)
endif
RestArea(aSaveArea)
Return ( lRetorno )
                                   	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³ H415ORC  ³ ALTERACAO EM MASSA DO REGISTRO DE ENTRADA COM BASE NO ORCA   º±±
±±º             ³ H415ATUR ³ MENTO                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Solicitante ³ 20.03.07 ³ Robson                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor       ³ 20.03.07 ³ Robson                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Produção    ³ ??.??.?? ³ Ignorado                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Parâmetros  ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno     ³ Nil                                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observações ³ 1. VALIDAR NO REGISTRO DE ENTRADA OS VALORES E REGRAS DA NECODIACAO     º±±
±±º             ³    NO ORCAMENTO                                                         º±±
±±º             ³                                                                         º±±
±±º             ³                                                                         º±±
±±º             ³                                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Alterações  ³ ??.??.?? - Nome - Descrição                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function HC415ORC()
if MsgYesNo("Esta rotina AJUSTA TODOS OS REGISTROS DE ENTRADA COM BASE NOS ORCAMENTOS EMITIDOS. O processamento e lento. Deseja realmente processar esta rotina?")
  Processa({|| U_H415ATUR()},"Rotina de Arualizacao de Reg Entrada","Atualizando dados, aguarde...")
ENDIF
RETURN


// ROTINA DE ATUALIZACAO DE REGISTROS DE ENTRADA EM MASSA

User Function H415ATUR()

Local lRetorno := .T.
Local cLoja:=""
Local lConPadOk := .F.
Local nEndereco		:= 0
Local nTotAnt:=0
Local X:=0
Local nTotAtu:=0
Local nSaldo:=0 
Local lMotivo1:=.f.
Local lmotivo2:=.f.
Local lmotivo3:=.f.
// rotina de avaliacao de credito do cliente
Local lBarrou:=.F.

if MsgYesNo("Processa ORCAMENTOS EMITIDOS?")
//EXTRAINDO DO SISTEMA O VALOR ATUAL DO PROCESSO 
DbSelectArea("SCJ")
dbSetOrder(1)
ProcRegua(SCJ->(RECCOUNT()))
While SCJ->(!Eof())
  nTotAtu:=0
  dbSelectArea("SCK")
  dbSetOrder(1)
  MsSeek(xfilial("SCJ")+SCJ->CJ_NUM)
  While SCK->(!Eof()) .AND. SCJ->CJ_NUM=SCK->CK_NUM
	if Posicione("SF4",1,xFilial("SF4")+SCK->CK_TES,"F4_DUPLIC")="S"
      nTotAtu:=nTotAtu+SCK->CK_VALOR 
    ENDIF
	dbSelectArea("SCK")
	dbSkip()
  EndDo
  DBSELECTAREA("SA1")
  DBSETORDER(1)
  MsSeek(xfilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA)
   //DESCOBRINDO O LIMITE UTILIZADO
  DbSelectArea("SZQ")
  dbSetOrder(1)
  if MsSeek(xfilial("SZQ")+SCJ->CJ_NUM)
    RecLock("SZQ",.F.)
    SZQ->ZQ_CLIENTE	:=SCJ->CJ_CLIENTE
    SZQ->ZQ_LOJA	:=SCJ->CJ_LOJA
    SZQ->ZQ_CNPJ	:=SA1->A1_CGC
    SZQ->ZQ_NOME	:=SA1->A1_NREDUZ
    SZQ->ZQ_REFCLI	:=SCJ->CJ_NUMCOT
    SZQ->ZQ_NEGOCIA	:=SCJ->CJ_NOMUSR
    SZQ->ZQ_VLALFR	:=NTOTATU
    SZQ->ZQ_D_DIGIT :=SCJ->CJ_EMISSAO
    if SCJ->CJ_CLASSI="1"
    	SZQ->ZQ_TIPO	:="2"
    	SZQ->ZQ_STATUS	:="05"
    ELSE
    	IF SCJ->CJ_CLASSI="2"
        	SZQ->ZQ_TIPO	:="3"
        	SZQ->ZQ_STATUS	:="05"
        	SZQ->ZQ_D_FOLLO :=SCJ->CJ_VALIDA-1
  	    ELSE
   	        SZQ->ZQ_TIPO	:="1"
        	SZQ->ZQ_STATUS	:="04"
        	SZQ->ZQ_D_FOLLO :=SCJ->CJ_VALIDA-1
        ENDIF  
    ENDIF
    MSUNLOCK()
    //Aviso("Arquivo Atualizado","O pedido <<<" + SCJ->CJ_NUM + ">>>, foi atualizado com sucesso",{"Ok"},,"Ajustes Comerciais")
  endif
  DbSelectArea("SCJ")
  incPROC("Atualizando Orc. n.:"+SCJ->CJ_NUM)
  INCPROC()
  dbSkip()
ENDDO                         
endif
//ATUALIZANDO TODOS OS PEDIDOS
if MsgYesNo("Processa PEDIDOS EMITIDOS?")
DbSelectArea("SC5")
dbSetOrder(1)
ProcRegua(SC5->(RECCOUNT()))
While SC5->(!Eof())
  nTotAtu:=0
  dbSelectArea("SC6")
  dbSetOrder(1)
  MsSeek(xfilial("SC6")+SC5->C5_NUM)
  While SC6->(!Eof()) .AND. SC5->C5_NUM=SC6->C6_NUM
	if Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES,"F4_DUPLIC")="S"
      nTotAtu:=nTotAtu+SC6->C6_VALOR 
    ENDIF
	dbSelectArea("SC6")
	dbSkip()
  EndDo
  DBSELECTAREA("SA1")
  DBSETORDER(1)
  MsSeek(xfilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
   //DESCOBRINDO O LIMITE UTILIZADO
  DbSelectArea("SZQ")
  dbSetOrder(1)
  if MsSeek(xfilial("SZQ")+SC5->C5_NUM)
    RecLock("SZQ",.F.)
    SZQ->ZQ_CLIENTE	:=SC5->C5_CLIENTE
    SZQ->ZQ_LOJA	:=SC5->C5_LOJACLI
    SZQ->ZQ_NOME	:=SA1->A1_NREDUZ
    SZQ->ZQ_CNPJ	:=SA1->A1_CGC
    SZQ->ZQ_REFCLI	:=SC5->C5_NUMCOT
    SZQ->ZQ_NEGOCIA	:=POSICIONE("SA3",1,XFILIAL("SA3")+SC5->C5_AGINT,"A3_NREDUZ")                     
    SZQ->ZQ_RESULT	:="1"
    SZQ->ZQ_VLALFR	:=NTOTATU
    SZQ->ZQ_D_DIGIT :=SC5->C5_EMISSAO
    SZQ->ZQ_STATUS	:="05"
    SZQ->ZQ_TIPO	:="1"
    MSUNLOCK()
    //Aviso("Arquivo Atualizado","O pedido <<<" + SCJ->CJ_NUM + ">>>, foi atualizado com sucesso",{"Ok"},,"Ajustes Comerciais")
  endif
  DbSelectArea("SC5")
  incPROC("Atualizando Ped. n.:"+SC5->C5_NUM)
  INCPROC()
  dbSkip()
ENDDO
ENDIF
Return ( lRetorno )
