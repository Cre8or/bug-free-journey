/* --------------------------------------------------------------------------------------------------------------------
	Author:		Cre8or
	Description:
		Moves a control to a given position and commits the change, with just one (convenient) line.
	Arguments:
		MACRO_FNC_UI_CTRL_SETPOSITION
			MY_CTRL			The control that we want to move
			MY_TARGETPOS		The position that the control should move to (in format [X,Y] or [X,Y,W,H])
			MY_COMMITDURATION	The commit duration

		MACRO_FNC_UI_CTRL_SETPOSITION_XY
			MY_CTRL			The control that we want to move
			MY_POSX			The target position's X component
			MY_POSY			The target position's Y component
			MY_COMMITDURATION	The commit duration

		MACRO_FNC_UI_CTRL_SETPOSITION_XYWH
			MY_CTRL			The control that we want to move
			MY_POSX			The target position's X component
			MY_POSY			The target position's Y component
			MY_POSW			The target position's width component
			MY_POSH			The target position's height component
			MY_COMMITDURATION	The commit duration

-------------------------------------------------------------------------------------------------------------------- */

// First variant - passed position is an array
#define MACRO_FNC_UI_CTRL_SETPOSITION(MY_CTRL,MY_TARGETPOS,MY_COMMITDURATION)						 \
MY_CTRL ctrlSetPosition MY_TARGETPOS;                                                                                    \
MY_CTRL ctrlCommit MY_COMMITDURATION;

// Second variant - passed position is in format X,Y
#define MACRO_FNC_UI_CTRL_SETPOSITION_XY(MY_CTRL,MY_POSX,MY_POSY,MY_COMMITDURATION)					 \
MY_CTRL ctrlSetPosition [MY_POSX, MY_POSY];                                                                              \
MY_CTRL ctrlCommit MY_COMMITDURATION;

// Third variant - passed position is in format X,Y,W,H
#define MACRO_FNC_UI_CTRL_SETPOSITION_XYWH(MY_CTRL,MY_POSX,MY_POSY,MY_POSW,MY_POSH,MY_COMMITDURATION)			 \
MY_CTRL ctrlSetPosition [MY_POSX, MY_POSY, MY_POSW, MY_POSH];                                                            \
MY_CTRL ctrlCommit MY_COMMITDURATION;
