#include "rwmake.ch"        
#include "topconn.ch"

User Function MESTA001()

                        
SetPrvt("_CCAMPO,_CCPO,AROTINA,CCADASTRO,CMARCA,CPERG,_CUSER")             


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MESTA001 ³ Autor ³Felipe Valenca         ³ Data ³26/08/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Browse do Saldo por Lote para gerar movimento de saída     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MINEXCO						                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   Analista   ³  Data  ³             Motivo da Alteracao               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*/

/*--------------------------------------------------------------------------*
*---------------------------------------------------------------------------*
* Criacao do MarkBrowse do Arquivo SB8 (Saldo por Lote)                     *
*---------------------------------------------------------------------------*
*--------------------------------------------------------------------------*/
_cCampo  := "B8_X_OK"
_cCpo    := "B8_NUMLOTE "   
_cFilter := "B8_SALDO > 0 .And. B8_EMPENHO = 0 "


DbSelectArea("SB8")
DbSetOrder(1)

aRotina   := { { "Pesquisa"  ,"AxPesqui" ,0,1},;
               { "Gerar Movimento","U_MOVSAIDA()" ,0,3}}

cCadastro := "Saldo por Lote"

cMarca    := getmark()

dbSelectArea("SB8")
Set Filter to &_cFilter
ProcRegua(RecCount())
MarkBrow("SB8",_cCampo,_cCpo,,,cMarca)

Return()

User Function MOVSAIDA()

Private aCab    := {}
Private aItem   := {}      
Private cNumDoc := ""
Private _Filial := cFilAnt
Private _Area   := GETAREA()
lMsErroAuto := .F.

   dbSelectArea("SB8") //arquivo temporario
   DbGotop()
   cNUMDOC := PROXNUM()
                                    
   aCab := {{"D3_DOC"    ,cNumDoc    ,Nil},;
            {"D3_TM"     ,'501'      ,Nil},;
            {"D3_CC"     ,' '        ,Nil},;
            {"D3_EMISSAO",dDataBase ,Nil}}
                                                  
	While !Eof()                           
		
		IncProc("Gerando Movimento, Documento "+cNumDoc)
		If marked("B8_X_OK")

	      aadd(aItem,{{"D3_FILIAL" ,xFilial("SB8") ,NIL},;
	          {"D3_COD"    ,SB8->B8_PRODUTO    ,NIL},;
	          {"D3_UM"    ,Posicione("SB1",1,xFilial("SB8")+SB8->B8_PRODUTO,"B1_UM")    ,NIL},;
	          {"D3_LOTECTL"  ,SB8->B8_LOTECTL    ,NIL},;
	          {"D3_X_LOTEF"  ,SB8->B8_LOTEFOR    ,NIL},;
	          {"D3_QUANT" ,SB8->B8_SALDO ,NIL},;
	          {"D3_LOCAL" ,SB8->B8_LOCAL ,NIL}})

			Reclock("SB8",.F.)
			SB8->B8_X_OK := ""
			MsUnlock()
	
			SB8->(dbSkip())
		Else
			SB8->(dbSkip())
		Endif

   Enddo
   
   RESTAREA(_Area) 
   MSExecAuto({|x,y,z|MATA241(x,y,z)},aCab,aItem, 3)

	If !lMsErroAuto
		_aCab		:= {}
		_aItens 	:= {}
	Else
		ApMsgAlert("Erro")
		MostraErro()
	Endif	

Return