#include "protheus.ch"       
                    
// Fun??o utilizada para formar a descri??o do produto de acordo com as regras passadas pelo Geraldinho - Qualidade
user function MAT1F005()

	// Define vari?veis
	local cTipoVidro   := ""
	local cConformacao := ""
	local cEspessura   := ""
	local cCor  	     := ""
	local cModeloProd  := ""
	local cApliComer   := ""
	local cLado        := ""   
	local cSpace       := Space(1)   
	local cArea        := ""   
	local cDesc        := ""
	
	if (M->B1_TIPO <> 'PA')
		return M->B1_DESC
	endif
	
	// Seta valores da mem?ria
	cTipoVidro   := M->B1_ZZTVIDR // Necess?rio select na descri??o
	cConformacao := M->B1_ZZVIDRO   
	cEspessura   := CValToChar(M->B1_ZZESPES)
	cCor         := M->B1_ZZCVIDR // Necess?rio select na descri??o
	cModeloProd  := M->B1_ZZMPROD // Necess?rio select na descri??o
	cApliComer   := M->B1_ZZAPLCO // Necess?rio select na descri??o
	cLado        := M->B1_ZZLVIDR // Necess?rio select na descri??o         
	
	// Realiza tratativa  
	cArea := "ZZ5"
	DbSelectArea(cArea)
	DbSetOrder(2)  
	DbSeek(xFilial( cArea ) + cTipoVidro)
	cTipoVidro := ZZ5->ZZ5_DESCRI   
	cArea := "ZZ6"
	DbSelectArea(cArea)
	DbSetOrder(2)  
	DbSeek(xFilial( cArea ) + cCor)
	cCor := ZZ6->ZZ6_DESCRI    
	cArea := "ZZ3"
	DbSelectArea(cArea)  
	DbSetOrder(1)
	DbSeek(xFilial( cArea ) + cModeloProd)
	cModeloProd := ZZ3->ZZ3_DESCRI 
	cArea := "ZZ4"     
	DbSelectArea(cArea)  
	DbSetOrder(2)
	DbSeek(xFilial( cArea ) + cApliComer)
	cApliComer := ZZ4->ZZ4_DESCRI    
	cArea := "ZZ7"   
	DbSelectArea(cArea)   
	DbSetOrder(2)
	DbSeek(xFilial( cArea ) + cLado)
	cLado := ZZ7->ZZ7_DESCRI        
	        
	// Retira espa?os (Gambeta mode ON)
	if (AllTrim(cTipoVidro) <> "")
		cDesc += AllTrim(cTipoVidro) + cSpace
	endif     
	if (AllTrim(cConformacao) <> "")
		cDesc += AllTrim(cConformacao) + cSpace
	endif
	if (AllTrim(cEspessura) <> "")
		cDesc += AllTrim(cEspessura) + "MM" + cSpace
	endif	   
	if (AllTrim(cCor) <> "")
		cDesc += AllTrim(cCor) + cSpace
	endif
	if (AllTrim(cModeloProd) <> "")
		cDesc += AllTrim(cModeloProd) + cSpace
	endif  
	if (AllTrim(cApliComer) <> "")
		cDesc += AllTrim(cApliComer) + cSpace
	endif   
	if (AllTrim(cLado) <> "")
		cDesc += AllTrim(cLado) + cSpace
	endif  
	
return cDesc