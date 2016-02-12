#include<sourcemod>
#define PLUGIN_VERSION "1.2.0"

public Plugin:myinfo =
{
	name = "KZ GOTV Fix",
	author = "Thiry (& edited by Kenneth)",
	description = "Slight modification of 'demo autorecord fix' by Thiry",
	version = PLUGIN_VERSION,
	url = "http://blog.five-seven.net/"
};
new Handle:cvar_tv_enable;
new Handle:cvar_tv_autorecord;
new bool:first_player;

public OnPluginStart()
{
    cvar_tv_enable=FindConVar("tv_enable");
    cvar_tv_autorecord=FindConVar("tv_autorecord");
    HookConVarChange(cvar_tv_enable,Force_TV_Enable);
    HookConVarChange(cvar_tv_autorecord,Force_AutoRecord_Disable);
}

public Force_TV_Enable(Handle:cvar, const String:oldVal[], const String:newVal[])
{
    PrintToServer("[KZ GOTV Fix] tv_enable is forced to 1");
    SetConVarInt(cvar,1);
}

public Force_AutoRecord_Disable(Handle:cvar, const String:oldVal[], const String:newVal[])
{
    PrintToServer("[KZ GOTV Fix] tv_autorecord is forced to 0");
    SetConVarInt(cvar,0);
}

public OnClientPostAdminCheck(int client)
{
	if (first_player == false) 
	{
		CreateTimer(5.0,StartRecord);
		CreateTimer(10.0,RestartGame);
		first_player = true;
	}

}

public OnClientDisconnect_Post(int client)
{
	if (GetClientCount() == 0) 
	{
		ServerCommand("tv_stoprecord");
		first_player = false;
	}
}

public Action:StartRecord(Handle:timer,any:client)
{
    new String:year[16];
    new String:month[16];
    new String:date[16];
    new String:hour[16];
    new String:minute[16];
    new String:map[128];

    //tv_autorecord format
    FormatTime(year, sizeof(year), "%Y");
    FormatTime(month, sizeof(month), "%m");
    FormatTime(date, sizeof(date), "%d");
    FormatTime(hour, sizeof(hour), "%H");
    FormatTime(minute, sizeof(minute), "%M");
    GetCurrentMap(map,sizeof(map));

    ReplaceString(map,sizeof(map),"/","_");//workshop

    ServerCommand("tv_record kz-demo-%s%s%s-%s%s-%s",year,month,date,hour,minute,map);
    PrintToServer("[KZ GOTV Fix] Demo record has started.");
}

public Action:RestartGame(Handle:timer,any:client)
{
    ServerCommand("mp_restartgame 1");
    PrintToServer("[KZ GOTV Fix] Restarted game.");
}
