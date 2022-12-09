#include "Protheus.ch"               
#include "TopConn.ch"

User Function DBSCTFIL()             
Local lRet := .T.
Local nIndCCli := ASCAN(aHeader, {|x| AllTrim(x[2]) == "CT_CLIENTE"}) 	//indice no aheader onde esta o codigo do cliente
Local nIndLCli := ASCAN(aHeader, {|x| AllTrim(x[2]) == "CT_LOJA"})  	//indice no aheader onde esta a loja do cliente 
Local nIndNCli := ASCAN(aHeader, {|x| AllTrim(x[2]) == "CT_NOMCLI"})    //indice no aheader onde esta a nome do cliente para posicionar 
Local nIndRCli := ASCAN(aHeader, {|x| AllTrim(x[2]) == "CT_REGIAO"})
Local nIndGCli := ASCAN(aHeader, {|x| AllTrim(x[2]) == "CT_GRPCLI"})
Local nIndDCli := ASCAN(aHeader, {|x| AllTrim(x[2]) == "CT_DIVCLI"})

Local cCliente := aCols[n,nIndCCli]
Local cLojaCli := aCols[n,nIndLCli]       

If(!Empty(cCliente) .AND. !Empty(cLojaCli))
	DbSelectArea("SA1"); DbSetOrder(1)
	If(DbSeek(xFilial("SA1")+cCliente+cLojaCli))
		aCols[n,nIndNCli] := SA1->A1_NOME	 //POSICIONE("SA1",1,xFilial("SA1")+cCliente+cLojaCli, "A1_NOME")		
		aCols[n,nIndRCli] := SA1->A1_REGIAO  //POSICIONE("")       
		aCols[n,nIndGCli] := SA1->A1_GRPVEN  //       
				
		cGrpVCli := aCols[n,nIndGCli]         
		
		DbSelectArea("ACY"); DbSetOrder(1)
		If(DbSeek(xFilial("ACY")+cGrpVCli))
		     aCols[n,nIndDCli] := ACY->ACY_DESCRI
		Else
			 aCols[n,nIndDCli] := ""
		EndIf
	Else
		aCols[n,nIndNCli] := ""
		aCols[n,nIndRCli] := ""
		aCols[n,nIndGCli] := ""
	EndIf		
EndIf

Return lRet