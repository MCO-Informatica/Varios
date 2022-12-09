/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FC010CON  ºAutor  ³Microsiga           º Data ³ 01/09/2008  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Consulta os ultimos contatos do Telemarketing              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FC010CON
 
Local nModuloAnt  := nModulo   
Local cFuncaoAnt  := FunName()
Local lHabilita   := .F.
Local oFolderTmk  := NIL
Local oEnchTmk    := NIL  
Local oEnchTlv    := NIL
Local cCodPagto   := "" 
Local cDescPagto  := "" 
Local cTransp     := "" 
Local cCob        := "" 
Local cEnt        := "" 
Local cCepC       := "" 
Local cUfC        := ""          
Local cBairroE    := ""
Local cCidadeE    := ""
Local cCepE       := ""           
Local cUfE        := "" 
Local nTxJuros    := 0  
Local nTxDescon   := 0             
Local nVlJur      := 0  
Local nEntrada    := 0  
Local nFinanciado := 0  
Local nNumParcelas:= 0  
Local cMotivo     := ""  
Local cEncerra    := ""         
Local oFolderTlc  := NIL 
Local aColsTlv    := {} 
Local cCodAnt     := ""       
Local cCliAnt     := ""
Local oFolderTlv  := ""
Local cCodTransp  := ""
Local cCidadeC    := ""
Local cBairroC    := ""
Local nLiquido    := 0
Local aParcelas   := {}
Local nValorCC    := 0
Local oEnchTlc    := NIL

 
Private nFolder   := 1
Private nOpc      := 4
Private cNumTmk   := ""
Private cNumTlv   := ""
Private cNumTlc   := "" 
Private lProspect := .F.   
Private aPosicoes := {}
Private aPosicoesM:= {}
Private aPosicoesV:= {}
Private aPosicoesC:= {}     
Private aSvFolder := {}
Private aCols     := {}
Private aHeader   := {}
Private N         := 1


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializa aSvFolder³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aSvFolder,{{},{},1})
Aadd(aSvFolder,{{},{},1})
Aadd(aSvFolder,{{},{},1})

TkGetTipoAte("2")            
 
IF Alltrim(Upper(FunName()))=="MATA410"
   DbSelectArea("SA1")
   DbSeek( xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,.F.)
ENDIF

M->UA_CLIENTE := SA1->A1_COD
M->UA_LOJA    := SA1->A1_LOJA
M->UA_DESCCLI := SA1->A1_NOME
M->UC_ENTIDAD := "SA1"
M->UC_CHAVE   := SA1->A1_COD+SA1->A1_LOJA

IF ! TkContatos()  
   Alert("Deve ser selecionado um contato para esta consulta!")
   Return
Endif           

cCodCont := SU5->U5_CODCONT 
M->UC_CODCONT := cCodCont   
M->UC_DESCCHA := TkEntidade(M->UC_ENTIDAD,M->UC_CHAVE,1)
   
nModulo := 13    
SetFunName("TMKA380")

//+------------------------------------------------------+
//¦ Configuraçao da GetDados - Folder 01 Telemarketing   ¦
//+------------------------------------------------------+

TkGetTipoAte("1")            

lRet := TK271Config("SUD","UD_CODIGO",nOpc,cNumTmk,cNumTlv,cNumTlc ) 
                                                                       
Tk271Historico(@nOpc,@lHabilita,@oFolderTmk,@oEnchTmk,@oFolderTlv,@oEnchTlv,@cCodPagto,@cDescPagto,@cCodTransp,@cTransp,@cCob,@cEnt,@cCidadeC,@cCepC,@cUfC,@cBairroE,@cBairroC,@cCidadeE,@cCepE,@cUfE,@nLiquido,@nTxJuros,@nTxDescon,@nVlJur,@aParcelas,@nEntrada,@nFinanciado,@nNumParcelas,@nValorCC,@cMotivo,@cEncerra,@oFolderTlc,@oEnchTlc,@aColsTlv,@cCodAnt,@cCliAnt)

nModulo := nModuloAnt
SetFunName(cFuncaoAnt)

Return  