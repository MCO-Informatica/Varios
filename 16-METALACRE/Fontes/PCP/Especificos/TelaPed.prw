#Include "RWMAKE.CH"
#Include "TOPCONN.CH" 
#Include "Protheus.Ch"            

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออปฑฑ
ฑฑบPrograma  ณEndereco    บAutor  ณ Mateus Hengle      บData  ณ 03/07/13  บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออนฑฑ
ฑฑบDescric.  ณTela que insere o pedido de venda e item na tabela SC2      บฑฑ
ฑฑบ          ณTOTVS TRIAH												  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Metalacre                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TelaPed()  

Local oDlg
Local aSay    := {}
Local aButton := {} 
Local nOpcao  := 0

Private cPed        := Space(8)
Private cItem       := ""
Private cOPST       := Space(11) 
Private aRotina     := {}
Private cMarca      := ""
Private cCadastro   := "Tela que insere o numero e o item do PV"  


aAdd(aSay,"Este programa tem como objetivo informar e amarrar o numero e o item do PV")
aAdd(aSay,"referente a uma Ordem de Produ็ใo Manual")


aAdd(aButton, { 1,.T.,{|| nOpcao := 1, FechaBatch() }})
aAdd(aButton, { 2,.T.,{|| FechaBatch()              }})

FormBatch(cCadastro,aSay,aButton)

If nOpcao <> 1
   Return
Endif


DEFINE MSDIALOG oDlg TITLE "PEDIDO E ITEM DA OP MANUAL" FROM 0,0 TO 150,400 OF oDlg PIXEL

@ 07, 10 SAY   "Pedido"     SIZE 100,8 PIXEL OF oDlg 		// pega o numero do pedido
@ 07, 30 MSGET cPed F3 "SC6" SIZE 50,10 PIXEL OF oDlg
		
@ 07, 120 SAY   "Item do Pedido"     SIZE 100,8 PIXEL OF oDlg    		// pega o item do pedido
@ 07, 160 GET SUBSTR(cPed, 7,2) SIZE 20,10 PIXEL OF oDlg
	                                  
@ 35, 10 SAY   "Num da OP Manual"     SIZE 100,8 PIXEL OF oDlg //pega o numero da OP manual
@ 35, 65 MSGET cOPST F3 "SC2" SIZE 60,10 PIXEL OF oDlg
		
@ 35,140 BUTTON "OK"          SIZE 25,13 PIXEL ACTION oDlg: End()
	
ACTIVATE MSDIALOG oDlg CENTER ON INIT(oDlg)

cPedido := ALLTRIM(SUBSTR(cPed, 1,6))  // pega as 6 primeiras posi็oes do pedido
cItem   := ALLTRIM(SUBSTR(cPed, 7,2))  // pega as 2 ultimas q eh o item do pedido

cOP     := ALLTRIM(SUBSTR(cOPST, 1,6))
cItemOP := ALLTRIM(SUBSTR(cOPST, 7,2))
cSeq    := ALLTRIM(SUBSTR(cOPST, 9,3))

IF !EMPTY(cPed) .AND. !EMPTY(cOPST)  // se os campos nao estiverem vazios
    
   DBSELECTAREA("SC2")
   DBSETORDER(1)
   IF DBSEEK(XFILIAL("SC2") + cOP + cItemOP + cSeq )  // faz um seek na tabela SC2 com o numero do pedido e item
        
		RecLock("SC2",.F.)          	
		SC2->C2_XPEDIDO  := cPedido
		SC2->C2_XITEM    := cItem
		SC2->C2_OPSTAND  := 'S'
	    
		MSGINFO("O Pedido e o item da OP manual foi gravado com sucesso!")
   		MsUnLock()
	ELSE
   		ALERT("Nao achou o registro !")
   	ENDIF
ELSE
	ALERT("Existe um campo vazio, favor preencher !")    			
ENDIF
	

Return