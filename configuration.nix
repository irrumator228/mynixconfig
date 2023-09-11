{ config, pkgs, ... }:

{
imports =
	[ # Include the results of the hardware scan.
		./hardware-configuration.nix
	];

# boot.loader.grub.enable = true;
# boot.loader.grub.device = "/dev/sda";
# boot.loader.grub.useOSProber = true;

boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;

networking.hostName = "nixos";
  
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

networking.networkmanager.enable = true;

time.timeZone = "Europe/Moscow";

services.xserver = {
	layout = "us, ru";
	# xkbVariant = "";
	xkbOptions = "grp:win_space_toggle";
};	

services.xserver.enable = true; 

# services.xserver.displayManager.startx.enable = true;
 
services.xserver.windowManager.dwm.enable = true;

nixpkgs.overlays = [
	(final: prev: {
		dwm = prev.dwm.overrideAttrs (oldAttrs: rec {
			patches = [
				/etc/nixos/patches/dwm.diff

				# ffcast -w png ~/ss_"$(date +%F-%T)".png
				# ffcast -s png ~/ss_"$(date +%F-%T)".png



				(prev.fetchpatch {
					url = "https://dwm.suckless.org/patches/warp/dwm-warp-6.4.diff";
					hash = "sha256-8z41ld47/2WHNJi8JKQNw76umCtD01OUQKSr/fehfLw=";
				})
				
				/*
				(prev.fetchpatch {
					url = "	https://dwm.suckless.org/patches/fullgaps/dwm-fullgaps-6.4.diff";
					hash = "sha256-+OXRqnlVeCP2Ihco+J7s5BQPpwFyRRf8lnVsN7rm+Cc=";
				})
				*/

			];
			
		});

		dmenu = prev.dmenu.overrideAttrs (oldAttrs: rec {
			patches = [
				
				/etc/nixos/patches/dmenu.diff

				/*
				(prev.fetchpatch {
					url = "https://tools.suckless.org/dmenu/patches/border/dmenu-border-5.2.diff";
					hash = "sha256-pf9UM3cEVfYr99HuQeeakYbFNSAJmCPS+uqSI6Anf/I=";
				})
				*/

				/*
				https://tools.suckless.org/dmenu/patches/center/dmenu-center-5.2.diff
				*/

			];
			
		});
	
		st = prev.st.overrideAttrs (oldAttrs: rec {
			buildInputs = oldAttrs.buildInputs ++ [ pkgs.harfbuzz ];
    			patches = [
				/etc/nixos/patches/st.diff
				
      				(prev.fetchpatch {
        				url = "https://st.suckless.org/patches/ligatures/0.9/st-ligatures-20230105-0.9.diff";
        				hash = "sha256-F2LvUT2bPFfkw82vFS16wwGoB+TEIquTG2UnKAZfzh0=";
      				})

				/*
				(prev.fetchpatch {
        				url = "https://st.suckless.org/patches/alpha/st-alpha-20220206-0.8.5.diff";
        				hash = "sha256-01/KBNbBKcFcfbcpMnev/LCzHpON3selAYNo8NUPbF4=";
      				})
				*/

				(prev.fetchpatch {
        				url = "https://st.suckless.org/patches/anysize/st-expected-anysize-0.9.diff";
        				hash = "sha256-q21HEZoTiVb+IIpjqYPa9idVyYlbG9RF3LD6yKW4muo=";
      				})
			];
			# configFile = super.writeText "config.h" (builtins.readFile ./dwm-config.h);
			# postPatch = oldAttrs.postPatch or "" + "\necho 'Using own config file...'\n cp ${configFile} config.def.h";
		});

		slstatus = prev.slstatus.overrideAttrs (oldAttrs: rec {
    			patches = [
      				/etc/nixos/patches/slstatus.diff
			];
		});
	})

];

services.xserver.displayManager.defaultSession = "none+dwm";

users.users.talp = {
	isNormalUser = true;
	description = "talp";
	extraGroups = [ "networkmanager" "wheel" ];
	packages = with pkgs; [];
};

# services.getty.autologinUser = "talp";

environment.systemPackages = with pkgs; [
	neovim			# text editor
	dwm			# window manager 
	st			# term 			# kitty
	
	dmenu			# program menu
	rofi			#

	slstatus		# status screen
	taskwarrior		# tasks 
	feh			# image viever
	tlp			# battery ctrl 
	wget			# 
	mpv			# media player		# vlc
	git			# 
	gcc			# compiler		# lacc	# cproc
	
	fish			# shell			
	yash
	dash
	mksh
	oksh
	
	vieb			# browser		
	surf			# vimb	# nyxt # 
	google-chrome 
	
	ffcast	 		# screenshot		# scrot
	unzip			# 
	ranger			# file manager		# nnn	# sfm
	zathura			# document viewer
	htop			# resourse screen
	fira-code		# font with ligatures
	musl			# lib
	tk			# lib
	harfbuzz		# ligatures lib
	kmix			# sound ctrl
	translate-shell		# translator
	keynav    		# mouse killer
	nitch			# fetch
	
	discord

	slock			# screen lock
	sselp

	picom

	screenkey

#	lsw
#	sprop
	svkbd
#	swarp
	wmname
#	xssstate
	tabbed
	sent
#	scroll
#	quark
	
	phoronix-test-suite

	# gomuks		#
	iwd			# wifi
	# stagit    		# static git page generator (HTML)
	# btpd			# torrent client
	# transmission		#
	# libz			# archive manager
	# qemu			# virtual
	# browsh		# lagrange	# offpunk	
	# librewolf		#
	# lynx			# w3m		
	# kcli			#
	# ngrok 		# is the fastest way to put your app on the internet.
	# vscodium		#
	# bluez			#
	# kicad			#
	# obsidian		#
	# thttpd		#
	# iortcw_sp		#
	# zlib			#
	# freecad		#
	# protontricks		#
	# gamescope		#
	yt-dlp			#
	# ventoy		# multibootable usb drive
	# activate-linux-unstable
	# wine			#
	gamemode		# game
	# gamehub		# game
	# lutris		# game
	# mumble		# voice chat
	obs-studio		# 
	# blender		# 3d
	# gimp			# image editor
	# inkscape		# vector editor
	# octave		# mat pkg
	# scilab		# mat pkg
	# graphviz		# 
	# puredata		#
	# supercollideride	#
	# lmms			# 
	# audacity		#
	# brasero		#
	# opentoonz		#

	/*
	Json
	UTF-8
	limbo
	9p
	libthread
	libtask
	man pages
	8c
	tcc
	mk			# widget
	nuclear			# widget	
	acme
	sam
	postscript
	pq
	djvu
	Licenses
	ISC
	BSD
	OSS4
	*/

	# https://st.suckless.org/
	# https://app.element.io/
	# https://web.telegram.org/
	# https://vk.com/feed
	# https://github.com/
	# https://irrumator228.github.io/
	# https://peertube.su/
	# https://www.youtube.com/
	# https://suckless.org/
	# https://www.typingstudy.com/en-us_workman-3/lesson/1
	# https://monkeytype.com/
	# http://dotshare.it/
	# https://godbolt.org/
];

fonts.fonts = with pkgs; [ 
	fira-code 
	fira-code-symbols
];

nixpkgs.config.allowUnfree = true;

# nix-prefetch-url <url> # for hash

boot.supportedFilesystems = [ "ntfs" ];

services.logrotate.checkConfig = false;

# my kitty conf
/*
font_family Fira Code
tap_bar_edge top
tap_bar_style powerline
shell fish
editor nvim
sturtup_session <path>
	layout stack
	launch --title "main" fish
exe_search_path +~/
*/

services.openssh.enable = true;

sound.enable = true;
hardware.pulseaudio.enable = true;
nixpkgs.config.pulseaudio = true;
hardware.pulseaudio.extraConfig = "load-module module-combine-sink";

programs.fish.enable = true;
programs.slock.enable = true;
networking.wireless.iwd.enable = true;

users.defaultUserShell = pkgs.fish;
programs.steam.enable = true;
# programs.harfbuzz.enable = true;
hardware.opengl.driSupport32Bit = true;
hardware.bluetooth.enable = true;
services.blueman.enable = true;

# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# networking.firewall.enable = false;

system.stateVersion = "23.05";
}
