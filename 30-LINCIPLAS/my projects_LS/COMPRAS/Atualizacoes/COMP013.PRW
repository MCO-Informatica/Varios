#INCLUDE "PROTHEUS.CH"   

#Define GD_INSERT 1
#Define GD_UPDATE 2                                                                                                                       
#Define GD_DELETE 4

/*
+==========================================================+
|Programa: COMP013 |Autor: Antonio Carlos |Data: 22/06/10  | 
+==========================================================+
|Descricao: Responsavel pela configuração entre Compradores|
|x Grupos de Produtos ref. processo de Aprovação de Pedido |
|de Compra                                                 |
+==========================================================+
|Uso: Laselva                                              |
+==========================================================+
*/

User Function COMP013(cProd)                                     

Private	_cProd	:= cProd
Private aHeader	:= {}
Private aCols	:= {}
Private oGetDados	

DbSelectArea("SX3")
SX3->( DbSetorder(1) )
MsSeek("SX5")                         
While SX3->( !Eof() ) .And. (SX3->X3_ARQUIVO == "SX5")
	
	If Alltrim(SX3->X3_CAMPO) $ "X5_CHAVE/X5_DESCRI"
		
		Aadd( aHeader, { 	IIf(Alltrim(X3_CAMPO)=="X5_CHAVE","Grupo Produtos",IIf(Alltrim(X3_CAMPO)=="X5_DESCRI","Grupo Aprovacao",AlLTrim( X3Titulo() )))	,;
		SX3->X3_CAMPO		,;
		SX3->X3_Picture		,;
		SX3->X3_TAMANHO		,;
		SX3->X3_DECIMAL		,;
		IIf(Alltrim(X3_CAMPO)=="X5_CHAVE",'ExistCpo("SBM",Alltrim(M->X5_CHAVE))',IIf(Alltrim(X3_CAMPO)=="X5_DESCRI",'ExistCpo("SAL",Alltrim(M->X5_DESCRI))',SX3->X3_Valid))	,;
		SX3->X3_USADO		,;
		SX3->X3_TIPO		,;
		IIf(Alltrim(X3_CAMPO)=="X5_CHAVE","SBM",IIf(Alltrim(X3_CAMPO)=="X5_DESCRI","SAL",SX3->X3_F3))	,; 			
		SX3->X3_CONTEXT		,;
		SX3->X3_CBOX		,;
		SX3->X3_RELACAO } )
	
	EndIf	
	
	SX3->( DbSkip() )
	
EndDo

DbSelectArea("SX5")
SX5->( DbsetOrder(1) )
SX5->( Dbseek(Space(2)+"Z1") )
While SX5->( !Eof() ) .And. SX5->X5_TABELA == "Z1"
	
	Aadd(aCols,Array(Len(aHeader)+1))
	
	For nY	:= 1 To Len(aHeader)
		If ( aHeader[nY][10] == "V" )
			aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2])
		Else		
			aCols[Len(aCols)][nY] := FieldGet(FieldPos(aHeader[nY][2]))
		EndIf			
	Next nY
	
	aCols[Len(aCols)][Len(aHeader)+1] := .F.
			
	SX5->( DbSkip() )
	
EndDo

If Len(aCols) == 0
	
	aCols := {}
	Aadd(aCols,Array(Len(aHeader)+1))
	For nY := 1 To Len(aHeader)
		aCols[Len(aCols),nY] := CriaVar(aHeader[nY][2])
	Next nY
	aCols[Len(aCols),Len(aHeader)+1] := .F.
	
EndIf 

nStyle := GD_INSERT+GD_UPDATE+GD_DELETE

DEFINE MSDIALOG oDlg TITLE "Amarracao Grupo Produtos x Grupo Aprovadores" FROM 8,0 TO 300, 650 PIXEL

oGetDados:= MsNewGetDados():New(20,10,130,310,nStyle,"Allwaystrue","AllWaysTrue",,,,99999,,,,oDlg,aHeader,aCols)

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar( oDlg, { || AtuDados(),oDlg:End() }, { ||  oDlg:End() } )

Return

Static Function AtuDados()
      
DbSelectArea("SX5")
SX5->( DbSetOrder(1) )

For nX := 1 To Len(oGetDados:aCols)
			
	lAchou := SX5->( DbSeek(Space(2)+"Z1"+oGetDados:aCols[nX,1]) )
			
	If oGetDados:aCols[nX,Len(oGetDados:aHeader)+1]
				
		If lAchou   
				
			RecLock("SX5",.F.)
			DbDelete()
			SX5->( MsUnLock() )
				
		EndIf
				
	Else
				
		If lAchou
			RecLock("SX5",.F.)
		Else
			RecLock("SX5",.T.)
		EndIf
				
		For nX2 := 1 To Len(oGetDados:aHeader)
			If ( oGetDados:aHeader[nX2][10] != "V" )
				FieldPut(FieldPos(oGetDados:aHeader[nX2][2]),oGetDados:aCols[nX][nX2])
			EndIf
		Next
		SX5->X5_TABELA := "Z1"
		
		SX5->( MsUnLock() )
	
	EndIf	
				
Next nX

MsgInfo("Atualizacao efetuada com sucesso!")

Return