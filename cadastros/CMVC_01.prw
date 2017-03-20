#Include 'Protheus.ch'
#Include 'FWMVCDEF.ch'

User Function CMVC_01(nOpcAuto, xAuto)
Local oBrowse
	
	If xAuto <> NIL
		FWMVCRotAuto(FWLoadModel("CMVC_01"),"ZB2",nOpcAuto, {"MASTERZB2",xAuto})
	Else
		oBrowse := FWMBrowse():New()
		oBrowse:SetAlias('ZB2')
		oBrowse:SetDescription('Cadastro de Alunos')
		oBrowse:Activate()
	EndIf
	
Return

Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.CMVC_01' OPERATION 2 ACCESS 0
ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.CMVC_01' OPERATION 3 ACCESS 0
ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.CMVC_01' OPERATION 4 ACCESS 0
ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.CMVC_01' OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.CMVC_01' OPERATION 8 ACCESS 0
ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.CMVC_01' OPERATION 9 ACCESS 0

Return aRotina

Static Function ModelDef()
Local oModel
Local oStruZB2 := FWFormStruct(1,"ZB2")

	oModel := MPFormModel():New("MD_ALUNO")
	oModel:SetDescription("Cadastro de Alunos")
	
	oModel:addFields('MASTERZB2',,oStruZB2)
	oModel:getModel('MASTERZB2'):SetDescription('Dados do Aluno')
	 
Return oModel

Static Function ViewDef()
Local oModel := ModelDef()
Local oView
Local oStrZB2:= FWFormStruct(2, 'ZB2')
	
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField('FORM_ALUNO' , oStrZB2,'MASTERZB2' ) 
	oView:CreateHorizontalBox( 'BOX_FORM_ALUNO', 100)
	oView:SetOwnerView('FORM_ALUNO','BOX_FORM_ALUNO')
	oView:SetTimer(10000,{|| Alert("TSTE") })
	
Return oView