#INCLUDE "protheus.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} MT010INC
Ponto de Entrada para gravar dados complementares, apos a inclusao do cadastro de produtos

@author		DayHome
@since		25/09/2015
@version	P11
@obs		Parametros: Nenhum
/*/
//-------------------------------------------------------------------

User Function MT010INC()

LOCAL _aArea
LOCAL _aAreaSM0
LOCAL _cFilAnt  := cFilAnt
LOCAL _cFilSFK  := xFilial("SFK")
LOCAL _dDtSaldo := CTOD( "01/"+StrZero(Month(dDataBase),2)+"/"+StrZero(Year(dDataBase),4) )
LOCAL _cESTICM, _cESTADO, _nPerICM

If ! SB1->B1_ORIGEM $ "16" // Faz a inclusao dos saldos de ST Somente para Origens Diferentes de 1 e 6
	
	_aArea    := GetArea()
	_aAreaSM0 := SM0->( GetArea() )
	
	dbSelectArea("SFK")  // Saldos Iniciais ST - cat17
	dbSetOrder(1)        // Produto + Data
	
	dbSelectArea("SM0")  // Empresas
	dbSetOrder(1)        // Codigo + CodFil
	dbSeek( cEmpAnt, .T. )
	
	Do While SM0->M0_CODIGO==cEmpAnt .AND. !Eof()
		
		cFilAnt := SM0->M0_CODFIL
		_cESTICM  := GetMv("MV_ESTICM")
		_cESTADO  := GetMv("MV_ESTADO")
		_nPerICM  := Val( Substr(_cESTICM,AT(_cESTADO,_cESTICM)+2,2) )  // Define a Aliquota de acordo com o Estado da Filial
		
		// Verifica se Existe o Saldo Inicial Cadastrado na SFK, para o produto, no primeiro dia do mes em que esta sendo cadastrado, para Todas as Filiais
		dbSelectArea("SFK")
		If ! dbSeek( Iif(Empty(_cFilSFK),_cFilSFK,SM0->M0_CODFIL) + SB1->B1_COD + DTOS(_dDtSaldo) , .F. )
			RecLock("SFK",.T.)
			SFK->FK_FILIAL  := Iif(Empty(_cFilSFK),_cFilSFK,SM0->M0_CODFIL)
			SFK->FK_PRODUTO := SB1->B1_COD
			SFK->FK_DATA    := _dDtSaldo
			SFK->FK_AICMS   := Iif( !Empty(SB1->B1_PICM), SB1->B1_PICM, _nPerICM )
			SFK->FK_SALDO   := "1"  // Indica que eh saldo inicial
			// Obs: FK_QTDE, FK_BRICMS, FK_BASEICM ficam zerados, o registro sera apenas para constar o saldo inicial Zerado, para ser considerado pelo relatorio MATR461 - Pergunta PROCESSA CDM = NAO
			MsUnLock()
		EndIf
		
		If Empty(_cFilSFK)  // Se a SFK for compartilhada, sera executado so a primeira vez do loop e depois abandona
			Exit
		EndIf
		
		dbSelectArea("SM0")
		dbSkip()
		
	EndDo
	
	cFilAnt := _cFilAnt    // Restaura a Filial
	
	RestArea( _aAreaSM0 )
	RestArea( _aArea )
	
EndIf

Return( Nil )
