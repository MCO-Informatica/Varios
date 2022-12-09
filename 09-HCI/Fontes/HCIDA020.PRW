#Include "Protheus.CH"
#Include "RwMake.Ch"
#Include "TopConn.CH"
#include "TBICONN.CH" 

#DEFINE CRLF CHR(13) + CHR(10)

User Function HCIDA020()

	Local _aCores		:= {}
	Local cUserAdmin	:= GetMv("ES_Z0ADMUS",,"000000,000335,000148")
	Local _cVend		:= FT300VEND()
	
	Private cCadastro	:= OEMTOANSI("Apontamento de Visita")
	Private _cFiltro	:= ""
	Private aRotina		:= {}
	
	// Adiciona elementos ao aRotina
	Aadd(aRotina,{"Pesquisar"		,"AxPesqui"			,0,1})
	Aadd(aRotina,{"Atividades"		,"u_fHCIDA20(2)"	,0,2})
	Aadd(aRotina,{"Agenda"			,"u_fHCIDA20(3)"	,0,3})
	Aadd(aRotina,{"Oportunidade"	,"u_fHCIDA20(4)"	,0,3})

	If !(__cUserID $ cUserAdmin)			
		_cFiltro := "ADL_VEND = '" + _cVend + "'"
		MBrowse(6, 1,22,75,"ADL",,,,,,/*_aCores*/,,,,,,,,_cFiltro)						
	Else		
		MBrowse(6, 1,22,75,"ADL",,,,,,/*_aCores*/)		
	EndIf
	
Return()

User Function fHCIDA20(_nOpc)
	
	Local _aArea	:= GetArea()
	Local _nOpcA	:= 0
	Local _aEncho	:= {}

	Do Case
		Case _nOpc == 2
			If AllTrim(ADL->ADL_ENTIDA) $ "SA1/SUS"
				FATA320B(Ft320Age)
			Else
				Aviso(OEMTOANSI("Atenção"),"O uso da agenda é limitado a prospects e clientes",{"Ok"},2)
			EndIf                       

			
		Case _nOpc == 3
                       
			U_HCIDA019()
                       
		Case _nOpc == 4
        	
        	u_fHCIDA18(3)
		
	EndCase
	
	RestArea(_aArea)

Return()
