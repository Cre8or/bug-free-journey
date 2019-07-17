/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Creates a picture icon. Used for pretty much everything, except weapons (due to the image aspect ratio).
		(This function assumes a 1x1 aspect ratio)
	Arguments:
		MACRO_FNC_UI_CREATEPICTUREICON:
			MY_CTRLFRAME			The frame control to which the generated icon will belong
			MY_CTRLICON			The variable name of the icon control to be created
			MY_DISPLAY			The display in which to create the icon control
			MY_IDC				The icon control's IDC
			MY_CTRLPARENT			The parent controls group to which the icon control should attach
			MY_CTRLPOS			The position array of the icon control
			MY_ICONPATH			The path to the icon

		MACRO_FNC_UI_CREATEPICTUREICON_ROTATED:
			(same as MACRO_FNC_UI_CREATEPICTUREICON)
			The Icon control variable already eists - icon will be rotated 90°

		MACRO_FNC_UI_CREATEPICTUREICON_PRIVATE:
			(same as MACRO_FNC_UI_CREATEPICTUREICON)
			This macro assumes the icon control variable does not exit yet, and will create it (using "private")

		MACRO_FNC_UI_CREATEPICTUREICON_PRIVATE_ROTATED:
			(same as MACRO_FNC_UI_CREATEPICTUREICON)
			This macro assumes the icon control variable does not exit yet, and will create it (using "private")
			The icon will be rotated 90°
-------------------------------------------------------------------------------------------------------------------- */

// First variant - icon control variable already exists - item is NOT rotated
#define MACRO_FNC_UI_CREATEPICTUREICON(MY_CTRLFRAME,MY_CTRLICON,MY_DISPLAY,MY_IDC,MY_CTRLPARENT,MY_CTRLPOS,MY_ICONPATH)			 \
MY_CTRLICON = MY_DISPLAY ctrlCreate ["Cre8ive_Inventory_ScriptedPicture", MY_IDC, MY_CTRLPARENT];                                        \
MY_CTRLICON ctrlSetText MY_ICONPATH;                                                                                                     \
MY_CTRLICON ctrlSetPosition MY_CTRLPOS;                                                                                                  \
MY_CTRLICON ctrlCommit 0;                                                                                                                \
MY_CTRL setVariable [MACRO_VARNAME_UI_CTRLICON, MY_CTRLICON];

// Second variant - icon control variable does NOT exist yet - item IS rotated
#define MACRO_FNC_UI_CREATEPICTUREICON_ROTATED(MY_CTRLFRAME,MY_CTRLICON,MY_DISPLAY,MY_IDC,MY_CTRLPARENT,MY_CTRLPOS,MY_ICONPATH)		 \
MACRO_FNC_UI_CREATEPICTUREICON(MY_CTRLFRAME,MY_CTRLICON,MY_DISPLAY,MY_IDC,MY_CTRLPARENT,MY_CTRLPOS,MY_ICONPATH)                          \
MY_CTRLICON ctrlSetAngle [90, 0.5, 0.5];

// Third variant - icon control variable does NOT exist yet - item is NOT rotated
#define MACRO_FNC_UI_CREATEPICTUREICON_PRIVATE(MY_CTRLFRAME,MY_CTRLICON,MY_DISPLAY,MY_IDC,MY_CTRLPARENT,MY_CTRLPOS,MY_ICONPATH)		 \
private MACRO_FNC_UI_CREATEPICTUREICON(MY_CTRLFRAME,MY_CTRLICON,MY_DISPLAY,MY_IDC,MY_CTRLPARENT,MY_CTRLPOS,MY_ICONPATH)

// Fourth variant - icon control variable does NOT exist yet - item IS rotated
#define MACRO_FNC_UI_CREATEPICTUREICON_PRIVATE_ROTATED(MY_CTRLFRAME,MY_CTRLICON,MY_DISPLAY,MY_IDC,MY_CTRLPARENT,MY_CTRLPOS,MY_ICONPATH)	 \
private MACRO_FNC_UI_CREATEPICTUREICON_ROTATED(MY_CTRLFRAME,MY_CTRLICON,MY_DISPLAY,MY_IDC,MY_CTRLPARENT,MY_CTRLPOS,MY_ICONPATH)
