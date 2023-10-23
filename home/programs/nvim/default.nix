{ config, pkgs, ... }:

{
	programs.neovim = {
		enable = true;
		defaultEditor = true;
		viAlias = true;
		vimAlias = true;
		vimdiffAlias = true;

		plugins = with pkgs.vimPlugins; [

		 nvim-lspconfig
		      nvim-treesitter.withAllGrammars
	      plenary-nvim
	      gruvbox-material
	      mini-nvim
		];

 extraLuaConfig = /* lua */ ''
      vim.o.termguicolors  = true
      vim.cmd('colorscheme gruvbox-material')
      vim.g.gruvbox_material_background = 'hard'
    '';
	};

}
