// Simple but efficient Flymode
// by Rzzr.
// You are free to use, reproduce, edit, burn or whipe your ass with this script.
//Translated by site http://pawn-lab.ru | Переведенно сайтом http://pawn-lab.ru
#include <a_samp>

#define FLYMODESPEED GetPVarFloat(playerid, "FlymodeSpeed")
new PlayerToetsen, OmhoogLaag, LinksRechts;
new Float:x,Float:y,Float:z;
new Float:x2, Float:y2, Float:z2;

public OnFilterScriptInit()
{
	print(">> Simple Flymode, by Rzzr <c>");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	SetPVarFloat(playerid, "FlymodeSpeed", 1);
	return 1;
}

forward Float:SetPlayerToFacePos(playerid, Float:X, Float:Y);
public Float:SetPlayerToFacePos(playerid, Float:X, Float:Y)
{
	new
		Float:pX,
		Float:pY,
		Float:pZ,
		Float:ang;

	if(!IsPlayerConnected(playerid)) return 0.0;

	GetPlayerPos(playerid, pX, pY, pZ);

	if( Y > pY ) ang = (-acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);
	else if( Y < pY && X < pX ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 450.0);
	else if( Y < pY ) ang = (acos((X - pX) / floatsqroot((X - pX)*(X - pX) + (Y - pY)*(Y - pY))) - 90.0);

	if(X > pX) ang = (floatabs(floatabs(ang) + 180.0));
	else ang = (floatabs(ang) - 180.0);

	//ang += 180.0;

	SetPlayerFacingAngle(playerid, ang);

 	return ang;
}

public OnPlayerCommandText(playerid, cmdtext[])
{

	if (strcmp("/flymode", cmdtext, true, 10) == 0)
	{
		if(GetPVarInt(playerid, "Flymode") == 0)
		{
		  	SetPVarInt(playerid, "Flymode", 1);
		  	//ApplyAnimation(playerid,"PARACHUTE","FALL_SkyDive_Accel",4.1,1,1,1,1,0);
		  	SetPlayerHealth(playerid, 50000);
		  	SendClientMessage(playerid, 0xFF0000AA, "Fly активирован. Нажмите шифт, чтобы летать!");
		  	return 1;
		}
	  	if(GetPVarInt(playerid, "Flymode") == 1)
		{
		  	SetPVarInt(playerid, "Flymode", 0);
		  	ClearAnimations(playerid);
		  	SetPlayerHealth(playerid, 100);
		  	SendClientMessage(playerid, 0xFF0000AA, "Flymode disabled");
		 	return 1;
		}
		return 1;
	}
	if (strcmp("/flyspeed", cmdtext, true, 10) == 0)
	{
		ShowPlayerDialog(playerid, 40, DIALOG_STYLE_INPUT, "Сменить скорость полета", "Пожалуйста, введите сюда скорость полёта:\n\n", "OK", "Выход");
		return 1;
	}
	return 0;
}


public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if ((newkeys & KEY_JUMP) && !(oldkeys & KEY_JUMP))
    {
        if(GetPVarInt(playerid, "Flymode") == 1)
        {
            if(GetPVarInt(playerid, "Flying") == 0)
        	{
        	    SetPVarInt(playerid, "Flying", 1);
        	    //SetPlayerAttachedObject(playerid, 2, 2237, 7, -0.08,0.5,-0.2, 271.4781,0,0);
        	    return 1;
			}
			if(GetPVarInt(playerid, "Flying") == 1)
        	{
        	    SetPVarInt(playerid, "Flying", 0);
        	    GetPlayerVelocity(playerid, x, y, z);
        	    ClearAnimations(playerid);
        	    SetPlayerVelocity(playerid, x/2, y/2, z/2);
				//RemovePlayerAttachedObject(playerid, 2);
        	    return 1;
			}
		}
	}
	return 1;
}


public OnPlayerUpdate(playerid)
{
	if(GetPVarInt(playerid, "Flymode") == 1 && GetPVarInt(playerid, "Flying") == 1)
	{
    GetPlayerKeys(playerid,PlayerToetsen,OmhoogLaag,LinksRechts);
    if(PlayerToetsen & KEY_SPRINT)
    {
        GetPlayerPos(playerid, x2, y2, z2);
		GetPlayerCameraFrontVector(playerid, x, y, z);
		SetPlayerToFacePos(playerid, x + x2, y+y2);
		SetPlayerVelocity(playerid, x*FLYMODESPEED, y*FLYMODESPEED, z*FLYMODESPEED);
		//ApplyAnimation(playerid,"PARACHUTE","FALL_SkyDive_Accel",4.1,1,1,1,1,0);
		ApplyAnimation(playerid,"ped","run_player",4.1,1,1,1,1,0);
	}
	else
    {
		SetPlayerVelocity(playerid, 0, 0, 0);
		ApplyAnimation(playerid,"FAT","FatIdle",4.1,0,1,1,1,0);
	}
	}

	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == 40)
	{
	    if(response && strlen(inputtext))
	    {
	        new Float:speed;
	        if (sscanf(inputtext, "f", speed)) SendClientMessage(playerid, 0xFF0000AA, "Введите корректный номер!");
	        else
	        {
	            SetPVarFloat(playerid, "FlymodeSpeed", speed);
	            SendClientMessage(playerid, 0xFF0000AA, "Скорость изменена.");
			}
	    }
	}
	return 1;
}

stock sscanf(string[], format[], {Float,_}:...)
{
	#if defined isnull
		if (isnull(string))
	#else
		if (string[0] == 0 || (string[0] == 1 && string[1] == 0))
	#endif
		{
			return format[0];
		}
	#pragma tabsize 4
	new
		formatPos = 0,
		stringPos = 0,
		paramPos = 2,
		paramCount = numargs(),
		delim = ' ';
	while (string[stringPos] && string[stringPos] <= ' ')
	{
		stringPos++;
	}
	while (paramPos < paramCount && string[stringPos])
	{
		switch (format[formatPos++])
		{
			case '\0':
			{
				return 0;
			}
			case 'i', 'd':
			{
				new
					neg = 1,
					num = 0,
					ch = string[stringPos];
				if (ch == '-')
				{
					neg = -1;
					ch = string[++stringPos];
				}
				do
				{
					stringPos++;
					if ('0' <= ch <= '9')
					{
						num = (num * 10) + (ch - '0');
					}
					else
					{
						return -1;
					}
				}
				while ((ch = string[stringPos]) > ' ' && ch != delim);
				setarg(paramPos, 0, num * neg);
			}
			case 'h', 'x':
			{
				new
					num = 0,
					ch = string[stringPos];
				do
				{
					stringPos++;
					switch (ch)
					{
						case 'x', 'X':
						{
							num = 0;
							continue;
						}
						case '0' .. '9':
						{
							num = (num << 4) | (ch - '0');
						}
						case 'a' .. 'f':
						{
							num = (num << 4) | (ch - ('a' - 10));
						}
						case 'A' .. 'F':
						{
							num = (num << 4) | (ch - ('A' - 10));
						}
						default:
						{
							return -1;
						}
					}
				}
				while ((ch = string[stringPos]) > ' ' && ch != delim);
				setarg(paramPos, 0, num);
			}
			case 'c':
			{
				setarg(paramPos, 0, string[stringPos++]);
			}
			case 'f':
			{

				new changestr[16], changepos = 0, strpos = stringPos;
				while(changepos < 16 && string[strpos] && string[strpos] != delim)
				{
					changestr[changepos++] = string[strpos++];
    				}
				changestr[changepos] = '\0';
				setarg(paramPos,0,_:floatstr(changestr));
			}
			case 'p':
			{
				delim = format[formatPos++];
				continue;
			}
			case '\'':
			{
				new
					end = formatPos - 1,
					ch;
				while ((ch = format[++end]) && ch != '\'') {}
				if (!ch)
				{
					return -1;
				}
				format[end] = '\0';
				if ((ch = strfind(string, format[formatPos], false, stringPos)) == -1)
				{
					if (format[end + 1])
					{
						return -1;
					}
					return 0;
				}
				format[end] = '\'';
				stringPos = ch + (end - formatPos);
				formatPos = end + 1;
			}
			case 'u':
			{
				new
					end = stringPos - 1,
					id = 0,
					bool:num = true,
					ch;
				while ((ch = string[++end]) && ch != delim)
				{
					if (num)
					{
						if ('0' <= ch <= '9')
						{
							id = (id * 10) + (ch - '0');
						}
						else
						{
							num = false;
						}
					}
				}
				if (num && IsPlayerConnected(id))
				{
					setarg(paramPos, 0, id);
				}
				else
				{
					#if !defined foreach
						#define foreach(%1,%2) for (new %2 = 0; %2 < MAX_PLAYERS; %2++) if (IsPlayerConnected(%2))
						#define __SSCANF_FOREACH__
					#endif
					string[end] = '\0';
					num = false;
					new
						name[MAX_PLAYER_NAME];
					id = end - stringPos;
					foreach (Player, playerid)
					{
						GetPlayerName(playerid, name, sizeof (name));
						if (!strcmp(name, string[stringPos], true, id))
						{
							setarg(paramPos, 0, playerid);
							num = true;
							break;
						}
					}
					if (!num)
					{
						setarg(paramPos, 0, INVALID_PLAYER_ID);
					}
					string[end] = ch;
					#if defined __SSCANF_FOREACH__
						#undef foreach
						#undef __SSCANF_FOREACH__
					#endif
				}
				stringPos = end;
			}
			case 's', 'z':
			{
				new
					i = 0,
					ch;
				if (format[formatPos])
				{
					while ((ch = string[stringPos++]) && ch != delim)
					{
						setarg(paramPos, i++, ch);
					}
					if (!i)
					{
						return -1;
					}
				}
				else
				{
					while ((ch = string[stringPos++]))
					{
						setarg(paramPos, i++, ch);
					}
				}
				stringPos--;
				setarg(paramPos, i, '\0');
			}
			default:
			{
				continue;
			}
		}
		while (string[stringPos] && string[stringPos] != delim && string[stringPos] > ' ')
		{
			stringPos++;
		}
		while (string[stringPos] && (string[stringPos] == delim || string[stringPos] <= ' '))
		{
			stringPos++;
		}
		paramPos++;
	}
	do
	{
		if ((delim = format[formatPos++]) > ' ')
		{
			if (delim == '\'')
			{
				while ((delim = format[formatPos++]) && delim != '\'') {}
			}
			else if (delim != 'z')
			{
				return delim;
			}
		}
	}
	while (delim > ' ');
	return 0;
}

