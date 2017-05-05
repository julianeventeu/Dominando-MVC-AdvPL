#Include 'Protheus.ch'
#Include 'FWEditPanel.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} CMVC_08
Exemplo de programa MVC sem uso de dicionario de dados

@author Juliane Venteu
@since 04/04/2017
/*/
//-------------------------------------------------------------------
User Function CMVC_08()
	If MsgYesNo('Deseja executar exemplo com load?')
		FWExecView("Titulo","CMVC_08",4,,{|| .T.})
	Else
		FWExecView("Titulo","CMVC_08",3,,{|| .T.})
	EndIf
Return

Static Function ModelDef()
Local oModel
Local oStr := getModelStruct()

	oModel := MPFormModel():New('MLDNOSXS',,,{|oModel| Commit(oModel) })
	oModel:SetDescription('Exemplo Modelo sem SXs')
	
	oModel:AddFields("MASTER",,oStr,,,{|| Load() })
	oModel:getModel("MASTER"):SetDescription("DADOS")
	oModel:SetPrimaryKey({})
Return oModel

static function getModelStruct()
Local oStruct := FWFormModelStruct():New()
	
	oStruct:AddField('Arquivo Origem','Arquivo Origem' , 'ARQ', 'C', 50, 0, , , {}, .T., , .F., .F., .F., , )
	oStruct:AddField('Carregar','Carregar' , 'LOAD', 'BT', 1, 0, { |oMdl| getArq(oMdl), .T. }, , {}, .F., , .F., .F., .F., , )
	oStruct:AddField('Caminho de Destino','Caminho de Destino' , 'DEST', 'C', 50, 0, , , {}, .T., , .F., .F., .F., , )
	oStruct:AddField('Selecionar','Selecionar' , 'LOAD2', 'BT', 1, 0, { |oMdl| getDir(oMdl), .T. }, , {}, .F., , .F., .F., .F., , )
	
return oStruct

Static Function ViewDef()
Local oView
Local oModel := ModelDef() 
Local oStr:= getViewStruct()

	oView := FWFormView():New()
	oView:SetModel(oModel)
	
	oView:AddField('FORM1' , oStr,'MASTER' ) 
	oView:CreateHorizontalBox( 'BOXFORM1', 100)
	oView:SetOwnerView('FORM1','BOXFORM1')
	oView:SetViewProperty('FORM1' , 'SETLAYOUT' , {FF_LAYOUT_VERT_DESCR_TOP,3} ) 
	oView:EnableTitleView('FORM1' , 'Movimentação de Arquivo' ) 

Return oView

static function getViewStruct()
Local oStruct := FWFormViewStruct():New()

	oStruct:AddField( 'ARQ','1','Arquivo Origem','Arquivo Origem',, 'Get' ,,,,.F.,,,,,,,, )
	oStruct:AddField( 'LOAD','2','Carregar','Carregar',, 'BT' ,,,,,,,,,,,, )
	oStruct:AddField( 'DEST','3','Destino','Destino',, 'Get' ,,,,.F.,,,,,,,, )
	oStruct:AddField( 'LOAD2','4','Selecionar','Selecionar',, 'BT' ,,,,,,,,,,,, )

return oStruct

Static Function getArq(oField)
Local cArq := cGetFile( '*.txt' , 'Textos (TXT)', 1, 'C:\', .T.,,.T., .T. )
	
	If !Empty(cArq)
		oField:SetValue("ARQ",cArq)
	EndIf
	
Return 

Static Function getDir(oField)
Local cDir := cGetFile( '*' , 'Diretorio Destino', 1, 'C:\', .T.,nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY ) ,.T., .T. )
	
	If !Empty(cDir)
		oField:SetValue("DEST",cDir)
	EndIf
	
Return 

Static Function Commit(oModel)
Local cArq := oModel:GetValue("MASTER", "ARQ")
Local cDest := oModel:GetValue("MASTER", "DEST")	
Local cFile
Local cExt
Local cDrive
Local cDir
Local nError
Local lRet := .T.
	
	SplitPath( cArq, @cDrive, @cDir, @cFile, @cExt )
	nError := fRename(AllTrim(cArq), AllTrim(cDest) + AllTrim(cFile) + AllTrim(cExt))
	
	If nError > 0
		lRet := .F.
		Help( ,, 'Help',, 'Erro ao copiar arquivo. FError() = ' + cValToChar(fError()), 1, 0 )
	EndIf	
	
Return lRet

Static Function Load()
Local aLoad := {}

   aAdd(aLoad, {"C:\teste.txt","","D:\",""}) //dados
   aAdd(aLoad, 0) //recno
      
Return aLoad