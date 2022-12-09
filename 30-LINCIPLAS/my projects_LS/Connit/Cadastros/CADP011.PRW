
#INCLUDE "PROTHEUS.CH"   

#Define GD_INSERT 1
#Define GD_UPDATE 2                                                                                                                       
#Define GD_DELETE 4

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CADP011 º Autor ³ Antonio Carlos       º Data ³  06/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina para testes diversos.                                ±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±             
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CADP011()                                     

Private aHeader		:= {}
Private aCols		:= {}
Private cCadastro	:= "Cadastro de Perfil"
Private oGetDados	

If Alltrim(cUserName) $ GetMv("MV_USRPER")

	Aadd( aHeader, { 'Chave'	, 'X5_CHAVE'	, '@!', 2,	0,,, 'C',,  ,  ,  , , ,	} )
	Aadd( aHeader, { 'Descricao', 'X5_DESCRI'	, '@!', 55, 0,,, 'C',,  ,  ,  , , ,	} )

	DbSelectArea("SX5")
	SX5->( DbsetOrder(1) )
	SX5->( Dbseek(xFilial("SX5")+"ZR") )
	While SX5->( !Eof() ) .And. SX5->X5_FILIAL == xFilial("SX5") .And. SX5->X5_TABELA == "ZR"
	
		Aadd(aCols,Array(Len(aHeader)+1))
	
		For nY	:= 1 To Len(aHeader)
			IF ( aHeader[nY][10] != "V" )
				aCols[Len(aCols)][nY] := FieldGet(FieldPos(aHeader[nY][2]))
			Else
				aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2])
			EndIf
		Next nY
	
		aCols[Len(aCols)][Len(aHeader)+1] := .F.
			
		SX5->( DbSkip() )
	
	EndDo

	nStyle := GD_INSERT+GD_UPDATE+GD_DELETE

	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 8,0 TO 300, 650 PIXEL

	oGetDados:= MsNewGetDados():New(20,10,130,310,nStyle,"Allwaystrue","AllWaysTrue",,,,99999,,,,oDlg,aHeader,aCols)

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar( oDlg, { || AtuDados(),oDlg:End() }, { ||  oDlg:End() } )
    
Else
    
	MSGInfo( "** Usuário sem Permissão! **" + char(13) + "MV_USRPER" )
    	
EndIf
    	
Return

Static Function AtuDados()

Local nPosChav	:= aScan(oGetDados:aHeader,{|x| AllTrim(x[2])=="X5_CHAVE"})
      
DbSelectArea("SX5")
SX5->( DbSetOrder(1) )

For nX := 1 To Len(oGetDados:aCols)
			
	lAchou := SX5->( DbSeek(xFilial("SX5")+"ZR"+oGetDados:aCols[nX,nPosChav]) )
			
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
				
		SX5->X5_FILIAL := xFilial("SX5")
		SX5->X5_TABELA := "ZR"
		
		For nX2 := 1 To Len(oGetDados:aHeader)
			If ( oGetDados:aHeader[nX2][10] != "V" )
				FieldPut(FieldPos(oGetDados:aHeader[nX2][2]),oGetDados:aCols[nX][nX2])
			EndIf
		Next
				
		SX5->( MsUnLock() )
				
	EndIf
			
Next nX

MsgInfo("Atualizacao efetuada com sucesso!")
     
Return