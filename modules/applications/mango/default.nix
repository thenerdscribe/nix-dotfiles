{ pkgs, inputs, ... }:
{
  wayland.windowManager.mango = {
    enable = true;
    settings = {
      env = [
        "WLR_RENDERER,vulkan"
        "QT_QPA_PLATFORM,wayland"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "QT_QPA_PLATFORMTHEME,gtk3"
        "WLR_DRM_NO_ATOMIC,1"
      ];
      blur = "1";
      hdr_depth = "2";
      allow_tearing = "1";
      blur_params_radius = "7";
      blur_params_num_passes = "3";
      blur_optimized = "0";
      blur_layer = "1";
      unfocused_opacity = "0.75";
      border_radius = "16";
      exec_once = [
        "vicinae server"
        "dcal run -d --hidden"
        "syncthing"
        "/home/ryanm/Applications/pcpaneld/target/debug/pcpaneld daemon"
        "multimon-target"
        "streamdeck -n"
      ];
      focus_color = "0x82ffd6ff";
      cursor_theme = "Sweet-dark";
      cursor_size = "18";
      cursor_hide_timeout = "3";
      cursor_hide_on_keypress = "1";
      drag_tile_to_tile = "1";
      scroller_proportion_preset = [
        "0.25,0.33,0.5,0.66,0.75,1"
      ];
      monitor_rule = [
        "name:^DP-1$,vrr:1,hdr:1,x:0,y:0,width:2560,height:1440,refresh:239.99"
        "name:^DP-2$,vrr:1,x:2560,y:-505,rr:1,width:2560,height:1440,refresh:144"
        "name:^HDMI-A-1$,vrr:1,width:3840,height:2160,refresh:120.00"
      ];
      scroller_default_proportion = "0.5";
      scroller_default_proportion_single = "1.0";
      scroller_ignore_proportion_single = "0";
      edge_scroller_pointer_focus = "0";
      sync_obj_enable = true;
      disable_middle_paste = true;
      window_rule = [
        "tags:2,monitor:^DP-2$,app_id:discord"
        "tags:2,monitor:^DP-2$,app_id:slack"
        "tags:2,monitor:^DP-2$,app_id:tether-gtk"
        "tags:2,monitor:^DP-2$,app_id:signal"
        "tags:3,monitor:^DP-1,app_id:steam"
        "app_id:ghostty,title:RMPC,is_floating:1,is_overlay:1,width:0.75,height:0.75"
        "app_id:ghostty,title:TTUI,is_floating:1,is_overlay:1,width:0.75,height:0.75"
      ];
      tag_rule = [
        "id:*,monitor_name:^DP-1$,layout_name:scroller"
        "id:*,monitor_name:^DP-2$,layout_name:vertical_scroller"
      ];
      axisbinds = [
        "SUPER,LEFT,viewtoleft_have_client"
        "SUPER,RIGHT,viewtoright_have_client"
        "SUPER,UP,viewtoleft_have_client"
        "SUPER,DOWN,viewtoright_have_client"
        "ALT,LEFT,focusdir,left"
        "ALT,RIGHT,focusdir,right"
        "ALT,UP,focusdir,up"
        "ALT,DOWN,focusdir,down"
      ];
      binds = [
        "SUPER,q,killclient"
        "SUPER+CTRL,h,exchange_client,left"
        "SUPER+CTRL,j,exchange_client,down"
        "SUPER+CTRL,k,exchange_client,up"
        "SUPER+CTRL,l,exchange_client,right"
        "SUPER,r,switch_proportion_preset"
        "SUPER+SHIFT,f,togglefullscreen"
        "SUPER+SHIFT,p,spawn,~/Scripts/sleep_monitors.sh"
        "SUPER,y,switch_layout"
        "SUPER,t,spawn,ghostty"
        "SUPER,space,spawn,vicinae toggle"
        "SUPER,m,spawn,dms ipc call processlist toggle"
        "SUPER+SHIFT,space,spawn,dms ipc call spotlight toggle"

        # Screenshots
        "SUPER+SHIFT,code:11,spawn,capture-script fullscreen"
        "SUPER+SHIFT,code:12,spawn,capture-script region"
        "SUPER+SHIFT,code:13,spawn,capture-script window"
        "SUPER+SHIFT,code:14,spawn,capture-script annotate"

        "ALT,h,focusdir,left"
        "ALT,j,focusdir,down"
        "ALT,k,focusdir,up"
        "ALT,l,focusdir,right"

        "ALT,u,viewtoleft"
        "ALT,i,viewtoright"

        "SUPER+SHIFT,l,focusmon,right"
        "SUPER+SHIFT,h,focusmon,left"
        "SUPER+SHIFT+CTRL,l,tagmon,right"
        "SUPER+SHIFT+CTRL,h,tagmon,left"

        "SUPER,1,set_proportion,0.25"
        "SUPER,2,set_proportion,0.33"
        "SUPER,3,set_proportion,0.5"
        "SUPER,4,set_proportion,0.66"
        "SUPER,5,set_proportion,0.75"
        "SUPER,f,togglemaximizescreen"
        "SUPER+SHIFT,j,scroller_stack,left"
        "SUPER+SHIFT,k,scroller_stack,right"
        "SUPER,e,spawn,ghostty --title='Yazi' -e 'yazi'"
        "SUPER+SHIFT,e,spawn,dfiles"
        "SUPER+SHIFT,m,spawn,ghostty --title='RMPC' -e 'rmpc'"
        "SUPER+SHIFT,t,spawn,ghostty --title='TTUI' -e 'taskwarrior-tui'"
        "SUPER+SHIFT+CTRL+ALT,c,spawn,vicinae 'vicinae://launch/clipboard/history'"
        "SUPER,c,centerwin"
        "SUPER+CTRL,t,setkeymode,tags"
        "SUPER+CTRL,r,setkeymode,resize"
        "SUPER+CTRL,1,view,1"
        "SUPER+CTRL,2,view,2"
        "SUPER+CTRL,3,view,3"
        "SUPER,tab,focusstack,next"
        "SUPER+SHIFT,tab,focusstack,previous"
        "SUPER,o,toggleoverview"
        "NONE,XF86AudioLowerVolume,spawn,playerctl volume 0.05-"
        "NONE,XF86AudioRaiseVolume,spawn,playerctl volume 0.05+"
        "NONE,XF86AudioPrev,spawn,playerctl previous"
        "NONE,XF86AudioNext,spawn,playerctl next"
        "NONE,XF86AudioPlay,spawn,playerctl play-pause"
      ];
      key_mode.resize.bind = [
        "NONE,h,resizewin,+10,0"
        "NONE,l,resizewin,+10,0"
        "NONE,j,resizewin,0,+10"
        "NONE,k,resizewin,0,+10"
        "NONE,ESCAPE,setkeymode,default"
        "SUPER+CTRL,r,setkeymode,default"
      ];
      key_mode.tags.bind = [
        "SUPER,1,toggletag,1"
        "SUPER,2,toggletag,2"
        "SUPER,3,toggletag,3"
        "SUPER+SHIFT,1,tag,1"
        "SUPER+SHIFT,2,tag,2"
        "SUPER+SHIFT,3,tag,3"
        "NONE,1,view,1"
        "NONE,2,view,2"
        "NONE,3,view,3"
        "NONE,ESCAPE,setkeymode,default"
        "SUPER+CTRL,t,setkeymode,default"
      ];
      source = [
        "./dms/layout.conf"
      ];
    };
  };
}
