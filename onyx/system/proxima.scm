(use-modules (gnu))
(use-service-modules networking ssh)

(operating-system
  (locale "en_US.utf8")
  (timezone "America/New_York")
  (keyboard-layout (keyboard-layout "us"))

  (host-name "proxima")

  (users (cons* (user-account
		  (name "arizona")
		  (comment "Arizona")
		  (group "users")
		  (home-directory "/home/arizona")
		  (shell
		    (file-append (specification->package "zsh") "/bin/zsh"))
		  (supplementary-groups
		    '("wheel" "netdev" "audio" "video")))
		%base-user-accounts))

  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (targets '("/boot/efi"))
      (keyboard-layout keyboard-layout)))

  (swap-devices
    (list (swap-space
	    (target (uuid "a8099640-6324-4001-8614-74902e2063f7"))
	    (discard? #t))))

  (file-systems
    (cons* (file-system
	     (mount-point "/boot/efi")
	     (device
	       (uuid "8994-37B4" 'fat32))
	     (type "vfat"))
	   (file-system
	     (mount-point "/")
	     (device
	       (uuid "f0900641-9d0d-48b4-8bcf-6c9e9835964d" 'btrfs))
	     (type "btrfs")
	     (options "compress-force=zstd,discard"))
	   %base-file-systems))

  (packages
    (append
      (map specification->package
	   '("nss-certs" "zsh" "tmux" "git" "vim" "vim-scheme"))
      %base-packages))

  (services
    (append
      (list (service openssh-service-type)
	    (service dhcp-client-service-type))
      %base-services)))
