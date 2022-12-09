#INCLUDE "PROTHEUS.CH"
#INCLUDE "JPEG.CH"
#INCLUDE "Rwmake.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MT093B1  ³ Autor ³ Rogerio Leite         ³ Data ³ 12.06.07   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ponto de Entrada na Inclusao de Produtos - Config.Produtos   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MATA093                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³xx/xx/xx³XXXXXX³                                          ³±±
±±³              ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT093B1() 

Local cOldEmp   :=cEmpAnt
Local cDesPrd   :=SB1->B1_DESC
Local cCodPrd   :=SB1->B1_COD
Local CodNorma  :=SBS->BS_NORMAT
Local cBase     :=SBS->BS_BASE
Local aChave    :={}
Local aDados    :={}
Local cTecnico  :=""
Local nPosicao  :=LEN(TRIM(cBase))+1
Local nLinha    :=1
Private cEmpAtual := SM0->M0_CODIGO
Private cFilAtual := SM0->M0_CODFIL
SB1->B1_XMATCOP=CODNORMA
SB1->B1_GRUPO  =SBS->BS_GRUPO
SB1->B1_POSIPI =SBS->BS_POSIPI
DbSelectArea("SBQ")
dbSetOrder(1)
If SBQ->(DbSeek(xFilial("SBQ")+cBase))
  While xFilial("SBQ") == SBQ->BQ_FILIAL .and. !SBQ->(Eof()) .and. SBQ->BQ_BASE == cBase
    aAdd( aDados,SUBSTR(SB1->B1_COD,nPosicao,SBQ->BQ_TAMANHO))
    aAdd( aChave,SBQ->BQ_FILIAL+SBQ->BQ_BASE+SBQ->BQ_ID+SUBSTR(SB1->B1_COD,nPosicao,SBQ->BQ_TAMANHO))
    nPosicao:=nPosicao+SBQ->BQ_TAMANHO
    nLinha:=nLinha+1
    dbskip()
  EndDo
ENDIF
for x:=1 to len(aChave)
  cTecnico:=cTecnico+TRIM(Posicione("SBS",1,ACHAVE[x],"BS_TECNICA"))
  IF LEN(TRIM(Posicione("SBS",1,ACHAVE[x],"BS_TECNICA")))>0
    cTecnico:=cTecnico+"|"
  ENDIF
  if LEN(TRIM(SB1->B1_POSIPI))=0
    SB1->B1_POSIPI:=Posicione("SBS",1,ACHAVE[x],"BS_POSIPI")
  ENDIF    
NEXT  
IF LEN(aChave)>0
  SB1->B1_XDETEV:=cTecnico
ENDIF

If SB1->B1_TIPO $ "PA"
   U_RESTG001(SB1->B1_COD)  // Funcao no MT010INC
Endif

If SB1->B1_PESO=0
   SB1->B1_PESO:=U_A093PESO(SB1->B1_DESC)
ENDIF
if sb1->b1_peso=0 
   Msginfo("Cadastro Automatico Interrompido por falta de Peso, Inclusao Abortada")
   SB1->( dbDelete() )
	 SB1->( MsUnLock() )
   
endif   

Return


USER FUNCTION A093PESO(cDescricao)
  Local aAreaAtu	:= GetArea()												// Salva a area atual  
  Local lRet		:= .T.
  LOCAL nPesoProd:=0
  Local oDlg7 
  Local cTitulo :="Peso do Produto"
  @ 000,000 To 180,400 Dialog Odlg7 Title OemToAnsi("Rotina para Cadastro de Peso")
  @ 003,008 To 85,200 Title OemToAnsi("Digite o Peso do Produto: "+cDescricao)
  @ 015,015 Say OemToAnsi("Peso:") OF Odlg7 PIXEL
  @ 015,045 msget nPesoProd SIZE 60,10 PICTURE PesqPict("SB1","B1_PESO") OF Odlg7 PIXEL
  @ 055,030 BMPBUTTON TYPE 1 ACTION 	Processa({|| OkProc(odlg7,nPesoProd,lRet)},cTitulo,"Aguardando dados, informe...")
  @ 055,060 BMPBUTTON TYPE 2 ACTION Finaliza(odlg7,lret)
  Activate Dialog Odlg7 CENTER
RETURN (nPesoProd)
// Finalizacao do Processo
Static Function Finaliza(Odlg7,lRet)
  Msginfo("Registro nao informado por falta de interacao, Inclusao Abortada")
  Close(Odlg7)
  lret:=.F.
Return (lret)
// Processamento
Static Function OkProc(Odlg7,nPesoProd,lRet)
  If nPesoProd>0 
    lRet:=.T.
  else
    Msginfo("Registro nao informado por falta de interacao, Inclusao Abortada")
    lRet:=.F.
  endif    
  Close(Odlg7)
Return (nPesoprod)
