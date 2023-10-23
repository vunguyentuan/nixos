
{ config, pkgs, ... }:

{
    programs = {
        git = {
            enable = true;
	    userName = "Vu Nguyen";
	    userEmail = "tuanvu.vn007@gmail.com";
        };
    };
}
