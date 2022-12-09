#include "rwmake.ch"
User Function FimSPF()
Return( _SPF_CLOSE( "SIGAPSS.SPF" ) )

Static Function _SPF_CLOSE( cSPFFile )
Return( SPF_CLOSE( cSPFFile ) )